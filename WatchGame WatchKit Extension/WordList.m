//
//  WordList.m
//  WatchGame
//
//  Created by Herman Schaaf on 4/15/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordList.h"

@interface WordList()
@property NSArray* words;
@end

@implementation WordList
-(id)init
{
    if ( self = [super init] ) {
        self.words = @[@"CAT", @"DOG", @"GIRAFFE", @"HOOLIGAN", @"APPLE", @"ORANGE", @"WATCH", @"PEACH", @"TREE"];
    }
    return self;
}

-(NSString*) getWord
{
    int len = (int)[self.words count];
    unsigned int i = arc4random_uniform(len);
    return [self.words objectAtIndex:i];
}
@end