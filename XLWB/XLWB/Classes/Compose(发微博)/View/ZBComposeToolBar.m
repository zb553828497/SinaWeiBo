//
//  ZBComposeToolBar.m
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBComposeToolBar.h"

@implementation ZBComposeToolBar
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        // 初始化工具条上的按钮
        // 高亮状态和选中状态的区别:高亮就是点击亮一下，松手之后就不亮了。选中状态就是点了之后亮，松手之后仍然亮

        [self setUpBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:ZBComposeToolBarButtonTypeCamera];
        [self setUpBtn:@"compose_toolbar_picture"   highImage:@"compose_toolbar_picture_highlighted" type:ZBComposeToolBarButtonTypePicture];
        [self setUpBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:ZBComposeToolBarButtonTypeMention];
        [self setUpBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:ZBComposeToolBarButtonTypeTrend];
        [self setUpBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:ZBComposeToolBarButtonTypeEmotion];
    }
    return self;
}
/**
 *  在工具条上创建按钮
 *
 *  @param image     普通图片
 *  @param highImage 高亮图片
 *  @param type      图片类型
 */
-(void)setUpBtn:(NSString *)image highImage:(NSString *)highImage type:(ZBComposeToolBarButtonType)type {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    // 监听工具条上按钮的点击
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 一个按钮对应一个类型
    btn.tag = type;
    
    // 5张图片放在工具条ZBComposeToolBar中
    [self addSubview:btn];
}

// 布局工具条中的5个按钮
-(void)layoutSubviews{
    [super layoutSubviews];
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    // self.zb_width就是外界(ZBComposeController类的setUpToolBar方法中)传递过来的屏幕的宽度
    CGFloat btnW = self.zb_width / count;
    // self.zb_height是外界(ZBComposeController类的setUpToolBar方法中)传递过来的44【已验证】
    CGFloat btnH = self.zb_height;
    for (NSUInteger i = 0; i < count; i ++) {
        UIButton *btn = self.subviews[i];
        btn.zb_X = i * btnW;
        btn.zb_Y = 0;
        btn.zb_width = btnW;
        btn.zb_height = btnH;
    }
}
/**
 *  监听工具条上按钮的点击
 *
 *  @param button      UIButton类的对象
 *  参数的类型由谁决定呢？答:不是由addTarget后面的self决定的，而是由self监听的那个对象决定，self监听的对象就是工具条上的按钮，也就是btn，因为btn是UIButton类型的，所以参数的类型为UIButton

 */
-(void)btnClick:(UIButton *)button{
    //如果ZBComposeToolBar类的代理对composeToolBar:didClickBtn:方法有响应，就执行括号里面的内容(调用代理方法)
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickBtn:)]) {
        // 通过上面的 btn.tag = type;可知，btn.tag对应唯一的一个按钮的类型
        [self.delegate composeToolBar:self didClickBtn:button.tag];
    }

}

@end
