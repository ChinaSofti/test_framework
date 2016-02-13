//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//


#import "SVBackView.h"
#import "SVPointView.h"
#import "SVTestingCtrl.h"
#import "SVTimeUtil.h"
#import "SVVideoTest.h"

@interface SVTestingCtrl ()
{

    // 定义headerView
    UIView *_headerView;
    // headerView参数
    // 定义U-vMos参数
    // 定义speed实时速度参数
    // 定义buffer缓冲次数参数
    UILabel *_uvMosLabel;
    UILabel *_speedLabel;
    UILabel *_bufferLabel;
    UILabel *_uvMosNumLabel;
    UILabel *_speedNumLabel;
    UILabel *_bufferNumLabel;

    //定义testingView
    SVPointView *_testingView;

    //定义视频播放View
    UIView *_videoView;

    // 定义footerView
    UIView *_footerView;
    // footerView参数
    // 定义视频服务位置place
    // 定义分辨率resolution
    // 定义码率(比特率bit)
    UILabel *_placeLabel;
    UILabel *_resolutionLabel;
    UILabel *_bitLabel;
    UILabel *_placeNumLabel;
    UILabel *_resolutionNumLabel;
    UILabel *_bitNumLabel;
    UILabel *placeLabel;
    UILabel *resolutionLabel;
    UILabel *bitLabel;
    UILabel *bufferLabel;
    UILabel *speedLabel;
    UILabel *uvMosLabel;
}

@property (nonatomic, strong) SVBackView *backView;
@end

@implementation SVTestingCtrl

- (void)viewDidLoad
{

    [super viewDidLoad];
    NSLog (@"SVTestingCtrl");

    // 1.自定义navigationItem.titleView
    //设置图片大小
    UIImageView *imageView = [[UIImageView alloc]
    initWithFrame:CGRectMake (FITWIDTH (0), FITWIDTH (0), FITWIDTH (100), FITWIDTH (30))];
    //设置图片名称
    imageView.image = [UIImage imageNamed:@"speed_pro"];
    //让图片适应
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //把图片添加到navigationItem.titleView
    self.navigationItem.titleView = imageView;
    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    // 2.设置整个Viewcontroller
    //设置背景颜色
    self.view.backgroundColor =
    [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    //打印排序结果
    //    NSLog (@"%@", _selectedA);

    // 3.自定义UIBarButtonItem
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 44, 44)];
    //    button.backgroundColor = [UIColor redColor];
    //    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //图片位置(相对于)
    //    [button setImageEdgeInsets:UIEdgeInsetsMake (0, -10, 0, 10)];
    //设置点击事件
    [button addTarget:self
               action:@selector (backBtnClik)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    // backButton设为navigationItem.leftBarButtonItem
    self.navigationItem.leftBarButtonItem = backButton;
    //是否允许用户交互(默认是交互的)
    //    self.navigationItem.leftBarButtonItem.enabled = YES;

    //为了保持平衡添加一个leftBtn
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 44, 44)];
    UIBarButtonItem *backButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = backButton1;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    //添加方法
    [self creatHeaderView];
    [self creatTestingView];
    [self creatVideoView];
    [self creatFooterView];
}


#pragma mark - 创建头headerView

