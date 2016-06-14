//
//  ImageView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/29.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ImageView.h"

@interface ImageView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *presentViewController;

@end

@implementation ImageView

- (instancetype)initWithFrame:(CGRect)frame presentViewController:(UIViewController *)Control
{
    self = [super initWithFrame:frame];
    if (self) {
        self.presentViewController = Control;
        [self createAllSubView];
    }
    return self;
}

- (void)createAllSubView
{
    // 设置可被点击
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapGestureRecognizer)];
    [self addGestureRecognizer:tap];
}

#pragma mark - 手势执行方法
- (void)clickTapGestureRecognizer
{
    __weak ImageView *controller = self;
    // 创建提示窗口
    // 1. 创建UIAlertControl变量，但并不穿GIAn
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 创建提示窗口按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action]; // 取消按钮添加到提示框上
    
    
    // 2.添加相册按钮
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            // 跳转到相册
            UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
            imageController.allowsEditing = YES; // 允许图片编辑
            imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imageController.delegate = controller;
            // 推出相册
            [controller presentViewControllers:imageController];
            
        }];
        action;
    })];
    
    // 3.添加摄像头按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            // 跳转到摄像头
            UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
            imageController.allowsEditing = YES; // 允许图片编辑
            imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imageController.delegate = controller;
            // 推出摄像头
            [controller presentViewControllers:imageController];
            
        } else {
            
            
            // 没有摄像头
            UIAlertController *MYalert = [UIAlertController alertControllerWithTitle:@"没有摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [MYalert addAction:action]; // 取消按钮添加到提示框上
            
            // 推出提示框
            [controller presentViewControllers:MYalert];
        }
        
        
    }]];
    // 推出提示框
    [self.presentViewController presentViewController:alert animated:YES completion:nil];
}

- (void)presentViewControllers:(id)sender
{
    [self.presentViewController presentViewController:sender animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 剪裁后图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 替换原来image
    self.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentViewController  dismissViewControllerAnimated:YES completion:nil];
}

@end
