//
//  LS_Lease_Inform_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/28.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Lease_Inform_ViewController.h"

@interface LS_Lease_Inform_ViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
// scroll
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
// 出租|出售
@property (weak, nonatomic) IBOutlet UISegmentedControl *leaseOrSell;
// 格局
@property (weak, nonatomic) IBOutlet UITextField *geju;
// 价格
@property (weak, nonatomic) IBOutlet UITextField *price;
// 小区
@property (weak, nonatomic) IBOutlet UITextField *xiaoqu;
// 地址
@property (weak, nonatomic) IBOutlet UITextField *address;
// 介绍
@property (weak, nonatomic) IBOutlet UITextView *jieshao;
// 电话
@property (weak, nonatomic) IBOutlet UITextField *phone;
// 姓名
@property (weak, nonatomic) IBOutlet UITextField *name;

// 图片1
@property (weak, nonatomic) IBOutlet UIButton *image1;
// 图片2
@property (weak, nonatomic) IBOutlet UIButton *image2;
// 图片3
@property (weak, nonatomic) IBOutlet UIButton *image3;
// 发布
@property (weak, nonatomic) IBOutlet UIButton *sender;

// 记录出租还是出售
@property (assign, nonatomic) NSInteger index;
// 记录图片
@property (strong, nonatomic) UIImage *image11;
@property (strong, nonatomic) UIImage *image22;
@property (strong, nonatomic) UIImage *image33;

// 点击那个添加图片
@property (assign, nonatomic) NSInteger selectImage;

// 菊花
@property (strong, nonatomic) UIView *activityView;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

@end

@implementation LS_Lease_Inform_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSetting];
    _index = 1; // 默认出租
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scroll.frame = _bounds;
}

#pragma mark - 初始化设置
- (void)initSetting {
    _scroll.bounces = NO;
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_sender.frame) + 20);
    _geju.delegate = self;
    _price.delegate = self;
    _xiaoqu.delegate = self;
    _address.delegate = self;
    _jieshao.delegate = self;
    _jieshao.layer.masksToBounds = YES;
    _jieshao.layer.cornerRadius = 6;
    _jieshao.layer.borderWidth = 0.5;
    _jieshao.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _phone.delegate = self;
    _name.delegate = self;
    
}

#pragma mark - 出售 or 出租
- (IBAction)segmentedControlAcion:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    
    switch (index) {
        case 0: {
            _index = 1;
            break;
        }
        case 1: {
            _index = 2;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - image1Action
- (IBAction)obtainImage1:(UIButton *)sender {
    _selectImage = 100000001;
    [self createrImagePickerControlAlertControl];
}

#pragma mark - image2Action
- (IBAction)obtainImage2:(UIButton *)sender {
    _selectImage = 100000002;
    [self createrImagePickerControlAlertControl];
}

#pragma mark - image3Action
- (IBAction)obtainImage3:(UIButton *)sender {
    _selectImage = 100000003;
    [self createrImagePickerControlAlertControl];
}

#pragma mark - senderAction
- (IBAction)senderAction:(UIButton *)sender {
    [self resignFirstResponders];
    
    NSString *geju = _geju.text;
    if ([geju isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入房屋格局!"];
        return;
    }
    
    NSString *price = _price.text;
    if ([price isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入房屋价格!"];
        return;
    }
    
    NSString *xiaoqu = _xiaoqu.text;
    if ([xiaoqu isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入所在小区!"];
        return;
    }
    
    NSString *address = _address.text;
    if ([address isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入具体地址!"];
        return;
    }
    
    NSString *jieshao = _jieshao.text;
    if ([jieshao isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入房介绍!"];
        return;
    }
    
    NSString *phone = _phone.text;
    if ([phone isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入联系电话!"];
        return;
    }
    
    NSString *name = _name.text;
    if ([name isEqualToString:@""]) {
        [self createrAlertControlMessage:@"请输入联系姓名!"];
        return;
    }
    
    [self activityControl]; // 打开菊花
    
    __weak LS_Lease_Inform_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] other_releaseHousingInformLeaseOrSell:_index Geju:geju price:price community:xiaoqu address:address introduce:jieshao phone:phone name:name image1:_image11 image2:_image22 image3:_image33 returns:^(BOOL is) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weak_control stopActivityIndicator];
            if (is) {
                [weak_control createrAlertControlMessage:@"信息发布成功!"];
            } else {
                [weak_control createrAlertControlMessage:@"信息发布失败!"];
            }
        });
    }];
}

#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_sender.frame) + 250);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_sender.frame) + 20);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_sender.frame) + 250);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_sender.frame) + 20);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)resignFirstResponders {
    [_geju resignFirstResponder];
    [_price resignFirstResponder];
    [_xiaoqu resignFirstResponder];
    [_address resignFirstResponder];
    [_jieshao resignFirstResponder];
    [_phone resignFirstResponder];
    [_name resignFirstResponder];
}

#pragma mark - Alert
- (void)createrAlertControlMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ImagePicker
- (void)createrImagePickerControlAlertControl
{
    UIImagePickerController *imagePickerControl = [[UIImagePickerController alloc] init];
    imagePickerControl.allowsEditing = YES; // 允许图片编辑
    imagePickerControl.delegate = self;
    
    __weak LS_Lease_Inform_ViewController *control = self;
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
            [control createrAlertControlMessage:@"没有摄像头"];
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
    
    switch (_selectImage) {
        case 100000001:{
            [_image1 setImage:editedImage forState:UIControlStateNormal];
            _image11 = editedImage;
            break;
        }
        case 100000002:{
            [_image2 setImage:editedImage forState:UIControlStateNormal];
            _image22 = editedImage;
            break;
        }
        case 100000003:{
            [_image3 setImage:editedImage forState:UIControlStateNormal];
            _image33 = editedImage;
            break;
        }
            
        default:
            break;
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 菊花
- (void)activityControl {
    
    _activityView = [[UIView alloc] initWithFrame:self.view.superview.bounds];
    _activityView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_activityView];
    /**
     *  蒙版
     */
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(_activityView.center.x - 50, _activityView.center.y - 140, 100, 80);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    [maskLayer setPath:maskPath.CGPath];
    _activityView.layer.mask = maskLayer;
    
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(_activityView.center.x, _activityView.center.y - 110);
    _activity = activity;
    [_activityView addSubview:_activity];
    [_activity startAnimating];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    title.center = CGPointMake(_activity.center.x, _activity.center.y + 30);
    title.text = @"正在加载...";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:10.0f];
    [_activityView addSubview:title];
}

- (void)stopActivityIndicator {
    if ([_activity isAnimating]) {
        [_activity stopAnimating];
        [_activityView removeFromSuperview];
    }
}
@end
