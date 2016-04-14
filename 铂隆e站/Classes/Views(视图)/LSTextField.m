//
//  LSTextField.m
//  Textflied
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 咕啦电商. All rights reserved.
//

#import "LSTextField.h"

@implementation LSTextField

- (void)deleteBackward
{
    
    if ([self.ls_delegate respondsToSelector:@selector(lsTextFieldDelegateBackward:)]) {
        [self.ls_delegate lsTextFieldDelegateBackward:self];
    }
    [super deleteBackward];
}

@end
