                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    //
//  NetWorkRequestManage.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/30.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//



#import "NetWorkRequestManage.h"
#import "CommunityInformation.h"
#import "WuYeDetails.h"
#import "HousingAddress.h"
#import "Product.h"
#import "AlipayManage.h"
#import "Reachability.h"
#import "ConsultListModel.h"
#import "ReplyListModel.h"
#import "LS_addressManage.h"
#import "LS_feipinPrice_model.h"
#import "LS_Record_Model.h"
#import "LS_WuYeInform_Model.h"

#define LSEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]

@interface NetWorkRequestManage ()

@property (strong, nonatomic) UIAlertController *alertControl;

@end

@implementation NetWorkRequestManage


+ (instancetype)sharInstance
{
    static NetWorkRequestManage *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[NetWorkRequestManage alloc] init];
    });
    return manage;
}

#pragma mark - 判断当前是否有网络连接
- (BOOL)determineTheNetwork
{
    // WIFI
    BOOL isWIFI = ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable);
    // 3G
    BOOL is3G = ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable);
    
    
    if (isWIFI && is3G) {
        
        [self alertView:@"网络请求失败，请检查网络连接"];
        
        return NO; // 没有网络连接
    } else {
        return YES;  // 有网络连接
    }
}

// 多用提示框
- (void)alertView:(NSString *)str
{
    if (!_alertControl) {
        _alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [_alertControl addAction:cancel];
    }
    
    _alertControl.message = str;
    UIViewController *control = [self getCurrentVC];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [control presentViewController:_alertControl animated:YES completion:nil];
        
        // 延时执行方法
        [self performSelector:@selector(dismissAlert:)
                   withObject:_alertControl
                   afterDelay:2];
    });

}
// 获取当前显示的viewController
- (UIViewController *)getCurrentVC
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}


// 移除提示框
- (void)dismissAlert:(UIAlertController *)sender
{
    if (sender) {
        [sender dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 发送手机号，获取验证码
- (void)senderVerificationCode:(NSString *)phone
                          type:(NSString *)type
        returnVerificationCode:(void(^)(NSString *str))verification;
{
    // 创建请求体
    NSString *parameters = [NSString stringWithFormat:@"mobile=%@&type=%@", phone, type];
    
    [self requestNetworkURL:kSenderPhoneURL requserParameter:parameters returns:^(NSMutableDictionary *dataDict) {
        
        if ([[dataDict objectForKey:@"code"] integerValue] == 1) {
            verification([dataDict objectForKey:@"datas"]);
        }
        
    }];
}

#pragma mark - 注册用户
- (void)registeredAccount:(NSString *)account
                     code:(NSString *)code
                 password:(NSString *)password
                  returns:(void(^)(NSDictionary *isRegisteredAccount))block;
{
    // 创建请求体
    NSString *parameter = [NSString stringWithFormat:@"mobile=%@&code=%@&password=%@", account, code, password];
    
    [self requestNetworkURL:kRegistURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
        if (block) {
            block(dataDict);
        }
        
    }];
}

#pragma mark 登陆用户
- (void)longinAccount:(NSString *)account
             password:(NSString *)password
              returns:(void(^)(NSDictionary *isLongin))block
{
    NSString *parameters = [NSString stringWithFormat:@"mobile=%@&password=%@", account, password];
    
    [self requestNetworkURL:kLonginURL requserParameter:parameters returns:^(NSMutableDictionary *dataDict) {
        if (block) {
            block(dataDict);
        }
    }];
}

#pragma mark - 修改头像
- (void)upLoadHead:(NSString *)user_id
             image:(UIImage *)image
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    // 记录Image的类型和data
    NSData *imageData;
    NSString *imageFormat;
    if (UIImagePNGRepresentation(image) == nil) {
        imageFormat = @"Content-Type: image/jpeg \r\n";
        imageData = UIImageJPEGRepresentation(image, 0.5f);
    } else {
        imageFormat = @"Content-Type: image/png \r\n";
        imageData = UIImagePNGRepresentation(image);
    }
    
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    /**文件参数**/
    [body appendData:LSEncode(@"--LS\r\n")];
    NSString *disposition = @"Content-Disposition: form-data; name=\"file\"; filename=\"image.png\"\r\n";
    [body appendData:LSEncode(disposition)];
    [body appendData:LSEncode(imageFormat)];
    [body appendData:LSEncode(@"\r\n")];
    [body appendData:imageData];
    [body appendData:LSEncode(@"\r\n")];
    
    /**普通参数**/
    [body appendData:LSEncode(@"--LS\r\n")];
    NSString *dispositions = @"Content-Disposition: form-data; name=\"user_id\"\r\n";
    [body appendData:LSEncode(dispositions)];
    [body appendData:LSEncode(@"\r\n")];
    [body appendData:LSEncode(user_id)];
    [body appendData:LSEncode(@"\r\n")];
    
    /**参数结束**/
    [body appendData:LSEncode(@"LS--")];
    
    // 请求地址
    NSURL *url = [NSURL URLWithString:kUpLoadHead];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // 设置为 multipart 请求
    NSString *contenType = @"multipart/form-data;boundary=LS";
    [request setValue:contenType forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionUploadTask *upLoadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self alertView:@"网络请求失败!"];
            return ;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] integerValue] == 0) {
            NSString *headURL = [dic objectForKey:@"datas"];
            [[LocalStoreManage sharInstance] upUserHeadURL:headURL];
        }
        
    }];
    [upLoadTask resume];
}

