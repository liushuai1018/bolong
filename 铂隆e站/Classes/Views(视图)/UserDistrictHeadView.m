//
//  UserDistrictHeadView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/30.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "UserDistrictHeadView.h"

@implementation UserDistrictHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

// 创建显示图片
- (void)createView
{
    // 创建背景图片并添加
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImage.image = [UIImage imageNamed:@"beijing.png"];
    [self addSubview:_backgroundImage];
    
    // 创建头像图片并添加
    _headPortraitImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _headPortraitImage.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetHeight(_backgroundImage.frame) / 2 - 5);
    _headPortraitImage.backgroundColor = [UIColor whiteColor];
    _headPortraitImage.layer.masksToBounds = YES; // 显示圆角
    _headPortraitImage.layer.cornerRadius = 50.0; // 设置弧度
    _headPortraitImage.layer.borderWidth = 3.0; // 设置圆的宽度
    _headPortraitImage.layer.borderColor = [[UIColor whiteColor] CGColor]; // 圆边的颜色
    [_backgroundImage addSubview:_headPortraitImage];
    
    
    // 创建 用户名并添加
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_backgroundImage.frame) / 2 - 50, CGRectGetMaxY(_headPortraitImage.frame) + 5, 100, 21)];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.textColor = [UIColor whiteColor];
    [_backgroundImage addSubview:_userNameLabel];
    
    // 创建性别
    _sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userNameLabel.frame) +  2, CGRectGetMinY(_userNameLabel.frame) + 3, 15, 15)];
    [_backgroundImage addSubview:_sexImage];
    
    
    // 将Image用户交互打开
    _headPortraitImage.userInteractionEnabled = YES;
    _backgroundImage.userInteractionEnabled = YES;
    
    
    // 创建手势添加到image
    UITapGestureRecognizer *headPortraitTapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longActions:)];
    [_headPortraitImage addGestureRecognizer:headPortraitTapgesture];
    UITapGestureRecognizer *backgTG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackgroundAction:)];
    [_backgroundImage addGestureRecognizer:backgTG];
    
}

#pragma mark - 区头头像手势方法
// 头像手势执行方法
- (void)longActions:(UITapGestureRecognizer *)sender
{
    NSLog(@"你点击头像了");
    __weak UserDistrictHeadView *userDHV = self;
    // 创建提示窗口
    // 1. 创建UIAlertControl变量，但并不穿GIAn
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 创建提示窗口按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消操作");
    }];
    [alert addAction:action]; // 取消按钮添加到提示框上
    
    
    // 2.添加相册按钮
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"打开相册");
            
            // 跳转到相册
            UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
            imageController.allowsEditing = YES; // 允许图片编辑
            imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            // 推出相册
            userDHV.blocks(imageController);
            
        }];
        action;
    })];
    
    // 3.添加摄像头按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"打开摄像头");
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            // 跳转到摄像头
            UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
            imageController.allowsEditing = YES; // 允许图片编辑
            imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            // 推出摄像头
            userDHV.blocks(imageController);
            
        } else {
            
            
            // 没有摄像头
            UIAlertController *MYalert = [UIAlertController alertControllerWithTitle:@"没有摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消操作");
            }];
            [MYalert addAction:action]; // 取消按钮添加到提示框上
            
            // 推出没有摄像头提示框
            userDHV.block1(MYalert);
        }
        
        
    }]];
    // 推出图片来源提示框
    self.block1(alert);
    
}

#pragma mark - 区头背景
- (void)clickBackgroundAction:(UITapGestureRecognizer *)sender
{
    self.block2();
    
}

@end
