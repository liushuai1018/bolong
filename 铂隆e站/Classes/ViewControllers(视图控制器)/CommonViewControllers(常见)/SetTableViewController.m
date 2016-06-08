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
#import "LS_AddressManage_ViewController.h"

@interface SetTableViewController ()
{
    NSArray *_imageArray; // 图片数组
    NSArray *_titleArray; // 标题数组
    
    InforSetTableViewController *_inforSetTVC; // 信息设置
    LS_AddressManage_ViewController *_addressManage; // 地址管理
}
@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    
    [self initData];
    [self addLeftBut];
    [self initTableView];
    
}

#pragma mark - initData
- (void)initData
{
    _imageArray = @[@"LS_qingchuhuancun",
                    @"LS_dizhiguabli",
                    @"LS_xinxishezhi"];
    _titleArray = @[@"清理缓存",
                    @"地址管理",
                    @"信息设置"];
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

#pragma mark - init TableView
- (void)initTableView
{
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_bangzhu_bg"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_titleArray.count != 0) {
#warning mark - 隐藏了一项
        return _titleArray.count - 1;
    } else {
        return 0;
    }
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
    button.frame = CGRectMake(SCREEN_WIDTH * 0.3, 5, SCREEN_WIDTH * 0.4, 30);
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

// 退出按钮
- (void)clickFooterButton:(UIButton *)sender
{
    // 设置登录状态
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"status"];
    // 移除上一个用户信息
    [[LocalStoreManage sharInstance] removeAllUserInfor];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_block) {
            _block();
        }
    }];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.08;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2: {
            
            _inforSetTVC = [[InforSetTableViewController alloc] init];
            [self.navigationController pushViewController:_inforSetTVC animated:YES];
            break;
        }
        case 0: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[LocalStoreManage sharInstance] clearTheCache];
            }];
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 1: {
            _addressManage = [[LS_AddressManage_ViewController alloc] init];
            [self.navigationController pushViewController:_addressManage animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
