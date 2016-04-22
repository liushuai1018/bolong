//
//  LS_addressManage.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//


#import "LS_addressManage.h"

@implementation LS_addressManage

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

#pragma mark - 编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_address_id forKey:@"address_id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_code forKey:@"code"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_region forKey:@"region"];
    [aCoder encodeObject:_street forKey:@"street"];
    [aCoder encodeObject:_full_address forKey:@"full_address"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%@", _LS_default ? @"YES" : @"NO"] forKey:@"LS_default"];
}

#pragma mark - 反编码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _address_id = [aDecoder decodeObjectForKey:@"address_id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _mobile = [aDecoder decodeObjectForKey:@"mobile"];
        _code = [aDecoder decodeObjectForKey:@"code"];
        _province = [aDecoder decodeObjectForKey:@"province"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _region = [aDecoder decodeObjectForKey:@"region"];
        _street = [aDecoder decodeObjectForKey:@"street"];
        _full_address = [aDecoder decodeObjectForKey:@"full_address"];
        _LS_default = [[aDecoder decodeObjectForKey:@"LS_default"] isEqualToString:@"YES"] ? YES : NO;
    }
    return self;
}

@end
