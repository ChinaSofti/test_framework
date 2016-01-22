//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVTestingCtrl.h"

@interface SVTestingCtrl ()

@end

@implementation SVTestingCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置背景颜色
    self.view.backgroundColor = [UIColor redColor];

    NSLog(@"%@", _selectedA);
    NSLog(@"SVTestingCtrl页面");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
