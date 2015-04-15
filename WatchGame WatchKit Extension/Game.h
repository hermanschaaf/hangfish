//
//  Game.h
//  WatchGame
//
//  Created by Herman Schaaf on 4/15/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#ifndef WatchGame_Game_h
#define WatchGame_Game_h

@interface Game : NSObject
-(id)init;
-(void)nextWord;
-(NSString*)getAnswer;
-(NSString*)getQuestion;
@end

#endif
