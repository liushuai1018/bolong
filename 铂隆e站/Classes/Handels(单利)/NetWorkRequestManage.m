//
//  NetWorkRequestManage.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/30.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//



#import "NetWorkRequestManage.h"
#import "UserInformation.h"

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


#pragma mark - 发送手机号，获取验证码
- (void)senderVerificationCode:(NSString *)phone
        returnVerificationCode:(void(^)(NSString *str))verification
{
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

#pragma mark - 用户信息发送到服务器
- (void)sendUserData:(UserInformation *)infor
{
    
    NSURL *url = [NSURL URLWithString:kSendUserURL];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    // 此处发送一定要设置，这个地方吧字典封装成JSON格式
    [request setValue:@"application/jason" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:
                        infor.headPortraitURL, @"headPortraitURL",
                        infor.name, @"name",
                        infor.gender, @"gender",
                        infor.birthday, @"birthday",
                        infor.signature, @"signature",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if (dict) {
            NSLog(@"发送服务器存储用户个人信息");
        }
        
    }];
}

#pragma mark - 修改头像
- (void)upLoadHead:(NSString *)user_id
             image:(UIImage *)image
{
    // 记录Image的类型和data
    NSData *imageData;
    NSString *imageFormat;
    if (UIImagePNGRepresentation(image) == nil) {
        imageFormat = @"Content-Type: image/jpeg \r\n";
        imageData = UIImageJPEGRepresentation(image, 1.0);
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

//- (void)upload:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params
//{
//    // 文件上传
//    NSURL *url = [NSURL URLWithString:kUpLoadHead];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    
//    // 设置请求体
//    NSMutableData *body = [NSMutableData data];
//    
//    /**********文件参数**********/
//    
//    // 参数开始的标志
//    [body appendData:LSEncode(@"--YY\r\n")];
//    
//    // name:指定参数名
//    // filename: 文件名
//    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, fileName];
//    [body appendData:LSEncode(disposition)];
//    
//    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
//    [body appendData:LSEncode(type)];
//    
//    [body appendData:LSEncode(@"\r\n")];
//    [body appendData:data];
//    [body appendData:LSEncode(@"\r\n")];
//    
//    /**********普通参数**********/
//    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        // 参数开始的标志
//        [body appendData:LSEncode(@"--YY\r\n")];
//        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
//        [body appendData:LSEncode(disposition)];
//        [body appendData:LSEncode(@"\r\n")];
//        [body appendData:LSEncode(obj)];
//        [body appendData:LSEncode(@"\r\n")];
//    }];
//    
//    /**********参数结束**********/
//    [body appendData:LSEncode(@"--YY--")];
//    request.HTTPBody = body;
//    
//    // 设置请求头，请求体的长度
//    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
//    // 声明这个POST请求是个文件上传
//    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        
//        if (data) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            
//            NSLog(@"----code = %ld, datas = %@", [dic[@"code"] integerValue], dic[@"datas"]);
//            
//        }
//        
//    }];
//    
//}

#pragma mark - 修改昵称
- (void)updateUserName:(NSString *)name
               user_id:(NSString *)user_id
{
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

@end
