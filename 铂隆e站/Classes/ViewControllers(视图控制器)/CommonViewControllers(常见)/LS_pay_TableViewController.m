//
//  LS_pay_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_pay_TableViewController.h"
#import "HelpTableViewCell.h"
#import "PayTableViewController.h"
#import "LS_Pay_OtherTableViewController.h"

#define cellStr @"cell"
@interface LS_pay_TableViewController ()
{
    // 缴费
    PayTableViewController *_pay;
    // 其他
    LS_Pay_OtherTableViewController *_pay_other;
}

@property (strong, nonatomic) NSArray *imageAr;
@end

@implementation LS_pay_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initData];
    [self addBarButton];
    [self initTableView];
}
#pragma mark - 初始化数据
- (void)initData
{
    _imageAr = @[@"new_wuye_jiaofei",
                 @"new_other_jiaofei"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加左边 barBUtton
- (void)addBarButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)clickLeftBarButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - initTableView
- (void)initTableView
{
    // 设置cell分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIImageView new];
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:cellStr];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_bangzhu_bg"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_imageAr.count != 0) {
        return _imageAr.count;
    } else {
        
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    cell.imageViews.image = [UIImage imageNamed:[_imageAr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            _pay = [[PayTableViewController alloc] init];
            [self.navigationController pushViewController:_pay animated:YES];
            break;
        case 1:
            _pay_other = [[LS_Pay_OtherTableViewController alloc]init];
            [self.navigationController pushViewController:_pay_other animated:YES];
            break;
            
        default:
            break;
    }
}

@end
