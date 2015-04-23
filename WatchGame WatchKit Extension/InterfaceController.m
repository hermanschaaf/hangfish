//
//  InterfaceController.m
//  WatchGame WatchKit Extension
//
//  Created by Herman Schaaf on 4/13/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import "InterfaceController.h"
#import "Game.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceGroup* firstGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup* secondGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup* thirdGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup* fourthGroup;
@property NSArray* groups;

@property (weak, nonatomic) IBOutlet WKInterfaceImage *fish;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *word;

@property (weak, nonatomic) IBOutlet WKInterfaceButton *leftButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *middleButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *rightButton;
@property NSArray* buttons;

- (IBAction)leftButtonPress;
- (IBAction)middleButtonPress;
- (IBAction)rightButtonPress;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *categoryLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *scoreLabel;

@property NSInteger currentIndex;
@property NSInteger secondsLeftBeforeNewGame; // seconds left before you can play again
@property Game* game;

@property NSTimer* currentTimer;
@property NSTimer* scoreTimer;
@property NSTimer* fishTimer;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.groups = [[NSArray alloc] initWithObjects:self.firstGroup, self.secondGroup, self.thirdGroup, self.fourthGroup, nil];
    self.buttons = [[NSArray alloc] initWithObjects:self.leftButton, self.middleButton, self.rightButton, nil];
    
    // Configure interface objects here.
    [self gameBegin];
}

-(void)updateUI
{
    NSString* question = [self.game getQuestion];
    NSArray* options = [self.game getOptions];
    
    [self.word setText:question];
    NSString* hint = [self.game getHint];
    hint = [hint stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[hint substringToIndex:1] uppercaseString]];
    [self.categoryLabel setText: hint];
    int i = 0;
    for (NSString* option in options) {
        [[self.buttons objectAtIndex:i] setTitle: option];
        i++;
    }
    [self updateScoreLabel];
}

-(void)setIndex:(int)index
{
    if (self.currentTimer != nil ) {
        [self.currentTimer invalidate];
    }
    if (index >= [self.groups count]) {
        NSLog(@"Game over buddy");
        return;
    }
    
    self.currentIndex = index;
    for (long i = 0; i < [self.groups count]; i++) {
        WKInterfaceGroup* group = [self.groups objectAtIndex:i];
        [group setBackgroundColor:[UIColor blackColor]];
        if (self.currentIndex == 0 && i == 0) {
            [group setBackgroundImageNamed:@"wave-standing"];
            [group startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration: 1.0 repeatCount:NSIntegerMax];
        } else if (i < self.currentIndex - 1) {
            [group setBackgroundImageNamed:@"black"];
        } else if (i == self.currentIndex - 1) {
            [group setBackgroundImageNamed:@"wave-to-bottom"];
            [group startAnimatingWithImagesInRange:NSMakeRange(0, 18) duration: 1.8 repeatCount:1];
        } else if (i == self.currentIndex) {
        } else {
            [group setBackgroundImageNamed:@"blue"];
        }
    }
    if (self.currentIndex > 0){
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(animateTopDown) userInfo:nil repeats:NO];
    }
}

-(void)animateTopDown
{
    WKInterfaceGroup* group = [self.groups objectAtIndex:[self currentIndex]];
    [group setBackgroundColor:[UIColor blackColor]];
    [group setBackgroundImageNamed:@"wave-from-top"];
    [group startAnimatingWithImagesInRange:NSMakeRange(0, 3) duration: 0.3 repeatCount:1];
    
    if(self.currentIndex >= 3) {
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(removeWater) userInfo:nil repeats:NO];
    } else {
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animateWaves) userInfo:nil repeats:NO];
    }
}

-(void)animateWaves
{
    WKInterfaceGroup* group = [self.groups objectAtIndex:[self currentIndex]];
    [group setBackgroundImageNamed:@"wave-standing"];
    [group startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration: 1.0 repeatCount:NSIntegerMax];
}

-(void)removeWater
{
    for (long i = 0; i < [self.groups count]; i++) {
        WKInterfaceGroup* group = [self.groups objectAtIndex:i];
        [group setBackgroundImageNamed:@"black"];
    }
}

- (void)gameBegin
{
    self.game = [[Game alloc] init: (unsigned int)[self.buttons count]];
    
    [self setIndex:0];
    [self updateUI];
    self.scoreTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateScoreLabel) userInfo:nil repeats:YES];
    
    [self resetFishAnimation];

    [self.leftButton setHidden:FALSE];
    [self.rightButton setHidden:FALSE];
    [self.rightButton setWidth:self.contentFrame.size.width / 3];
    [self.middleButton setWidth:self.contentFrame.size.width / 3];
}

