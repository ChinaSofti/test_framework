//
//  SVPointView.h
//  SPUIView
//
//  Created by WBapple on 16/1/25.
//  Copyright © 2016年 chinasofti. All rights reserved.
//
/*
 
 指针转动XIB页面

 */

#import <UIKit/UIKit.h>

@interface SVPointView : UIView

//定义随机数
@property (nonatomic, assign) float num;
//定义指针View
@property (nonatomic, strong) UIView *pointView;
//定义gray遮挡View
@property (nonatomic, strong) UIView * grayView;
//定义grayViewSuperView
@property (nonatomic, weak) UIView *grayViewSuperView;
//定义IndexIn(插入view的位置)
@property (nonatomic, assign) NSInteger grayViewIndexInSuperView;
//定义仪表盘View
@property (nonatomic, strong) UIView * panelView;
//定义中间半圆View
@property (nonatomic, strong) UIView * middleView;
//定义label1
@property (nonatomic, strong) UILabel * label1;
//定义label2
@property (nonatomic, strong) UILabel * label2;
//定义label2SuperView
@property (nonatomic, weak) UIView *label2SuperView;
//定义label2IndexInSuperView(插入label的位置)
@property (nonatomic, assign) NSInteger label2IndexInSuperView;


//@property (nonatomic, assign) float  value;

//指针转动页面用XIB页面
- (UIView *)pointView;
//开始转动方法
- (void)start;
//转动角度,速度控制
- (void)rotate;
//每5s产生一个随机数
- (void)suijishu;


@end
