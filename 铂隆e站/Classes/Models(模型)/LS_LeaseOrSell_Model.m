//
//  LS_LeaseOrSell_Model.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/7/1.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_LeaseOrSell_Model.h"

@implementation LS_LeaseOrSell_Model

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _listID = value;
    }
}

@end