#pragma mark - 修改昵称
- (void)updateUserName:(NSString *)name
               user_id:(NSString *)user_id
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&user_name=%@", user_id, name];
    [self requestNetworkURL:kUpdateUserName requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
    }];
}

#pragma mark - 忘记密码
- (void)forgetPasswordphone:(NSString *)phone
                   password:(NSString *)password
                       code:(NSString *)code
                      retun:(void(^)(NSString *str))block
{
    NSString *parameter = [NSString stringWithFormat:@"mobile=%@&password=%@&code=%@", phone, password, code];
    [self requestNetworkURL:kForgetPassword requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        if ([[dataDict objectForKey:@"code"] integerValue] == 0) {
            block(@"修改成功");
        } else {
            block([dataDict objectForKey:@"datas"]);
        }

    }];
}

#pragma mark - 获取物业
- (void)getWuYeRetuns:(void(^)(NSArray *array))block
{
    [self requestNetworkURL:kObtainWuYeURL requserParameter:nil returns:^(NSMutableDictionary *dataDict) {
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        if (0 == index) {
            NSArray *dataAr = [dataDict objectForKey:@"datas"];
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < dataAr.count; i++) {
                NSDictionary *dict = [dataAr objectAtIndex:i];
                LS_WuYeInform_Model *model = [[LS_WuYeInform_Model alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                NSLog(@"wuyeInform : id:%@ 名称: %@ 编号: %@", model.wuyeID, model.fenqu, model.fenquhao);
                [array addObject:model];
            }
            if (block) {
                block(array);
            }
            
        } else {
            if (block) {
                block(nil);
            }
        }
        
    }];
}

#pragma mark - 获取小区
- (void)getCommunityWuYeID:(NSString *)wuYeID
           communityInform:(void(^)(NSArray *array))sender
{
    NSString *parameter = [NSString stringWithFormat:@"id=%@", wuYeID];
    [self requestNetworkURL:kGetCommunityURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        
        if (index != 0) {
            if (sender) {
                sender(nil);
            }
            return;
        }
        
        NSArray *array = [dataDict objectForKey:@"datas"];
        NSMutableArray *communityArray = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            
            CommunityInformation *community = [[CommunityInformation alloc] init];
            [community setValuesForKeysWithDictionary:dict];
            [communityArray addObject:community];
        }
        if (sender) {
            sender(communityArray);
        }
    }];
}

