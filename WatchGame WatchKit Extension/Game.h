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
-(id)init:(unsigned int)numOptions;
-(void)nextWord;
-(void)guess:(NSString*)ch;
-(NSString*)getQuestion;
-(NSString*)getAnswer;
-(NSArray*)getOptions;
-(NSString*)getHint;
-(int)getScore;
-(int)remainingLives;
-(int)getRound;
@end

#endif
