//
//  PresenceOfparkingViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PresenceOfparkingViewController.h"
#import "PresenceNumber.h"
#import "PresenceTags.h"


@interface PresenceOfparkingViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *_hoursAr;  // 小时
    NSMutableArray *_minAr;    // 分钟
}
@property (strong, nonatomic) UIButton *number;  // 泊车号
@property (strong, nonatomic) UIButton *tags;    // 电子标签

@property (strong, nonatomic) PresenceNumber *numberView; //泊车号View
@property (strong, nonatomic) PresenceTags *tagsView; // 电子标签View


@end

@implementation PresenceOfparkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"占道停车";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initatinDateData];
    [self createrSelector];
    
}

// 初始化数据
- (void)initatinDateData
{
    _hoursAr = [NSMutableArray array];
    _minAr = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        [_hoursAr addObject:[NSString stringWithFormat:@"%d小时", i]];
    }
    
    for (int i = 0; i < 60; i++) {
        [_minAr addObject:[NSString stringWithFormat:@"%d分钟", i]];
    }
}

#pragma mark - 创建选择器
- (void)createrSelector
{
    // 号码
    _number = [UIButton buttonWithType:UIButtonTypeCustom];
    _number.frame = CGRectMake(30, 20, SCREEN_WIDTH  * 0.3, 35);
    [_number setTitle:@"泊车号" forState:UIControlStateNormal];
    [_number setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _number.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_number setBackgroundImage:[UIImage imageNamed:@"bochehao_btn_selected"] forState:UIControlStateNormal];
    [_number addTarget:self action:@selector(numberAtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_number];
    
    // 标签
    _tags = [UIButton buttonWithType:UIButtonTypeCustom];
    _tags.frame = CGRectMake(CGRectGetMinX(_number.frame), CGRectGetMaxY(_number.frame) + 10, CGRectGetWidth(_number.frame), CGRectGetHeight(_number.frame));
    [_tags setTitle:@"电子标签" forState:UIControlStateNormal];
    [_tags setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _tags.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_tags setBackgroundImage:[UIImage imageNamed:@"bochehao_btn"] forState:UIControlStateNormal];
    [_tags addTarget:self action:@selector(tageAtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_tags];
    
    
    // 泊车号View
    _numberView = [[PresenceNumber alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tags.frame) + 10, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_tags.frame) + 10)];
//    [_numberView.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _numberView.pickerView.delegate = self;
    _numberView.pickerView.dataSource = self;
    [_numberView.determine addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 电子标签View
    _tagsView = [[PresenceTags alloc] initWithFrame:_numberView.frame];
    
    [self.view addSubview:_numberView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 泊车号
- (void)numberAtion:(UIButton *)sender
{
    [_number setBackgroundImage:[UIImage imageNamed:@"bochehao_btn_selected"] forState:UIControlStateNormal];
    [_tags setBackgroundImage:[UIImage imageNamed:@"bochehao_btn"] forState:UIControlStateNormal];
    
    if (_numberView.superview == nil) {
        [_tagsView removeFromSuperview];
        [self.view addSubview:_numberView];
    }
}

#pragma mark - 泊车号确定
- (void)determineAction:(UIButton *)sender
{
    NSString *hours = [_hoursAr objectAtIndex:[_numberView.pickerView selectedRowInComponent:0]];
    NSString *min = [_minAr objectAtIndex:[_numberView.pickerView selectedRowInComponent:1]];
    
    NSString *title = [NSString stringWithFormat:@"泊车号:%@ \n预约时间:%@:%@", _numberView.numberStr, hours, min];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"canel" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 电子标签
- (void)tageAtion:(UIButton *)sender
{
    [_number setBackgroundImage:[UIImage imageNamed:@"bochehao_btn"] forState:UIControlStateNormal];
    [_tags setBackgroundImage:[UIImage imageNamed:@"bochehao_btn_selected"] forState:UIControlStateNormal];
    
    if (_tagsView.superview == nil) {
        [_numberView removeFromSuperview];
        [self.view addSubview:_tagsView];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_numberView removeKeyObtaionNumber];
    
}

#pragma mark - 时间选择器 Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _hoursAr.count;
    } else {
        return _minAr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_hoursAr objectAtIndex:row];
    } else {
        return [_minAr objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_numberView removeKeyObtaionNumber];
}

@end
