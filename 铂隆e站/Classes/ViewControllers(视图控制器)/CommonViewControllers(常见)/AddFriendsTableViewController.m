//
//  AddFriendsTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/22.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "AddFriendsTableViewController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBook.h"

@interface AddFriendsTableViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *addressBookArr;  // 存储所有联系人数组

@property (nonatomic, strong) NSMutableArray *searchResult;    // 搜索的数据

@end

@implementation AddFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self acquisitionRessBook];
    
    [self accessToTheAddressBook];
    
    [self setTheTabelView];
    
    // 初始化 data
    _searchResult = [[NSMutableArray alloc] init];
    
}

#pragma mark - 申请访问通讯录权限
- (void)acquisitionRessBook
{
    // 记录访问通讯录授权是否成功
    int __block tip = 0;
    
    // 声明一个通讯录的引用
    ABAddressBookRef addBook = nil;
    
    // 因为在iOS 6.0 之前和之后的申请方式有所差别，这里做一个判断
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        // 创建通讯录的引用
        addBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        // 创建一个初始信号为0的信号
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool granted, CFErrorRef error) {
            
            // granted为YES是表示用户允许，否则为不允许
            if (!granted) {
                tip = 1;
            }
            
            // 发送一次信号
            dispatch_semaphore_signal(sema);
            
        });
        
        // 等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        
        // iOS 6.0之前
        addBook = ABAddressBookCreate();
        
    }
    
    if (tip) {
        // 做一个提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (addBook != nil) {
        
        // 释放引用
        CFRelease(addBook);
    }
}

#pragma mark - 获取通讯录联系人
- (void)accessToTheAddressBook
{
    self.addressBookArr = [[NSMutableArray alloc] init];
    
    // 创建通讯录的引用
    ABAddressBookRef addBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    
    // 获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    
    // 进行遍历
    for (NSInteger i = 0; i < number; i++) {
        
        // 创建联系人对象
        AddressBook *addressBook = [[AddressBook alloc] init];
        
        // 获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
        
        // 获取当前联系人名字
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        // 获取当前联系人姓氏
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        
        addressBook.name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
        
        // 获取当前联系人姓氏拼音
        NSString *lastNamePhoneic = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNamePhoneticProperty));
        
        addressBook.lastName = lastNamePhoneic;
        
        // 获取当前联系人的电话 (数组)
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        // 遍历转存 phoneArray
        for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
            
            NSString *str = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            
            if (![str isEqualToString:@""]) {
                
                [phoneArray addObject:str];
            }
            
        }
        
        addressBook.phoneNumber = [phoneArray firstObject];
        
        // 获取当前联系人头像图片
        NSData *userImage = (__bridge NSData *)(ABPersonCopyImageData(people));
        
        addressBook.headImage = [UIImage imageWithData:userImage];
        
        [_addressBookArr addObject:addressBook];
    }
    
    if (addBook != nil) {
        
        // 释放引用
        CFRelease(addBook);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置tableView
- (void)setTheTabelView
{
    
    
    self.tableView.tableHeaderView = [self createrSearchBar];
    
    self.tableView.tableFooterView = [UIImageView new];
}

// 创建区头搜索
- (UIView *)createrSearchBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1)];
    view.backgroundColor = [UIColor whiteColor];
    
    // 创建搜索框
    /*
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:view.frame];
    searchBar.backgroundColor = [UIColor lightGrayColor];
    searchBar.backgroundImage = [UIImage new];
    searchBar.delegate = self;
    [view addSubview:searchBar];
    */
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    [searchController.searchBar sizeToFit];
    [view addSubview:searchController.searchBar];
    /*
    CGFloat height = SCREEN_HEIGHT * 0.06;
    
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT * 0.02, SCREEN_WIDTH - 40 - height, height)];
    text.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:text];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(text.frame), CGRectGetMinY(text.frame), height, height);
    [button setBackgroundImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame) - 1, CGRectGetWidth(view.frame), 0.5)];
    divider.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:divider];
    */
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _addressBookArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellString = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];
    }
    
    
        
        AddressBook *addressBook = [self.addressBookArr objectAtIndex:indexPath.row];
        
        if (!addressBook.headImage) {
            cell.imageView.image = [UIImage imageNamed:@"touxiang.jpg"];
        } else {
            
            cell.imageView.image = addressBook.headImage;
        }
        
        cell.textLabel.text = addressBook.name;
        cell.detailTextLabel.text = addressBook.phoneNumber;
        
        NSLog(@"name : %@ \n phoneNumber : %@", addressBook.name, addressBook.phoneNumber);
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.12;
}

#pragma mark - searchDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"我也不知道这是在干嘛");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_searchResult addObjectsFromArray:@[@"1",@"12",@"123"]];
        [self.searchDisplayController.searchResultsTableView reloadData];
    });
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSLog(@"这个方法真晕了");
}

@end
