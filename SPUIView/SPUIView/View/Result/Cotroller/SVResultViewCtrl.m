//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#define Button_Tag 10

#import "SVDBManager.h"
#import "SVResultCell.h"
#import "SVResultViewCtrl.h"
#import "SVSortTools.h"
#import "SVSummaryResultModel.h"

@interface SVResultViewCtrl () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSInteger currentBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIButton *typeButton;

@end

@implementation SVResultViewCtrl
{
    UIView *_toolView;
    SVDBManager *_db;
}

- (UIImageView *)bottomImageView
{
    if (_bottomImageView == nil)
    {
        _bottomImageView = [[UIImageView alloc] init];
    }
    return _bottomImageView;
}
- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        // 1.创建一个 tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake (0, 64 + 10, kScreenW, kScreenH - 64)
                                                  style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        // 2.设置背景颜色
        _tableView.backgroundColor = [UIColor whiteColor];

        // 3.设置代理
        _tableView.delegate = self;
        // 4.设置数据源
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)viewDidLoad
{
    // 初始化数据库和表
    _db = [SVDBManager sharedInstance];
    [super viewDidLoad];
    //   NSLog(@"SVResultView页面");

    self.view.backgroundColor = [UIColor whiteColor];

    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    //创建数据源
    [self initDataSouce];

    //从数据库中读取数据
    [self readDataFromDB];

    //添加NavigationRightItem
    [self addNavigationRightItem];

    //在NavigationBar下面添加一个View
    [self addHeadView];

    //添加TableView
    [self addTableView];
    currentBtn = -1;
}

- (void)readDataFromDB
{
    // 1、添加数据之前 先清空数据源
    [_dataSource removeAllObjects];
    // 2、添加数据
    NSArray *array =
    [_db executeQuery:[SVSummaryResultModel class]
                  SQL:@"select * from SVSummaryResultModel order by id desc limit 100 offset 0;"];
    [_dataSource addObjectsFromArray:array];

    // 3、刷新列表
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self buttonClick:_typeButton];
}

//创建数据源
- (void)initDataSouce
{
    NSArray *array = @[@"日期", @"时间", @"na", @"加载时间", @"带宽"];

    [self.dataSource addObject:array];
}


//添加NavigationRightItem
- (void)addNavigationRightItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector (removeButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)removeButtonClicked:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"清空所有测试结果"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert show];
}
/**
 *  UIAlertViewDelegate
 *
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog (@"确定删除所有数据");

        //从数据库中删除
        [_db executeUpdate:@"delete from SVJunitTestTable;"];

        //从UI上删除
        [_dataSource removeAllObjects];

        [_tableView reloadData];
    }
}


/**
 *  在NavigationBar下面添加一个View
 */
