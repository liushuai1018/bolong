//
//  InputBoxView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  输入框
 */
#import <UIKit/UIKit.h>

@interface InputBoxView : UIView

@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) UIButton *sendBut;

- (id)initWithFrame:(CGRect)frame string:(NSString *)str;

@end
