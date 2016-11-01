//
//  ChatLeftCell.m
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "ChatLeftCell.h"
#import "Header.h"

@interface ChatLeftCell ()
{
    //头像
    UIImageView *personImage;
    UIImage *image;
    //内容
    UIButton *contionBtn;
}
@end

@implementation ChatLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化子控件
        [self createSubView];
    }
    return self;
}
//初始化子控件
- (void)createSubView {
    //头像
    image = [UIImage imageNamed:@"头像"];
    personImage = [[UIImageView alloc]initWithImage:image];
    personImage.frame = CGRectMake(kMarrage, 0, image.size.width, image.size.height);
    [self.contentView addSubview:personImage];
    
    //内容
    contionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contionBtn.userInteractionEnabled = NO;
    contionBtn.titleEdgeInsets = UIEdgeInsetsMake(kMarrage / 2.0, kMarrage, kMarrage / 2.0, kMarrage / 2.0);
    //背景
    [contionBtn setBackgroundImage:[UIImage resizableWithName:@"chat_receiver_bg"] forState:UIControlStateNormal];
    contionBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    contionBtn.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:contionBtn];
}

- (void)setMessage:(EMMessage *)message {
    EMMessageBody *msgBody = message.body;
    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
    [contionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contionBtn setTitle:textBody.text forState:UIControlStateNormal];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //frame
    CGFloat contionLableX = CGRectGetMaxX(personImage.frame) + kMarrage / 2;
    CGFloat contionLableY = 0;
    CGFloat contionLableW = kWidht / 2.0 - contionLableX;
    CGFloat contionLableH = self.frame.size.height;
    contionBtn.frame = CGRectMake(contionLableX, contionLableY, contionLableW, contionLableH);

}
@end
