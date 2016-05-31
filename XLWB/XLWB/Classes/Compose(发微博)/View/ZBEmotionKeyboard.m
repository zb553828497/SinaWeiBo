//
//  ZBEmotionKeyboard.m
//  XLWB
//
//  Created by zhangbin on 16/5/31.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionKeyboard.h"
#import "ZBEmotionTabBar.h"
#import "ZBEmotionListView.h"

@interface ZBEmotionKeyboard()<ZBEmotionTabBarDelegate>
/** 表情内容*/
@property(nonatomic,weak)ZBEmotionListView *listView;
/** tabBar*/
@property(nonatomic,weak)ZBEmotionTabBar * tabBar;
@end

@implementation ZBEmotionKeyboard

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.表情内容
        ZBEmotionListView *listView = [[ZBEmotionListView alloc] init];
        listView.backgroundColor = [UIColor redColor];
        [self addSubview:listView];
        self.listView = listView;
        // 2.tabbar
        ZBEmotionTabBar *tabBar = [[ZBEmotionTabBar alloc] init];
        //tabBar.backgroundColor = [UIColor greenColor];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
    }
    return self;
}
// 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    // tabbar
    self.tabBar.zb_width = self.zb_width;
    self.tabBar.zb_height = 44;
    self.tabBar.zb_X = 0;
    self.tabBar.zb_Y = self.zb_height - self.tabBar.zb_height;
    
    
    // 表情内容
    self.listView.zb_width = self.zb_width;
    self.listView.zb_height = self.zb_height - self.tabBar.zb_height;
    // x和y都为0，因为键盘没有父控件，系统默认从底往上弹出，弹出的高度就是你设定的高度。键盘停在哪里，哪里就为(0,0)
    self.listView.zb_X = 0;
    self.listView.zb_Y = 0;
}

#pragma mark - ZBEmotionTabBarDelegate
-(void)emotionTabBar:(ZBEmotionTabBar *)tabBar didSelectButton:(ZBEmotionTabBarButtonType)buttonType{
    switch (buttonType) {
        case ZBEmotionTabBarButtonTypeRecent:
            ZBLog(@"最近");
            break;
        case ZBEmotionTabBarButtonTypeDefault:
            ZBLog(@"默认");
            break;
        case ZBEmotionTabBarButtonTypeEmoji:
            ZBLog(@"Emoji");
            break;
        case ZBEmotionTabBarButtonTypeLxh:
            ZBLog(@"Lxh");
            break;
    }
}

@end