#pragma mark - 交物业费
- (void)wuyeInoformationID:(NSString *)user_id
               communityID:(NSString *)communityID
                    number:(NSString *)number
                      name:(NSString *)name
                    wuyeID:(NSString *)wuyeID
                   returns:(void(^)(WuYeDetails *wuyeDetails))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&wuye_id=%@&number=%@&name=%@&id=%@", user_id, communityID, number, name, wuyeID];
    __weak NetWorkRequestManage *weak_object = self;
    [self requestNetworkURL:kWuYePayInformationURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NetWorkRequestManage *strong_object = weak_object;
        if (strong_object) {
            WuYeDetails *wuye = [[WuYeDetails alloc] init];
            wuye.code = [[dataDict objectForKey:@"code"] integerValue];
        
            if (0 == wuye.code) { // 请求成功则开始解析
        
                NSDictionary *dict = [dataDict objectForKey:@"datas"];
                [wuye setValuesForKeysWithDictionary:dict];
                if (block) {
                    block(wuye);
                }
        
            } else {
                
                [strong_object alertView:[dataDict objectForKey:@"datas"]];
            }
        }
    }];
}

#pragma makr - 确认物业缴费
- (void)wuyePay:(NSString *)user_id
        log_ids:(NSString *)log_ids
          retum:(void(^)(NSDictionary *dict))inform
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&log_ids=%@", user_id, log_ids];
    [self requestNetworkURL:kWuYePayURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        if (0 == index) {
            
            NSDictionary *productDict = [dataDict objectForKey:@"datas"];
            Product *product = [[Product alloc] init];
            [product setValuesForKeysWithDictionary:productDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AlipayManage sharInstance] createrOrderAndSignature:product retum:^(NSDictionary *ditc) {
                    // 把支付宝返回信息反馈到显示界面
                    inform(ditc);
                    
                }];
            });
            
        }
    }];
}

#pragma mark - 其他_送水单价
- (void)other_WaterMoneyWithPrice:(void(^)(NSString *price))block
{
    [self requestNetworkURL:kWaterMoneyURL requserParameter:nil returns:^(NSMutableDictionary *dataDict) {
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        if (0 == index) {
            NSDictionary *priceDict = [dataDict objectForKey:@"datas"];
            NSString *price = [priceDict objectForKey:@"price"];
            if (block) {
                block(price);
            }
        }
    }];
}

#pragma mark - 其他_送水
- (void)other_waterWithWuYeId:(NSString *)wuyeId
                      Address:(NSString *)address
                        momey:(NSString *)momey
                     userInfo:(NSString *)userId
{
    NSString *parameter = [NSString stringWithFormat:@"wuye_id=%@& money=%@&address=%@&user_id=%@", wuyeId, momey, address, userId];
    
    __weak NetWorkRequestManage *weak_object = self;
    [self requestNetworkURL:kWaterURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NetWorkRequestManage *strong_object = weak_object;
        if (strong_object) {
            NSInteger index = [[dataDict objectForKey:@"code"] intValue];
            if (0 == index) {
                
                Product *product = [[Product alloc] init];
                [product setValuesForKeysWithDictionary:[dataDict objectForKey:@"datas"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[AlipayManage sharInstance] createrOrderAndSignature:product retum:^(NSDictionary *ditc) {
                        if ([[ditc objectForKey:@"resultStatus"] intValue] == 9000) {
                            [strong_object alertView:@"购买成功!"];
                        } else {
                            [strong_object alertView:@"购买失败!"];
                        }
                    }];
                });
            }
        }
    }];
}

#pragma mark - 其他_开锁
- (void)other_UnlockingAddress:(NSString *)address returns:(void(^)(NSString *phone))block
{
    NSString *parameter = [NSString stringWithFormat:@"wuye_id=%@&unlock=%@", @"4", address];
    [self requestNetworkURL:kUnlockingURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSDictionary *dict = [dataDict objectForKey:@"datas"];
        block([dict objectForKey:@"phone"]);
    }];
}

