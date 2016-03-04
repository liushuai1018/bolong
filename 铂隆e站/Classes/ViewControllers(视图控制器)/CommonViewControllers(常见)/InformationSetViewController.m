//
//  InformationSetViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/26.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "InformationSetViewController.h"
#import "UserInformation.h"
#import "ImageView.h"
#import "LSPickerView.h"

@interface InformationSetViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) ImageView *headImage;

@property (nonatomic, strong) LSPickerView *lsPickerView;

@end

@implementation InformationSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setNavigation];
    [self createHeadView];
    [self initTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据类
- (void)initData
{
    self.itemArray = @[@"我的头像",
                       @"昵称",
                       @"性别",
                       @"生日",
                       @"城市",
                       @"个性签名"
                       ];
    
}

#pragma mark - 创建设置Navigation
- (void)setNavigation
{
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.translucent = YES;
    [bar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsCompact];
    
    // 导航栏底部黑线
    if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        NSArray *list = bar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                NSArray *list2 = imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj isKindOfClass:[UIImageView class]]) {
                        UIImageView *image = (UIImageView *)obj2;
                        image.hidden = YES;
                    }
                }
            }
        }
    }
    // 标题
    self.navigationItem.title = @"我";
    
    // 设置标题颜色
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //设置导航栏上控件的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}

// 点击左边BarButton
- (void)clickLeftBarButtonItem:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存信息按钮事件
- (void)clickRightBarButtonItem:(UIBarButtonItem *)sender
{
    UserInformation *infor = [[UserInformation alloc] init];
    
    UITextField *nameText = [_tableView viewWithTag:13004];
    infor.name = nameText.text;
    
    UITextField *genderText = [_tableView viewWithTag:13000];
    infor.gender = genderText.text;
    
    UITextField *birText = [_tableView viewWithTag:13001];
    infor.birthday = birText.text;
    
    UITextField *cityText = [_tableView viewWithTag:13002];
    infor.city = cityText.text;
    
    UITextField *signatureText = [_tableView viewWithTag:13003];
    infor.signature = signatureText.text;
    
    UIImageView *headImage = [_tableView viewWithTag:13005];
    infor.headPortrait = headImage.image;
    
    infor.backgroundImage = self.headImage.image;
    
    // 开始存储信息
    [[LocalStoreManage sharInstance] UserInforStoredLocally:infor]; // 文件信息存储到本地
    [[LocalStoreManage sharInstance] storageHeadImage:headImage.image]; // 头像存储到本地
    [[NetWorkRequestManage sharInstance] upLoadHead:_userInfor.user_id image:headImage.image]; // 头像存储到服务器
    [[LocalStoreManage sharInstance] storageBackgroundImage:_headImage.image]; // 背景图片存储到本地
    [self alertView];
}

#pragma mark - 存储成功提示框
- (void)alertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - headView
- (void)createHeadView
{
    
    self.headImage = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) presentViewController:self];
    
    if (_userInfor.backgroundImage == nil) {
        _headImage.image = [UIImage imageNamed:@"beijing"];
    } else {
        _headImage.image = _userInfor.backgroundImage;
    }
    
    [self.view addSubview:_headImage];
}

#pragma mark - tableView
- (void)initTableView
{
    
    // 创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImage.frame), SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 设置区尾
    [_tableView setTableFooterView:[[UIImageView alloc] init]];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self accessoryViewCell:cell indexPath:indexPath];
    
    return cell;
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 70.0f;
    }
    return 50.0f;
}

#pragma mark - 创建 accessory
- (void)accessoryViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = _itemArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    
    UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 30)];
    
    // 附件设置为图片
    if (indexPath.row == 0) {
        
        accessory.frame = CGRectMake(0, 0, 50, 50);
        
        ImageView *imageView = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) presentViewController:self];
        imageView.image = [UIImage imageNamed:@"wo"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 25.0f;
        imageView.tag = 13005;
        
        if (_userInfor.headPortrait != nil) {
            imageView.image = _userInfor.headPortrait;
        }
        
        [accessory addSubview:imageView];
        cell.accessoryView = accessory;
        
        return;
    }
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:accessory.frame];
    textField.font = [UIFont systemFontOfSize:12.0f];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textAlignment = NSTextAlignmentRight;
    [accessory addSubview:textField];
    
    switch (indexPath.row) {
        case 1: {
            
            textField.tag = 13004;
            [self textField:textField text:_userInfor.name placeholder:@"设置用户名"];
            break;
        }
        case 2: {
            
            textField.tag = 13000;
            NSString *str = (_userInfor.gender == nil) ? nil : [NSString stringWithFormat:@"%@", _userInfor.gender];
            
            NSLog(@"_userInfor.gender : %@, class : %@", str, [str class]);
            
            if ([str isEqualToString:@"1"]) {
                [self textField:textField text:@"男" placeholder:@"请选择性别"];
                break;
            }
            if ([str isEqualToString:@"0"]) {
                [self textField:textField text:@"女" placeholder:@"请选择性别"];
            }
            
            [self textField:textField text:str placeholder:@"请选择性别"];
            
            break;
        }
        case 3: {
            textField.tag = 13001;
            [self textField:textField text:_userInfor.birthday placeholder:@"请选择生日"];
            break;
        }
        case 4: {
            
            textField.tag = 13002;
            [self textField:textField text:_userInfor.city placeholder:@"请选择城市"];
            break;
        }
        case 5: {
            
            textField.tag = 13003;
            [self textField:textField text:_userInfor.signature placeholder:@"请输入个性签名"];
            break;
        }
            
        default:
            break;
    }
    
    cell.accessoryView = accessory;
}

// 附件 textField 显示内容
- (void)textField:(UITextField *)textField text:(NSString *)text placeholder:(NSString *)placeholder
{
    if (text == nil) {
        textField.placeholder = placeholder;
    } else {
        textField.text = text;
    }
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 13000: {
            
            [textField resignFirstResponder];
            // 推出性别选择
            [self launchGender];
            break;
        }
        case 13001: {
            [textField resignFirstResponder];
            
            // 生日选择
            _lsPickerView = [[LSPickerView alloc] initWithFrame:self.view.frame chooseIndex:2];
            __weak InformationSetViewController *infor = self;
            self.lsPickerView.block = ^(NSString *str) {
                UITextField *textField = [infor.tableView viewWithTag:13001];
                textField.text = str;
                infor.userInfor.birthday = str;
            };
            [self.view addSubview:self.lsPickerView];
            
            break;
        }
        case 13002: {
            [textField resignFirstResponder];
            
            // 城市选择
            _lsPickerView = [[LSPickerView alloc] initWithFrame:self.view.frame chooseIndex:1];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
            self.lsPickerView.dataDic = [[NSDictionary alloc] initWithContentsOfFile:path];
            __weak InformationSetViewController *infor = self;
            self.lsPickerView.block = ^(NSString *str) {
                UITextField *textField = [infor.tableView viewWithTag:13002];
                textField.text = str;
                infor.userInfor.city = str;
            };
            [self.view addSubview:self.lsPickerView];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 性别推出
- (void)launchGender
{
    __weak InformationSetViewController *infor = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancel];
    
    
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"男神" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [infor getGenderString:@"男"];
        }];
        action;
    })];
    
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"女神" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [infor getGenderString:@"女"];
        }];
        action;
    })];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 设置显示的性别
- (void)getGenderString:(NSString *)gender
{
    UITextField *textField = [self.tableView viewWithTag:13000];
    textField.text = gender;
}


@end
