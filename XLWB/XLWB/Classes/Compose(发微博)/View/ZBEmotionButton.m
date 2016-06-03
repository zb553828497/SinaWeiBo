//
//  ZBEmotionButton.m
//  XLWB
//
//  Created by zhangbin on 16/6/2.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionButton.h"
#import "ZBEmotion.h"
#import "NSString+Emoji.h"

@implementation ZBEmotionButton

/**
 *  当控件不是从xib、storyboard中创建时，就会调用这个方法
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return  self;
}

-(void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    // 按钮高亮的时候。不会调整图片为灰色
    self.adjustsImageWhenHighlighted = NO;
    
    
}

-(void)setEmotion:(ZBEmotion *)emotion{
    _emotion = emotion;
    
    if(emotion.png){// 为png图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        NSLog(@"%@",emotion.png);
    }else if (emotion.code){// 为Emoji图片
        // 设置emoji    emotion模型存储着20个表情或不足20个表情，因为这20个表情分别都有chs，chs，code三个属性，我们要显示表情,必须访问对应属性的getter方法来显示对应属性的内容
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    }
}

@end