#pragma mark - 其他_获取废品单价
- (void)other_FeipinPriceReturn:(void(^)(NSArray *array))block
{
    [self requestNetworkURL:kFeipinPriceURL
           requserParameter:nil
                    returns:^(NSMutableDictionary *dataDict)
    {
        if (![[dataDict objectForKey:@"datas"] isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *dataAr = [dataDict objectForKey:@"datas"];
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < dataAr.count; i++) {
            LS_feipinPrice_model *model = [[LS_feipinPrice_model alloc] init];
            [model setValuesForKeysWithDictionary:[dataAr objectAtIndex:i]];
            [array addObject:model];
        }
        if (block) {
            block(array);
        }
    }];
}

#pragma mark - 其他_废品回收
- (void)other_FeipinAcquisitionID:(NSString *)feipinID
                          wuye_id:(NSString *)wuye_id
                          address:(NSString *)address
                            phone:(NSString *)phone
                           returns:(void(^)(BOOL is))block
{
    NSString *parameter = [NSString stringWithFormat:@"id=%@&wuye_id=%@&address=%@&phone=%@", feipinID, wuye_id, address, phone];
    
    [self requestNetworkURL:kFeiPinRecycleURL
           requserParameter:parameter
                    returns:^(NSMutableDictionary *dataDict)
    {
        if (block) {
            block(YES);
        }
    }];
}

#pragma mark - 其他_报修
- (void)other_repairUserID:(NSString *)userID
                   wuye_id:(NSString *)wuye_ID
                  question:(NSString *)question
                   address:(NSString *)address
                      pic1:(UIImage *)image1
                      pic2:(UIImage *)image2
                      pic3:(UIImage *)image3
                   returns:(void(^)(BOOL is))block
{
    
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kQuestionURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    // 设置为 multipart 请求
    NSString *contenType = @"multipart/form-data;boundary=LS";
    [request setValue:contenType forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // data
    NSMutableData *data = [NSMutableData data];
    
    // 图片
    if (image1) {
        
        [data appendData:LSEncode(@"--LS\r\n")];
        NSString *disposition = @"Content-Disposition: form-data; name=\"pic1\"; filename=\"image1.jpeg\"\r\n";
        [data appendData:LSEncode(disposition)];
        NSString *imageFormat = @"Content-Type: image/jpeg \r\n";
        [data appendData:LSEncode(imageFormat)];
        [data appendData:LSEncode(@"\r\n")];
        NSData *imageData = UIImageJPEGRepresentation(image1, 0.5);
        [data appendData:imageData];
        [data appendData:LSEncode(@"\r\n")];
    }
    
    if (image2) {
        
        [data appendData:LSEncode(@"--LS\r\n")];
        NSString *disposition = @"Content-Disposition: form-data; name=\"pic2\"; filename=\"image2.jpeg\"\r\n";
        [data appendData:LSEncode(disposition)];
        NSString *imageFormat = @"Content-Type: image/jpeg \r\n";
        [data appendData:LSEncode(imageFormat)];
        [data appendData:LSEncode(@"\r\n")];
        NSData *imageData = UIImageJPEGRepresentation(image2, 0.5);
        [data appendData:imageData];
        [data appendData:LSEncode(@"\r\n")];
    }
    
    if (image3) {
        
        [data appendData:LSEncode(@"--LS\r\n")];
        NSString *disposition = @"Content-Disposition: form-data; name=\"pic3\"; filename=\"image3.jpeg\"\r\n";
        [data appendData:LSEncode(disposition)];
        NSString *imageFormat = @"Content-Type: image/jpeg \r\n";
        [data appendData:LSEncode(imageFormat)];
        [data appendData:LSEncode(@"\r\n")];
        NSData *imageData = UIImageJPEGRepresentation(image3, 0.5);
        [data appendData:imageData];
        [data appendData:LSEncode(@"\r\n")];
    }
    
    
    // 参数
    [data appendData:LSEncode(@"--LS\r\n")];
    NSString *parameter_userID = @"Content-Disposition: form-data; name=\"id\"\r\n";
    [data appendData:LSEncode(parameter_userID)];
    [data appendData:LSEncode(@"\r\n")];
    [data appendData:LSEncode(userID)];
    [data appendData:LSEncode(@"\r\n")];
    
    [data appendData:LSEncode(@"--LS\r\n")];
    NSString *parameter_wuyeID = @"Content-Disposition: form-data; name=\"wuye_id\"\r\n";
    [data appendData:LSEncode(parameter_wuyeID)];
    [data appendData:LSEncode(@"\r\n")];
    [data appendData:LSEncode(wuye_ID)];
    [data appendData:LSEncode(@"\r\n")];
    
    [data appendData:LSEncode(@"--LS\r\n")];
    NSString *parameter_question = @"Content-Disposition: form-data; name=\"question\"\r\n";
    [data appendData:LSEncode(parameter_question)];
    [data appendData:LSEncode(@"\r\n")];
    [data appendData:LSEncode(question)];
    [data appendData:LSEncode(@"\r\n")];
    
    [data appendData:LSEncode(@"--LS\r\n")];
    NSString *parameter_address = @"Content-Disposition: form-data; name=\"address\"\r\n";
    [data appendData:LSEncode(parameter_address)];
    [data appendData:LSEncode(@"\r\n")];
    [data appendData:LSEncode(address)];
    [data appendData:LSEncode(@"\r\n")];
    
    NSURLSessionUploadTask *upLoadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self alertView:@"网络请求失败!"];
            return ;
        }
        
        NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableLeaves
                                                                          error:nil];
        if ([[dataDict objectForKey:@"code"] integerValue] != 0) {
            [self alertView:[dataDict objectForKey:@"datas"]];
            return ;
        }
        
        if (block) {
            block(YES);
        }
        
    }];
    [upLoadTask resume];
}

