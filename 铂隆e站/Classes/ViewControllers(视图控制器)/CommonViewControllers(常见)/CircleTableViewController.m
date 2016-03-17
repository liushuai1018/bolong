//
//  CircleTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/4.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "CircleTableViewController.h"
#import "CircleListTableViewCell.h"

@interface CircleTableViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CircleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initData];
}

#pragma mark - init
- (void)initSet
{
    self.title = @"发现圈子";
    self.navigationController.navigationBar.translucent = NO;
    
    [self addLeftBut];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [UIImageView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CircleListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - addBar
- (void)addLeftBut
{
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didCilckLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftBut;
}

- (void)didCilckLeftAction:(UIBarButtonItem *)but
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data
- (void)initData
{
    NSDictionary *dic = @{@"name" : @"门头沟  （石门营）",
                          @"headImage" : [UIImage imageNamed:@"shimenying"],
                          @"targetId" : @"circle1"};
    NSDictionary *dic1= @{@"name" : @"门头沟  （冯  村）",
                          @"headImage" : [UIImage imageNamed:@"fengcun"],
                          @"targetId" : @"circle2"};
    
    self.dataArray = [NSMutableArray arrayWithObjects:dic, dic1, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.circleName.text = [dic objectForKey:@"name"];
    cell.headImage.image = [dic objectForKey:@"headImage"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArray[indexPath.row];
    
    // 创建一个聊天会话view Controller对象
    RCConversationViewController *chat = [[RCConversationViewController alloc] init];
    
    // 设置会话的类型为聊天室
    chat.conversationType = ConversationType_CHATROOM;
    
    // 设置目标会话ID
    chat.targetId = [dic objectForKey:@"targetId"];
    
    // 设置加入聊天室时候需要获取的历史聊天数量
    chat.defaultHistoryMessageCountOfChatRoom = 20;
    
    // 显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
    
    
}
@end
