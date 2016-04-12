//
//  LocalStoreManage.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/21.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "LocalStoreManage.h"

// 存储文件夹路径
#define kFilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
// 用户信息路径
#define kUserInforPath [kFilePath stringByAppendingPathComponent:@"userInfor.plist"]
// 头像路径
#define kHeadImagePath [kFilePath stringByAppendingPathComponent:@"userInforHeadImage.png"]
// 背景图路径
#define kBackgroundPath [kFilePath stringByAppendingPathComponent:@"backgroundImage.png"]
// 文件夹管理工具
#define kFileManager [NSFileManager defaultManager]

@interface LocalStoreManage ()

@property (nonatomic, strong) UserInformation *userInfor;

@end

@implementation LocalStoreManage

+ (instancetype)sharInstance
{
    static LocalStoreManage *localStoreM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localStoreM = [[LocalStoreManage alloc] init];
    });
    return localStoreM;
}

#pragma mark - 用户信息存储到本地
- (void)UserInforStoredLocally:(UserInformation *)userInfor
{
    // 记录最新消息
    self.userInfor = userInfor;
    
    // 创建一个可变 data 用来存放用户信息被归档之后的 data 数据
    NSMutableData *data = [NSMutableData data];
    // 创建一个归档工具对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // 开始对用户信息对象进行归档
    [archiver encodeObject:userInfor forKey:@"userInfor"];
    // 归档结束
    [archiver finishEncoding];
    // 本地存储路径
    NSString *path = kUserInforPath;
    [data writeToFile:path atomically:YES];
    
}

#pragma mark - 存储头像到本地
- (void)storageHeadImage:(UIImage *)image
{
    // Image
    if (image == nil) { // 如果没有图片则 return
        NSLog(@"用户修改的头像为空");
        return;
    }
    _userInfor.headPortrait = image;
    NSData *data1 = UIImagePNGRepresentation(image);
    NSString *path1 = kHeadImagePath;
    [data1 writeToFile:path1 atomically:YES];
}

#pragma makr - 存储背景图片到本地
- (void)storageBackgroundImage:(UIImage *)image
{
    // Image
    if (image == nil) { // 如果没有图片则 return
        NSLog(@"背景图片为空");
        return;
    }
    _userInfor.backgroundImage = image;
    NSData *data1 = UIImagePNGRepresentation(image);
    NSString *path1 = kBackgroundPath;
    [data1 writeToFile:path1 atomically:YES];
}

#pragma mark -- 获取存储在本地的用户信息
- (UserInformation *)requestUserInfor
{
    if (nil != _userInfor) {
        
        return _userInfor;
    }
    
    // 本地存储路径
    NSString *path = kUserInforPath;
    
    // 存储在本地data类型的用户信息
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 反归档工具
    NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    _userInfor = [archiver decodeObjectForKey:@"userInfor"];
    
    // Image头像
    NSString *path1 = kHeadImagePath;
    
    if (![kFileManager fileExistsAtPath:path1]) {
        return _userInfor; // 本地没有存储头像
    }
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    _userInfor.headPortrait = [UIImage imageWithData:data1];
    
    // 背景图片
    NSString *path2 = kBackgroundPath;
    if (![kFileManager fileExistsAtPath:path2]) {
        return _userInfor; // 本地没有存储背景
    }
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    _userInfor.backgroundImage = [UIImage imageWithData:data2];
    
    return _userInfor;
}

#pragma mark - 更新用户头像URL
- (void)upUserHeadURL:(NSString *)headURL
{
    _userInfor.headPortraitURL = headURL;
    
    NSLog(@"修改头像后的用户信息 :%@", _userInfor);
    
    [self UserInforStoredLocally:_userInfor];
}

#pragma mark -清除所有用户信息
- (void)removeAllUserInfor
{
    // 获取所有路径
    NSString *userInforPath = kUserInforPath;
    NSString *headPath = kHeadImagePath;
    NSString *backgroundPath = kBackgroundPath;
    
    if ([kFileManager fileExistsAtPath:userInforPath]) {
        [kFileManager removeItemAtPath:userInforPath error:nil];
    }
    
    if ([kFileManager fileExistsAtPath:headPath]) {
        [kFileManager removeItemAtPath:headPath error:nil];
    }
    
    if ([kFileManager fileExistsAtPath:backgroundPath]) {
        [kFileManager removeItemAtPath:backgroundPath error:nil];
    }
}

@end
