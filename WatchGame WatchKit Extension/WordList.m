//
//  WordList.m
//  WatchGame
//
//  Created by Herman Schaaf on 4/15/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordList.h"
#import "Word.h"

@interface WordList()
@property NSArray* words;
@property Word* currentWord;
@end

@implementation WordList
-(id)init
{
    if ( self = [super init] ) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"json"];
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error = nil;
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if(error) {
            // JSON was malformed, act appropriately here
            NSLog(@"Malformed JSON");
            return self;
        }
        
        NSMutableArray* words = [[NSMutableArray alloc] init];
        for (NSDictionary* wordDict in json) {
            NSString* wrd = [wordDict objectForKey:@"word"];
            NSString* cat = [wordDict objectForKey:@"category"];
            Word* word = [[Word alloc] init: [wrd uppercaseString] withCategory: cat];
            [words addObject:word];
        }
        self.words = words;
        [self nextWord];
    }
    return self;
}

-(void) nextWord
{
    int len = (int)[self.words count];
    unsigned int i = arc4random_uniform(len);
    self.currentWord = [self.words objectAtIndex:i];
}

-(NSString*) getWord
{
    return self.currentWord.word;
}

-(NSString*) getCategory
{
    return self.currentWord.category;
}
@end