#pragma mark - 其他_是否已经签到
- (void)other_isSignInUserID:(NSString *)userID
                     returns:(void(^)(BOOL is))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", userID];
    [self requestNetworkURL:kIsSignInURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        if (0 == index) {
            if (block) {
                block(NO);
            }
        } else {
            if (block) {
                block(YES);
            }
        }
    }];
}

#pragma mark - 其他_签到
- (void)other_signinUserID:(NSString *)userID
                   returns:(void(^)(BOOL is))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", userID];
    [self requestNetworkURL:kSignInURl requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        if (0 == index) {
            if (block) {
                block(YES);
            }
        } else {
            if (block) {
                block(NO);
            }
        }
    }];
}

#pragma mark - 获取资讯列表
- (void)consultListPage:(NSString *)index returns:(void(^)(NSArray *array))block
{
    NSString *parameter = [NSString stringWithFormat:@"page=%@", index];
    [self requestNetworkURL:kConsultList requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        if (0 == [[dataDict objectForKey:@"code"] integerValue]) {
            
            NSArray *consultAr = [dataDict objectForKey:@"datas"];
            
            NSMutableArray *consultListArray = [NSMutableArray array];
            
            for (NSDictionary *dict in consultAr) {
                ConsultListModel *model = [[ConsultListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [consultListArray addObject:model];
                
            }
            
            block(consultListArray);
        } else {
            block(nil);
        }
    }];
}

#pragma mark - 发送新的咨询
- (void)senderConsultUser_id:(NSString *)user_id info:(NSString *)info
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&info=%@", user_id, info];
    __weak NetWorkRequestManage *weak_object = self;
    [self requestNetworkURL:kSenderConsult requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
        if (index == 0) {
            [weak_object alertView:@"发送成功!"];
        } else {
            [weak_object alertView:@"发送失败!"];
        }
    }];
}

#pragma mark - 咨询_赞
- (void)consultZanUser_id:(NSString *)user_id consult_id:(NSString *)consult_id
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&consult_id=%@", user_id, consult_id];
    [self requestNetworkURL:kConsult_zan requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
    }];
}

