//
//  MainViewController.m
//  ReadingTogether
//
//  Created by WeiHan on 1/14/15.
//  Copyright (c) 2015 Wei Han. All rights reserved.
//

#import "MainViewController.h"
#import "MagicView.h"
#import "UIView+Size.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MagicView *rView = [[MagicView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height / 2)];
    rView.identifier = @"**V1**";
    [self.view addSubview:rView];
    
    rView = [[MagicView alloc] initWithFrame:CGRectMake(0, self.view.bottom / 2, self.view.width, self.view.height / 2)];
    rView.identifier = @"**V2**";
    [self.view addSubview:rView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
