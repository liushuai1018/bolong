//
//  PresenceNumber.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  泊车号
 */
#import <UIKit/UIKit.h>
#import "LSTextField.h"

@interface PresenceNumber : UIView <UITextFieldDelegate, LSTextFieldDelegate>

// 标签号
@property (strong, nonatomic) NSMutableString *numberStr;

// 时间选择器
//@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *pickerView;

// 应缴车费
@property (strong, nonatomic) UILabel *payLabel;

// 确认
@property (strong, nonatomic) UIButton *determine;

// 移除键盘 获取泊车号
- (void)removeKeyObtaionNumber;

@end
