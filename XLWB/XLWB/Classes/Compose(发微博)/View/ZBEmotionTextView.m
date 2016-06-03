//
//  ZBEmotionTextView.m
//  XLWB
//
//  Created by zhangbin on 16/6/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionTextView.h"
#import "ZBEmotion.h"
#import "NSString+Emoji.h"
#import "UITextView+Extension.h"

@implementation ZBEmotionTextView

-(void)insertEmotion:(ZBEmotion *)emotion{
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];;
    }else if (emotion.png){
        NSTextAttachment *attch = [[NSTextAttachment alloc]init];
        // 加载当前点击的表情
        attch.image = [UIImage imageNamed:emotion.png];
        // 设置当前表情的lineHeight
        CGFloat attchWH = self.font.lineHeight;
        // 当前表情的位置和尺寸
        attch.bounds = CGRectMake(0,-4,attchWH,attchWH);
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        // 插入属性文字到光标位置(就是把当前点击的表情插入到光标的后面，光标在哪里，表情就会插入到哪里)
        [self insertAttributeText:imageStr];
        
        NSMutableAttributedString *text = (NSMutableAttributedString *)self.attributedText;
        // 设置字体
        [text addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
        
        /**
         selectedRange :
         1.本来是用来控制textView的文字选中范围
         2.如果selectedRange.length为0，那么selectedRange.location就表示光标位置
         
         关于textView文字的字体
         1.如果是普通文字（text），文字大小由textView.font控制
         2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
         **/
    }
}

@end
