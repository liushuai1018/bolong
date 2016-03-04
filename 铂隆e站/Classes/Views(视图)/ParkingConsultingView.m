//
//  ParkingConsultingView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/20.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "ParkingConsultingView.h"

@implementation ParkingConsultingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView]; // 创建所有子视图
    }
    return self;
}

#pragma mark - 创建所有子视图
- (void)createAllSubView
{
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[@"最新咨询", @"在线咨询", @"答复"];
    for (int i = 0; i < 3; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
        but.frame = CGRectMake(width / 3.0 * i, 18, width / 3.0, 30);
        [but setTitle:array[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        but.tag = i + 11900;
        [but addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        
    }
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50.0, width, height - 50.0)];
    _scrollView.contentSize = CGSizeMake(3 * SCREEN_WIDTH, CGRectGetHeight(self.frame) - 50);
    _scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.bounces = NO; // 边界反弹
    _scrollView.alwaysBounceHorizontal = NO; // 水平
    _scrollView.alwaysBounceVertical = NO; // 垂直
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    CGFloat scrollHeight = CGRectGetHeight(_scrollView.frame);
    
    // 最新咨询
    self.latestTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, scrollHeight- 45.0f)];
    _latestTV.backgroundColor = [UIColor purpleColor];
    _latestTV.tag = 12500;
    [_scrollView addSubview:_latestTV];
    
    // 回复信息
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_latestTV.frame), CGRectGetWidth(_latestTV.frame), 45.0f)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 991000;
    [_scrollView addSubview:view];
    
    self.ziXunTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 5, CGRectGetWidth(view.frame) - 110, 35)];
    
    _ziXunTF.font = [UIFont systemFontOfSize:14.0f];
    _ziXunTF.layer.borderWidth = 1.0f;
    _ziXunTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ziXunTF.delegate = self;
    _ziXunTF.returnKeyType = UIReturnKeyDone;
    [view addSubview:_ziXunTF];
    
    // 发送消息
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendButton.frame = CGRectMake(CGRectGetMaxX(_ziXunTF.frame), CGRectGetMinY(_ziXunTF.frame),60, 35);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:_sendButton];
    
    // 在线咨询
    self.onlineTV = [[UITableView alloc] initWithFrame:CGRectMake(width, 0, width, scrollHeight)];
    _onlineTV.backgroundColor = [UIColor redColor];
    _onlineTV.tag = 12501;
    [_scrollView addSubview:_onlineTV];
    
    
    // 答复
    self.replyTV = [[UITableView alloc] initWithFrame:CGRectMake(width * 2, 0, width, scrollHeight)];
    _replyTV.backgroundColor = [UIColor orangeColor];
    _replyTV.tag = 12502;
    [_scrollView addSubview:_replyTV];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"你注册了通知");
    
    [self sendZiXun];
    
}

// 监听键盘推出
- (void)keyboardWillShow:(NSNotification *)info
{
    // 获取键盘高度，在不同设备以及中英文不同的
    CGFloat kbHeight = [[info.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 计算键盘顶端到 inputTextView panel 底端的距离(加上自定义的缓冲距离 INTERVAL_KEYBOARO)
    UIView *view = [_scrollView viewWithTag:991000];
    CGFloat offset = self.scrollView.frame.size.height - 45.0 - kbHeight;
    
    // 取得键盘动画时间
    double duration = [[info.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (offset > 45) {
        [UIView animateWithDuration:duration animations:^{
            view.frame = CGRectMake(0, offset, CGRectGetWidth(view.frame), kbHeight + 45.0);
        }];
    }
    
}

// 监听键盘回收
- (void)keyboardWillHide:(NSNotification *)info
{
    UIView *view = [_scrollView viewWithTag:991000];
    double duraction = [[info.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    [UIView animateWithDuration:duraction animations:^{
        view.frame = CGRectMake(0, CGRectGetMaxY(_latestTV.frame), CGRectGetWidth(_latestTV.frame), 45.0f);
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

// 键盘 Retutn
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textfieldResignFirstResponder];
    return YES;
}

// 收回键盘
- (void)textfieldResignFirstResponder
{
    [_ziXunTF resignFirstResponder];
    [self sendZiXun];
}

#pragma mark - 点击最新、在线、答复跳转相对于页面
- (void)clickAction:(UIButton *)sender
{
    [self sendZiXun];
    // 收回键盘
    [self textfieldResignFirstResponder];
    
    NSInteger index = sender.tag - 11900;
    
    switch (index) {
        case 0: {
            [self setDisplayThePage:index];
            break;
        }
        case 1: {
            [self setDisplayThePage:index];
            break;
        }
        case 2: {
            [self setDisplayThePage:index];
            break;
        }
            
        default:
            break;
    }
    
}
- (void)setDisplayThePage:(NSInteger)index
{
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}

#pragma mark - ScrollView 开始滑动视图收回键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self sendZiXun];
    [self textfieldResignFirstResponder];
}

- (void)dealloc
{
    NSLog(@"将要注销通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - 回复事件
- (void)replyActionForName:(NSString *)str
{
    _interpretation = YES;
    _ziXunTF.placeholder = str;
    [_ziXunTF becomeFirstResponder];
}

#pragma mark - 发送咨询
- (void)sendZiXun
{
    _interpretation = NO;
    _ziXunTF.placeholder = @"  我要咨询";
}

@end
