//
//  ReplyListTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/12.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ReplyListTableViewController.h"
#import "ReplyTableViewCell.h"
#import "ReplyListModel.h"
#import "InputBoxView.h"

#define cellStr @"replyCell"
@interface ReplyListTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) InputBoxView *inputBox;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation ReplyListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LSsetTableView];
}

#pragma mark - 设置tableView
- (void)LSsetTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ReplyTableViewCell" bundle:nil] forCellReuseIdentifier:cellStr];
    self.tableView.tableFooterView = [UIImageView new];
    self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, CGRectGetHeight(self.tableView.frame) - 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图将要显示、将要消失
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

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArry != nil) {
        return _dataArry.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    cell.headImage.layer.masksToBounds = YES;
    cell.headImage.layer.cornerRadius = CGRectGetHeight(cell.headImage.frame) * 0.5;
    [cell.reply addTarget:self action:@selector(replyAtion:event:) forControlEvents:UIControlEventTouchUpInside];
    
    ReplyListModel *model = [_dataArry objectAtIndex:indexPath.row];
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.from_user_avar]];
    cell.from_name.text = model.from_user_name;
    cell.from_info.text = model.from_info;
    cell.to_info.text = model.to_info;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.2;
}

#pragma mark - 回复事件
- (void)replyAtion:(UIButton *)sender event:(id)event
{
    _indexPath = [self indexPathForSender:sender event:event];
    
    if (_inputBox != nil) {
        [_inputBox removeFromSuperview];
    }
    
    _inputBox = [[InputBoxView alloc] initWithFrame:CGRectMake(0, 700, 0, 0) string:@"回复答复"];
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
        ReplyListModel *model = [_dataArry objectAtIndex:_indexPath.row];
        [[NetWorkRequestManage sharInstance] replyConsultUser_id:_userInfo.user_id consult_id:model.consult_id info:_inputBox.textField.text];
        
        if (self.block) {
            self.block();
        }
        
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
        
        
        [UIView animateWithDuration:duration animations:^{
            // 列表
            self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, tableViewHeight);
            
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
    
    [UIView animateWithDuration:duraction animations:^{
        
        self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, CGRectGetHeight(self.view.superview.frame) - 50);
    }];
    [_inputBox removeFromSuperview];
}

#pragma mark - textFieldDetegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
