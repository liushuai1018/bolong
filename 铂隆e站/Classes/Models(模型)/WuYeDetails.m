//
//  WuYeDetails.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/30.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "WuYeDetails.h"

#import "HousingAddress.h"

@implementation WuYeDetails

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"address_list"]) {
        NSArray *ar = value;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in ar) {
            HousingAddress *address = [[HousingAddress alloc] init];
            [address setValuesForKeysWithDictionary:dict];
            [array addObject:address];
        }
        _addressList = array;
    }

}

@end
