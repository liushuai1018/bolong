//
//  LSPickerView.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/2.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  自定义选择器
 */
#import <UIKit/UIKit.h>

typedef void(^aBlock)(NSString *);

@interface LSPickerView : UIView

// data
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, copy) aBlock block;

- (instancetype)initWithFrame:(CGRect)frame chooseIndex:(NSInteger)index;

@end
