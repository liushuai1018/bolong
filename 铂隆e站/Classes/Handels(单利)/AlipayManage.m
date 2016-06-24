//
//  AlipayManage.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/3/25.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "AlipayManage.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "Product.h"

@implementation AlipayManage

#pragma mark - 创建支付订单管理工具
+ (instancetype)sharInstance
{
    static AlipayManage *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[AlipayManage alloc] init];
    });
    return manage;
}

#pragma mark - 创建订单和签名
- (void)createrOrderAndSignature:(Product *)product
                           retum:(void(^)(NSDictionary *dict))retum
{
    /**
     *  生成订单信息及签名
     */
    
    // 将商品信息赋予AliixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = product.partner;                  // 合作伙伴ID
    order.seller = product.seller;                    // 收款账号
    order.tradeNO = product.orderId;          // 订单ID
    order.productName = product.subject;      // 商品标题
    order.productDescription = product.body;  // 商品描述
    order.amount = [NSString stringWithFormat:@"%.2f", product.price]; // 商品价格
    order.notifyURL = product.notify_url;  // 支付成功后会给这个URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkBolong";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *privateKey = product.privateKey;
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            retum(resultDic);
        }];
    }

}

@end
