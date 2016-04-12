//
//  ParkingConsultingViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ParkingConsultingViewController.h"
#import "ParkingConsultingView.h"
#import "LatestTableViewCell.h"
#import "ConsultListModel.h"
#import "ReplyTableViewCell.h"
#import "ReplyListModel.h"

@interface ParkingConsultingViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIView *_senderConsultingView;    // 发布、回复咨询
    UITextField *_textField;          // 输入框
    UIButton *_senderBut;             // 发送
}

@property (nonatomic, strong) ParkingConsultingView *parkingCV; // 停车咨询视图

@property (strong, nonatomic) UserInformation *userinfo;   // 用户信息

@property (strong, nonatomic) NSArray *consultList;     // 记录咨询列表信息

@property (strong, nonatomic) NSArray *replyList;       // 答复列表信息

@property (strong, nonatomic) NSIndexPath *indexPath;   // 记录回复咨询时选择的那个

@end

@implementation ParkingConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"咨询";
    self.navigationController.navigationBar.translucent = NO;
    
    // 获取用户信息
    self.userinfo = [[LocalStoreManage sharInstance] requestUserInfor];
    
    [self createrSubView];
    [self initializ];
    [self requestConsultData];
}

#pragma mark - 创建 View
- (void)createrSubView
{
    self.parkingCV = [[ParkingConsultingView alloc] initWithFrame:self.view.bounds];
    self.view = self.parkingCV;
    
    __weak ParkingConsultingViewController *parking = self;
    _parkingCV.block = ^(NSInteger index){
        [parking removeDialog];
        [parking requestUpDataIndex:index];
    };
}

