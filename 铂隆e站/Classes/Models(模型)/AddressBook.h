//
//  AddressBook.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/24.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  通讯录联系人
 */
#import <Foundation/Foundation.h>

@interface AddressBook : NSObject

/**
 *  联系人姓名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  姓氏拼音
 */
@property (nonatomic, strong) NSString *lastName;

/**
 *  手机号码
 */
@property (nonatomic, strong) NSString *phoneNumber;

/**
 *  头像
 */
@property (nonatomic, strong) UIImage *headImage;

@end
