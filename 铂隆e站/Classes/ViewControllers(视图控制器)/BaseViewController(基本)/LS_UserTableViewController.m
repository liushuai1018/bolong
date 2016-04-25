//
//  LS_UserTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/15.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_UserTableViewController.h"
#import "LS_user_TableViewCell.h"
#import "LS_user_headView.h"


#import "WalletViewController.h"
#import "PhoneViewController.h"
#import "YourTestChatViewController.h"
#import "CircleTableViewController.h"
#import "SetTableViewController.h"
#import "LonginViewController.h"

// 新钱包
#import "LS_Wallet_Root_ViewController.h"

@interface LS_UserTableViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *_imageAr;   // 图标数组
    NSArray *_titleAr;   // 标题数组
    
    // 区头
    LS_user_headView *_headView;
    // 用户信息
    UserInformation *_userInfo;
    
    // navigationControl
    UINavigationController *_navigationControl;
}

@end

@implementation LS_UserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.navigationController.navigationBar.translucent = NO;
    
    [self initData];
    [self initTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData
{
    _imageAr = @[@"LS_qianbao_ico",
                 @"LS_chongzhi_ico",
                 @"LS_haoyou_ico",
                 @"LS_quanzi_ico",
                 @"LS_shezhi_ico"];
    _titleAr = @[@"钱包",
                 @"话费充值",
                 @"好友",
                 @"圈子",
                 @"设置",];
    
    // 获取用户信息
    _userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
}

#pragma mark - initTableView
- (void)initTableView
{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [UIImageView new];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
    [self createrHeadView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LS_user_TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - initHeadView
- (void)createrHeadView
{
    _headView = [[LS_user_headView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.45)];
    self.tableView.tableHeaderView = _headView;
    _headView.name.delegate = self;
    [_headView.portraitBut addTarget:self action:@selector(headPortraitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *   设置显示信息
     */
    
    // 铂隆币
    _headView.BoLongbi.text = [NSString stringWithFormat:@"铂隆币: %@", _userInfo.money];
    NSRange range = {3, 6};
    // 手机号
    NSString *str = [_userInfo.mobile stringByReplacingCharactersInRange:range withString:@"******"];
    _headView.phoneNumber.text = [NSString stringWithFormat:@"手机号: %@", str];
    // 姓名
    _headView.name.text = _userInfo.name;
    // 设置头像
    [self downloadHeadImage];
}

#pragma marrk - 判断是否有头像图片没有下载
- (void)downloadHeadImage
{
    if (_userInfo.headPortrait == nil) {
        
        NSLog(@"UserTableView_headURL %@", _userInfo.headPortraitURL);
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_userInfo.headPortraitURL]
                                                        options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {// 下载中
                                                        }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          // 下载完成
                                                          if (image) { // 图片下载完成进行相关操作
                                                              _userInfo.headPortrait = image;
                                                              _headView.portraitImage.image = image;
                                                              [[LocalStoreManage sharInstance] storageHeadImage:image];
                                                          }
                                                      }];
        
    } else {
        _headView.portraitImage.image = _userInfo.headPortrait;
    }
}

#pragma mark - 修改头像
- (void)headPortraitAction:(UIButton *)sender
{
    [self createrImagePickerControlAlertControl];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_imageAr.count == 0) {
        return 0;
    } else {
        return _imageAr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LS_user_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageViews.image = [UIImage imageNamed:[_imageAr objectAtIndex:indexPath.row]];
    cell.title.text = [_titleAr objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.06;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_navigationControl) {
        _navigationControl = [[UINavigationController alloc] init];
    }
    id control = nil;
    switch (indexPath.row) {
        case 0:{ // 钱包
            control = [[LS_Wallet_Root_ViewController alloc] init];
            
        }
            break;
        case 1:{ // 充值
            control = [[PhoneViewController alloc]init];
            
        }
            break;
        case 2:{ // 好友
            control = [[YourTestChatViewController alloc] init];
        }
            break;
        case 3:{ // 圈子
            control = [[CircleTableViewController alloc] init];
        }
            break;
        case 4:{ // 设置
            __weak LS_UserTableViewController *user = self;
            SetTableViewController *set = [[SetTableViewController alloc] init];
            set.block = ^(){
                LonginViewController *longin = [[LonginViewController alloc] init];
                [user presentViewController:longin animated:YES completion:nil];
                user.tabBarController.selectedIndex = 0;
            };
            control = set;
        }
            break;
            
        default:
            break;
    }
    _navigationControl.viewControllers = @[control];
    [self presentViewController:_navigationControl animated:YES completion:nil];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NetWorkRequestManage sharInstance] updateUserName:textField.text user_id:_userInfo.user_id];
    _userInfo.name = textField.text;
    [[LocalStoreManage sharInstance] UserInforStoredLocally:_userInfo];
}

#pragma mark - 创建头像来源提示框
- (void)createrImagePickerControlAlertControl
{
    UIImagePickerController *imagePickerControl = [[UIImagePickerController alloc] init];
    imagePickerControl.allowsEditing = YES; // 允许图片编辑
    imagePickerControl.delegate = self;
    
    __weak LS_UserTableViewController *control = self;
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
    _headView.portraitImage.image = editedImage;
    
    // 把用户头像存储到本地
    [[LocalStoreManage sharInstance] storageHeadImage:editedImage];
    // 把用户头像发送服务器
    [[NetWorkRequestManage sharInstance] upLoadHead:_userInfo.user_id image:editedImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
