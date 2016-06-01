//
//  LS_EquipmentModel.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/19.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_EquipmentModel.h"
#import "sys/utsname.h"

@implementation LS_EquipmentModel

+ (instancetype)sharedEquipmentModel
{
    static LS_EquipmentModel *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[LS_EquipmentModel alloc] init];
    });
    return manage;
}

- (NSString *)accessModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"3.5_inch";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"4_inch";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"4_inch";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"4_inch";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"4_inch";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"4_inch";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"4_inch";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"4.7_inch";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"4.7_inch";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"5.5_inch";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"5.5_inch";
    
    return deviceString;
}



@end
