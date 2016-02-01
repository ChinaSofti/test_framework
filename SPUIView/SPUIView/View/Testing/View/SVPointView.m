//
//  SVPointView.m
//  SPUIView
//
//  Created by WBapple on 16/1/25.
//  Copyright © 2016年 chinasofti. All rights reserved.
//


#import "SVPointView.h"
#import "SVTestingCtrl.h"

@interface SVPointView ()
//定义转盘imageView
@property (weak, nonatomic) IBOutlet UIImageView *imgViewWheel;

@end

@implementation SVPointView
//初始化方法
- (instancetype)init
{
    if ([super init])
    {
        _panelView = [[UIView alloc]
        initWithFrame:CGRectMake (FITWIDTH (20), FITWIDTH (160), FITWIDTH (280), FITWIDTH (280))];
        _panelView.backgroundColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"clock_video_panel"]];

        _middleView = [[UIView alloc]
        initWithFrame:CGRectMake (FITWIDTH (20), FITWIDTH (160), FITWIDTH (280), FITWIDTH (280))];
        _middleView.backgroundColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"clock_middle"]];

        _grayView = [[SVPointView alloc]
        initWithFrame:CGRectMake (FITWIDTH (20), FITWIDTH (160), FITWIDTH (280), FITWIDTH (280))];
        _grayView.backgroundColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"clock_pointer_gray"]];
        

        _label1 = [[UILabel alloc] initWithFrame:CGRectMake (FITWIDTH(130), FITWIDTH(290), FITWIDTH (60), FITWIDTH (20))];
        _label1.text = @"U-vMos";
        _label1.font = [UIFont systemFontOfSize:13.0f];
        _label1.textAlignment = NSTextAlignmentCenter;        
        
        _label2 = [[UILabel alloc]
                   initWithFrame:CGRectMake (FITWIDTH (110), FITWIDTH (350), FITWIDTH (100), FITWIDTH (50))];
        //传值
        _label2.text = @"0.00";
        _label2.textColor = RGBACOLOR (44, 166, 222, 1);
        _label2.font = [UIFont systemFontOfSize:36.0f];
        _label2.textAlignment = NSTextAlignmentCenter;
       
        _pointView = [[[NSBundle mainBundle] loadNibNamed:@"SVPointView" owner:nil options:nil] lastObject];
        _pointView.center = _panelView.center;
    }
    return self;
}

//开始转动方法
- (void)start
{

    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector (rotate)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self suijishu];
}

//每3秒执行一次线程
- (void)suijishu
{
    //    NSLog (@"每3s将输出一个随机数");
    // 在子线程中做事情
    dispatch_async (dispatch_get_global_queue (0, 0), ^{

      // 创建一个5s的定时器
      NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                               target:self
                                             selector:@selector (test)
                                             userInfo:nil
                                              repeats:YES];
      // 需要将定时器添加到运行循环中
      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
      // 在子线程中想要执行定时器,必须开启运行循环(这里就有一个死循环)
      [[NSRunLoop currentRunLoop] run];
      CFRunLoopRun ();

    });
}
//生成一个随机数
- (void)test
{
    //获取一个随机数范围在：[0,5）
    float abcd = (arc4random () % 501);
    self.num = M_PI * 4 * abcd / 1500;
//    num =  pi *4*abcd/15*100
//    NSLog (@"指针刻度:"
//           @"%.2f",
//           abcd / 100);
    CFRunLoopStop (CFRunLoopGetCurrent ());

}


//转动角度,速度控制
- (void)rotate
{
    //设置图片旋转速度
    self.pointView.transform = CGAffineTransformMakeRotation (self.num);
}
//重写了num的set方法
- (void)setNum:(float)num
{
    if (num != _num)
    {

        
        if (num < M_PI * 2 / 3)
        {
            [self.grayViewSuperView insertSubview:_grayView atIndex:self.grayViewIndexInSuperView];
            [self.label2SuperView insertSubview:_label2 atIndex:self.label2IndexInSuperView];

            
        }
        if (num > M_PI * 2 / 3)
        {
            [_grayView removeFromSuperview];
            
        }
        _num = num;
        _label2.text = [NSString stringWithFormat:@"%.2f",_num*1.194];
    }
}

@end
