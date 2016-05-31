//
//  LS_feipinPrice_model.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/26.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

/**
 *  废品单价 model
 */
#import <Foundation/Foundation.h>

@interface LS_feipinPrice_model : NSObject

/**
 *  废品ID
 */
@property (strong, nonatomic) NSString *feipinID;

/**
 *  废品名称
 */
@property (strong, nonatomic) NSString *name;

/**
 *  废品单价
 */
@property (strong, nonatomic) NSString *price;

@end