- (void)addHeadView
{
    NSArray *titles = @[@"类型", @"时间", @"U-vMOS", @"加载时间", @"带宽"];
    NSArray *images = @[
        @"ic_network_type_normal",
        @"ic_start_time_normal",
        @"ic_video_normal",
        @"ic_web_normal",
        @"ic_speed_normal"
    ];
    NSArray *imagesSelected = @[
        @"ic_network_type",
        @"ic_start_time",
        @"ic_video_testing",
        @"ic_web_test",
        @"ic_speed_testing"
    ];

    _toolView = [[UIView alloc] initWithFrame:CGRectMake (0, 64, kScreenW, 64)];
    _toolView.backgroundColor =
    [UIColor colorWithRed:69 / 255.0 green:84 / 255.0 blue:92 / 255.0 alpha:1.0];

    CGFloat BandGap = 10;
    CGFloat ButtonWidth = (kScreenW - 2 * BandGap) / 5;

    for (int i = 0; i < 5; i++)
    {

        _button = [[UIButton alloc]
        initWithFrame:CGRectMake (BandGap + ButtonWidth * i, 0, ButtonWidth, ButtonWidth)];

        [_button setTitle:titles[i] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:kScreenW / 27];
        // button普通状态下的字体颜色
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        // button选中状态下的字体颜色
        [_button setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        // button普通状态下的图片
        [_button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        // button选中状态下的图片
        [_button setImage:[UIImage imageNamed:imagesSelected[i]]
                 forState:UIControlStateSelected | UIControlStateHighlighted];
        [_button setImage:[UIImage imageNamed:imagesSelected[i]] forState:UIControlStateSelected];


        _button.titleEdgeInsets = UIEdgeInsetsMake (25, -33, 0, -5);
        _button.imageEdgeInsets = UIEdgeInsetsMake (-25, 17, 0, 4);


        [_button addTarget:self
                    action:@selector (buttonClick:)
          forControlEvents:UIControlEventTouchUpInside];

        _button.tag = Button_Tag + i;
        _button.selected = NO;

        [_toolView addSubview:_button];
        if (i == 0)
        {
            _typeButton = _button;
        }
    }

    [self.navigationController.view addSubview:_toolView];
}


- (void)buttonClick:(UIButton *)button
{

    if (button != self.button)
    {
        self.button.selected = NO;
        self.button = button;
    }
    self.button.selected = YES;

    //在被点击的按钮下方 添加细长白条
    switch (button.tag - Button_Tag)
    {
    case 0:
        self.bottomImageView.frame = CGRectMake (10, 62, kScreenW / 5 - 5, 2);
        self.bottomImageView.backgroundColor = [UIColor whiteColor];
        [self.bottomImageView removeFromSuperview];
        [_toolView addSubview:self.bottomImageView];
        break;
    case 1:
        self.bottomImageView.frame = CGRectMake (5 + kScreenW / 5, 62, kScreenW / 5 - 5, 2);
        self.bottomImageView.backgroundColor = [UIColor whiteColor];
        [self.bottomImageView removeFromSuperview];
        [_toolView addSubview:self.bottomImageView];
        break;
    case 2:
        self.bottomImageView.frame = CGRectMake (5 + 2 * kScreenW / 5, 62, kScreenW / 5 - 5, 2);
        self.bottomImageView.backgroundColor = [UIColor whiteColor];
        [self.bottomImageView removeFromSuperview];
        [_toolView addSubview:self.bottomImageView];
        break;
    case 3:
        self.bottomImageView.frame = CGRectMake (2 + 3 * kScreenW / 5, 62, kScreenW / 5 - 5, 2);
        self.bottomImageView.backgroundColor = [UIColor whiteColor];
        [self.bottomImageView removeFromSuperview];
        [_toolView addSubview:self.bottomImageView];
        break;
    case 4:
        self.bottomImageView.frame = CGRectMake (4 * kScreenW / 5, 62, kScreenW / 5 - 10, 2);
        self.bottomImageView.backgroundColor = [UIColor whiteColor];
        [self.bottomImageView removeFromSuperview];
        [_toolView addSubview:self.bottomImageView];
        break;

    default:
        break;
    }

    //按钮被点击后 右侧显示排序箭头
    UIImage *image = [UIImage imageNamed:@"ic_sort"];
    self.imageView.frame =
    CGRectMake (CGRectGetMaxX (button.titleLabel.frame) - 6, button.titleLabel.frame.origin.y - 10,
                image.size.width, image.size.height);

    static int a = 0;
    //    if (currentBtn != button.tag - Button_Tag)

    if (a % 2 == 0)
    {
        //显示向上箭头
        UIImage *image = [UIImage imageNamed:@"ic_sort_asc"];
        self.imageView.image = image;
        //       UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        switch (button.tag - Button_Tag)
        {
        case 0:
            //类型
            NSLog (@"类型--箭头向上");
            [SVSortTools sortByType:_dataSource];
            [SVSortTools reverse:_dataSource];
            [_tableView reloadData];

            break;
        case 1:
            //时间
            NSLog (@"时间--箭头向上");
            [SVSortTools sortByTime:_dataSource];
            [SVSortTools reverse:_dataSource];
            [_tableView reloadData];

            break;
        case 2:
            // U-vMOS
            [SVSortTools sortByScore:_dataSource];
            [SVSortTools reverse:_dataSource];
            [_tableView reloadData];
            NSLog (@"U-vMOS--箭头向上");
            break;
        case 3:
            //加载时间
            NSLog (@"加载时间--箭头向上");
            [SVSortTools sortByLoadTime:_dataSource];
            [SVSortTools reverse:_dataSource];
            [_tableView reloadData];
            break;
        case 4:
            //带宽
            NSLog (@"带宽--箭头向上");
            [SVSortTools sortByBandWitdh:_dataSource];
            [SVSortTools reverse:_dataSource];
            [_tableView reloadData];

            break;

        default:
            break;
        }
        currentBtn = button.tag - Button_Tag;
    }
    else
    { //显示向下箭头
        self.imageView.image = [UIImage imageNamed:@"ic_sort"];

        switch (button.tag - Button_Tag)
        {
        case 0:
            //类型
            NSLog (@"类型--箭头向下");
            [SVSortTools sortByType:_dataSource];

            [_tableView reloadData];
            break;
        case 1:
            //时间
            NSLog (@"时间--箭头向下");
            [SVSortTools sortByTime:_dataSource];

            [_tableView reloadData];
            break;
        case 2:
            // U-vMOS
            NSLog (@"U-vMOS--箭头向下");
            [SVSortTools sortByScore:_dataSource];

            [_tableView reloadData];
            break;
        case 3:
            //加载时间
            NSLog (@"加载时间--箭头向下");
            [SVSortTools sortByLoadTime:_dataSource];

            [_tableView reloadData];
            break;
        case 4:
            //带宽
            NSLog (@"带宽--箭头向下");
            [SVSortTools sortByBandWitdh:_dataSource];

            [_tableView reloadData];
            break;

        default:
            break;
        }
        //        [SVSortTools reverse:_dataSource];
        //        [_tableView reloadData];
    }
    a++;
    [self.imageView removeFromSuperview];
    [button addSubview:self.imageView];
}

//添加TableView
- (void)addTableView
{
    // 将tableView添加到 view上
    [self.view addSubview:self.tableView];
}


/**
 * tableViewDelegate
 **/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataSource.count;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenH * 0.115;
}

//设置 tableView的 cellForRowIndexPath(设置每个cell内的具体内容)
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];
    if (cell == nil)
    {
        cell =
        [[SVResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aCell"];

        //取消cell 被点中的效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.resultModel = self.dataSource[indexPath.row];

    cell.cellBlock = ^() {
      NSLog (@"第%ld个cell 被点击", indexPath.row);
    };

    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
