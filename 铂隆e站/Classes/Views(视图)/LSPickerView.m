//
//  LSPickerView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LSPickerView.h"


@interface LSPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) NSArray *thirdArray;
@property (nonatomic, strong) NSArray *selectedArray;

@property (nonatomic, assign) NSInteger chooseIndex;

@property (nonatomic, strong) NSString *returnString;

@end

@implementation LSPickerView

- (instancetype)initWithFrame:(CGRect)frame chooseIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView];
        [self createPicker:index];
        _chooseIndex = index;
    }
    return self;
}



// 懒加载
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.firstArray = [dataDic allKeys]; // 获取所有省份
    
    self.selectedArray = [self.dataDic objectForKey:[self.firstArray objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.secondArray = [[self.selectedArray objectAtIndex:0] allKeys]; // 获取市
    }
    
    if (self.secondArray.count > 0) {
        self.thirdArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.secondArray objectAtIndex:0]]; // 获取县
    }
    
}

#pragma mark - 选择创建那个选择器
- (void)createPicker:(NSInteger)index
{
    switch (index) {
        case 1: {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 200, CGRectGetWidth(self.frame), 162)];
            _pickerView.delegate = self;
            _pickerView.dataSource = self;
            _pickerView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_pickerView];
            break;
        }
        default:
            
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 200, CGRectGetWidth(self.frame), 162)];
            _datePicker.backgroundColor = [UIColor whiteColor];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区
            _datePicker.date = [NSDate date]; // 设置初始化时间
            _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:50 * 365 * 24 * 60 * 60 * -1]; // 设置最小时间
            _datePicker.maximumDate = [NSDate date]; // 设置最大时间
            [_datePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:_datePicker];
            break;
    }
}

#pragma mark - 创建所有子视图
- (void)createAllSubView
{
    UIColor *color = [UIColor colorWithRed:55.0 / 256.0 green:55.0 / 256.0 blue:55.0 / 256.0 alpha:0.7];
    self.backgroundColor = color;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 38, CGRectGetWidth(self.frame), 38)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(40, 0, 40, 30);
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [cancel addTarget:self action:@selector(clickCancelPickerView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    
    UIButton *determine = [UIButton buttonWithType:UIButtonTypeCustom];
    determine.frame = CGRectMake(CGRectGetMaxX(self.frame) - 80, 0, 40, 30);
    [determine setTitle:@"确定" forState:UIControlStateNormal];
    [determine setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    determine.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [determine addTarget:self action:@selector(clickDeterminePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:determine];
}

// button方法
- (void)clickCancelPickerView
{
    [self removeFromSuperview];
}

- (void)clickDeterminePickerView:(UIButton *)sender
{
    
    if (_chooseIndex == 1) {
        
        NSString *firstStr = [self.firstArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        NSString *secondStr = [self.secondArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
        NSString *thirdStr = [self.thirdArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
        _returnString = [NSString stringWithFormat:@"%@-%@-%@", firstStr, secondStr, thirdStr];
    }
    
    if (self.block) {
        
        self.block(_returnString);
    }
    
    [self clickCancelPickerView];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.firstArray.count;
    } else if (component == 1) {
        return self.secondArray.count;
    } else {
        return self.thirdArray.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3.0, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:12.0f];
    
    if (component == 0) {
        myView.text = [self.firstArray objectAtIndex:row];
    } else if (component == 1) {
        myView.text = [self.secondArray objectAtIndex:row];
    } else {
        myView.text = [self.thirdArray objectAtIndex:row];
    }
    
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        // 获取当前显示的省份所包含的城市
        self.selectedArray = [self.dataDic objectForKey:[self.firstArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            // 获取所有的城市
            self.secondArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.secondArray = nil;
        }
        
        if (self.secondArray.count > 0) {
            // 根据城市获取当前所有县
            self.thirdArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.secondArray objectAtIndex:0]];
        } else {
            self.thirdArray = nil;
        }
    }
    
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.secondArray.count > 0) {
            self.thirdArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.secondArray objectAtIndex:row]];
        } else {
            self.thirdArray = nil;
        }
        
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
    
}

#pragma mark - datePicker Delegate
- (void)datePicker:(UIDatePicker *)sender
{
    NSDate *select = [sender date];// 被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    _returnString = dateAndTime;
}

@end