#pragma mark - 回复咨询
- (void)replyConsultUser_id:(NSString *)user_id consult_id:(NSString *)consult_id info:(NSString *)info
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&consult_id=%@&info=%@", user_id, consult_id, info];
    [self requestNetworkURL:kReplyConsult requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
    }];
}

#pragma mark - 获取答复列表信息
- (void)requestReplyListInfoUser_id:(NSString *)user_id returns:(void(^)(NSArray *array))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", user_id];
    [self requestNetworkURL:kReplyList requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        if ([[dataDict objectForKey:@"code"] integerValue] == 0) {
            
            NSArray *array = [dataDict objectForKey:@"datas"];
            NSMutableArray *replyArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                ReplyListModel *model = [[ReplyListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [replyArray addObject:model];
            }
            // 请求解析完毕返回数据
            if (block) {
                block(replyArray);
            }
        }
    }];
}

#pragma mark - 我的地址列表
- (void)requestAddressUser_id:(NSString *)user_id  returns:(void(^)(NSArray *array))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", user_id];
    [self requestNetworkURL:kAddress_list requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        if (0 == [[dataDict objectForKey:@"code"] integerValue]) {
            
            NSArray *dataAr = [dataDict objectForKey:@"datas"];
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dic in dataAr) {
                LS_addressManage *address = [[LS_addressManage alloc] init];
                [address setValuesForKeysWithDictionary:dic];
                [array addObject:address];
            }
            if (block) {
                block(array);
            }
        }
    }];
}

#pragma mark - 删除地址
- (void)removeAddressUser_id:(NSString *)user_id address_id:(NSString *)addres_id
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&address_id=%@", user_id, addres_id];
    [self requestNetworkURL:kRemoveAddress requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
    }];
}

#pragma mark - 添加新地址
- (void)addNewAddressUser_id:(NSString *)user_id full_address:(LS_addressManage *)address
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&name=%@&mobile=%@&code=%@&province=%@&city=%@&region=%@&street=%@&full_address=%@", user_id, address.name, address.mobile, address.code, address.province, address.city, address.region, address.street, address.full_address];
    [self requestNetworkURL:kAddNewAddress requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
    }];
}

#pragma mark - 修改地址
- (void)upAddressUser_id:(NSString *)user_id address:(LS_addressManage *)address
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&name=%@&mobile=%@&code=%@&province=%@&city=%@&region=%@&street=%@&full_address=%@&address_id=%@", user_id, address.name, address.mobile, address.code, address.province, address.city, address.region, address.street, address.full_address, address.address_id];
    [self requestNetworkURL:kUpAddress requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
    }];
}

#pragma mark - 获取IM_token
- (void)obtainIMToken:(UserInformation *)userInfo returns:(void(^)(NSString *token))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&user_name=%@&user_avar=%@", userInfo.user_id, userInfo.name, userInfo.headPortraitURL];
    __weak NetWorkRequestManage *weak_object = self;
    [self requestNetworkURL:kIM_token requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSInteger code = [[dataDict objectForKey:@"code"] integerValue];
        if (code == 200) {
            
            NSString *token = [dataDict objectForKey:@"token"];
            block(token);
            
        } else {
            [weak_object alertView:@"IM登陆失败"];
        }
    }];
}

#pragma mark - 账号剩余的铂隆币
- (void)wallet_obtainMoneyUserID:(NSString *)userID
                         returns:(void(^)(NSString *money))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", userID];
    [self requestNetworkURL:kBoLongBiURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        NSString *money = [dataDict objectForKey:@"datas"];
        if (block) {
            block(money);
        }
    }];
}

