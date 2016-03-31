//
//  Product.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/25.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "Product.h"

@implementation Product

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"total_fee"]) {
        _price = [value floatValue];
    }
    
    if ([key isEqualToString:@"out_trade_no"]) {
        _orderId = value;
    }
}

@end
