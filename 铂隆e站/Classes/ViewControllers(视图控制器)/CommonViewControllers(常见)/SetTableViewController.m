//
//  SetTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "SetTableViewController.h"
#import "SetTableViewCell.h"

#import "InforSetTableViewController.h"
#import "TheBindingViewController.h"

@interface SetTableViewController ()
{
    NSArray *_imageArray; // 图片数组
    NSArray *_titleArray; // 标题数组
    
    InforSetTableViewController *_inforSetTVC; // 信息设置
    TheBindingViewController *_theBindingVC;    // 绑定手机
}
@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.title = @"设置";
    
    _imageArray = @[@"xinxishezhi.png", @"bangding.png", @"qingchuhuancun.png", @"dizhiguanli.png"];
    _titleArray = @[@"信息设置", @"未绑定", @"清理缓存", @"地址管理"];
    
    [self addLeftBut];
    
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - 添加 BarBUtton
- (void)addLeftBut
{
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didCilckLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)didCilckLeftAction:(UIBarButtonItem *)but
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.title.text = _titleArray[indexPath.row];
    
    return cell;
}

// 设置区尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = view.bounds;
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

// 退出按钮
- (void)clickFooterButton:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"status"];
    // 移除信息
    [[LocalStoreManage sharInstance] removeAllUserInfor];
    // 退出当前界面，返回到首界面
    [self dismissViewControllerAnimated:YES completion:nil];
    self.block();
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            
            _inforSetTVC = [[InforSetTableViewController alloc] init];
            [self.navigationController pushViewController:_inforSetTVC animated:YES];
            
            break;
        }
        case 1: {
            _theBindingVC = [[TheBindingViewController alloc] init];
            [self.navigationController pushViewController:_theBindingVC animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
