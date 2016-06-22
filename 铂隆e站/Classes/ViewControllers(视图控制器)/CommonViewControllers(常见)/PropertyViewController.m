//
//  PropertyViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PropertyViewController.h"
#import "SelectAVillageTableViewController.h"
#import "CommunityInformation.h"
#import "WuYePayCostViewController.h"
#import "WuYeDetails.h"
#import "LS_WuYeInform_Model.h"

@interface PropertyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    LS_WuYeInform_Model *_wuyeModel;     // 记录选择的物业
    CommunityInformation *_community;    // 记录选择的小区
}

@property (nonatomic, strong) UITableView *aTableView;  // 表格
@property (nonatomic, strong) NSArray *dataArray;       // 表格数据

@property (strong, nonatomic) NSArray *wuyeInformAr;    // 物业数据

@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物业缴费";
    self.navigationController.navigationBar.translucent = NO;
    
    [self getCommunityInformation];
    [self createrTableView];
    
}

#pragma mark - 获取数据
- (void)getCommunityInformation
{
    _dataArray = @[@"缴费单位",
                   @"缴费小区",
                   @"户主姓名",
                   @"身份证号"];
    
    
    
    // 获取物业信息
    __weak PropertyViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance]  getWuYeRetuns:^(NSArray *array) {
        if (array) {
            _wuyeInformAr = array;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                PropertyViewController *strong_control = weak_control;
                if (strong_control) {
                    [strong_control createrAlertControlTitle:@"请求物业失败!"];
                }
            });
        }
    }];
    
}

#pragma mark - 创建tableView
- (void)createrTableView
{
    self.aTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.aTableView.delegate = self;
    self.aTableView.dataSource = self;
    self.aTableView.tableFooterView = [self createFooterView];
    self.view = _aTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图已经出现
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UITableViewCell *cell = [_aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    CGRect frame = cell.textLabel.frame;
    UITextField *text = [_aTableView viewWithTag:14000];
    text.frame = CGRectMake(CGRectGetMaxX(frame) + 20, CGRectGetMinY(frame), 200, CGRectGetHeight(frame));
    
    
    UITextField *text1 = [_aTableView viewWithTag:14001];
    text1.frame = CGRectMake(CGRectGetMaxX(frame) + 20, CGRectGetMinY(frame), 200, CGRectGetHeight(frame));
    
    
}
#pragma mark - 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 注册键盘推出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // 注册键盘回收通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // remove通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStr";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0: {
            cell.detailTextLabel.text = @"请选择物业";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 显示跳转图标
            break;
        }
        case 1: {
            cell.detailTextLabel.text = @"请选择小区";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 显示跳转图标
            cell.contentView.frame = CGRectMake(0, 0, 320, 100);
            break;
        }
        case 2: {
            [self createrTextField:cell indexPath:indexPath];
            break;
        }
        case 3: {
            [self createrTextField:cell indexPath:indexPath];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.1;
}

