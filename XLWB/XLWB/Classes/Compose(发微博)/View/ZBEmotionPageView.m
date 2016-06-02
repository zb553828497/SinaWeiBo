
//
//  ZBEmotionPageView.m
//  XLWB
//
//  Created by zhangbin on 16/6/2.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionPageView.h"
#import "ZBEmotion.h"
#import "NSString+Emoji.h"
@implementation ZBEmotionPageView
// 将当前页的20个表情或不足20个表情放到UIButton中
-(void)setEmotions:(NSArray *)emotions{// emotions存储着20个表情或不足20个表情
    _emotions = emotions;
    // 当前页的表情个数
    NSUInteger count = emotions.count;
    for (int i = 0; i< count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        // 将emotions数组中的每一个表情赋值给模型emotion
        btn.backgroundColor = ZBRandomColor;

        ZBEmotion *emotion = emotions[i];
        if(emotion.png){// 为png图片
            [btn setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
            NSLog(@"%@",emotion.png);
        }else if (emotion.code){// 为Emoji图片
            // 设置emoji    emotion模型存储着20个表情或不足20个表情，因为这20个表情分别都有chs，chs，code三个属性，我们要显示表情,必须访问对应属性的getter方法来显示对应属性的内容
            [btn setTitle:emotion.code.emoji forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:32];
        }
         // 将按钮中存储的表情添加到当前类中
        [self addSubview:btn];
    }
}
// 计算当前页表情的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    // 内边距(四周)
    CGFloat inset = 20;
    // 用count保存emotions数组中的20个表情或不足20个表情
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.zb_width - 2 * inset) / ZBEmotionEveryPageMaxColums ;
    CGFloat btnH = (self.zb_height - inset ) / ZBEmotionEveryPageMaxRows;
    // count就是20个表情或不足20个表情
    for (int i = 0; i < count;i++) {
        // 取出当前类中的按钮(按钮中有表情哦)
        UIButton *btn = self.subviews[i];
        btn.zb_width = btnW;
        btn.zb_height = btnH;
        // 如果有20个表情，那么20个表情的排布情况如下
        // 第0行表情从左到右对应的下标: 0-6
        // 第1行表情从左到右对应的下标: 7-13
        // 第2行表情从左到右对应的下标:7-19
        btn.zb_X = inset + (i % ZBEmotionEveryPageMaxColums) * btnW;
        btn.zb_Y = inset + (i / ZBEmotionEveryPageMaxColums) * btnH;
    }
    
}

@end
