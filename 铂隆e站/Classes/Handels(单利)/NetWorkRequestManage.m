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

#define LSEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]

@interface NetWorkRequestManage ()

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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络请求失败，请检查网络连接"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert show];
        
        // 延时执行方法
        [self performSelector:@selector(dismissAlert:)
                   withObject:alert
                   afterDelay:2];
        
        return NO; // 没有网络连接
    } else {
        return YES;  // 有网络连接
    }
}

// 移除提示框
- (void)dismissAlert:(UIAlertView *)sender
{
    if (sender) {
        [sender dismissWithClickedButtonIndex:[sender cancelButtonIndex] animated:YES];
    }
}

#pragma mark - 发送手机号，获取验证码
- (void)senderVerificationCode:(NSString *)phone
        returnVerificationCode:(void(^)(NSString *str))verification
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    if ([phone isEqualToString:@""]) {
        if (verification) {
            verification(@"手机号不能为空");
        }
        return;
    }
    // 创建请求体
    NSString *parameters = [NSString stringWithFormat:@"mobile=%@&type=0", phone];
    NSData *data = LSEncode(parameters);
    
    NSURL *url = [NSURL URLWithString:kSenderPhoneURL];
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    // 请求体添加到请求网址
    [request setHTTPBody:data];
    
    
    // 异步请求
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
        
        if ([[dic objectForKey:@"code"] integerValue] == 1) {
            verification([dic objectForKey:@"datas"]);
        }
        
    }];
    
}

#pragma mark 注册用户
- (BOOL)registeredAccount:(NSString *)account
                     code:(NSString *)code
                 password:(NSString *)password
{
    if (![self determineTheNetwork]) {
        return NO;
    }
    
    // 创建请求体
    NSString *str = [NSString stringWithFormat:@"mobile=%@&code=%@&password=%@", account, code, password];
    NSData *data = LSEncode(str);
    
    
    // 创建请求网址
    NSURL *url = [NSURL URLWithString:kRegistURL];
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    // 请求体添加到请求网址
    [request setHTTPBody:data];
    
    
     NSError * error = nil;
     NSURLResponse * respose = nil;
    // 设置请求超时时间
     request.timeoutInterval = 10.0;
     // 同步请求 获取返回数据
     NSData *data1 = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&respose
                                                       error:&error];
    
    // 解析JSON 数据
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    NSInteger index = [[dic objectForKey:@"code"] integerValue];
    
    // 判断是否注册成功
    if (index == 0) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark 登陆用户
- (BOOL)longinAccount:(NSString *)account
             password:(NSString *)password
{
    if (![self determineTheNetwork]) {
        return NO;
    }
    
    // 账户或密码为空直接 NO
    if (!account.length && !password.length) {
        return NO;
    }
    
    // 参数
    NSString *parameters = [NSString stringWithFormat:@"mobile=%@&password=%@", account, password];
    NSData *data = LSEncode(parameters);
    
    // 创建请求网址
    NSURL *url = [NSURL URLWithString:kLonginURL];
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    // 请求体添加到请求网址
    [request setHTTPBody:data];
    // 设置请求超时时间
    request.timeoutInterval = 10.0;
    
    
    NSURLResponse * respose = nil;
    NSError * error = nil;
    // 同步请求 获取返回数据
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&respose
                                                      error:&error];
    
    // JSON数据解析
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    
    // 获取判断值
    NSInteger code = [[dic objectForKey:@"code"] integerValue];
    
    if (code == 0) {
        
        NSDictionary *dict = dic[@"datas"];
        
        
         UserInformation *infor = [[UserInformation alloc] init];
         [infor setValuesForKeysWithDictionary:dict];
         // 用户信息存储到本地
         [[LocalStoreManage sharInstance] UserInforStoredLocally:infor];
        
        
        return YES;
    } else {
        
        NSLog(@"datas = %@", dic[@"datas"]);
        
        return NO;
    }
    
    
    
}

