//
//  UserTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "UserTableViewController.h"
#import "UserDistrictHeadView.h"
#import "UserSecondTableViewCell.h"
#import "UserThirdTableViewCell.h"
#import "UserfirstSTableViewCell.h"
#import "WalletViewController.h"
#import "SetTableViewController.h"
#import "FriendsTableViewController.h"  // 好友列表
#import "YourTestChatViewController.h"  // 会话列表
#import "CircleTableViewController.h"
#import "UserInformation.h"
#import "LocalStoreManage.h"
#import "InformationSetViewController.h"

#import "CustomTabBar.h"
#import "LonginViewController.h"

@interface UserTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UserfirstSTableViewCell *_cell3;  // 第一个cell
    UserSecondTableViewCell *_cell1; // 第二个cell
    UserThirdTableViewCell *_cell2; // 第三个cell
    
}

@property (nonatomic, strong) UserDistrictHeadView *userView; // 区头视图

@property (nonatomic, strong) NSArray *setImage; // 设置动画图组

@property (nonatomic, strong) UserInformation *userInfor; // 用户信息

@property (nonatomic, strong) UINavigationController *navigationC;

@end

@implementation UserTableViewController

// 懒加载
- (UINavigationController *)navigationC
{
    if (!_navigationC) {
        _navigationC = [[UINavigationController alloc] init];
    }
    return _navigationC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone; // tableView样式
    self.navigationItem.title = @"我"; // 标题
    self.tableView.showsVerticalScrollIndicator = NO; // 隐藏滚动条
    self.tableView.allowsSelection = NO; // cell不可选中
    
    [self registerCell]; // 注册cell
    [self setHeaderView]; // 设置自定义区头
    [self requestUserData]; // 请求数据
    
}

#pragma mark - 在这设置区头显示信息
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_cell3 startAnimation]; // 设置设置动画开启
    
    // 获取最新用户消息
    self.userInfor = [[LocalStoreManage sharInstance] requestUserInfor];
    
    if (_userInfor.backgroundImage != nil) {
        _userView.backgroundImage.image = _userInfor.backgroundImage;
    }
    if (_userInfor.headPortrait == nil) {
        [self downloadHeadImage];                               
    }
    
    _userView.headPortraitImage.image = _userInfor.headPortrait;
    _userView.userNameLabel.text = _userInfor.name;
}

#pragma mark -- 获取用户数据
- (void)requestUserData
{
    // 获取用户信息
    self.userInfor = [[LocalStoreManage sharInstance] requestUserInfor];
    // 下载头像
    [self downloadHeadImage];
    
    // 设置动画数组
    self.setImage = @[[UIImage imageNamed:@"shezhi-2.png"],
                      [UIImage imageNamed:@"shezhi-3.png"],
                      [UIImage imageNamed:@"shezhi-4.png"]];
}

#pragma marrk - 判断是否有头像图片没有下载
- (void)downloadHeadImage
{
    if (_userInfor.headPortrait == nil) {
        
        NSLog(@"UserTableView_headURL %@", _userInfor.headPortraitURL);
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_userInfor.headPortraitURL]
                                                        options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {// 下载中
         }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // 下载完成
            if (image) { // 图片下载完成进行相关操作
                _userInfor.headPortrait = image;
                _userView.headPortraitImage.image = image;
                [[LocalStoreManage sharInstance] storageHeadImage:image];
            }
        }];
        
    }
}

#pragma mark -- 设置区头VIew
- (void)setHeaderView
{
    // 创建自定义区头
    _userView = [[UserDistrictHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)];
    // 设置区头上分别推出的Contnroller
    [self presentVC];
    
    // 放上区头
    self.tableView.tableHeaderView = self.userView;
}

