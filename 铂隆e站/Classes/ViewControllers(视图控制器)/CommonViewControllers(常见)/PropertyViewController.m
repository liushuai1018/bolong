//
//  PropertyViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PropertyViewController.h"
#import "PropertyView.h"
#import "PulldownMenusView.h"

@interface PropertyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

// 物业缴费视图
@property (nonatomic, strong) PropertyView *propertyV;

@property (nonatomic, strong) UITableView *aTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) PulldownMenusView *pulldownMenus;  // 二级菜单

@end

@implementation PropertyViewController

/*
- (void)loadView
{
    self.propertyV = [[PropertyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _propertyV;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物业缴费";
    self.navigationController.navigationBar.translucent = NO;
    
    self.aTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.aTableView.delegate = self;
    self.aTableView.dataSource = self;
    self.aTableView.tableFooterView = [self createFooterView];
    self.view = _aTableView;
    
    
    _dataArray = @[@"缴费单位", @"缴费小区",
                   @"户主姓名", @"身份证号"];
//    _propertyV.communltyPMV.tableArray = @[@"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区"];
//    _propertyV.unitPMV.tableArray = @[@"一单元", @"二单元", @"三单元", @"四单元"];
//    
//    [self cilckButton]; // 添加按钮事件
}



#pragma makr - addAction
- (void)cilckButton
{
    [_propertyV.payButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(UIButton *)sender
{
    NSLog(@"缴纳物业费用");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UITableViewCell *cell = [_aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    CGRect frame = cell.textLabel.frame;
    UITextField *text = [_aTableView viewWithTag:14000];
    text.frame = CGRectMake(CGRectGetMaxX(frame) + 20, CGRectGetMinY(frame), 200, CGRectGetHeight(frame));
    
    
    UITextField *text1 = [_aTableView viewWithTag:14001];
    text1.frame = CGRectMake(CGRectGetMaxX(frame) + 20, CGRectGetMinY(frame), 200, CGRectGetHeight(frame));
    
    _pulldownMenus = [[PulldownMenusView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(frame) + 20, CGRectGetMinY(frame), 200, CGRectGetHeight(frame))];
    _pulldownMenus.textField.placeholder = @"您的小区";
    _pulldownMenus.textField.textAlignment = NSTextAlignmentLeft;
    _pulldownMenus.tableArray = @[@"惠润嘉园一区",
                                  @"惠润嘉园二区",
                                  @"惠润嘉园三区",
                                  @"惠润嘉园四区",
                                  @"惠润嘉园五区",
                                  @"惠润嘉园六区",
                                  @"惠润嘉园七区"];
    [cell addSubview:_pulldownMenus];
    
    
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
            cell.detailTextLabel.text = @"华特物业";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 显示跳转图标
            break;
        }
        case 1: {
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
    NSLog(@"indexPath = %@", indexPath);
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
    button.frame = CGRectMake(SCREEN_WIDTH * 0.25, CGRectGetMaxY(label.frame) + 20, SCREEN_WIDTH * 0.5, 40);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = grennColor.CGColor;
    [button setTitle:@"缴费" forState:UIControlStateNormal];
    [button setTitleColor:grennColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(propertyAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height + 70);
    
    return view;
}

#pragma makr - 创建accessoryView
- (UIView *)createrAccessoryView
{
    UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    UITextField *label = [[UITextField alloc] initWithFrame:accessory.bounds];
    label.placeholder = @"家庭";
    label.textAlignment = NSTextAlignmentCenter;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiayibu"]];
    imageView.frame = CGRectMake(0, 0, 10, 15);
    label.rightView = imageView;
    label.rightViewMode = UITextFieldViewModeAlways;
    [accessory addSubview:label];
    
    return accessory;
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
    NSLog(@"物业缴费...............");
}

#pragma makr - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