- (void)gameOver
{
    [self.scoreTimer invalidate];
    
    self.fishTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(deadFishAnimation) userInfo:nil repeats:NO];
    
    BOOL highScore = [self saveScore];
    
    if (highScore) {
        [self.categoryLabel setText:@"HIGH SCORE!"];
    } else {
        [self.categoryLabel setText:@"GAME OVER"];
    }
    [self.word setText:[self.game getAnswer]];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", [self.game getScore]]];
    
    [self.leftButton setHidden:TRUE];
    [self.rightButton setTitle:@"BUY"];
    [self.rightButton setWidth:self.contentFrame.size.width / 2];
    [self.middleButton setWidth:self.contentFrame.size.width / 2];
    [self.middleButton setEnabled:FALSE];
    
    self.secondsLeftBeforeNewGame = 10;
    [self setRestartTimer];
}

- (void)setRestartTimer
{
    self.secondsLeftBeforeNewGame -= 1;
    
    if (self.secondsLeftBeforeNewGame >= 1) {
        [self.middleButton setTitle:[NSString stringWithFormat:@"PLAY IN %ld", self.secondsLeftBeforeNewGame]];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setRestartTimer) userInfo:nil repeats:NO];
    } else {
        [self.middleButton setTitle:@"PLAY"];
        [self.middleButton setEnabled:TRUE];
    }
}

- (void)resetFishAnimation
{
    if (self.fishTimer != nil ) {
        [self.fishTimer invalidate];
    }
    
    [self.fish setImageNamed:@"fish"];
    [self.fish startAnimatingWithImagesInRange:NSMakeRange(0, 11) duration: 1.2 repeatCount:NSIntegerMax];
}

- (void)deadFishAnimation
{
    if (self.fishTimer != nil ) {
        [self.fishTimer invalidate];
    }
    
    [self.fish setImageNamed:@"fish-dead"];
    [self.fish startAnimatingWithImagesInRange:NSMakeRange(0, 4) duration: 0.4 repeatCount:1];
}

- (void)swimmingFishAnimation
{
    if (self.fishTimer != nil ) {
        [self.fishTimer invalidate];
    }
    
    [self.fish setImageNamed:@"fish-swimming"];
    [self.fish startAnimatingWithImagesInRange:NSMakeRange(0, 32) duration: 2.0 repeatCount:1];
}

- (void)updateScoreLabel
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", [self.game getScore]]];
}

- (void)buttonPress:(int)choice
{
    NSString* choiceStr = [[self.game getOptions] objectAtIndex:choice];
    
    int livesBefore = [self.game remainingLives];
    int roundBefore = [self.game getRound];
    
    [self.game guess:choiceStr];
    int livesNow = [self.game remainingLives];
    
    if (livesNow < livesBefore) {
        // wrong answer
        [self setIndex:3 - livesNow];
        if (livesNow <= 0) {
            [self gameOver];
            return;
        }
    } else {
        // correct
        int roundNow = [self.game getRound];
        if (roundNow > roundBefore) {
            [self swimmingFishAnimation];
            self.fishTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(resetFishAnimation) userInfo:nil repeats:NO];
        }
    }
    
    [self updateUI];
}

- (IBAction)leftButtonPress
{
    [self buttonPress:0];
}

- (IBAction)middleButtonPress
{
    if([self.game isGameOver]){
        [self gameBegin];
    } else {
        [self buttonPress:1];
    }
}

- (IBAction)rightButtonPress
{
    if([self.game isGameOver]){
        [self openParentBuyScreen];
    } else {
        [self buttonPress:2];
    }
}

- (void) openParentBuyScreen
{
    [WKInterfaceController openParentApplication:@{@"wantbuy": @1} reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"ReplyReceived : %lu",(unsigned long)[replyInfo count]);
        NSLog(@"Reply Info: %@", replyInfo);
        NSLog(@"Error: %@", error);
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// returns whether or not this was a high score
- (BOOL)saveScore {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSInteger prevHigh = [defs integerForKey:@"highscore"];
    NSInteger score = (long)[self.game getScore];
    if (prevHigh < score) {
        [defs setInteger:score forKey:@"highscore"];
        return TRUE;
    }
    return FALSE;
}

@end



