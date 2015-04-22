//
//  Game.m
//  WatchGame
//
//  Created by Herman Schaaf on 4/15/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "WordList.h"

@interface Game()
@property WordList* wordList;

@property unsigned int numOptions;
@property int round;
@property NSString* currentWord;
@property NSArray* currentOptions;
@property NSMutableDictionary* guessed;
@property NSString* alphabet;
@property int lives;
@property int score;
@property NSTimer* scoreTimer;
@end

@implementation Game

-(id)init:(unsigned int)numOptions
{
    if ( self = [super init] ) {
        self.alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        self.numOptions = numOptions;
        self.wordList = [[WordList alloc] init];
        self.lives = 3;
        self.score = 200;
        self.round = 0;
        self.scoreTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(decreaseScore) userInfo:nil repeats:YES];
        
        [self nextWord];
    }
    return self;
}

-(void)nextWord
{
    self.round +=1;
    
    [self.wordList nextWord];
    self.currentWord = [self.wordList getWord];
    self.guessed = [[NSMutableDictionary alloc] init];
    
    // we give a hint by showing one random character in the word
    NSString* randomChar = [self getRandomCharFrom:self.currentWord];
    while ([self haveGuessed:randomChar] || [randomChar isEqualToString:@" "]) {
        randomChar = [self getRandomCharFrom:self.currentWord];
    }
    [self guess:randomChar];
    
    // update the options (stored in currentOptions)
    [self updateOptions];
}

-(NSString*)getAnswer
{
    return self.currentWord;
}

// get the current word, with unknown letters blanked out with
// underscores.
-(NSString*)getQuestion
{
    NSMutableArray* q = [[NSMutableArray alloc] initWithCapacity:[self.currentWord length]*2];
    [self.currentWord enumerateSubstringsInRange:NSMakeRange(0, [self.currentWord length])
        options:NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         // substring here contains each character in turn
         if ([self haveGuessed:substring]) {
            [q addObject:substring];
         } else if ([substring isEqualToString:@" "]) {
             [q addObject:@" "];
         } else {
             [q addObject:@"_"];
         }
     }];
    return [q componentsJoinedByString:@" "];
}

-(NSString*)getHint
{
    return [self.wordList getCategory];
}

// unknownCharactersLeft tells us how many characters are still blank
-(int)unknownCharactersLeft
{
    __block int unknown = 0;
    [self.currentWord enumerateSubstringsInRange:NSMakeRange(0, [self.currentWord length])
         options:NSStringEnumerationByComposedCharacterSequences
      usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
          if (![self haveGuessed:substring] && ![substring isEqualToString:@" "]) {
              unknown += 1;
          }
      }];
    return unknown;
}

// get possible characters that may be tried as guesses. The
// number of options normally corresponds to the number of buttons
// to show on the UI.
-(NSArray*)getOptions
{
    return self.currentOptions;
}

-(void)updateOptions
{
    NSMutableArray* options = [[NSMutableArray alloc] init];
    NSMutableString* chosen = [[NSMutableString alloc] init];
    
    NSString* correctChoice = [self getRandomCharFrom:self.currentWord];
    while ([self haveGuessed:correctChoice] || [correctChoice isEqualToString:@" "]) {
        correctChoice = [self getRandomCharFrom:self.currentWord];
    }
    unsigned int ansPos = arc4random_uniform((int)self.numOptions);
    
    for (unsigned int i = 0; i < (int)self.numOptions; i++) {
        NSString* rand;
        if (i == ansPos) {
            rand = correctChoice;
        } else {
            rand = [self getRandomCharFrom:self.alphabet];
            while ([self haveGuessed:rand] || [rand isEqualToString:correctChoice] || [chosen containsString:rand]) {
                rand = [self getRandomCharFrom:self.alphabet];
            }
        }
        [options addObject:rand];
        [chosen appendString:rand];
    }
    self.currentOptions = options;
}

// gets a random character from the given string. If the same
// character appears more than once, this will serve to skew the
// distribution in favor of such a character.
- (NSString *)getRandomCharFrom:(NSString*)str {
    int len = (int)[str length];
    unsigned int i = arc4random_uniform(len);
    return [str substringWithRange:NSMakeRange(i, 1)];
}

// make a guess of a specific character
-(void)guess:(NSString*)ch
{
    int unknownBefore = [self unknownCharactersLeft];
    
    NSNumber *boolean = [NSNumber numberWithBool:YES];
    [self.guessed setObject:boolean forKey:ch];
    
    int unknownNow = [self unknownCharactersLeft];
    if(unknownNow > 0) {
        if (unknownBefore == unknownNow) {
            self.lives -= 1;
        } else {
            [self increaseScore: 25];
        }
    } else {
        [self increaseScore: 300];
        [self nextWord];
    }
    
    [self updateOptions];
}

-(int)remainingLives
{
    return self.lives;
}

-(int)getScore
{
    return self.score;
}

-(void)decreaseScore
{
    if (self.score > 0) {
        self.score -= 1;
    }
}

-(void)increaseScore:(int)inc
{
    self.score += inc;
}

-(BOOL)haveGuessed:(NSString*)ch
{
    NSNumber *value = [self.guessed objectForKey:ch];
    if (value != nil) {
        return [value boolValue];
    }
    return FALSE;
}

-(int)getRound
{
    return self.round;
}

@end