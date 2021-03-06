//
//  UITextView+Extension.m
//  XLWB
//
//  Created by zhangbin on 16/6/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
-(void)insertAttributeText:(NSAttributedString *)text{
    [self insertAttributedText:text settingBlock:nil];
 }
// ZBEmotionTextView类的block中保存的代码块被存在了这个方法的settingBlock中
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    // 拼接之前的文字（图片和普通文字），放到attributedText中.如果不拼接，之前的文字/表情会被现在的表情覆盖掉
    [attributedText appendAttributedString:self.attributedText];
    // 拼接图片
    // 用loc存储当前光标的位置
    NSUInteger loc = self.selectedRange.location;
    // 将text中的表情(就是带有图片的字符串)插入到attributedText内容的loc的位置
//    [attributedText insertAttributedString:text atIndex:loc];
    [attributedText appendAttributedString:self.attributedText];
    // 调用外面传进来的代码
    if (settingBlock) {
        /* settingBlock(attributedText);这句代码就是ZBEmotionTextView类中保存的
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];这段代码
         */
    settingBlock(attributedText);// 代码1
        /* 等价于代码2
        ^(NSMutableAttributedString *attributedText) {
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }(attributedText);
       */

    
    }
    // 赋值给系统的attributedText属性，使插入的生效，如果没有这句代码，插入表情没有反应
    self.attributedText = attributedText;
    // 移除光标到表情的后面,也就是loc + 1的位置。如果没有这句代码，插入表情后，光标就会移动到内容的最后面
    // loc + 1表示光标的位置，0表示选中的长度为0
    self.selectedRange = NSMakeRange(loc + 1, 0);



}
@end
