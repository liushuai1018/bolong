//
//  LS_Other_Sign_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/27.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_Sign_ViewController.h"
#import "LS_Other_Sign_day_CollectionViewCell.h"

@interface LS_Other_Sign_ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// 日期
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


// 背景
@property (weak, nonatomic) IBOutlet UIImageView *bg;

// 小猫
@property (weak, nonatomic) IBOutlet UIImageView *xm;

// 当前月有多少天
@property (assign, nonatomic) NSInteger numberDay;

// 当前是哪天
@property (assign, nonatomic) NSInteger day;

// 存储这个月的所有星期五日期
@property (strong, nonatomic) NSMutableSet *daySet;

// 定时器
@property (strong, nonatomic) NSTimer *timer;
// 设置倒计时
@property (assign, nonatomic) NSInteger number;

// 奖励view
@property (strong, nonatomic) UIImageView *imageView;

// 点击签到
@property (weak, nonatomic) IBOutlet UIButton *didSign;

@property (strong, nonatomic) UserInformation *userInfo;

@end

@implementation LS_Other_Sign_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    
    [self initData];
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData
{
    UserInformation *userInfo = [[LocalStoreManage sharInstance] requestUserInfor];
    _userInfo = userInfo;
    __weak LS_Other_Sign_ViewController *weak_control = self;
    [[NetWorkRequestManage sharInstance] other_isSignInUserID:userInfo.user_id returns:^(BOOL is) {
        if (is) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_control didSignInAction];
            });
        }
    }];
    
    // 获取当月天数
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSInteger numberOfDaysInMonth = range.length;
    
    // 获取当前天数
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|kCFCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger day = [components day]; // 获取今天是几号
    NSInteger weekday = [components weekday]; // 今天是星期几 ？1是星期日
    _numberDay = numberOfDaysInMonth;
    _day = day;
    
    NSInteger index = 6 - weekday; // 求和星期五差几天
    NSInteger index1 = day + index;  // 求最近的一个星期五是那一天
    
    BOOL is = 0 < index1 < numberOfDaysInMonth + 1; // 获得的日期是在月份内
    
    if (!is) { //如果不是则 - 7
        index1 = index1 - 7; // 现在获取的日期是 星期五
    }
    
    _daySet = [NSMutableSet set];
    
    for (int i = 0; i < 6; i++) {
        
        NSInteger index2 = index1 + 7 * i;
        if (index2 < numberOfDaysInMonth) {
            [_daySet addObject:[NSString stringWithFormat:@"%d", index2]];
        }
        
        NSInteger index3 = index1 - 7 * i;
        if (index2 > 0) {
            [_daySet addObject:[NSString stringWithFormat:@"%d", index3]];
        }
        
    }
}

#pragma mark - 点击签到
- (IBAction)didSign:(UIButton *)sender {
    // 签到
    [[NetWorkRequestManage sharInstance] other_signinUserID:_userInfo.user_id returns:^(BOOL is) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self siginIS:is];
        });
    }];
}

// 签到结果
- (void)siginIS:(BOOL)is {
    
    if (!is) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"签到失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    } else {
        __weak LS_Other_Sign_ViewController *weak_control = self; // 签到成功后最新剩余铂隆币在本地存储一下
        [[NetWorkRequestManage sharInstance] wallet_obtainMoneyUserID:_userInfo.user_id returns:^(NSString *money) {
            
            LS_Other_Sign_ViewController *strong_control = weak_control;
            if (strong_control) {
                _userInfo.money = money;
                [[LocalStoreManage sharInstance] UserInforStoredLocally:_userInfo];
            }
            
        }];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        
        [self didSignInAction];
        // 计时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countdown:)
                                                userInfo:nil
                                                 repeats:YES];
        _number = 1;
    }
}

