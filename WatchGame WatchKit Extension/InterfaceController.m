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
@property Game* game;

@property NSTimer* currentTimer;
@property NSTimer* scoreTimer;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.groups = [[NSArray alloc] initWithObjects:self.firstGroup, self.secondGroup, self.thirdGroup, self.fourthGroup, nil];
    self.buttons = [[NSArray alloc] initWithObjects:self.leftButton, self.middleButton, self.rightButton, nil];
    
    // Configure interface objects here.
    self.game = [[Game alloc] init: (unsigned int)[self.buttons count]];
    
    [self setIndex:0];
    [self updateUI];
    self.scoreTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateScoreLabel) userInfo:nil repeats:YES];
    
    [self.fish setImageNamed:@"fish"];
    [self.fish startAnimatingWithImagesInRange:NSMakeRange(0, 11) duration: 1.2 repeatCount:NSIntegerMax];
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
    NSLog(@"Current index is: %ld", (long)self.currentIndex);
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
//    long prev = [self currentIndex]-1;
//    if (prev >= 0) {
//        WKInterfaceGroup* group = [self.groups objectAtIndex:prev];
//        [group setBackgroundImageNamed:@"black"];
//    }
    
    WKInterfaceGroup* group = [self.groups objectAtIndex:[self currentIndex]];
    [group setBackgroundColor:[UIColor blackColor]];
    [group setBackgroundImageNamed:@"wave-from-top"];
    [group startAnimatingWithImagesInRange:NSMakeRange(0, 3) duration: 0.3 repeatCount:1];
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(animateWaves) userInfo:nil repeats:NO];
}

-(void)animateWaves
{
    WKInterfaceGroup* group = [self.groups objectAtIndex:[self currentIndex]];
    [group setBackgroundImageNamed:@"wave-standing"];
    [group startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration: 1.0 repeatCount:NSIntegerMax];

}

- (void)buttonPress:(int)choice
{
    NSString* choiceStr = [[self.game getOptions] objectAtIndex:choice];
    
    int livesBefore = [self.game remainingLives];
    
    [self.game guess:choiceStr];
    int livesNow = [self.game remainingLives];
    
    if (livesNow < livesBefore) {
        [self setIndex:3 - livesNow];
    }
    
    [self updateUI];
}

- (void)updateScoreLabel
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"%d", [self.game getScore]]];
}

- (IBAction)leftButtonPress
{
    NSLog(@"left button pressed");
    [self buttonPress:0];
}

- (IBAction)middleButtonPress
{
    NSLog(@"middle button pressed");
    [self buttonPress:1];
}

- (IBAction)rightButtonPress
{
    NSLog(@"right button pressed");
    [self buttonPress:2];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



