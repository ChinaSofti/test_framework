//
//  SVCurrentResultViewCtrl.m
//  SPUIView
//
//  Created by Rain on 2/14/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVCurrentResultViewCtrl.h"
#import "SVI18N.h"
#import "SVSystemUtil.h"
#import "SVTestContextGetter.h"
#import "SVTestViewCtrl.h"
#import "SVToolCell.h"

#define kFirstHederH 40
#define kLastFooterH 140
#define kCellH (kScreenW - 20) * 0.22
#define kMargin 10
#define kCornerRadius 5

@interface SVCurrentResultViewCtrl () <UITableViewDelegate, UITableViewDataSource>

{
    // 重新测试按钮
    UIButton *_reTestButton;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *soucreMA;
@property (nonatomic, retain) NSMutableArray *selectedMA;
@property (nonatomic, retain) UIButton *testBtn;
@property (nonatomic, retain) UIView *footerView;


@end

@implementation SVCurrentResultViewCtrl

@synthesize navigationController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog (@"---------------------go to result view---------------------");

    [super viewDidLoad];
    NSLog (@"SVTestViewController");

    // 1.自定义navigationItem.titleView
    //设置图片大小
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake (0, 0, 100, 30)];
    //设置图片名称
    imageView.image = [UIImage imageNamed:@"speed_pro"];
    //让图片适应
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //把图片添加到navigationItem.titleView
    self.navigationItem.titleView = imageView;
    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    // 2.编辑界面
    //创建一个 tableView
    // 1.style:Grouped化合的,分组的
    _tableView =
    [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 2.设置背景颜色
    _tableView.backgroundColor = [UIColor whiteColor];
    // 3.设置 table 的行高
    //*4.设置代理
    _tableView.delegate = self;
    //*5.设置数据源
    _tableView.dataSource = self;
    // 6.定义数组展示图片
    _selectedMA = [NSMutableArray array];
    NSString *title = I18N (@"VideoTest");
    //    NSString *title = @"视频测试";
    NSArray *sourceA = @[
        @{
            @"img_normal": @"ic_video_label",
            @"img_selected": @"ic_video_label",
            @"title": title,
            @"rightImg_normal": @"1",
            @"rightImg_selected": @"ic_video_check"
        }
    ];
    NSMutableArray *sourceMA = [NSMutableArray array];
    for (int i = 0; i < sourceA.count; i++)
    {
        SVToolModel *toolModel = [SVToolModel modelWithDict:sourceA[i]];
        [sourceMA addObject:toolModel];
    }

    _soucreMA = sourceMA;
    // 7.把tableView添加到 view
    [self.view addSubview:_tableView];
}

//方法:

//设置 tableView 的 numberOfSectionsInTableView(设置几个 section)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _soucreMA.count;
}
//设置 tableView的 numberOfRowsInSection(设置每个section中有几个cell)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//设置 tableView的 cellForRowIndexPath(设置每个cell内的具体内容)
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";

    SVToolCell *cell =
    [[SVToolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    cell.delegate = self;
    [cell cellViewModel:_soucreMA[indexPath.section] section:indexPath.section];
    return cell;
}

//设置 tableView 的 sectionHeader蓝色 的header的有无
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
//设置tableView的 sectionFooter黑色 的Footer的有无
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _soucreMA.count - 1)
    {

        [self.footerView addSubview:self.testBtn];
        return self.footerView;
    }
    return nil;
}

//设置 tableView的section 的Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//设置 tableView的section 的Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kCellH;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *开始测试按钮初始化(按钮未被选中时的状态)
 **/

- (UIButton *)testBtn
{
    if (_testBtn == nil)
    {
        //按钮高度
        CGFloat testBtnH = 40;
        //按钮类型
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //按钮尺寸
        _testBtn.frame = CGRectMake (kMargin * 4, kLastFooterH - testBtnH, kScreenW - kMargin * 8, testBtnH);
        //按钮背景颜色
        _testBtn.backgroundColor =
        [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0];
        //按钮文字和类型
        [_testBtn setTitle:@"再测一次" forState:UIControlStateNormal];
        //按钮点击事件
        [_testBtn addTarget:self
                     action:@selector (testBtnClick)
           forControlEvents:UIControlEventTouchUpInside];
        //按钮圆角
        _testBtn.layer.cornerRadius = kCornerRadius;
        //设置居中
        _testBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //按钮文字颜色和类型
        [_testBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //按钮交互
        //设置按钮默认情况下不可交互
        _testBtn.userInteractionEnabled = YES;
    }
    return _testBtn;
}

//初始化footerView
- (UIView *)footerView
{
    if (_footerView == nil)
    {
        _footerView = [[UIView alloc] init];
    }
    return _footerView;
}

/**
 *section中的cell的点击事件(按钮选中后的状态设置)
 **/

- (void)toolCellClick:(SVToolCell *)cell
{
    NSLog (@"cell is clicked. %@", cell);
}


//按钮的点击事件
- (void)testBtnClick
{
    NSLog (@"back to testting view");
    [navigationController popViewControllerAnimated:NO];
}

@end
