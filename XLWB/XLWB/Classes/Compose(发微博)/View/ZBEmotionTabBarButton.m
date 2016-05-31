//
//  ZBEmotionTabBarButton.m
//  XLWB
//
//  Created by zhangbin on 16/5/31.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionTabBarButton.h"

@implementation ZBEmotionTabBarButton
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置键盘底部文字的颜色
        // 正常状态下的文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 不可点击状态下的文字颜色
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        
        // 设置键盘底部的文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

// 点击按钮不放，就是按钮的高亮状态。我们重写了系统的setHighlighted方法，然后什么也不做，这样就没有高亮状态了
-(void)setHighlighted:(BOOL)highlighted{
    
}
@end
