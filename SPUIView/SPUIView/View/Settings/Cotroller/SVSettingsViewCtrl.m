//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVSettingsViewCtrl.h"
@interface SVSettingsViewCtrl () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation SVSettingsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"SVSettingsView页面");

    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //编辑界面
    //一.创建一个 tableView
    // 1.style:Grouped化合的,分组的
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                              style:UITableViewStyleGrouped];
    //2.设置背景颜色
    _tableView.backgroundColor = [UIColor whiteColor];
    // 3.设置 table 的行高
    _tableView.rowHeight = 50;
    //*4.设置代理
    _tableView.delegate = self;
    //*5.设置数据源
    _tableView.dataSource = self;
    //三.添加
    // 7.把tableView添加到 view
    [self.view addSubview:_tableView];
}

//方法:

//设置 tableView 的 numberOfSectionsInTableView(设置几个 section)
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}
//设置 tableView的 numberOfRowsInSection(设置每个section中有几个cell)
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return 5;
}
//设置 tableView的 cellForRowIndexPath(设置每个cell内的具体内容)

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellId = @"cell";

    UITableViewCell* cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:cellId];
    // 1.设置cell的textLabel
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    // 2.设置cell的背景颜色
    //        cell.backgroundColor = [UIColor yellowColor];


    //设置每个cell的内容
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"                  当前连接:";
        }
       
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        if (indexPath.row == 0) {
            cell.textLabel.text = @"版本升级";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"意见反馈";
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"分享";
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"关于";
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"语言设置";
        }
    }
    return cell;
}

//设置 tableView 的 sectionHeader蓝色 的header的有无
- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                          50)];
//        view.backgroundColor = [UIColor blueColor];
    view.alpha = 0.5;

    return view;
}
//设置tableView的 sectionFooter黑色 的Footer的有无
- (UIView*)tableView:(UITableView*)tableView
    viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                          50)];
    //    view.backgroundColor = [UIColor blackColor];
    return view;
}

//设置 tableView的section 的Header的高度
- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    else
        return 10;
}
//设置 tableView的section 的Footer的高度
- (CGFloat)tableView:(UITableView*)tableView
    heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        //添加按钮:开始测试
        //创建一个switch并添加
        UISwitch* abcd =
            [[UISwitch alloc] initWithFrame:CGRectMake(265, 6, 0, 0)];
        //改变switch的位置
        //                abcd = [[UISwitch alloc]initWithFrame:CGRectMakeF(265,
        //                6, 0, 0)];
        //改变switch的状态
        abcd.on = YES;
        //添加
        //        [cell.contentView addSubview:abcd];
        return 10;
    }
    else
        return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
