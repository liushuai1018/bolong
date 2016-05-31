//
//  LS_feipinPrice_model.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/26.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_feipinPrice_model.h"

@implementation LS_feipinPrice_model

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _feipinID = value;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

@end
