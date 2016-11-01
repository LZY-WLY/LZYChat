//
//  NSString+Alert.h
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Alert)
///提示框
+ (void)alertWithTarget:(UIViewController *)target title:(NSString *)title;
@end