#pragma mark - 选择界面获取对应数据
- (void)requestUpDataIndex:(NSInteger)index
{
    switch (index) {
        case 0: {
            [self requestConsultData];
            break;
        }
        case 2: {
            [self requstReplyData];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 获取咨询数据
- (void)requestConsultData
{
    [[NetWorkRequestManage sharInstance] consultListPage:@"1" returns:^(NSArray *array) {
        
        _consultList = array;
        [_parkingCV.latestTV reloadData];
        
    }];
}

#pragma mark - 获取答复数据
- (void)requstReplyData
{
    
    [[NetWorkRequestManage sharInstance] requestReplyListInfoUser_id:_userinfo.user_id returns:^(NSArray *array) {
        _replyList = array;
        [_parkingCV.replyTV reloadData];
    }];
}

#pragma mark - 将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
// 将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // remove通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - initializ Table View
- (void)initializ
{
    
    // 发送咨询监听事件
    [self.parkingCV.senderConsulting addTarget:self action:@selector(senderConsultingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 所有的TableView 的代理
    _parkingCV.latestTV.delegate = self;
    _parkingCV.latestTV.dataSource = self;
    _parkingCV.onlineTV.delegate = self;
    _parkingCV.onlineTV.dataSource = self;
    _parkingCV.replyTV.delegate = self;
    _parkingCV.replyTV.dataSource = self;
    [self.parkingCV.latestTV registerNib:[UINib nibWithNibName:@"LatestTableViewCell" bundle:nil] forCellReuseIdentifier:@"latestCell"];
    [self.parkingCV.onlineTV registerNib:[UINib nibWithNibName:@"LatestTableViewCell" bundle:nil] forCellReuseIdentifier:@"latestCell"];
    [self.parkingCV.replyTV registerNib:[UINib nibWithNibName:@"ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"replyCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 咨询列表时
    if (tableView == _parkingCV.latestTV) {
        
        if (_consultList != nil) {
            
            return _consultList.count;
        } else {
            return 0;
        }
    }
    
    // 答复列表时
    if (tableView == _parkingCV.replyTV) {
        if (_replyList != nil) {
            return _replyList.count;
        } else {
            return 0;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 咨询列表时
    if (tableView == _parkingCV.latestTV) {
        
        LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
        [self consultTableViewCell:cell indexPath:indexPath];
        return cell;
    }
    
    // 答复列表时
    if (tableView == _parkingCV.replyTV) {
        
        ReplyTableViewCell *replyCell = [tableView dequeueReusableCellWithIdentifier:@"replyCell" forIndexPath:indexPath];
        [self replyTableViewCell:replyCell indexPath:indexPath];
        return replyCell;
    }
    
    
    return nil;
    
}

#pragma mark - 不同的tableView实现不同Cell数据
// 咨询列表
- (void)consultTableViewCell:(LatestTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.iocImageView.layer.masksToBounds = YES;
    cell.iocImageView.layer.cornerRadius = CGRectGetHeight(cell.iocImageView.frame) * 0.5;
    [cell.zanButton addTarget:self action:@selector(zanAction:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.huiFuBUtton addTarget:self action:@selector(replyClickAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    // 界面信息
    ConsultListModel *model = [_consultList objectAtIndex:indexPath.row];
    
    [cell.iocImageView sd_setImageWithURL:[NSURL URLWithString:model.user_avar]];
    cell.contentTextView.text = model.info;
    cell.nameLabel.text = model.user_name;
    cell.wellLabel.text = model.zan_count;
}

// 答复列表
- (void)replyTableViewCell:(ReplyTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.headImage.layer.masksToBounds = YES;
    cell.headImage.layer.cornerRadius = CGRectGetHeight(cell.headImage.frame) * 0.5;
    
    
    ReplyListModel *model = [_replyList objectAtIndex:indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.2;
}

// 当前点击的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了 %@", indexPath);
}

#pragma mark - 回复按钮事件
- (void)replyClickAction:(UIButton *)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event];
    // 记录回复的那一天信息
    _indexPath = indexPath;
    
    NSLog(@" 回复 indexPath : %@", indexPath);
    [self removeDialog];
    [self createrDialogString:@" 回复:" index:1];
    
}

#pragma mark - 点赞绑定事件
- (void)zanAction:(UIButton *)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event];
    
    NSLog(@" 赞 indexPath : %@", indexPath);
    
    ConsultListModel *model = [_consultList objectAtIndex:indexPath.row];
    
    
    [[NetWorkRequestManage sharInstance] consultZanUser_id:self.userinfo.user_id consult_id:model.consult_id];
    // 发送完毕再次请求最新数据
    [self requestConsultData];
}

// 获取点击 Cell 位置
- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton *)sender; // 当前点击的按钮
    UITouch *touch = [[event allTouches] anyObject]; // 获取按钮event 里包含的 touch 动作
    
    if (![button pointInside:[touch locationInView:button] withEvent:event]) {
        return nil;
    }
    
    CGPoint touchPosition = [touch locationInView:_parkingCV.latestTV];
    
    return [self.parkingCV.latestTV indexPathForRowAtPoint:touchPosition];
}

#pragma mark - 发送新的咨询按钮_监听事件
- (void)senderConsultingAction:(UIButton *)sender
{
    [self removeDialog];
    [self createrDialogString:@" 发送新的咨询" index:0];
}

#pragma mark - 创建咨询/回复对话框
- (void)createrDialogString:(NSString *)str index:(NSInteger)index
{
    // 背景图
    _senderConsultingView = [[UIView alloc] init];
    [self.parkingCV.scrollView addSubview:_senderConsultingView];
    
    // 输入框
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(30, SCREEN_HEIGHT, SCREEN_WIDTH - 110, 35);
    _textField.placeholder = str;
    _textField.font = [UIFont systemFontOfSize:14.0f];
    _textField.layer.borderWidth = 1.0;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [_senderConsultingView addSubview:_textField];
    
    /**
     *  index 区分创建出来的是发送新的咨询还是 回复别人的咨询
     *  0   : 发送新的咨询
     *  1   : 回复别人咨询
     */
    
    // 发送按钮
    _senderBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _senderBut.frame = CGRectMake(CGRectGetMaxX(_textField.frame), CGRectGetMinY(_textField.frame), 60, 35);
    [_senderBut setTitle:@"发送" forState:UIControlStateNormal];
    [_senderBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_senderConsultingView addSubview:_senderBut];
    
    if (0 == index) {
        
        [_senderBut addTarget:self action:@selector(senderButAtion:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_senderBut addTarget:self action:@selector(replyButAtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    [_textField becomeFirstResponder];
    
    
}
#pragma mark - 发送咨询按钮
- (void)senderButAtion:(UIButton *)sneder
{
    [_textField resignFirstResponder];
    NSLog(@"----发送新的咨询----");
    
    
    // 输入框为空禁止发送
    if (![_textField.text isEqualToString:@""]) {
        [[NetWorkRequestManage sharInstance] senderConsultUser_id:_userinfo.user_id info:_textField.text];
        
        // 发送完毕再次请求最新数据
        [self requestConsultData];
    }
    
}
#pragma mark - 发送回复信息
- (void)replyButAtion:(UIButton *)sender
{
    [_textField resignFirstResponder];
    NSLog(@"----回复按钮----");
    
    if (![_textField.text isEqualToString:@""]) {
        
        ConsultListModel *model = [_consultList objectAtIndex:_indexPath.row];
        [[NetWorkRequestManage sharInstance] replyConsultUser_id:_userinfo.user_id consult_id:model.consult_id info:_textField.text];
    }
    
    
}

#pragma mark - 监听键盘
- (void)keyboardWillShow:(NSNotification *)info
{
    
    // 键盘高度
    CGFloat kbHeight = [[info.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 上移高度
    CGFloat offset = kbHeight + 45.0;
    
    // 列表高度
    CGFloat latestTV_Height = CGRectGetHeight(self.parkingCV.scrollView.frame) - offset;
    // sender按钮高度
    CGFloat senderConsulting_Height = CGRectGetHeight(self.parkingCV.scrollView.frame) - 70 - offset;
    
    // 动画时间
    double duration = [[info.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 列表
        self.parkingCV.latestTV.frame = CGRectMake(0, 0, CGRectGetWidth(_parkingCV.latestTV.frame), latestTV_Height);
        
        // sender按钮
        self.parkingCV.senderConsulting.frame = CGRectMake(CGRectGetMinX(self.parkingCV.senderConsulting.frame), senderConsulting_Height, CGRectGetWidth(self.parkingCV.senderConsulting.frame), CGRectGetHeight(self.parkingCV.senderConsulting.frame));
        
        _senderConsultingView.frame = CGRectMake(0, CGRectGetMaxY(_parkingCV.latestTV.frame), SCREEN_WIDTH, offset);
        _textField.frame = CGRectMake(30, 5, SCREEN_WIDTH - 110, 35);
        _senderBut.frame = CGRectMake(CGRectGetMaxX(_textField.frame), CGRectGetMinY(_textField.frame), 60, 35);
        
    }];
    
}
// 键盘收回
- (void)keyboardWillHide:(NSNotification *)infor
{
    
    double duraction = [[infor.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    // sender按钮高度
    CGFloat senderConsulting_Height = CGRectGetHeight(self.parkingCV.scrollView.frame) - 90;
    
    [UIView animateWithDuration:duraction animations:^{
        
        self.parkingCV.latestTV.frame = self.parkingCV.scrollView.bounds;
        self.parkingCV.senderConsulting.frame = CGRectMake(SCREEN_WIDTH - 70, senderConsulting_Height, 50, 50);
    }];
    
    [self removeDialog];
}

#pragma mark - 移除输入框
- (void)removeDialog
{
    [_senderConsultingView removeFromSuperview];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
