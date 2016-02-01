//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVResultViewCtrl.h"

@interface SVResultViewCtrl ()

@end

@implementation SVResultViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog (@"SVResultView");

    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
