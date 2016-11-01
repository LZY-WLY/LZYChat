//
//  RegisterController.m
//  RingLetter
//
//  Created by LZY on 16/9/21.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "RegisterController.h"
#import "Header.h"
#import "PersonController.h"



@interface RegisterController ()
{
    UIView *textFieldView;
}
///placeholder
@property (nonatomic, strong) NSArray *placeholderArrays;
@end

@implementation RegisterController
- (NSArray *)placeholderArrays {
    if (!_placeholderArrays) {
        self.placeholderArrays = @[@"手机号/邮箱/用户名", @"密码"];
    }
    return _placeholderArrays;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ///账号密码
    [self account];
    ///登录注册
    [self password];
    
}
///账号密码
- (void)account {
    
    textFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kWidht, 2 * kTextFieldH + 1)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textFieldView];
    
    for (int i = 0; i < 2; i++) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(kMarrage, i * (kTextFieldH + 1), kWidht - kMarrage, kTextFieldH)];
        if (i == 0) {
            //分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kMarrage, CGRectGetMaxY(textField.frame), kWidht - kMarrage, 1)];
            line.backgroundColor = kColor(244, 244, 244);
            [textFieldView addSubview:line];
        }
        textField.placeholder = self.placeholderArrays[i];
        
        [textFieldView addSubview:textField];
    }

}
///登录注册
- (void)password {
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    loginBtn.frame = CGRectMake(kMarrage, CGRectGetMaxY(textFieldView.frame) + kMarrage, kWidht - 2 * kMarrage, kTextFieldH);
    [loginBtn setBackgroundColor:kColor(70, 124, 197)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //忘记密码
    UIButton *forgetPassword = [UIButton buttonWithType:UIButtonTypeSystem];
    
    forgetPassword.frame = CGRectMake(kWidht - kMarrage - 2 * kTextFieldH, CGRectGetMaxY(loginBtn.frame) + kMarrage / 2, 2 * kTextFieldH, kTextFieldH);
    
    [forgetPassword setTitle:@"注册" forState:UIControlStateNormal];
    [forgetPassword addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPassword];
    
    
}
//注册
- (void)forgetPassword {
    //第一个
    UITextField *firstField = textFieldView.subviews[1];
    //第二个
    UITextField *secondField = textFieldView.subviews.lastObject;
    EMError *error = [[EMClient sharedClient] registerWithUsername:firstField.text password:secondField.text];
    if (error==nil) {
        [NSString alertWithTarget:self title:@"注册成功"];
    }
}
//登录
- (void)login {
    [self.view endEditing:YES];
    //第一个
    UITextField *firstField = textFieldView.subviews[1];
    //第二个
    UITextField *secondField = textFieldView.subviews.lastObject;
    EMError *error = [[EMClient sharedClient] loginWithUsername:firstField.text password:secondField.text];
    
    if (!error) {
        [self.navigationController pushViewController:[[PersonController alloc]init] animated:YES];
    }
}

@end