#pragma mark - 头像区推出设置
- (void)presentVC
{
    __block UserTableViewController *userTVC = self;
    
    UserTableViewController * __weak userListVC = self;
    // 实现推出'头像'图片来源选择提示框
    _userView.block1 = ^(UIAlertController *alertC) {
        UserTableViewController *userlistVC = userListVC;
        if (userlistVC) {
            
            [userTVC presentViewController:alertC animated:YES completion:nil];
        }
    };
    
    
    // 实现推出'头像'相册或者摄像头界面
    _userView.blocks = ^(UIImagePickerController *imagePC) {
        imagePC.delegate = userTVC; // 设置相册或摄像头的代理
        [userTVC presentViewController:imagePC animated:YES completion:nil]; // 推出相册或者摄像头
    };
    
    
    // 实现推出信息控制器
    _userView.block2 = ^() {
        InformationSetViewController *infor = [[InformationSetViewController alloc] init];
        infor.userInfor = userTVC.userInfor;
        
        UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:infor];
        [userTVC presentViewController:navigationC animated:YES completion:nil];
    };
}

#pragma mark -- 注册cell
- (void)registerCell
{
    // 注册 cell
    [self.tableView registerClass:[UserfirstSTableViewCell class] forCellReuseIdentifier:@"Scell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"thirdCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        _cell3 = [tableView dequeueReusableCellWithIdentifier:@"Scell" forIndexPath:indexPath];
        _cell3.aimageArray = _setImage;
        [_cell3.walletBtn addTarget:self action:@selector(didClickWallet:) forControlEvents:UIControlEventTouchUpInside]; // 钱包
        [_cell3.settingBtu addTarget:self action:@selector(didClickSet:) forControlEvents:UIControlEventTouchUpInside]; // 设置
        return _cell3;
        
    }
    if (indexPath.row == 1) {
        _cell1 = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
        [_cell1.friendsBut addTarget:self action:@selector(didClickFriends:) forControlEvents:UIControlEventTouchUpInside]; // 好友
        
        
        return _cell1;
    }
    _cell2 = [tableView dequeueReusableCellWithIdentifier:@"thirdCell" forIndexPath:indexPath];
    [_cell2.circleBut addTarget:self action:@selector(didClickCircle:) forControlEvents:UIControlEventTouchUpInside]; // 发现圈子
    return _cell2;
    
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.17;
}

#pragma mark --- cell 上 button 方法
// 钱包
- (void)didClickWallet:(UIButton *)but
{
    WalletViewController *VC = [[WalletViewController alloc] init];
    self.navigationC.viewControllers = @[VC];
    [self presentViewController:_navigationC animated:YES completion:nil];
}

// 设置
- (void)didClickSet:(UIButton *)but
{
    __weak UserTableViewController *userTVC = self;
    
    SetTableViewController *VC = [[SetTableViewController alloc] init];
    VC.block = ^(){
        // 设置tabBar 为0
        userTVC.tabBarController.selectedIndex = 0;
        NSArray *array = userTVC.tabBarController.view.subviews;
        
        // 设置自定义button 为灰色
        for (id obje in array) {
            NSLog(@"id = %@", [obje class]);
            if ([obje isKindOfClass:[CustomTabBar class]]) {
                CustomTabBar *tabBar = (CustomTabBar *)obje;
                [tabBar.button setImage:[UIImage imageNamed:@"wo"] forState:UIControlStateNormal];
                break;
            }
        }
        
        // 推出 登陆界面
        LonginViewController *longinVC = [[LonginViewController alloc] init];
        [userTVC presentViewController:longinVC animated:YES completion:nil];
        
        // 移除上一个用户信息
        [[LocalStoreManage sharInstance] removeAllUserInfor];
        
    };
    self.navigationC.viewControllers = @[VC];
    [self presentViewController:self.navigationC animated:YES completion:nil];
}

// 好友
- (void)didClickFriends:(UIButton *)but
{
    YourTestChatViewController *yourTestChatVC = [[YourTestChatViewController alloc] init];
    self.navigationC.viewControllers = @[yourTestChatVC];
    [self presentViewController:_navigationC animated:YES completion:nil];
}

// 发现
- (void)didClickCircle:(UIButton *)but
{
    CircleTableViewController *VC = [[CircleTableViewController alloc] init];
    self.navigationC.viewControllers = @[VC];
    [self presentViewController:_navigationC animated:YES completion:nil];
}

#pragma mark 实现imagePicker Delegate事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 退出提示框
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 剪裁后图片
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 把用户信息存储到本地
    [[LocalStoreManage sharInstance] storageHeadImage:editedImage];
    
    [[NetWorkRequestManage sharInstance] upLoadHead:_userInfor.user_id image:editedImage];
    
}

// 图像选择器控制器并取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