- (void)creatHeaderView
{
    //初始化headerView
    _headerView = [[UIView alloc]
    initWithFrame:CGRectMake (FITWIDTH (5), FITWIDTH (70), FITWIDTH (310), FITHEIGHT (100))];

    //设置Label
    uvMosLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (10), FITWIDTH (30), FITWIDTH (80), FITWIDTH (20))
                withFont:16
          withTitleColor:RGBACOLOR (250, 180, 86, 1)
               withTitle:@"0"];

    speedLabel = [CTWBViewTools createLabelWithFrame:CGRectMake (uvMosLabel.rightX + FITWIDTH (35),
                                                                 FITWIDTH (30), FITWIDTH (80), FITWIDTH (20))
                                            withFont:16
                                      withTitleColor:RGBACOLOR (250, 180, 86, 1)
                                           withTitle:@"0ms"];

    bufferLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (speedLabel.rightX + FITWIDTH (35), FITWIDTH (30), FITWIDTH (50), FITWIDTH (20))
                withFont:16
          withTitleColor:RGBACOLOR (250, 180, 86, 1)
               withTitle:@"0"];

    _uvMosNumLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (10), uvMosLabel.bottomY + FITWIDTH (10), FITWIDTH (80), FITWIDTH (10))
                withFont:13
          withTitleColor:RGBACOLOR (81, 81, 81, 1)
               withTitle:@"U-vMOS"];

    _speedNumLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (_uvMosNumLabel.rightX + FITWIDTH (35),
                                     uvMosLabel.bottomY + FITWIDTH (10), FITWIDTH (80), FITWIDTH (10))
                withFont:13
          withTitleColor:RGBACOLOR (81, 81, 81, 1)
               withTitle:@"首次缓冲时间"];

    _bufferNumLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (_speedNumLabel.rightX + FITWIDTH (35),
                                     uvMosLabel.bottomY + FITWIDTH (10), FITWIDTH (80), FITWIDTH (10))
                withFont:13
          withTitleColor:RGBACOLOR (81, 81, 81, 1)
               withTitle:@"卡顿次数"];
    //所有Label居中对齐
    uvMosLabel.textAlignment = NSTextAlignmentCenter;
    bufferLabel.textAlignment = NSTextAlignmentCenter;
    speedLabel.textAlignment = NSTextAlignmentCenter;
    _uvMosNumLabel.textAlignment = NSTextAlignmentCenter;
    _speedNumLabel.textAlignment = NSTextAlignmentCenter;
    _bufferNumLabel.textAlignment = NSTextAlignmentCenter;
    //把所有Label添加到headerView中
    [_headerView addSubview:uvMosLabel];
    [_headerView addSubview:speedLabel];
    [_headerView addSubview:bufferLabel];
    [_headerView addSubview:_uvMosNumLabel];
    [_headerView addSubview:_speedNumLabel];
    [_headerView addSubview:_bufferNumLabel];
    //把headerView添加到中整个视图上
    [self.view addSubview:_headerView];
}

#pragma mark - 创建测试中仪表盘testingView

- (void)creatTestingView
{

    //初始化
    _testingView = [[SVPointView alloc] init];

    //设置背景图片,图片层叠
    // 1.先加载指针 pointView(再最下面)
    [self.view addSubview:_testingView.pointView];
    [_testingView start];

    // 2.添加覆盖指针View

    [self.view addSubview:_testingView.grayView];
    _testingView.grayViewSuperView = _testingView.grayView.superview;
    _testingView.grayViewIndexInSuperView = [self.view.subviews indexOfObject:_testingView.grayView];

    // 3.再加载表盘View
    [self.view addSubview:_testingView.panelView];

    // 4.加载clock_middle(最上面)
    [self.view addSubview:_testingView.middleView];

    // 5.添加clock_middle上的label

    [self.view addSubview:_testingView.label1];

    // 6.传值把指针指向的值显示出来label

    [self.view addSubview:_testingView.label2];
    _testingView.label2SuperView = _testingView.label2.superview;
    _testingView.label2IndexInSuperView = [self.view.subviews indexOfObject:_testingView.label2];
}


#pragma mark - 创建视频播放View

- (void)creatVideoView
{
    //初始化
    _videoView = [[UIView alloc]
    initWithFrame:CGRectMake (FITWIDTH (10), FITWIDTH (420), FITWIDTH (150), FITWIDTH (92))];
    //设置颜色
    _videoView.backgroundColor = [UIColor blackColor];

    //    设置背景图片
    //    _videoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"111"]];
    //把panlView添加到中整个视图上
    [self.view addSubview:_videoView];

    long testId = [SVTimeUtil currentMilliSecondStamp];
    SVVideoTest *videoTest =
    [[SVVideoTest alloc] initWithView:testId showVideoView:_videoView testDelegate:self];
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [videoTest test];
      // TODO liuchengyu 完成测试。跳转到结果页面

    });
}

#pragma mark - 创建尾footerView

