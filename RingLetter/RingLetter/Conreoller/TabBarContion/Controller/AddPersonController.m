//
//  AddPersonController.m
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "AddPersonController.h"
#import "Header.h"
@interface AddPersonController ()<UITextFieldDelegate>
{
    UITextField *textFieldSearch;
}
@end

@implementation AddPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加联系人";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemSearch)];
    [self addTextField];
}
- (void)rightItemSearch {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"附加信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *OK =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager addContact:textFieldSearch.text message:alert.textFields.firstObject.text];
        if (!error) {
            [NSString alertWithTarget:self title:@"申请发送成功"];
        }
    }];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
    [self.view endEditing:YES];
}
- (void)addTextField {
    textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(kMarrage, 80, kWidht - kMarrage, kTextFieldH)];
    textFieldSearch.delegate = self;
    textFieldSearch.placeholder = @"输入账号";
    textFieldSearch.returnKeyType = UIReturnKeySearch;
    textFieldSearch.enablesReturnKeyAutomatically = YES;
    [self.view addSubview:textFieldSearch];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"附加信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *OK =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager addContact:textFieldSearch.text message:alert.textFields.firstObject.text];
        if (!error) {
            [NSString alertWithTarget:self title:@"申请发送成功"];
        }
    }];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
    return [textField resignFirstResponder];
}

@end
