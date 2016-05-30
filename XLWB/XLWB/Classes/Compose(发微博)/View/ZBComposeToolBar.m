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

        [self setUpBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted"];
        [self setUpBtn:@"compose_toolbar_picture"   highImage:@"compose_toolbar_picture_highlighted"];
        [self setUpBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted"];
        [self setUpBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted"];
        [self setUpBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted"];
    }
    return self;
}

-(void)setUpBtn:(NSString *)image highImage:(NSString *)highImage {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
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

@end