- (void)creatFooterView
{
    //初始化headerView
    _footerView = [[UIView alloc]
    initWithFrame:CGRectMake (FITWIDTH (165), FITWIDTH (420), FITWIDTH (150), FITHEIGHT (92))];
    //设置Label
    placeLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (0), FITWIDTH (0), FITWIDTH (150), FITWIDTH (20))
                withFont:16
          withTitleColor:[UIColor blackColor]
               withTitle:@""];

    resolutionLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (80), FITWIDTH (45), FITWIDTH (80), FITWIDTH (20))
                withFont:10
          withTitleColor:[UIColor blackColor]
               withTitle:@""];

    bitLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (80), FITWIDTH (70), FITWIDTH (80), FITWIDTH (20))
                withFont:10
          withTitleColor:[UIColor blackColor]
               withTitle:@""];

    _placeNumLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (0), FITWIDTH (20), FITWIDTH (150), FITWIDTH (20))
                withFont:12
          withTitleColor:[UIColor lightGrayColor]
               withTitle:@"视频服务器位置"];

    _resolutionNumLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (0), FITWIDTH (45), FITWIDTH (50), FITWIDTH (20))
                withFont:10
          withTitleColor:[UIColor lightGrayColor]
               withTitle:@"分辨率"];

    _bitNumLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (0), FITWIDTH (70), FITWIDTH (50), FITWIDTH (20))
                withFont:10
          withTitleColor:[UIColor lightGrayColor]
               withTitle:@"码率"];
    //所有Label居中对齐
    placeLabel.textAlignment = NSTextAlignmentLeft;
    bitLabel.textAlignment = NSTextAlignmentCenter;
    resolutionLabel.textAlignment = NSTextAlignmentCenter;
    _placeNumLabel.textAlignment = NSTextAlignmentLeft;
    _resolutionNumLabel.textAlignment = NSTextAlignmentLeft;
    _bitNumLabel.textAlignment = NSTextAlignmentLeft;
    //把所有Label添加到headerView中
    [_footerView addSubview:placeLabel];
    [_footerView addSubview:resolutionLabel];
    [_footerView addSubview:bitLabel];
    [_footerView addSubview:_placeNumLabel];
    [_footerView addSubview:_resolutionNumLabel];
    [_footerView addSubview:_bitNumLabel];
    //把headerView添加到中整个视图上
    [self.view addSubview:_footerView];
}


#pragma mark - back弹框页

//生命周期(点击按钮就创建)
- (void)backBtnClik
{
    //    [self setShadowView];
}
/**
 *  创建阴影背景
 */

//代理方法
- (void)setShadowView
{
    //添加动画
    [UIView
    animateWithDuration:1
             animations:^{
               //黑色透明阴影
               UIView *shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
               shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];

               if (!_backView)
               {
                   _backView = [[SVBackView alloc]
                   initWithFrame:CGRectMake (FITWIDTH (20), FITWIDTH (140),
                                             shadowView.frame.size.width - FITWIDTH (40), FITWIDTH (220))
                         bgColor:[UIColor whiteColor]];

                   //                   _backView.delegate = self;
               }

               [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                        action:@selector (dismissTextField:)]];

               [shadowView addSubview:_backView];

               [self.view.window addSubview:shadowView];
             }];
}
//取消键盘
- (void)dismissTextField:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view endEditing:YES];
}
//代理方法-否
- (void)backView:(SVBackView *)backView overLookBtnClick:(UIButton *)Btn
{
    NSLog (@"NO");
    UIView *shadowView = [[[Btn superview] superview] superview];
    [shadowView removeFromSuperview];
    backView = nil;
}
//代理方法-是
- (void)backView:(SVBackView *)backView saveBtnClick:(UIButton *)Btn
{
    NSLog (@"YES");
    UIView *shadowView = [[[Btn superview] superview] superview];
    [shadowView removeFromSuperview];
    backView = nil;
}
/**
 ******************************以上弹框代码结束*****************************************
 **/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTestResultDelegate:(SVVideoTestContext *)testContext
                      testResult:(SVVideoTestResult *)testResult
{

    // UvMOS 综合得分
    NSArray *testSamples = testResult.videoTestSamples;
    SVVideoTestSample *testSample = testSamples[testSamples.count - 1];
    float uvMOSSession = testSample.UvMOSSession;

    //首次缓冲时长
    long firstBufferTime = testResult.firstBufferTime;

    // 卡顿次数
    int cuttonTimes = testResult.videoCuttonTimes;

    // 视频服务器位置
    NSString *location = testContext.videoSegemnetLocation;

    // 视频码率
    float bitrate = testResult.bitrate;

    // 分辨率
    NSString *videoResolution = testResult.videoResolution;
    NSLog (@"uvMOSSession: %f  firstBufferTime:%ld  cuttonTimes:%d  location:%@  bitrate:%f  "
           @"videoResolution:%@",
           uvMOSSession, firstBufferTime, cuttonTimes, location, bitrate, videoResolution);
    dispatch_async (dispatch_get_main_queue (), ^{
      [placeLabel setText:location];
      [resolutionLabel setText:videoResolution];
      [bitLabel setText:[NSString stringWithFormat:@"%.2fkpbs", bitrate]];
      [bufferLabel setText:[NSString stringWithFormat:@"%d", cuttonTimes]];
      [speedLabel setText:[NSString stringWithFormat:@"%ldms", firstBufferTime]];
      [uvMosLabel setText:[NSString stringWithFormat:@"%.2f", uvMOSSession]];
      [_testingView updateUvMOS:uvMOSSession];
    });
}


@end
