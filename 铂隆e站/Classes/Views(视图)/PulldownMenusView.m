//
//  PulldownMenusView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/11.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "PulldownMenusView.h"

@implementation PulldownMenusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height<100) {
        frameHeight = 150;
    }else{
        frameHeight = frame.size.height;
    }
    tabHeight = frameHeight - frame.size.height;
    
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubView]; // 创建所有子视图
    }
    return self;
}

// 创建所有子视图
- (void)createAllSubView
{
    showList = NO; // 默认不显示下拉菜单
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
    [self addSubview:_textField];
    
}

- (void)createTableView
{
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    _tv.delegate = self;
    _tv.dataSource = self;
    _tv.backgroundColor = [UIColor grayColor];
    _tv.separatorColor = [UIColor lightGrayColor];
    _tv.hidden = YES; // 隐藏
    [self addSubview:_tv];
}

// 取消显示键盘显示
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)dropdown
{
    if (showList) {
        return;
    } else {
        
        [self createTableView];
        
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        // 把菜单放在最前面
        [self.superview bringSubviewToFront:self];
        _tv.hidden = NO;
        showList = YES; // 显示下拉菜单
        
        CGRect frame = _tv.frame;
        frame.origin.y = CGRectGetHeight(_textField.frame);
        frame.size.height = 0;
        _tv.frame = frame;
        frame.size.height = tabHeight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        _tv.frame = frame;
        [UIView commitAnimations];
        
        // 判断block 是否实现
        if (self.aBlock) {
            
            self.aBlock();
        }
        
    }
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [_tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

// 点击 cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textField.text = [_tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    _tv.hidden = YES;
    
    
    CGRect sf = self.frame;
    sf.size.height = CGRectGetHeight(_textField.frame);
    self.frame = sf;
    
     
    CGRect frame = _tv.frame;
    frame.size.height = 0;
    _tv.frame = frame;
}

/**
 *  点击其他收回菜单
 */
- (void)clickOnTheOther
{
    showList = NO;
    _tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = CGRectGetHeight(_textField.frame);
    self.frame = sf;
    
    CGRect frame = _tv.frame;
    frame.size.height = 0;
    _tv.frame = frame;
}

@end
