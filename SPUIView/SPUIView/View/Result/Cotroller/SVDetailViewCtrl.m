//
//  SVDetailViewCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/2/14.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVDetailViewCtrl.h"
#import "SVResultViewCtrl.h"
#import "SVToolCells.h"
#define kMargin 10
#define kFirstHederH 40
#define kLastFooterH 140

@interface SVDetailViewCtrl () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *soucreMA;
@property (nonatomic, retain) NSMutableArray *selectedMA;
@end

@implementation SVDetailViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置背景颜色
    //    self.view.backgroundColor = [UIColor redColor];
    NSLog (@"SVDetailViewCtrl页面");

    // 1.自定义navigationItem.title
    self.navigationItem.title = @"详细数据";
    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    // 2.设置整个Viewcontroller
    //设置背景颜色
    self.view.backgroundColor =
    [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];

    // 3.自定义UIBarButtonItem
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 45, 23)];
    [button setImage:[UIImage imageNamed:@"homeindicator"] forState:UIControlStateNormal];
    // 4.设置点击事件
    [button addTarget:self
               action:@selector (backBtnClik)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    // backButton设为navigationItem.leftBarButtonItem
    self.navigationItem.leftBarButtonItem = backButton;

    //为了保持平衡添加一个leftBtn
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake (300, 0, 23, 23)];
    [button1 setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    UIBarButtonItem *backButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = backButton1;

    // 5.编辑界面
    //一.创建一个 tableView
    // 1.style:Grouped化合的,分组的

    _tableView =
    [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    // 2.设置背景颜色
    _tableView.backgroundColor =
    [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    // 3.设置 table 的行高
    _tableView.rowHeight = 50;
    //*4.设置代理
    _tableView.delegate = self;
    //*5.设置数据源
    _tableView.dataSource = self;
    //设置tableView的section的分割线隐藏
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //三.添加
    // 6.定义数组展示图片
    _selectedMA = [NSMutableArray array];
    NSArray *sourceA = @[
        @{
            @"title": @"U-vMOS得分",
            @"title2": @"2.87",
        },
        @{
            @"title": @"      观看得分",
            @"title2": @"5.00",
        },
        @{
            @"title": @"      片源得分",
            @"title2": @"3.01",
        },
        @{
            @"title": @"      交互得分",
            @"title2": @"4.17",
        },
        @{
            @"title": @"首次缓冲时间",
            @"title2": @"842"
                       @"ms",
        },
        @{
            @"title": @"卡顿总时长",
            @"title2": @"0"
                       @"ms",
        },
        @{ @"title": @"卡顿次数",
           @"title2": @"0" },
        @{
            @"title": @"下载速度",
            @"title2": @"2427.72"
                       @"kbps",
        },
        @{
            @"title": @"码率",
            @"title2": @"1482.94"
                       @"kbps",
        },
        @{
            @"title": @"帧率",
            @"title2": @"30.00"
                       @"Fps",
        },
        @{
            @"title": @"分辨率",
            @"title2": @"1080×1920",
        },
        @{
            @"title": @"屏幕尺寸",
            @"title2": @"5.2"
                       @"英寸",
        },
        @{
            @"title": @"视频地址",
            @"title2": @"http://v.youku.com/v_show/i.",
        },
        @{
            @"title": @"视频服务器位置",
            @"title2": @"北京市",
        },

        @{
            @"title": @"所属运营商",
            @"title2": @"中国联通"
                       @" 北京市",
        },

        @{
            @"title": @"采集器所属运营商",
            @"title2": @"中国联通"
                       @" 北京市"
        },
        @{ @"title": @"宽带套餐",
           @"title2": @"未知" },
        @{ @"title": @"网络类型",
           @"title2": @"WIFI" },
        @{ @"title": @"测试时间",
           @"title2": @"2016年02月16日 09:15:10" },
        @{
            @"title": @"信号强度",
            @"title2": @"-104"
                       @"dBm"
        },

    ];
    NSMutableArray *sourceMA = [NSMutableArray array];
    for (int i = 0; i < sourceA.count; i++)
    {
        SVToolModels *toolModel = [SVToolModels modelWithDict:sourceA[i]];
        [sourceMA addObject:toolModel];
    }

    _soucreMA = sourceMA;
    // 7.把tableView添加到 view

    [self.view addSubview:_tableView];
}

- (void)backBtnClik
{
    [self.navigationController popViewControllerAnimated:NO];
}


//方法:

//设置 tableView 的 numberOfSectionsInTableView(设置几个 section)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}
//设置 tableView的 numberOfRowsInSection(设置每个section中有几个cell)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenH * 0.07;
}
//设置 tableView的 cellForRowIndexPath(设置每个cell内的具体内容)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellId = @"cell";

    SVToolCells *cell =
    [[SVToolCells alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.delegate = self;
    [cell cellViewModel2:_soucreMA[indexPath.section] section:indexPath.section];
    return cell;
}

//设置 tableView的section 的Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 15)
    {
        return 40;
    }
    else
    {
        return 0.01;
    }
}
//设置 tableView 的 sectionHeader蓝色 的header的有无
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *bgdView = [[UIView alloc] init];
        UIImage *image = [UIImage imageNamed:@"rt_detail_title_video_img"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake (18, 15, 17, 17);
        [bgdView addSubview:imageView];

        UILabel *label =
        [[UILabel alloc] initWithFrame:CGRectMake (kMargin + 33, 3, kScreenW - kMargin, kFirstHederH)];
        label.text = @"视频测试";
        label.font = [UIFont systemFontOfSize:12.0f];
        [bgdView addSubview:label];
        return bgdView;
    }
    if (section == 15)
    {
        UIView *bgdView = [[UIView alloc] init];
        UIImage *image = [UIImage imageNamed:@"rt_detail_title_collector_img"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake (18, 15, 17, 17);
        [bgdView addSubview:imageView];

        UILabel *label =
        [[UILabel alloc] initWithFrame:CGRectMake (kMargin + 33, 3, kScreenW - kMargin, kFirstHederH)];
        label.text = @"采集器信息";
        label.font = [UIFont systemFontOfSize:12.0f];
        [bgdView addSubview:label];
        return bgdView;
    }
    return nil;
}
//设置 tableView的section 的Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.05;
    }
    else
        return 0.05;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
