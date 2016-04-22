//
//  LS_AddressManage_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_AddressManage_ViewController.h"
#import "LS_addressManage_TableViewCell.h"
#import "LS_addressManage.h"
#import "LS_addNewAddress_ViewController.h"

#define cellString @"cell"
@interface LS_AddressManage_ViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 详细地址列表
@property (strong, nonatomic) NSMutableArray *dataAr;
// 用户信息
@property (strong, nonatomic) UserInformation *userInfo;

@end

@implementation LS_AddressManage_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理收货地址";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initData];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData
{
    NSArray *array = [[LocalStoreManage sharInstance] obtainAddressList];
    self.dataAr = [NSMutableArray array];
    
    if (array == nil) { // 如果本地有地址列表 则 不用网络请求
        
        _userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
        
        __weak LS_AddressManage_ViewController *control = self;
        [[NetWorkRequestManage sharInstance] requestAddressUser_id:_userInfo.user_id returns:^(NSArray *array) {
            [control.dataAr addObjectsFromArray:array];
            [control.tableView reloadData];
            
            [[LocalStoreManage sharInstance] storageAddressList:control.dataAr];
        }];
    } else {
        [_dataAr addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}

#pragma mark - initTableView
- (void)initTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LS_addressManage_TableViewCell" bundle:nil] forCellReuseIdentifier:cellString];
    self.tableView.tableFooterView = [UIImageView new];
}

#pragma mark - Table view data source
// 设置可以被编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 设置什么类型的编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// 编辑完成
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 发送删除地址命令
        LS_addressManage *address = [_dataAr objectAtIndex:indexPath.row];
        [[NetWorkRequestManage sharInstance] removeAddressUser_id:_userInfo.user_id address_id:address.address_id];
        
        // 本地删除
        [_dataAr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [[LocalStoreManage sharInstance] storageAddressList:_dataAr];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataAr.count == 0) {
        return 0;
    } else {
        return _dataAr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LS_addressManage_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString forIndexPath:indexPath];
    
    LS_addressManage *full_address = [_dataAr objectAtIndex:indexPath.row];
    
    if (full_address.LS_default || 0 == indexPath.row) { // 第一个元素或者‘设置’为真 的为默认地址
        
        [cell.select setImage:[UIImage imageNamed:@"LS_address_select"] forState:UIControlStateNormal];
    } else {
        [cell.select setImage:[UIImage imageNamed:@"LS_address_noselect"] forState:UIControlStateNormal];
    }
    
    [cell.select addTarget:self action:@selector(selectAddress:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.name.text = full_address.name;
    cell.address.text = full_address.full_address;
    cell.phoneNUmber.text = full_address.mobile;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.1;
}
#pragma mark - 修改已有地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LS_addNewAddress_ViewController *modify_address = [[LS_addNewAddress_ViewController alloc] init];
    modify_address.modeifyAddress = [_dataAr objectAtIndex:indexPath.row];
    
    __weak LS_AddressManage_ViewController *control = self;
    modify_address.sendNewAddress = ^(LS_addressManage *newAddress) {
        [control.dataAr replaceObjectAtIndex:indexPath.row withObject:newAddress];
        [control.tableView reloadData];
        // 修改完原有地址后跟新本地存储
        [[LocalStoreManage sharInstance] storageAddressList:_dataAr];
    };
    
    [self.navigationController pushViewController:modify_address animated:YES];
}

#pragma mark - 选择默认地址方法
- (void)selectAddress:(UIButton *)sender event:(UIEvent *)event
{
    NSIndexPath *indexPat = [self indexPathForSender:sender event:event];
    
    // 把原来默认地址取消
    LS_addressManage *address = [_dataAr objectAtIndex:0];
    address.LS_default = NO;
    
    // 把新的地址设为默认地址
    LS_addressManage *address1 = [_dataAr objectAtIndex:indexPat.row];
    address1.LS_default = YES;
    
    [_dataAr exchangeObjectAtIndex:indexPat.row withObjectAtIndex:0];
    [self.tableView reloadData];
    
    // 新设置默认地址后跟新本地存储地址
    [[LocalStoreManage sharInstance] storageAddressList:_dataAr];
}

// 获取点击 Cell 位置
- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton *)sender; // 当前点击的按钮
    UITouch *touch = [[event allTouches] anyObject]; // 获取按钮event 里包含的 touch 动作
    
    if (![button pointInside:[touch locationInView:button] withEvent:event]) {
        return nil;
    }
    
    CGPoint touchPosition = [touch locationInView:self.tableView];
    
    return [self.tableView indexPathForRowAtPoint:touchPosition];
}


#pragma mark - addAddress
- (IBAction)addAddress:(UIButton *)sender {
    LS_addNewAddress_ViewController *addressVC = [[LS_addNewAddress_ViewController alloc] init];
    
    __weak LS_AddressManage_ViewController *control = self;
    addressVC.sendNewAddress = ^(LS_addressManage *newAddress){
        [control addNewAddressAction:newAddress];
    };
    
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

// 添加新的地址后执行事件
- (void)addNewAddressAction:(LS_addressManage *)newAddress
{
    if (newAddress.LS_default) {  // 如果设置为默认地址则添加到数组第一位置
        LS_addressManage *address = [self.dataAr objectAtIndex:0];
        address.LS_default = NO; // 把原来默认设置为 NO
        
        [self.dataAr addObject:newAddress];
        [self.dataAr exchangeObjectAtIndex:self.dataAr.count - 1 withObjectAtIndex:0];  // 交换位置
    } else { // 添加到数组
        [self.dataAr addObject:newAddress];
    }
    
    [self.tableView reloadData];
    
    // 添加新地址后跟新本地地址列表
    [[LocalStoreManage sharInstance] storageAddressList:_dataAr];
}
@end
