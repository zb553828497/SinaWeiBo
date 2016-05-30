//
//  ZBTextView.m
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTextView.h"

@implementation ZBTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];//initWithFrame:是系统+父类的方法，所以必须用super调用
    if (self) {
        // 利用通知来实现 监听ZBTextView中文字改变的通知，如果文字改变了就调用textChanged方法,在方法中执行你想要的操作(官方解释:UITextView自己会发出一个UITextViewTextDidChangeNotification类型的通知)
        // 通知的类型:UITextViewTextDidChangeNotification
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

// 如果外界经常访问自定义的属性，并且马上能让这个属性产生效果做法的做法是重写属性的setter方法
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder =placeholder;
    // 先调drawrect，没有文字就画一个文字（占位文字），然后当你在textview中输入文字时，调用通知中的方法，在方法中重新绘制，调用drawrect 为什么进行一次判断就可以让之前的占位文字清空，不判断，占位文字不会被清空
   // 每次调用drawrect方法，就会把之前画的内容擦掉
    [self setNeedsDisplay];
}



// 第一次调用: textView.placeholder = @"分享新鲜事";--->setPlaceholder:--->setNeedsDisplay--->drawRect:--->画出占位文字

// 第二次调用: 监听(通知的方式)--ZBTextView中的文字改变了--> textChanged-->setNeedsDisplay--->擦掉之前画出的占位文字--->drawRect:-->画出"自己输入的文字"

-(void)drawRect:(CGRect)rect{
    
    if (self.hasText)  return;// 必不可少，少了这句，之前的占位文字不会被清除，但是为什么不糊被清除呢？
    
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    
    // 字典中的属性不能为空，否则会报错（也就是下面代码中等号右侧不能为空）。我们利用了三目运算符。当外界有设置占位文字的颜色时，即self.placeholdercolor不为空，那么就把外界设置的颜色作为占位文字的颜色。当外界没有设置占位文字的颜色，就采用默认的文字颜色作为占位文字的颜色。
     attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    // 画文字
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat width = rect.size.width - 2 * x;
    CGFloat height = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, width, height);
    
   // drawInRect中的参数就是限定画出的矩形的位置和宽高，这样造成的结果是:占位文字会规规矩矩的在矩形内显示，并且会自动换行.
        [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    /*
     如果用drawAtPoint:,那么仅仅是限定了从什么位置开始画图形，这样造成的结果是:占位文字会超出屏幕，并且还不换行
     [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attrs];
     */
    }

-(void)textChanged{
    // 重绘
    [self setNeedsDisplay];
}
-(void)dealloc{
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
