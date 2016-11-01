//
//  PersonController.m
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "PersonController.h"
#import "AddPersonController.h"
#import "ChatController.h"
#import "Header.h"

@interface PersonController ()<EMContactManagerDelegate>
{
    //好友列表
    NSMutableArray *dataSoucrePersons;
}
@end

@implementation PersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItem)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back_os7"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItem)];
    
    //监听加好友请求(注册好友回调)
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //获取好友列表
    [self getAllPersons];
    
    
}
//获取好友列表
- (void)getAllPersons {
    EMError *error = nil;
    dataSoucrePersons = [[[EMClient sharedClient].contactManager getContactsFromServerWithError:&error] mutableCopy];
    [self.tableView reloadData];
}

//监听回调

/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK =  [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            [NSString alertWithTarget:self title:@"同意了添加请求"];
        }
    }];
    UIAlertAction *cancle =  [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error) {
            [NSString alertWithTarget:self title:@"拒绝了添加请求"];
        }
    }];
    [alert addAction:OK];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}
//好友申请处理结果回调
/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername {
    [NSString alertWithTarget:self title:@"对方已同意添加请求"];
    //获取好友列表
    [self getAllPersons];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername {
    [NSString alertWithTarget:self title:@"对方已拒绝添加请求"];
}
//左边的item
- (void)leftItem {
    [[EMClient sharedClient] logout:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//右边的item
- (void)rightItem {
    [self.navigationController pushViewController:[[AddPersonController alloc]init] animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSoucrePersons.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"头像"];
    cell.textLabel.text = dataSoucrePersons[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatController *chat = [[ChatController alloc]init];
    chat.userName = dataSoucrePersons[indexPath.row];
    [self.navigationController pushViewController:chat animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除好友
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:dataSoucrePersons[indexPath.row]];
        if (!error) {
            [NSString alertWithTarget:self title:[NSString stringWithFormat:@"%@删除成功",dataSoucrePersons[indexPath.row]]];
        }
        //删除数据源
        [dataSoucrePersons removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}
- (void)dealloc {
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
}
@end
