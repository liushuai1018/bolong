//
//  LS_WuYeInform_Model.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/17.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_WuYeInform_Model.h"

@implementation LS_WuYeInform_Model

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _wuyeID = [NSString stringWithFormat:@"%ld", (long)[value integerValue]];
    }
}

@end
