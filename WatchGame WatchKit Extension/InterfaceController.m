//
//  InterfaceController.m
//  WatchGame WatchKit Extension
//
//  Created by Herman Schaaf on 4/13/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup* mainGroup;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self.mainGroup setBackgroundImageNamed:@"frame"];
    [self.mainGroup startAnimatingWithImagesInRange:NSMakeRange(0, 20) duration: 3 repeatCount:NSIntegerMax];
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