#pragma mark - 第三方登陆
- (BOOL)otherLoginOpenID:(NSInteger)openID
                    type:(NSInteger)type
               user_name:(NSString *)name
               user_avar:(NSString *)avar
{
    if (![self determineTheNetwork]) {
        return NO;
    }
    
    BOOL is;
    
    // 参数
    NSString *parameters = [NSString stringWithFormat:@"openid=%ld&type=%ld&user_name=%@&user_avar=%@", (long)openID, (long)type, name, avar];
    NSData *data = LSEncode(parameters);
    
    // 创建请求网址
    NSURL *url = [NSURL URLWithString:kOpenLoginURL];
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    // 请求体添加到请求网址
    [request setHTTPBody:data];
    // 设置请求超时时间
    request.timeoutInterval = 10.0;
    
    NSURLResponse * respose = nil;
    NSError * error = nil;
    // 同步请求 获取返回数据
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&respose
                                                      error:&error];
    
    // JSON数据解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    if ([[dic objectForKey:@"code"] integerValue] == 0) {
        
        NSLog(@"第三方登陆成功 = %@", [dic objectForKey:@"datas"]);
        
        // 获取服务器请求的用户信息
        NSDictionary *inforDic = [dic objectForKey:@"datas"];
        
        // 用户信息保存本地
        UserInformation *infor = [[UserInformation alloc] init];
        [infor setValuesForKeysWithDictionary:inforDic];
        [[LocalStoreManage sharInstance] UserInforStoredLocally:infor];
        is = YES;
    } else {
        NSLog(@"第三方登陆失败 = %@", [dic objectForKey:@"datas"]);
        is = NO;
    }
    
    return is;
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
    
    // 请求地址
    NSURL *url = [NSURL URLWithString:kUpLoadHead];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
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
    request.HTTPBody = body;
    // 设置请求体的长度
    NSInteger length = [body length];
    [request setValue:[NSString stringWithFormat:@"%ld", length] forHTTPHeaderField:@"Content-Length"];
    // 设置 POST 请求文件上传
    [request setValue:@"multipart/form-data; boundary=LS" forHTTPHeaderField:@"Content-Type"];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
       
        if ([dic[@"code"] integerValue] == 0) {
            NSLog(@"修改头像获取URL datas = %@", dic[@"datas"]);
            NSString *headURL = [dic objectForKey:@"datas"];
            [[LocalStoreManage sharInstance] upUserHeadURL:headURL];
        }
        
   }];
}

#pragma mark - 修改昵称
- (void)updateUserName:(NSString *)name
               user_id:(NSString *)user_id
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kUpdateUserName];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 请求体
    NSString *str = [NSString stringWithFormat:@"user_id=%@&user_name=%@", user_id, name];
    [request setHTTPBody:LSEncode(str)];
    request.timeoutInterval = 10.0;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"code = %@, datas = %@", dic[@"code"], dic[@"datas"]);
        
    }];
}

#pragma mark - 忘记密码
- (void)forgetPasswordphone:(NSString *)phone
                   password:(NSString *)password
                       code:(NSString *)code
                      retun:(void(^)(NSString *str))block
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kForgetPassword];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 请求体
    NSString *str = [NSString stringWithFormat:@"mobile=%@&password=%@&code=%@", phone, password, code];
    [request setHTTPBody:LSEncode(str)];
    request.timeoutInterval = 10.0;
    
    NSURLResponse * respose = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respose error:&error];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic objectForKey:@"code"] integerValue] == 0) {
        block(@"修改成功");
    } else {
        block([dic objectForKey:@"datas"]);
    }
    
}

#pragma mark - 获取小区
- (void)getCommunity:(void(^)(NSArray *array))sender
{
    
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kGetCommunity];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    request.timeoutInterval = 10.0;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:nil];
        
        NSArray *array = [dataDict objectForKey:@"datas"];
        
        NSMutableArray *communityArray = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            
            CommunityInformation *community = [[CommunityInformation alloc] init];
            [community setValuesForKeysWithDictionary:dict];
            [communityArray addObject:community];
            
        }
        
        sender(communityArray);
    }];
}

#pragma mark - 交物业费
- (WuYeDetails *)wuyeInoformationID:(NSString *)user_id
                      wuye:(NSString *)wuye_id
                    number:(NSString *)number
                      name:(NSString *)name;
{
    if (![self determineTheNetwork]) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:kWuYePayInformation];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 请求体
    NSString *str = [NSString stringWithFormat:@"user_id=%@&wuye_id=%@&number=%@&name=%@", user_id, wuye_id, number, name];
    [request setHTTPBody:LSEncode(str)];
    request.timeoutInterval = 10.0;
    
    NSURLResponse *respose = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&respose
                                                     error:&error];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    
    WuYeDetails *wuye = [[WuYeDetails alloc] init];
    wuye.code = [[dic objectForKey:@"code"] integerValue];
    
    if (0 == wuye.code) { // 请求成功则开始解析
        
        NSDictionary *dict = [dic objectForKey:@"datas"];
        [wuye setValuesForKeysWithDictionary:dict];
        
        
    }
    
    return wuye;
}

