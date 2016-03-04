//
//  UserInformation.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/21.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"user_name"]) {
        self.name = value;
    }
    if ([key isEqualToString:@"user_avar"]) {
        self.headPortraitURL = value;
    }
}

#pragma mark -- 对类中所有属性进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.headPortraitURL forKey:@"headPortraitURL"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.backgroundImage forKey:@"backgroundImage"];
}

#pragma mark -- 对类中所有属性进行反编码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.headPortraitURL = [aDecoder decodeObjectForKey:@"headPortraitURL"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
        self.backgroundImage = [aDecoder decodeObjectForKey:@"backgroundImage"];
    }
    return self;
}

@end