#pragma mark - 签到后变成点击都状态
- (void)didSignInAction
{
    // 判断是否星期五
    if ([_daySet containsObject:[NSString stringWithFormat:@"%d", _day]]) {
        
        _imageView.image = [UIImage imageNamed:@"LS_qiandao_x4"];
        _bg.image = [UIImage imageNamed:@"LS_qiandao_bg_after_x4"];
    } else {
        _imageView.image = [UIImage imageNamed:@"LS_qiandao_x1"];
        _bg.image = [UIImage imageNamed:@"LS_qiandao_bg_after"];
    }
    
    if (_imageView) {
        [self.view addSubview:_imageView];
    }
    
    // 小🐱
    _xm.image = [UIImage imageNamed:@"LS_qiandao_mao_pre"];
    
    // 为了防止多次点击获取
    _didSign.userInteractionEnabled = NO;
}

// 监听倒计时
- (void)countdown:(NSTimer *)timer
{
    if (_number > 0) {
        _number--;
    } else {
        [_timer invalidate];
        
        /**
         *  基本概念：
         *  属性变化：可以实现动画效果的属性包括位置(frame,bound)，对齐关系，透明的，背景色，内容拉伸和transform
         *  timing curve：时间曲线，以时间作为横轴，其他值（这里就是指需要变化的属性）作为纵轴。在整个动画持续时间内的函数曲线。
         *  ease in / ease out：慢进/慢出，结合上面的时间曲线的概念，就是在动画的开始/或者结束的时候，属性会减慢。
         *  liner：线性变化，时间变化曲线一共就这两种。默认是 EaseInEaseOut,无疑EaseInEaseOut的效果会更加平滑，但是负荷也大些，不过一般问题不大。
         *  fade in / fade out：淡入/淡出，是一种动画效果
         */
        
        /**
         *  这段代码可以实现淡出切换效果,你所要做的，就是用begin/commit函数圈起一块区域，然后把你想做的变化写进去，无论有多少个，他们都会不被立刻执行，知道commit函数提交。
         */
        
        /**
         * beginAnimations:context: 两个参数都是给delegate用的，一般nil也没问题.
         * animationID是标示当前动画的名称，在一个代理对应多端动画时用于区别.
         * context是void*，回调函数里常用，用于传递额外的数据，保存上下文，避免使用全局变量.
         */
        [UIView beginAnimations:nil context:nil];
        /**
         *  setAnimationCurve: 这个上面说过了，默认就是UIViewAnimationCurveEaseInOut，不写也可以
         *  再补充个常用的函数，setAnimationRepeatCount: 可以重复动画，有些场景下挺好用的。
         */
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        /**
         *  setAnimationDuration:  动画的长度，秒作为单位
         */
        [UIView setAnimationDuration:2.0];
        /**
         *  设置代理
         */
        [UIView setAnimationDelegate:self];
        /**
         *  添加代理事件 可以在动画执行完毕后执行
         */
        [UIView setAnimationDidStopSelector:@selector(animationDisappear)];
        /**
         *  想要实现动画的属性
         */
        _imageView.alpha =0.0;
        /**
         *  开始动画
         */
        [UIView commitAnimations];
        
    }
}

// 动画消失后执行事件
- (void)animationDisappear
{
    [_imageView removeFromSuperview];
}

#pragma mark - init CollectionView
- (void)initCollectionView
{
    
    // 代理
    [_collectionView registerNib:[UINib nibWithNibName:@"LS_Other_Sign_day_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_day - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - initCollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_numberDay) {
        return _numberDay;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LS_Other_Sign_day_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // 日期
    NSString *day = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    cell.image.image = nil;
    cell.title.text = day;
    
    if ((_day - 1) == indexPath.row) { // 表示当前日期
        
        cell.image.image = [UIImage imageNamed:@"LS_qiandao_top_msg"];
    }
    
    if ([_daySet containsObject:day]) { // 显示星期五
        cell.title.text = nil;
        cell.image.image = [UIImage imageNamed:@"LS_qiandao_lihe"];
    }
    
    
    return cell;
}

@end
