//
//  NSString+Alert.m
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "NSString+Alert.h"

@implementation NSString (Alert)
+ (void)alertWithTarget:(UIViewController *)target title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:OK];
    [target presentViewController:alert animated:YES completion:nil];
}
@end
