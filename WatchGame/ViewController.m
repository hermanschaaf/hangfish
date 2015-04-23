//
//  ViewController.m
//  WatchGame
//
//  Created by Herman Schaaf on 4/13/15.
//  Copyright (c) 2015 Herman Schaaf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWatchkitNotification) name:@"user wants to buy" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
- (void)handleWatchkitNotification {
    NSLog(@"IRRASHAIMASE!!");
}

@end
