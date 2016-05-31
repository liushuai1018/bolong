//
//  LS_Other_BaoXiu_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_BaoXiu_ViewController.h"

@interface LS_Other_BaoXiu_ViewController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
// 报修
@property (weak, nonatomic) IBOutlet UITextView *baoXiu;
// 地址
@property (weak, nonatomic) IBOutlet UITextView *address;

// 报修约束 距离上边
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baoXiu_top;
// 图片按钮长款比例
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthHeightProportion;

// 记录点击的那个imageBut
@property (assign, nonatomic) NSInteger index;

// 记录选择的图片
@property (strong, nonatomic) UIImage *image11;
@property (strong, nonatomic) UIImage *image22;
@property (strong, nonatomic) UIImage *image33;

// alert
@property (strong, nonatomic) UIAlertController *alertView;

@end

@implementation LS_Other_BaoXiu_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修";
    
    [self setAttribute];
    [self setFrame];
}

#pragma mark - 设置属性
- (void)setAttribute
{
    _baoXiu.delegate = self;
    _address.delegate = self;
}

#pragma mark - 设置Frame
- (void)setFrame
{
    // 适配
    NSString *deviceModel = [[LS_EquipmentModel sharedEquipmentModel] accessModel];
    
    if ([deviceModel isEqualToString:@"iPhone 4S"] || [deviceModel isEqualToString:@"iPhone 4"]) {
        _baoXiu_top.constant = CGRectGetHeight(self.view.frame) * 0.1;
    } else {
        _baoXiu_top.constant = CGRectGetHeight(self.view.frame) * 0.12;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择图片
- (IBAction)selectImage1:(UIButton *)sender {
    _index = sender.tag;
    [self createrImagePickerControlAlertControl];
}

- (IBAction)selectImage2:(UIButton *)sender {
    _index = sender.tag;
    [self createrImagePickerControlAlertControl];
}

- (IBAction)selectImage3:(UIButton *)sender {
    _index = sender.tag;
    [self createrImagePickerControlAlertControl];
}

#pragma mark - 上传报修问题
- (IBAction)postBaoXiu:(UIButton *)sender {
    
    NSString *question = _baoXiu.text;
    if ([question isEqualToString:@"维修问题"] || [question isEqualToString:@""]) {
        [self alertViewTitle:@"请填写报修的问题!"];
        return;
    }
    
    NSString *address = _address.text;
    if ([address isEqualToString:@"详细地址如: XX小区XX号楼XX单元XX号"] || [address isEqualToString:@""]) {
        [self alertViewTitle:@"请填写完整地址!"];
        return;
    }
    
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    __weak LS_Other_BaoXiu_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] other_repairUserID:userInfo.user_id
                                                    wuye_id:@"3"
                                                   question:question
                                                    address:address
                                                       pic1:_image11
                                                       pic2:_image22
                                                       pic3:_image33
                                                    returns:^(BOOL is) {
                                                        LS_Other_BaoXiu_ViewController *strong_control = weak_control;
                                                        if (strong_control) {
                                                            if (is) {
                                                                [strong_control alertViewTitle:@"我们以收到您的问题,会尽快给您去维修!"];
                                                            }
                                                        }
                                                        
                                                    }];
}


#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_baoXiu resignFirstResponder];
    [_address resignFirstResponder];
}

#pragma mark - 创建头像来源提示框
- (void)createrImagePickerControlAlertControl
{
    UIImagePickerController *imagePickerControl = [[UIImagePickerController alloc] init];
    imagePickerControl.allowsEditing = YES; // 允许图片编辑
    imagePickerControl.delegate = self;
    
    __weak LS_Other_BaoXiu_ViewController *control = self;
    UIAlertController *alelrtControl = [UIAlertController alertControllerWithTitle:@"图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 取消
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alelrtControl addAction:cancel];
    
    // 相册
    UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [control presentViewController:imagePickerControl animated:YES completion:nil];
        
    }];
    [alelrtControl addAction:photoAlbum];
    
    // 摄像头
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 判断有没有摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerControl.sourceType = UIImagePickerControllerSourceTypeCamera;
            [control presentViewController:imagePickerControl animated:YES completion:nil];
        } else {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"没有摄像头" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [view show];
        }
    }];
    [alelrtControl addAction:camera];
    
    [self presentViewController:alelrtControl animated:YES completion:nil];
}

#pragma mark - ImagePickerControlDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 退出提示框
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 剪裁后图片
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIButton *but = [self.view viewWithTag:_index];
    switch (_index) {
        case 14000: {
            _image11 = editedImage;
            break;
        }
        case 14001: {
            _image22 = editedImage;
            break;
        }
        case 14002: {
            _image33 = editedImage;
            break;
        }
    }
    
    
    [but setImage:editedImage forState:UIControlStateNormal];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - alertVIew
- (void)alertViewTitle:(NSString *)title
{
    if (!_alertView) {
        _alertView = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [_alertView addAction:cancel];
    }
    _alertView.message = title;
    [self presentViewController:_alertView animated:YES completion:nil];
}

@end