//
//  ZBTabBar.m
//  XLWB
//
//  Created by zhangbin on 16/5/10.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTabBar.h"

@interface ZBTabBar()

@property(nonatomic,weak)UIButton *plusBtn;
@end

@implementation ZBTabBar


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //添加一个有图片的按钮到tabBar中
        // 按钮图片
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        // 按钮图片上的加号图片
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.zb_size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
    }
    return  self;
}
/**
 *  加号按钮的点击
 */
-(void)plusClick{

    // 通知代理
    if([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]){
        [self.delegate tabBarDidClickPlusButton:self];
    
    
    
    }
}

-(void)layoutSubviews{
    #warning [super layoutSubviews] 一定要调用
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    self.plusBtn.zb_centerX = self.zb_width * 0.5;
    self.plusBtn.zb_centerY = self.zb_height *0.5;
    
    // 2.设置系统的tabBarButton的位置和尺寸
    CGFloat tabBarButton = self.zb_width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView  *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.zb_width = tabBarButton;
            // 设置x
            child.zb_X = tabBarButtonIndex *tabBarButton;
            
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
    

}

@end
