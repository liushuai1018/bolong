//
//  LS_Other_recycling_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/9.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_recycling_ViewController.h"
#import "LS_Other_recycling_View.h"
#import "LS_button.h"
#import "LS_feipinPrice_model.h"

#import "SelectAVillageTableViewController.h"
#import "LS_WuYeInform_Model.h"

@interface LS_Other_recycling_ViewController () <LS_buttonDelegate, UITextViewDelegate>

@property (strong, nonatomic) LS_Other_recycling_View *LS_view;

// 记录选择收购那一项
@property (assign, nonatomic) NSInteger index;

// 自定义提示框
@property (strong, nonatomic) UIView *alertView;
// 输入框
@property (strong, nonatomic) UITextView *textView;

// 记录废品单价数组
@property (strong, nonatomic) NSArray *priceAr;

// 物业公司选项
@property (strong, nonatomic) UIButton *wuye;

// 记录物业公司
@property (copy, nonatomic) NSArray *dataAr;

// 选择的物业公司
@property (strong, nonatomic) LS_WuYeInform_Model *model;

@end

@implementation LS_Other_recycling_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回收";
    self.tabBarController.tabBar.translucent = NO;
    
    [self createrSubView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据
- (void)initData
{
    __weak LS_Other_recycling_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] other_FeipinPriceReturn:^(NSArray *array) {
        LS_Other_recycling_ViewController *strong_control = weak_control;
        if (strong_control) {
            if (!array) {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{ // 主线程刷新UI
                strong_control.priceAr = array;
                LS_feipinPrice_model *model = [array objectAtIndex:1];
                strong_control.LS_view.button.label.text = [NSString stringWithFormat:@"%@:%@元", model.name, model.price];
            });
        }
    }];
    
    [[NetWorkRequestManage sharInstance] getWuYeRetuns:^(NSArray *array) {
        weak_control.dataAr = array;
    }];
}

#pragma mark - 创建视图
- (void)createrSubView
{
    LS_Other_recycling_View *view = [[LS_Other_recycling_View alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    _LS_view = view;
    self.view = _LS_view;
    
    _LS_view.button.delegate = self;
    _LS_view.button.label.text = @"易拉罐:--元";
    [_LS_view.buyBut addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _index = 1; // 默认收购1
}
#pragma mark - 监听上门收购按钮事件
- (void)buyAction:(UIButton *)sender
{
    
    [self createrAlertView];
}


#pragma mark - createrAlertView
- (void)createrAlertView
{
    if (!_alertView) {
        
        _alertView = [[UIView alloc] initWithFrame:self.view.bounds];
        _alertView.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.4];
        [self.view addSubview:_alertView];
        
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGrestureRecognizerAction:)];
        [_alertView addGestureRecognizer:tap];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.3)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.center = _alertView.center;
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 5;
        [_alertView addSubview:whiteView];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(whiteView.frame) - 20, CGRectGetHeight(whiteView.frame) * 0.6)];
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.text = @"请输入详细地址";
        _textView.delegate = self;
        [whiteView addSubview:_textView];
        
        UIButton *wuye = [UIButton buttonWithType:UIButtonTypeCustom];
        wuye.frame = CGRectMake(CGRectGetWidth(whiteView.frame) * 0.1, CGRectGetHeight(whiteView.frame) * 0.7 + 5, CGRectGetWidth(whiteView.frame) * 0.35, CGRectGetHeight(whiteView.frame) * 0.2);
        [wuye setBackgroundColor:[UIColor blackColor]];
        [wuye setTitle:@"选择物业" forState:UIControlStateNormal];
        [wuye setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        wuye.layer.masksToBounds = YES;
        wuye.layer.cornerRadius = CGRectGetHeight(wuye.frame) * 0.5;
        [wuye addTarget:self action:@selector(didClickWuYeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.wuye = wuye;
        [whiteView addSubview:self.wuye];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(whiteView.frame) * 0.55, CGRectGetMinY(wuye.frame), CGRectGetWidth(wuye.frame), CGRectGetHeight(wuye.frame));
        [button setBackgroundColor:[UIColor blackColor]];
        [button setTitle:@"收购" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = CGRectGetHeight(button.frame) * 0.5;
        [button addTarget:self action:@selector(recycleAction) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
    } else {
        [self.view addSubview:_alertView];
        _textView.text = @"请输入详细地址";
        
    }
    
    
}

#pragma mark - tap手势事件
- (void)tapGrestureRecognizerAction:(UITapGestureRecognizer *)sender
{
    [_alertView  removeFromSuperview];
}

#pragma mark - button_delegate
- (void)selectButtonAction:(LS_button *)sender selectIndex:(NSInteger)index
{
    if (_priceAr) {
        LS_feipinPrice_model *model = [_priceAr objectAtIndex:index];
        _LS_view.button.label.text = [NSString stringWithFormat:@"%@:%@元", model.name, model.price];
        _index = index;
    }
}

#pragma mark - 选择物业公司
- (void)didClickWuYeAction:(UIButton *)sender {
    SelectAVillageTableViewController *control = [[SelectAVillageTableViewController alloc] init];
    control.wuyeAr = _dataAr;
    __weak LS_Other_recycling_ViewController *weak_control = self;
    control.wuyeBlock = ^(LS_WuYeInform_Model *model) {
        weak_control.model = model;
        [weak_control.wuye setTitle:model.fenqu forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 收购action
- (void)recycleAction
{
    NSString *address = _textView.text;
    
    if (!_model) {
        [self alertViewString:@"请选择物业公司!"];
        return;
    }
    
    if ([address isEqualToString:@""] || [address isEqualToString:@"请输入详细地址"]) {
        [self alertViewString:@"地址不能为空!"];
        return;
    }
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    __weak LS_Other_recycling_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] other_FeipinAcquisitionWuye_id:_model.wuyeID
                                                                address:address
                                                                  phone:userInfo.mobile
                                                                returns:^(BOOL is)
    {
        LS_Other_recycling_ViewController *strong_control = weak_control;
        if (strong_control) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (is) {
                    [strong_control alertViewString:@"消息发送成功,敬请耐心等待!"];
                } else {
                    [strong_control alertViewString:@"消息发送失败!"];
                }
            });
        }
    }];
    
    [_alertView removeFromSuperview];
}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIView *view = textView.superview;
    
    view.center = CGPointMake(view.center.x, 100);
    
    textView.text = @"";
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIView *view = textView.superview;
    
    view.center = view.superview.center;
}

#pragma mark - alertView
- (void)alertViewString:(NSString *)title
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertControl addAction:cancel];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

@end
