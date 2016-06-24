//
//  WuYePayCostViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "WuYePayCostViewController.h"
#import "WuYePayCostView.h"
#import "WuYeDetails.h"
#import "HousingAddress.h"
#import "LS_MultiSelectMenu_TableViewController.h"

@interface WuYePayCostViewController ()

@property (strong, nonatomic) WuYePayCostView *wuyePayCostView;

// 记录选择缴费的房屋
@property (strong, nonatomic) NSArray *chooseAddressAr;
@property (strong, nonatomic) NSString *log_IDs;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int secondsCountDown;

@end

@implementation WuYePayCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self createrView];
    [self setBlock];
}

#pragma mark - 界面显示信息赋值
- (void)viewWillAppear:(BOOL)animated
{
    _wuyePayCostView.name.text = [NSString stringWithFormat:@"姓名:%@", _wuye.name];
    _wuyePayCostView.number.text = [NSString stringWithFormat:@"身份证:%@", _wuye.number];
    
    _wuyePayCostView.paymentDetails.text = [NSString stringWithFormat:@"详情:物业费每平方米按%.2f元收取", _wuye.unit_price];
    _wuyePayCostView.totalFee.text = @"总计:0.00元";
    
}

#pragma mark - 创建 SubView
- (void)createrView
{
    self.wuyePayCostView = [[WuYePayCostView alloc] initWithFrame:self.view.bounds];
    
    self.view = _wuyePayCostView;
}

#pragma mark - 设置block
- (void)setBlock
{
    __weak WuYePayCostViewController *wuyePay = self;
    
    // 支付block
    _wuyePayCostView.block = ^(){
        
        BOOL is = (wuyePay.chooseAddressAr.count != 0);
        
        if (is) { // 判断有没有选择房屋
            
            [[NetWorkRequestManage sharInstance] wuyePay:wuyePay.userInformation.user_id
                                                 log_ids:wuyePay.log_IDs
                                                  wuyeID:wuyePay.wuyeID
                                                   retum:^(NSDictionary *dict)
            {
                NSInteger index = [[dict objectForKey:@"resultStatus"] integerValue];
                if (9000 == index) { // 判断缴费情况 resultStatus 值除了 9000 以外都是缴费失败
                    
                    [wuyePay createrAlertString:@"缴费成功" choose:NO];
                    
                } else {
                    
                    [wuyePay createrAlertString:[dict objectForKey:@"memo"] choose:YES];
                    
                }
                
             }];
            
        } else {
            
            [wuyePay createrAlertString:@"请选择缴纳的房屋地址" choose:YES];
            
            
        }
        
    };
    
    /*
    // 选择房屋
    _wuyePayCostView.pulldownMenus.chooseBlcok = ^(NSIndexPath *indexPath){
        
        HousingAddress *address = [wuyePay.wuye.addressList objectAtIndex:indexPath.row];
        wuyePay.chooseAddress = address;
        wuyePay.wuyePayCostView.totalFee.text = [NSString stringWithFormat:@"总计:%.2f元", address.price];
        
    };
     */
    
    [_wuyePayCostView.pulldownMenus addTarget:self action:@selector(didClickHousingInform:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择缴费房屋
- (void)didClickHousingInform:(UIButton *)sender {
    LS_MultiSelectMenu_TableViewController *control = [[LS_MultiSelectMenu_TableViewController alloc] init];
    control.housingInform = _wuye;
    __weak WuYePayCostViewController *weak_control = self;
    control.block = ^(NSArray *dataAr) {
        WuYePayCostViewController *strong_control = weak_control;
        if (strong_control) {
            strong_control.chooseAddressAr = dataAr;
            
            CGFloat price = 0;
            NSMutableArray *log_idsAR = [NSMutableArray array];
            for (HousingAddress *model in dataAr) {
                price = price + model.price;
                [log_idsAR addObject:[NSString stringWithFormat:@"%ld", (long)model.log_id]];
            }
            NSString *log_IDs = [log_idsAR componentsJoinedByString:@","];
            strong_control.log_IDs = log_IDs;
            [sender setTitle:[NSString stringWithFormat:@"选择房屋编号:%@", log_IDs] forState:UIControlStateNormal];
            strong_control.wuyePayCostView.totalFee.text = [NSString stringWithFormat:@"总计:%.2f元", price];
        }
    };
    
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - 提示框
- (void)createrAlertString:(NSString *)title choose:(BOOL)is
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (is) {
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alert addAction:cancel];
    } else {
        
        __weak WuYePayCostViewController *wuyePay = self;
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action)
        {
            // 缴费成功点击确定 退出到父视图
            [_timer invalidate];
            [wuyePay.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        [alert addAction:cancel];
        
        [self createrTimer];
    }
    
    
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - 计时器
- (void)createrTimer
{
    _secondsCountDown = 2;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
}

#pragma mark - 倒计时
- (void)timerAction
{
    if (_secondsCountDown == 0) {
        [_timer invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    _secondsCountDown--;
}



@end
