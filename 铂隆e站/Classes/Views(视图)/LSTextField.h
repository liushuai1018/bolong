//
//  LSTextField.h
//  Textflied
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 咕啦电商. All rights reserved.
//

/**
 *  自定义带监听删除输入框
 */
#import <UIKit/UIKit.h>

@class LSTextField;

@protocol LSTextFieldDelegate <NSObject>

- (void)lsTextFieldDelegateBackward:(LSTextField *)textField;

@end

@interface LSTextField : UITextField

@property (assign, nonatomic) id<LSTextFieldDelegate> ls_delegate;

@end
