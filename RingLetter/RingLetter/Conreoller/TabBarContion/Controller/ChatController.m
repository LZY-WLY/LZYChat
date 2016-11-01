//
//  ChatController.m
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "ChatController.h"
#import "ChatLeftCell.h"
#import "ChatRightCell.h"
#define kUserTimestamp @"timestamp"

@interface ChatController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, EMChatManagerDelegate>
{
    //tableView
    UITableView *tableList;
    //UITextField
    UITextField *contionField;
    //数据源
    NSMutableArray *dataSoucre;
    //自己发送内容的数据源
    EMConversation *conversation;
}
@end

@implementation ChatController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    //title
    self.title = self.userName;
    //添加tableView
    [self createTableView];
    //输入框
    [self creaTextView];
    
    //注册聊天消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    //获取会话列表
    conversation = [[EMClient sharedClient].chatManager getConversation:self.userName type:EMConversationTypeChat createIfNotExist:YES];
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [conversation loadMessagesWithType:EMMessageBodyTypeText timestamp:[[userdef objectForKey:kUserTimestamp] longLongValue] count:12 fromUser:nil searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        dataSoucre = [NSMutableArray arrayWithArray:aMessages];
        [tableList reloadData];
        if (dataSoucre.count) {
            [tableList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataSoucre.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    }];


}

#pragma mark 收到消息的回调
- (void)didReceiveMessages:(NSArray *)aMessages
{
    //存储沙盒
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:@(conversation.lastReceivedMessage.timestamp + 10000) forKey:kUserTimestamp];
    
    //插入数组
    [dataSoucre addObject:conversation.lastReceivedMessage];
    //插入tableList
    [tableList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dataSoucre.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    //滑到最后一行
    if (dataSoucre.count) {
        [tableList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataSoucre.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
 }

#pragma mark 通知(键盘位置改变)
- (void)keyboard:(NSNotification *)info {
    CGFloat keyboardY = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGRect frame = contionField.frame;
    frame.origin.y = keyboardY - 49;
    CGFloat tableListSeclH = - 74 - 49 + keyboardY;
    [UIView animateWithDuration:[info.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue] animations:^{
        contionField.frame = frame;
        tableList.frame = CGRectMake(tableList.frame.origin.x, tableList.frame.origin.y, tableList.frame.size.width, tableListSeclH);
        //滑到最后一行
        if (dataSoucre.count) {
            [tableList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataSoucre.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    
}
//添加tableView
- (void)createTableView {
    tableList = [[UITableView alloc]initWithFrame:CGRectMake(0, 74, kWidht, kHeight - 74 - 49) style:UITableViewStylePlain];
    tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableList.delegate = self;
    tableList.dataSource = self;
    [tableList registerClass:[ChatLeftCell class] forCellReuseIdentifier:@"cellLeft"];
    [tableList registerClass:[ChatRightCell class] forCellReuseIdentifier:@"cellRight"];
    [self.view addSubview:tableList];
}
//输入框
- (void)creaTextView {
    contionField = [[UITextField alloc]initWithFrame:CGRectMake(0, kHeight - 49, kWidht, 49)];
    contionField.backgroundColor = kColor(211, 211, 211);
    contionField.borderStyle = UITextBorderStyleRoundedRect;
    contionField.returnKeyType = UIReturnKeySend;
    contionField.enablesReturnKeyAutomatically = YES;
    contionField.delegate = self;
    contionField.placeholder = @"输入内容";
    [self.view addSubview:contionField];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSoucre.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMessage *mssage = dataSoucre[indexPath.row];
    EMTextMessageBody *textBody = (EMTextMessageBody *)mssage.body;
    CGFloat cellHight = [textBody.text boundingRectWithSize:CGSizeMake(kWidht / 2.0 - 45 - kMarrage, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
    return cellHight + 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMessage *message = dataSoucre[indexPath.row];
    if ([message.from isEqualToString:self.userName]) {//对方的消息
        ChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellLeft" forIndexPath:indexPath];
        cell.message = message;
        return cell;
    }else {//自己的消息
        ChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellRight" forIndexPath:indexPath];
        cell.message = message;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textField.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.userName from:from to:self.userName body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    //发送消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        //存储沙盒
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        [userdef setObject:@(message.timestamp + 10000) forKey:kUserTimestamp];
        
        //插入数组
        [dataSoucre addObject:message];
        //插入tableList
        [tableList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dataSoucre.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        //滑到最后一行
        if (dataSoucre.count) {
            [tableList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataSoucre.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        textField.text = @"";
    }];
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)dealloc {
    //移除监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除聊天消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
@end
