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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                    message:str
//                                                   delegate:self
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
//    
//    // 延时执行方法
//    [self performSelector:@selector(dismissAlert:)
//               withObject:alert
//               afterDelay:2];
    
    
    if (!_alertControl) {
        _alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [_alertControl addAction:cancel];
    }
    
    _alertControl.message = str;
    [[self getCurrentVC] presentViewController:_alertControl animated:YES completion:nil];
    
    // 延时执行方法
    [self performSelector:@selector(dismissAlert:)
               withObject:_alertControl
               afterDelay:2];

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

#pragma mark
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
        
        
    } else {
        [self alertView:[dic objectForKey:@"datas"]];
        return nil;
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

#pragma mark - 其他_送水单价
- (NSString *)other_WaterMoney
{
    if (![self determineTheNetwork]) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:kWaterMoneyURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10.0];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if (!data) {
        [self alertView:@"网络请求失败"];
        return nil;
    }
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:nil];
    NSInteger code = [[dict objectForKey:@"code"] integerValue];
    if (code != 0) {
        [self alertView:@"网络请求失败"];
        return nil;
    }
    
    NSDictionary *dataDict = [dict objectForKey:@"datas"];
    
    
    return [dataDict objectForKey:@"price"];
}

#pragma mark - 其他_送水
- (void)other_waterAddress:(NSString *)address
                     momey:(NSString *)momey
                  userInfo:(UserInformation *)user
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kWaterURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *parameter = [NSString stringWithFormat:@"wuye_id=%@&money=%@&address=%@&user_id=%@", @"4", momey, address, user.user_id];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    NSURLResponse *respose = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&respose
                                                     error:nil];
    if (!data) {
        [self alertView:@"网络请求失败"];
        return;
    }
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
    
    NSInteger index = [[dic objectForKey:@"code"] intValue];
    if (index != 0) {
        [self alertView:@"网络请求失败"];
        return;
    }
    Product *product = [[Product alloc] init];
    [product setValuesForKeysWithDictionary:[dic objectForKey:@"datas"]];
    __weak NetWorkRequestManage *netWork = self;
    [[AlipayManage sharInstance] createrOrderAndSignature:product retum:^(NSDictionary *ditc) {
        if ([[ditc objectForKey:@"resultStatus"] intValue] == 9000) {
            [netWork alertView:@"购买成功!"];
        } else {
            [netWork alertView:@"购买失败!"];
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
        
        NSLog(@"question = %@", dataDict);
        
    }];
    [upLoadTask resume];
}

#pragma mark - 其他_是否已经签到
- (BOOL)other_isSignInUserID:(NSString *)userID
{
    if (![self determineTheNetwork]) {
        return NO;
    }
    NSURL *url = [NSURL URLWithString:kIsSignInURL];
    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
    [quest setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", userID];
    [quest setHTTPBody:LSEncode(parameter)];
    [quest setTimeoutInterval:10.0];
    
    NSURLResponse * respose = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:quest
                                         returningResponse:&respose
                                                     error:&error];
    if (error) {
        return NO;
    }
    
    NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
    
    if (0 == index) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 其他_签到
- (BOOL)other_signinUserID:(NSString *)userID
{
    if (![self determineTheNetwork]) {
        return NO;
    }
    NSURL *url = [NSURL URLWithString:kSignInURl];
    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
    [quest setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@", userID];
    [quest setHTTPBody:LSEncode(parameter)];
    [quest setTimeoutInterval:10.0];
    
    NSURLResponse * respose = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:quest
                                         returningResponse:&respose
                                                     error:&error];
    if (error) {
        return NO;
    }
    
    NSMutableDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSInteger index = [[dataDict objectForKey:@"code"] integerValue];
    
    if (0 == index) {
        return YES;
    } else {
        return NO;
    }
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

#pragma mark - 我的地址列表
- (void)requestAddressUser_id:(NSString *)user_id  returns:(void(^)(NSArray *array))block
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kAddress_list];
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
        
        
        if (0 == [[dict objectForKey:@"code"] integerValue]) {
            
            NSArray *dataAr = [dict objectForKey:@"datas"];
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dic in dataAr) {
                LS_addressManage *address = [[LS_addressManage alloc] init];
                [address setValuesForKeysWithDictionary:dic];
                [array addObject:address];
            }
            
            block(array);
        }
    }];
}

#pragma mark - 删除地址
- (void)removeAddressUser_id:(NSString *)user_id address_id:(NSString *)addres_id
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kRemoveAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&address_id=%@", user_id, addres_id];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
        if (0 == [[dict objectForKey:@"code"] integerValue]) {
            NSLog(@"删除成功");
        }
    }];
}

#pragma mark - 添加新地址
- (void)addNewAddressUser_id:(NSString *)user_id full_address:(LS_addressManage *)address
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kAddNewAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&name=%@&mobile=%@&code=%@&province=%@&city=%@&region=%@&street=%@&full_address=%@", user_id, address.name, address.mobile, address.code, address.province, address.city, address.region, address.street, address.full_address];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
        
        NSLog(@"addNewAddress = %@", dict);
    }];
}

#pragma mark - 修改地址
- (void)upAddressUser_id:(NSString *)user_id address:(LS_addressManage *)address
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kUpAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&name=%@&mobile=%@&code=%@&province=%@&city=%@&region=%@&street=%@&full_address=%@&address_id=%@", user_id, address.name, address.mobile, address.code, address.province, address.city, address.region, address.street, address.full_address, address.address_id];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
        
        NSLog(@"datas ===== %@", [dict objectForKey:@"datas"]);
    }];
}

#pragma mark - 获取IM_token
- (void)obtainIMToken:(UserInformation *)userInfo returns:(void(^)(NSString *token))block
{
    if (![self determineTheNetwork]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:kIM_token];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *parameter = [NSString stringWithFormat:@"user_id=%@&user_name=%@&user_avar=%@", userInfo.user_id, userInfo.name, userInfo.headPortraitURL];
    [request setHTTPBody:LSEncode(parameter)];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
    {
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        
        if (code == 200) {
            
            NSString *token = [dict objectForKey:@"token"];
            block(token);
            
        } else {
            [self alertView:@"IM登陆失败"];
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
                                      NetWorkRequestManage *strong_control = weak_control; // 弱引用装换强引用,防止在多线程和ARC下随时被释放的问题
                                      if (strong_control) { // 判断释放释放已经被释放
                                          
                                          if (error) {
                                              [strong_control alertView:@"网络请求失败"];
                                              return;
                                          }
                                          NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:NSJSONReadingMutableLeaves
                                                                                                        error:nil];
                                          NSInteger code = [[dict objectForKey:@"code"] integerValue];
                                          if (code != 0) {
                                              [strong_control alertView:[dict objectForKey:@"datas"]];
                                              return;
                                          }
                                          
                                          if (block) {
                                              block(dict);
                                          }
                                      }
                                      
                                  }];
    [task resume];
}

@end
