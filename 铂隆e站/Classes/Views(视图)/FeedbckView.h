//
//  FeedbckView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/14.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbckView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *opinionTF; // 意见信息
@property (nonatomic, strong) UITextField *unmberTF; // 手机号
@property (nonatomic, strong) UIButton *submitBtn; // 提交

@end
