//
//  ChatRightCell.m
//  RingLetter
//
//  Created by LZY on 16/9/22.
//  Copyright © 2016年 LZY. All rights reserved.
//

#import "ChatRightCell.h"
#import "Header.h"

@interface ChatRightCell ()
{
    //头像
    UIImageView *personImage;
    //内容
    UIButton *contionBtn;
}
@end
@implementation ChatRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化子控件
        [self createSubView];

    }
    return self;
}
- (void)setMessage:(EMMessage *)message {
    EMMessageBody *msgBody = message.body;
    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
    [contionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contionBtn setTitle:textBody.text forState:UIControlStateNormal];
}
//初始化子控件
- (void)createSubView {
    //头像
    UIImage *image = [UIImage imageNamed:@"头像"];
    personImage = [[UIImageView alloc]initWithImage:image];
    [self.contentView addSubview:personImage];
    
    //内容
    contionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contionBtn.userInteractionEnabled = NO;
    contionBtn.titleEdgeInsets = UIEdgeInsetsMake(kMarrage / 2.0, kMarrage / 2.0, kMarrage / 2.0, kMarrage);
    //背景
    [contionBtn setBackgroundImage:[UIImage resizableWithName:@"chat_sender_bg"] forState:UIControlStateNormal];
    contionBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    contionBtn.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:contionBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
     UIImage *image = [UIImage imageNamed:@"头像"];
    contionBtn.frame = CGRectMake(kWidht / 2.0, 0, kWidht / 2.0 - image.size.width - kMarrage, self.frame.size.height);
    
   
    personImage.frame = CGRectMake(CGRectGetMaxX(contionBtn.frame), 0, image.size.width, image.size.height);
    
}
@end
