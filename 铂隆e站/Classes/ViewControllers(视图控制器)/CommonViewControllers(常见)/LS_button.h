//
//  LS_button.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/9.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LS_button;
@protocol LS_buttonDelegate <NSObject>

- (void)selectButtonAction:(LS_button *)sender selectIndex:(NSInteger)index;

@end

@interface LS_button : UIButton

@property (assign, nonatomic) id<LS_buttonDelegate> delegate;

@property (strong, nonatomic) UILabel *label;

@end