#pragma makr - 确认物业缴费
- (void)wuyePay:(NSString *)user_id
        log_ids:(NSInteger)log_ids
          retum:(void(^)(NSDictionary *dict))inform
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kWuYePay];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *str = [NSString stringWithFormat:@"user_id=%@&log_ids=%ld", user_id, (long)log_ids];
    [request setHTTPBody:LSEncode(str)];
    request.timeoutInterval = 10.0;
    
    NSURLResponse *respose = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&respose
                                                     error:&error];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
    NSInteger index = [[dic objectForKey:@"code"] integerValue];
    if (1 == index) {
        NSLog(@"----------- 交易失败");
        return;
    }
    
    NSDictionary *dataDict = [dic objectForKey:@"datas"];
    
    Product *product = [[Product alloc] init];
    [product setValuesForKeysWithDictionary:dataDict];
    [[AlipayManage sharInstance] createrOrderAndSignature:product retum:^(NSDictionary *ditc) {
        
        // 把支付宝返回信息反馈到显示界面
        inform(ditc);
        
    }];
}

#pragma mark - 首页信息
- (NSDictionary *)requestHomeInformation
{
    if (![self determineTheNetwork]) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:kHomeInformation];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.0;
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
    NSInteger index = [[dict objectForKey:@"code"] integerValue];
    
    if (0 == index) {
        
        NSDictionary *datas = [dict objectForKey:@"datas"];
        
        // 轮播图
        NSArray *advs = [datas objectForKey:@"advs"];
        
        // 点赞
        NSDictionary *zan_count = [datas objectForKey:@"zan_count"];
        
        NSArray *zan_array = @[[zan_count objectForKey:@"type1"],
                               [zan_count objectForKey:@"type2"],
                               [zan_count objectForKey:@"type3"]];
        
        NSDictionary *returnDataDict = [NSDictionary dictionaryWithObjectsAndKeys:advs, @"advs", zan_array, @"zan_count", nil];
        
        return returnDataDict;
    }
    
    return nil;
}

#pragma mark - 为首页服务项点赞
- (void)didZanUser_id:(NSString *)user_id
                 type:(NSString *)type
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kHomeDidZan];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // 参数
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&type=%@", user_id, type];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                           }];
    
}

#pragma mark - 获取资讯列表
- (void)consultListPage:(NSString *)index returns:(void(^)(NSArray *array))block
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kConsultList];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"page=%@", index];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
        
        if (0 == [[dict objectForKey:@"code"] integerValue]) {
            
            NSArray *consultAr = [dict objectForKey:@"datas"];
            
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
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kSenderConsult];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&info=%@", user_id, info];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                           }];
}

#pragma mark - 咨询_赞
- (void)consultZanUser_id:(NSString *)user_id consult_id:(NSString *)consult_id
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kConsult_zan];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&consult_id=%@", user_id, consult_id];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                           }];
}

#pragma mark - 回复咨询
- (void)replyConsultUser_id:(NSString *)user_id consult_id:(NSString *)consult_id info:(NSString *)info
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kReplyConsult];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&consult_id=%@&info=%@", user_id, consult_id, info];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
        
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            NSLog(@"---咨询列表回复成功---");
        }
    
    
    }];
}

#pragma mark - 获取答复列表信息
- (void)requestReplyListInfoUser_id:(NSString *)user_id returns:(void(^)(NSArray *array))block
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kReplyList];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", user_id];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
        if ([[dict objectForKey:@"code"] integerValue] == 0) {
            
            NSArray *array = [dict objectForKey:@"datas"];
            NSMutableArray *replyArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                
                ReplyListModel *model = [[ReplyListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [replyArray addObject:model];
                
            }
            
            // 请求解析完毕返回数据
            block(replyArray);
            
        }
    }];
    
}

@end
