//
//  Word.h
//  WatchGame
//
//  Created by Herman Schaaf on 4/16/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#ifndef WatchGame_Word_h
#define WatchGame_Word_h

@interface Word: NSObject
-(id)init:(NSString*)word withCategory:(NSString*)category;

@property NSString* word;
@property NSString* category;
@end

#endif
