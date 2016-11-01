//
//  UIImage+resizable.m
//  RingLetter
//
//  Created by LZY on 16/9/23.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "UIImage+resizable.h"

@implementation UIImage (resizable)
+ (UIImage *)resizableWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
  image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.9, image.size.width / 2.0, image.size.height * 0.1, image.size.width / 2.0) resizingMode:UIImageResizingModeStretch];
    return image;
}
@end
