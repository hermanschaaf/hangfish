//
//  Word.m
//  WatchGame
//
//  Created by Herman Schaaf on 4/16/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@implementation Word
-(id)init:(NSString*)word withCategory:(NSString*)category {
    if ( self = [super init] ) {
        self.word = word;
        self.category = category;
    }
    return self;
}
@end