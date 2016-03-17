//
//  FriendsTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "FriendsTableViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendsListTableViewCell.h"

@interface FriendsTableViewController ()

@property (nonatomic, strong) NSMutableArray *allFriendsArray; // 全部好友

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友";
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIImageView new];
    
    NSDictionary *dic1 = @{@"name" : @"张三",
                           @"user_id" : @"User1",
                           @"url" : @"http://e.hiphotos.baidu.com/image/h%3D200/sign=a0901680a3c27d1eba263cc42bd4adaf/b21bb051f819861842d54ba04ded2e738bd4e600.jpg"};
    NSDictionary *dic2 = @{@"name" : @"李四",
                           @"user_id" : @"User2",
                           @"url" : @"http://img4.duitang.com/uploads/item/201601/03/20160103175943_SkFQf.png"};
    NSDictionary *dic3 = @{@"name" : @"王五",
                           @"user_id" : @"user3",
                           @"url" : @"http://img4.duitang.com/uploads/item/201501/20/20150120180628_Uy5in.jpeg"};
    
    self.allFriendsArray = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
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
    return _allFriendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = _allFriendsArray[indexPath.row];
    
    cell.name.text = dic[@"name"];
//    cell.headImage.layer.cornerRadius = 10;
    NSString *url = [dic objectForKey:@"url"];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        cell.headImage.image = image;
        
    }];
    
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    cell.textLabel.text = dic[@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建一个聊天会话 ViewController 对象
    RCConversationViewController *chat = [[RCConversationViewController alloc] init];
    // 设置会话的类型。<单聊、讨论组、群聊、聊天室、客服、公众号服务会话等>
    chat.conversationType = ConversationType_PRIVATE;
    // 设置会话的目标会话ID。<单聊、客服、公众服务会话为对方的ID、讨论组、群聊、聊天室为会话的ID>
    
    NSDictionary *dic = _allFriendsArray[indexPath.row];
    
    chat.targetId = dic[@"user_id"];
    // 设置聊天会话界面要显示的标题
    chat.title = [NSString stringWithFormat:@"%@", dic[@"name"]];
    
    // 推出先睡聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.125;
}

@end
