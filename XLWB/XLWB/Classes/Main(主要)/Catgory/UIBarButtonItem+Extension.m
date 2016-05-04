//
//  UIBarButtonItem+Extension.m
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

// 抽取出一个方法的原则:变化的变为参数
// addTarget之前为self，这里就不能用self，必须改成外界传递过的参数，这样参数才为外界的self
+(UIBarButtonItem *)ItemWithTarget:(id)target action:(SEL)action image:(NSString *)image HighlightImage:(NSString *)HighlightImage{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action  forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:HighlightImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.zb_size = btn.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    ;
}

@end
