//
//  YourTestChatViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "YourTestChatViewController.h"
#import "KxMenu.h"
#import "FriendsTableViewController.h"
#import "AddFriendsTableViewController.h"


@interface YourTestChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *affiliatedTableView; // 附属菜单

@end

@implementation YourTestChatViewController

- (void)viewDidLoad {
    // 重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self addLeftBut];
    
    [self setSessionList];
    
    [self setSessionListAccording];
    
}

#pragma mark - 返回上一界面和好友
- (void)addLeftBut
{
    
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didCilckLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftBut;
    
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightAction:event:)];
    self.navigationItem.rightBarButtonItem = rightBut;
}

// 左边
- (void)didCilckLeftAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 右边
- (void)clickRightAction:(UIBarButtonItem *)sender event:(UIEvent *)senderEven
{
    
    NSArray *menuItems = @[[KxMenuItem menuItem:@"添加好友"
                                          image:[UIImage new]
                                         target:self
                                         action:@selector(pushAddFriends:)],
                           [KxMenuItem menuItem:@"好友列表"
                                          image:[UIImage new]
                                         target:self
                                         action:@selector(pushFriendsList:)]];
    
    UIView *senderView = [[senderEven.allTouches anyObject] view];
    
    CGRect rect = senderView.frame;
    rect.origin.y = rect.origin.y + 15;
    
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];
    
}

// 推出好友列表
- (void)pushFriendsList:(id)sender
{
    FriendsTableViewController *friendsTVC = [[FriendsTableViewController alloc] init];
    [self.navigationController pushViewController:friendsTVC animated:YES];
}

// 添加好友
- (void)pushAddFriends:(id)sender
{
    AddFriendsTableViewController *addFriends = [[AddFriendsTableViewController alloc] init];
    [self.navigationController pushViewController:addFriends animated:YES];
}

#pragma mark - 设置会话列表
- (void)setSessionList
{
    [self.conversationListTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.conversationListTableView setTableFooterView:[UIView new]];
}

#pragma mark - 设置会话列表显示的东西
- (void)setSessionListAccording
{
    
    // 设置需要显示那些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    // 设置需要将那些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
}

#pragma mark - 点击会话列表，进入聊天会话界面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = [NSString stringWithFormat:@"与%@对话中...", model.targetId];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
