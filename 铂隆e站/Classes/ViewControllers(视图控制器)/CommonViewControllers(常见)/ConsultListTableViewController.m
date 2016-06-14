//
//  ConsultListTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ConsultListTableViewController.h"
#import "LatestTableViewCell.h"
#import "ConsultListModel.h"
#import "InputBoxView.h"

#define cellStr @"consultCell"
@interface ConsultListTableViewController () <UITextFieldDelegate>

// 最新咨询
@property (strong, nonatomic) UIButton *sendBut;

// 输入框
@property (strong, nonatomic) InputBoxView *inputBox;

// 记录回复那个咨询
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation ConsultListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LSsetTableView];
    
}

#pragma mark - 设置tableView
- (void)LSsetTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"LatestTableViewCell" bundle:nil] forCellReuseIdentifier:cellStr];
    self.tableView.tableFooterView = [UIImageView new];
    self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, CGRectGetHeight(self.tableView.frame) - 30);
}

#pragma mark - accessory
- (void)addAccessory
{
    self.sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBut.frame = CGRectMake(SCREEN_WIDTH - 70, CGRectGetHeight(self.view.frame) - 90, 50, 50);
    [self.sendBut setImage:[UIImage imageNamed:@"LS_sender"] forState:UIControlStateNormal];
    [self.sendBut addTarget:self action:@selector(senderConsultingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.superview addSubview:_sendBut];
    [self.view.superview bringSubviewToFront:_sendBut];
}

#pragma mark - 视图将要显示，视图将要消失
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_sendBut == nil) {
        
        [self addAccessory];
    } else {
        
        [_sendBut setHidden:NO];
    }
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_sendBut) {
        
        [_sendBut setHidden:YES];
    }
    
    // remove通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray != nil) {
        return _dataArray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    cell.iocImageView.layer.masksToBounds = YES;
    cell.iocImageView.layer.cornerRadius = CGRectGetHeight(cell.iocImageView.frame) * 0.5;
    [cell.zanButton addTarget:self action:@selector(zanAction:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.huiFuBUtton addTarget:self action:@selector(replyClickAction:event:) forControlEvents:UIControlEventTouchUpInside];
    // 界面信息
    ConsultListModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [cell.iocImageView sd_setImageWithURL:[NSURL URLWithString:model.user_avar]];
    cell.contentTextView.text = model.info;
    cell.nameLabel.text = model.user_name;
    cell.wellLabel.text = model.zan_count;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.2;
}

#pragma mark - 回复按钮事件
- (void)replyClickAction:(UIButton *)sender event:(id)event
{
    _indexPath = [self indexPathForSender:sender event:event];
    
    if (_inputBox != nil) {
        [self removeInputboxView];
    }
    _inputBox = [[InputBoxView alloc] initWithFrame:CGRectMake(0, 700, 0, 0) string:@" 回复咨询"];
    [_inputBox.sendBut addTarget:self action:@selector(replyButAtion:) forControlEvents:UIControlEventTouchUpInside];
    _inputBox.textField.delegate = self;
    [self.view.superview addSubview:_inputBox];
    // 设置为第一响应者
    [_inputBox.textField becomeFirstResponder];
    
}

#pragma mark - 发送回复信息
- (void)replyButAtion:(UIButton *)sender
{
    
    [_inputBox.textField resignFirstResponder];
    
    if (![_inputBox.textField.text isEqualToString:@""]) {
        ConsultListModel *model = [_dataArray objectAtIndex:_indexPath.row];
        [[NetWorkRequestManage sharInstance] replyConsultUser_id:_userInfo.user_id consult_id:model.consult_id info:_inputBox.textField.text];
        
    }
    
}

#pragma mark - 点赞绑定事件
- (void)zanAction:(UIButton *)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event];
    
    ConsultListModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [[NetWorkRequestManage sharInstance] consultZanUser_id:self.userInfo.user_id consult_id:model.consult_id];
    if (self.block) {
        self.block();
    }
}

// 获取点击 Cell 位置
- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton *)sender; // 当前点击的按钮
    UITouch *touch = [[event allTouches] anyObject]; // 获取按钮event 里包含的 touch 动作
    
    if (![button pointInside:[touch locationInView:button] withEvent:event]) {
        return nil;
    }
    
    CGPoint touchPosition = [touch locationInView:self.tableView];
    
    return [self.tableView indexPathForRowAtPoint:touchPosition];
}

#pragma mark - 发送新的咨询按钮_监听事件
- (void)senderConsultingAction:(UIButton *)sender
{
    if (_inputBox != nil) {
        [self removeInputboxView];
    }
    _inputBox = [[InputBoxView alloc] initWithFrame:CGRectMake(0, 700, 0, 0) string:@" 发送新资讯"];
    [_inputBox.sendBut addTarget:self action:@selector(senderButAtion:) forControlEvents:UIControlEventTouchUpInside];
    _inputBox.textField.delegate = self;
    [self.view.superview addSubview:_inputBox];
    // 设置为第一响应者
    [_inputBox.textField becomeFirstResponder];
}

#pragma mark - 发送咨询按钮
- (void)senderButAtion:(UIButton *)sneder
{
    [_inputBox.textField resignFirstResponder];
    
    if (![_inputBox.textField.text isEqualToString:@""]) {
        
        [[NetWorkRequestManage sharInstance] senderConsultUser_id:_userInfo.user_id info:_inputBox.textField.text];
        
        if (self.block) {
            self.block();
        }
    }
    
}

#pragma mark - 监听键盘
- (void)keyboardWillShow:(NSNotification *)info
{
    
    // 键盘高度
    CGFloat kbHeight = [[info.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 动画时间
    double duration = [[info.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 上移高度
    CGFloat offset = kbHeight + 45.0;
    
    // 列表高度
    CGFloat tableViewHeight = CGRectGetHeight(self.view.superview.frame) - 50 - offset;
    
    // 判断键盘是否以及弹出
    if (CGRectGetHeight(self.tableView.frame) != tableViewHeight) {
        
        // sender按钮 Y
        CGFloat sendBut_Y = CGRectGetMinY(_sendBut.frame) - offset;
        
        
        [UIView animateWithDuration:duration animations:^{
            // 列表
            self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, tableViewHeight);
            
            // sender按钮
            _sendBut.frame = CGRectMake(CGRectGetMinX(self.sendBut.frame), sendBut_Y, 50, 50);
            
            // 输入框
            _inputBox.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_WIDTH, offset);
            
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            
            // 输入框
            _inputBox.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_WIDTH, offset);
            
        }];
    }
    
    
}
// 键盘收回
- (void)keyboardWillHide:(NSNotification *)infor
{
    
    double duraction = [[infor.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    // sender按钮高度
    CGFloat accessory_Y = CGRectGetHeight(self.view.superview.frame) - 70;
    
    [UIView animateWithDuration:duraction animations:^{
        
        self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, CGRectGetHeight(self.view.superview.frame) - 50);
        self.sendBut.frame = CGRectMake(CGRectGetMinX(_sendBut.frame), accessory_Y, 50, 50);
    }];
    [self removeInputboxView];
}

#pragma mark - 移除输入框
- (void)removeInputboxView
{
    [_inputBox setHidden:YES];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
