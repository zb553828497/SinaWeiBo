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
#import "ZBEmotionAttachment.h"

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
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {// {}中的内容表示保存的代码，这段代码的内容将来要传递给别人
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
        
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

// 将表情图片变为文字，并拼接成一个完整的字符串发给新浪服务器，因为新浪服务器的数据库里面不能存储图片，你只有给新浪的数据库里面存字符串，新浪服务器才会解析图片出来，并且如果新浪如果发现你是在网页上浏览这个字符串，就会自动解析成动态的图片，如果发现是你是在客户端上，就会自动解析成静态的图片
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        ZBEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}
@end
