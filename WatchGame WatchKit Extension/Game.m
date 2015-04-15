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
@property NSString* currentWord;
@property NSMutableDictionary* guessed;

@end

@implementation Game

-(id)init
{
    if ( self = [super init] ) {
        [self nextWord];
    }
    return self;
}

-(void)nextWord
{
    self.currentWord = [WordList getWord];
    self.guessed = [[NSMutableDictionary alloc] init];
}

-(NSString*)getAnswer
{
    return self.currentWord;
}

-(NSString*)getQuestion
{
    NSMutableArray* q = [[NSMutableArray alloc] initWithCapacity:[self.currentWord length]*2];
    [self.currentWord enumerateSubstringsInRange:NSMakeRange(0, [self.currentWord length])
                                options:NSStringEnumerationByComposedCharacterSequences
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                 // substring here contains each character in turn
                                 if ([self haveGuessed:substring]) {
                                    [q addObject:substring];
                                 } else {
                                    [q addObject:@"_"];
                                 }
                             }];
    return [q componentsJoinedByString:@" "];
}

-(NSString*)guess:(NSString*)ch
{
    NSNumber *boolean = [NSNumber numberWithBool:YES];
    [self.guessed setObject:boolean forKey:ch];
    return [self getQuestion];
}

-(BOOL)haveGuessed:(NSString*)ch
{
    NSNumber *value = [self.guessed objectForKey:ch];
    if (value != nil) {
        return [value boolValue];
    }
    return FALSE;
}

@end