#pragma mark - 创建附件添加输入框到cell上
- (void)createrTextField:(UITableViewCell *)sender indexPath:(NSIndexPath *)indexPath
{
    
    // 创建输入框
    UITextField *text = [[UITextField alloc] init];
    text.backgroundColor = [UIColor whiteColor];
    text.delegate = self;
    if (indexPath.row == 2) {
        text.placeholder = @"输入户主姓名";
        text.tag = 14000;
    } else {
        text.placeholder = @"户主身份证号";
        text.tag = 14001;
    }
    
    [sender addSubview:text];
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __block PropertyViewController *property = self;
    [self textFieldResignFirstResponder];
    
    if (0 == indexPath.row) {
        SelectAVillageTableViewController *selectVillage = [[SelectAVillageTableViewController alloc] init];
        selectVillage.title = @"选择物业";
        selectVillage.wuyeAr = _wuyeInformAr;
        selectVillage.dataArray = nil;
        selectVillage.wuyeBlock = ^(LS_WuYeInform_Model *model){
            _wuyeModel = model;
            
            UITableViewCell *cell = [property.aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.detailTextLabel.text = model.fenqu;
            
            UITableViewCell *cell1 = [property.aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell1.detailTextLabel.text = @"请选择小区";
        };
        
        [self.navigationController pushViewController:selectVillage animated:YES];
    }
    
    // 点击小区推出选择界面
    if (1 == indexPath.row) {
        if (!_wuyeModel) {
            [self createrAlertControlTitle:@"请选择物业"];
            return;
        }
        
        SelectAVillageTableViewController *selectVillage = [[SelectAVillageTableViewController alloc] init];
        
        [[NetWorkRequestManage sharInstance] getCommunityWuYeID:_wuyeModel.wuyeID communityInform:^(NSArray *array) {
            
            selectVillage.dataArray = array;
        }];
        
        
        selectVillage.wuyeAr = nil;
        selectVillage.title = @"选择小区";
        
        
        // 选择完成本界面并设置上选择的小区
        selectVillage.block = ^(CommunityInformation *community){
            _community = community;
            
            UITableViewCell *cell = [property.aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.detailTextLabel.text = community.home;
        };
        
        [self.navigationController pushViewController:selectVillage animated:YES];
    }
    
}

#pragma mark - 创建尾部View
- (UIView *)createFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.35)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), 0.5)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:view1];
    
    // 富文本文字
    NSString *title = @"物业缴费: \n        1.物业共用部位共用设施设备的日常运行维护费用(含租区内正常工作时间的空调费，公共区域水费、排污费、电费、热水费、空调费等公共事业费用); 2.物业管理区域(公共区域)清洁卫生费用; 3.物业管理区域(公共区域)绿化养护费用; 4.物业管理区域秩序维护费用，办公费用; 5.物业管理企业固定资产折旧; 6.物业共用部位、共用设施设备及公众责任保险费用。";
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    
    UIColor *powderColor = [UIColor colorWithRed:0.98 green:0.6 blue:0.6 alpha:1.0];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:13.0f]
                          range:NSMakeRange(0, 5)];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:powderColor
                          range:NSMakeRange(0, 5)];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12.0f]
                          range:NSMakeRange(5, title.length - 5)];
    
    // 提示文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(view.frame) - 40, CGRectGetHeight(view.frame))];
    label.attributedText = attributedStr;
    label.numberOfLines = 0;
    CGSize size = [self boundingRextWithSize:CGSizeMake(CGRectGetWidth(label.frame), 0) label:label];
    label.frame = CGRectMake(20, 0, size.width, size.height);
    [view addSubview:label];
    
    
    // 缴费
    UIColor *grennColor = [UIColor colorWithRed:0 green:0.95 blue:0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(SCREEN_WIDTH * 0.25, CGRectGetMaxY(label.frame) + 10, SCREEN_WIDTH * 0.5, 40);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = grennColor.CGColor;
    [button setTitle:@"缴费" forState:UIControlStateNormal];
    [button setTitleColor:grennColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(propertyAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(button.frame) + 10);
    
    return view;
}

#pragma makr - 根据字符串获取高度
- (CGSize)boundingRextWithSize:(CGSize)size label:(UILabel *)label
{
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    
    CGSize retSize = [label.text boundingRectWithSize:size
                                              options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    
    return retSize;
}


#pragma mark - 物业缴费事件
- (void)propertyAction
{
    
    [self textFieldResignFirstResponder];
    // 户主名
    UITextField *nameTextField = [_aTableView viewWithTag:14000];
    NSString *name = nameTextField.text;
    
    // 户主身份证号
    UITextField *certificate = [_aTableView viewWithTag:14001];
    NSString *number = certificate.text;
    
    // 小区id
    NSString *communityID = _community.wuye_id;
    
    // 物业ID
    NSString *wuyeID = _wuyeModel.wuyeID;
    
    UserInformation *user =  [[LocalStoreManage sharInstance] requestUserInfor];
    
    __weak PropertyViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] wuyeInoformationID:user.user_id communityID:communityID number:number name:name wuyeID:wuyeID returns:^(WuYeDetails *wuyeDetails) {
        PropertyViewController *strong_control = weak_control;
        if (strong_control) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                WuYePayCostViewController *wuyePay = [[WuYePayCostViewController alloc] init];
                wuyePay.wuye = wuyeDetails;
                wuyePay.userInformation = user;
                [strong_control.navigationController pushViewController:wuyePay animated:YES];
            });
        }
    }];
}

#pragma makr - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldResignFirstResponder
{
    // 户主名
    UITextField *nameTextField = [_aTableView viewWithTag:14000];
    [nameTextField resignFirstResponder];
    
    // 户主身份证号
    UITextField *certificate = [_aTableView viewWithTag:14001];
    [certificate resignFirstResponder];
}

#pragma mark - 监听键盘的弹出
- (void)keyboardWillShow:(NSNotification *)info
{
    // 获取键盘高度
    CGFloat height = [[info.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    /*
     *  在弹出键盘的状态下再次修改输入的类型 会再次减去键盘的高度，导致tableView下面一大块空白
     */
    
    // 获取键盘的顶端到导航栏下部的高
    CGFloat tableViewHeight = SCREEN_HEIGHT - height;
    
    // 获取键盘弹出动画的时间
    double duration = [[info.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _aTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeight);
    }];
    
    
}

#pragma mark - 监听键盘的收回
- (void)keyboardWillHide:(NSNotification *)infor
{
    double duraction = [[infor.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duraction animations:^{
        _aTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

#pragma mark - alertControl 
- (void)createrAlertControlTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
