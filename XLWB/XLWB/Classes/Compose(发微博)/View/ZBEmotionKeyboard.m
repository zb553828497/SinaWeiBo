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
#import "ZBEmotion.h"
#import <MJExtension/MJExtension.h>
@interface ZBEmotionKeyboard()<ZBEmotionTabBarDelegate>


/** 容纳表情内容的控件*/
@property(nonatomic,weak)UIView *ContainsEmotion;

/** "最近"表情*/
@property(nonatomic,strong)ZBEmotionListView *RecentListView;
/** "默认"表情*/
@property(nonatomic,strong)ZBEmotionListView *DefaultListView;
/** "Emoji"表情*/
@property(nonatomic,strong)ZBEmotionListView *EmojiListView;
/** "浪小花"表情*/
@property(nonatomic,strong)ZBEmotionListView *LxhListView;

/** tabBar*/
@property(nonatomic,weak)ZBEmotionTabBar * tabBar;

@end

@implementation ZBEmotionKeyboard

-(ZBEmotionListView *)RecentListView{
    if (_RecentListView == nil) {
        self.RecentListView = [[ZBEmotionListView alloc] init];
        self.RecentListView.backgroundColor = ZBRandomColor;
    }
    return _RecentListView;
}

-(ZBEmotionListView *)DefaultListView{
    if (_DefaultListView == nil) {
        self.DefaultListView = [[ZBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        // 字典数组转为ZBEmotion类型的模型数组，并将转成功之后模型数组中的"默认"表情存储到ZBEmotionListView类的emotions数组中
        self.EmojiListView.emotions = [ZBEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.DefaultListView.backgroundColor = ZBRandomColor;
    }
    return _DefaultListView;
}

-(ZBEmotionListView *)EmojiListView{
    if (_EmojiListView == nil) {
        self.EmojiListView = [[ZBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        // 字典数组转为ZBEmotion类型的模型数组，并将转成功之后模型数组中的"emoji"表情存储到ZBEmotionListView类的emotions数组中
        self.EmojiListView.emotions = [ZBEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.EmojiListView.backgroundColor = ZBRandomColor;
    }
    return  _EmojiListView;
}

-(ZBEmotionListView *)LxhListView{
    if (_LxhListView == nil) {
        self.LxhListView = [[ZBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        // 字典数组转为ZBEmotion类型的模型数组，并将转成功之后模型数组中的"Lxh"表情存储到ZBEmotionListView类的emotions数组中
        self.LxhListView.emotions = [ZBEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.LxhListView.backgroundColor = ZBRandomColor;
    }
    return _LxhListView;
}


// 外界的ZBComposeController类调用了emotionKeyboard的getter方法，并在方法里执行了ZBEmotionKeyboard的init方法，所以会来到这个方法的initWithFrame:方法.
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.表情内容
        UIView *ContainsEmotion = [[ZBEmotionListView alloc] init];
      //  ContainsEmotion.backgroundColor = [UIColor redColor];
        [self addSubview:ContainsEmotion];
        self.ContainsEmotion = ContainsEmotion;
        
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
    // 1.tabbar
    self.tabBar.zb_width = self.zb_width;
    self.tabBar.zb_height = 44;
    self.tabBar.zb_X = 0;
    self.tabBar.zb_Y = self.zb_height - self.tabBar.zb_height;
    
    
    // 2.表情内容
    self.ContainsEmotion.zb_width = self.zb_width;
    self.ContainsEmotion.zb_height = self.zb_height - self.tabBar.zb_height;
    // x和y都为0，因为键盘没有父控件，系统默认从底往上弹出，弹出的高度就是你设定的高度。键盘停在哪里，哪里就为(0,0)
    self.ContainsEmotion.zb_X = 0;
    self.ContainsEmotion.zb_Y = 0;
    
    // 3.设置frame(为什么必不可少？因为这个计算ContainsEmotion中的子控件的frame，上面的代码是计算ContainsEmotion自身的frame)
    UIView *chileView = [self.ContainsEmotion.subviews lastObject];// lastObject firstObject都可以，因为ContainsEmotion中只有一个元素(因为每次点击键盘底部的tabbar就会移除ContainsEmotion中之前存储的控件，所以点击点击键盘底部的tabbar，只会有一个显示在ContainsEmotion上)。
    chileView.frame = self.ContainsEmotion.bounds;
    
}

#pragma mark - ZBEmotionTabBarDelegate
// 点击键盘底部的tabbar就会调用
-(void)emotionTabBar:(ZBEmotionTabBar *)tabBar didSelectButton:(ZBEmotionTabBarButtonType)buttonType{
    
    // 移除ContainsEmotion上之前显示的控件，保证每次点击键盘底部的tabbar，只会把 最近/默认/Emoji/Lxh中的一个显示在表情键盘的ContainsEmotion中，不会存在覆盖的现象。
    // 原理:只要删除ContainsEmotion，ContainsEmotion中的子控件也会被删除
    [self.ContainsEmotion.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 根据键盘底部tabbar中按钮的类型，切换ContainsEmotion上面的xxxxListView
    switch (buttonType) {
        case ZBEmotionTabBarButtonTypeRecent:// "最近"
            [self.ContainsEmotion addSubview:self.RecentListView];
            break;
        case ZBEmotionTabBarButtonTypeDefault: // "默认"
            [self.ContainsEmotion addSubview:self.DefaultListView];
            break;
        case ZBEmotionTabBarButtonTypeEmoji: // "emoji"
            [self.ContainsEmotion addSubview:self.EmojiListView];
            break;
        case ZBEmotionTabBarButtonTypeLxh: // "lxh"
            [self.ContainsEmotion addSubview:self.LxhListView];
            break;
    }
    // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    // 如果没有这句代码，ContainsEmotion上的子控件永远不会有frame，因为根本就没有执行layoutSubviews来设置子控件的frame。所以你即使设置了子控件的颜色，没有设置子控件的frame，那么颜色压根也不会显示。
    // 技:子控件必须设置frame，子控件的颜色才知道在具体的哪个位置上显示。
    [self setNeedsLayout];
}

@end
