//
//  FriendsTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "FriendsTableViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友";
    self.navigationController.navigationBar.translucent = NO;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.image = [UIImage imageNamed:@"haoyou.jpg"];
//    
//    self.view = imageView;
    
    self.tableView.tableFooterView = [UIImageView new];
    
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
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = @"好友1";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建一个聊天会话 ViewCOntroller 对象
    RCConversationViewController *chat = [[RCConversationViewController alloc] init];
    // 设置会话的类型。<单聊、讨论组、群聊、聊天室、客服、公众号服务会话等>
    chat.conversationType = ConversationType_PRIVATE;
    // 设置会话的目标会话ID。<单聊、客服、公众服务会话为对方的ID、讨论组、群聊、聊天室为会话的ID>
    chat.targetId = @"User1";
    // 设置聊天会话界面要显示的标题
    chat.title = @"与USer2对话中";
    
    // 推出先睡聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

@end