#pragma mark - 充值铂隆币
- (void)wallet_top_upMoneyUserID:(NSString *)userID
                             RMB:(NSString *)RMB
                         returns:(void(^)(NSDictionary *dic))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&rmb=%@", userID, RMB];
    [self requestNetworkURL:ktopUpMoneyURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        
        // 请求玩订单信息生成订单
        NSDictionary *dicts = [dataDict objectForKey:@"datas"];
        Product *product = [[Product alloc] init];
        [product setValuesForKeysWithDictionary:dicts];
        product.price = 0.01;
        // 跳到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 根据生成订单去支付宝结算
            [[AlipayManage sharInstance] createrOrderAndSignature:product retum:^(NSDictionary *ditc) {
                if (block) {
                    block(ditc);
                }
            }];
            
        });
        
    }];
}

#pragma mark - 查询铂隆币充值记录
- (void)wallet_moneyRecordUserID:(NSString *)userID
                         returns:(void(^)(NSArray *array))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", userID];
    
    if (![self determineTheNetwork]) {
        return;
    }
    NSURL *urlPath = [NSURL URLWithString:kMoneyRecordURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPath];
    [request setHTTPMethod:@"POST"];
    if (parameter) {
        [request setHTTPBody:LSEncode(parameter)];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setTimeoutIntervalForRequest:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    __weak NetWorkRequestManage *weak_control = self; // 若引用防止block循环引用
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NetWorkRequestManage *strong_control = weak_control; // 弱引用转换强引用,防止在多线程和ARC下随时被释放的问题
                                      if (strong_control) { // 判断释放释放已经被释放
                                          
                                          if (error) {
                                              [strong_control alertView:@"网络请求失败"];
                                              return;
                                          }
                                          NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:NSJSONReadingMutableLeaves
                                                                                                        error:nil];
                                          NSInteger code = [[dict objectForKey:@"code"] integerValue];
                                          if (code == 0) {
                                              
                                              NSMutableArray *array = [NSMutableArray array];
                                              NSArray *dataAr = [dict objectForKey:@"datas"];
                                              
                                              for (int i = 0; i < dataAr.count; i++) {
                                                  LS_Record_Model *model = [[LS_Record_Model alloc] init];
                                                  NSDictionary *subDict = [dataAr objectAtIndex:i];
                                                  [model setValuesForKeysWithDictionary:subDict];
                                                  [array addObject:model];
                                              }
                                              
                                              if (block) {
                                                  block(array);
                                              }
                                              
                                          } else {
                                              
                                              if (block) {
                                                  block(nil);
                                              }
                                          }
                                          
                                          
                                      }
                                      
                                  }];
    [task resume];
    
}

#pragma mark - 帮助_意见反馈
- (void)help_opinionUserID:(NSString *)userID
                   content:(NSString *)content
                     phone:(NSString *)phone
                   returns:(void(^)(BOOL is))block
{
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&content=%@&phone=%@", userID, content, phone];
    [self requestNetworkURL:kFankuiURL requserParameter:parameter returns:^(NSMutableDictionary *dataDict) {
        if (block) {
            block(YES);
        }
    }];
    
}

#pragma mark - 网络请求函数
- (void)requestNetworkURL:(NSString *)url
         requserParameter:(NSString *)parameter
                  returns:(void(^)(NSMutableDictionary *dataDict))block;
{
    if (![self determineTheNetwork]) {
        return;
    }
    NSURL *urlPath = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPath];
    [request setHTTPMethod:@"POST"];
    if (parameter) {
        [request setHTTPBody:LSEncode(parameter)];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setTimeoutIntervalForRequest:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    __weak NetWorkRequestManage *weak_control = self; // 若引用防止block循环引用
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NetWorkRequestManage *strong_control = weak_control; // 弱引用转换强引用,防止在多线程和ARC下随时被释放的问题
                                      if (strong_control) { // 判断释放释放已经被释放
                                          
                                          if (error) {
                                              [strong_control alertView:@"网络请求失败"];
                                              return;
                                          }
                                          NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:NSJSONReadingMutableLeaves
                                                                                                        error:nil];
                                          if (block) {
                                              block(dict);
                                          }
                                      }
                                      
                                  }];
    [task resume];
}

@end
