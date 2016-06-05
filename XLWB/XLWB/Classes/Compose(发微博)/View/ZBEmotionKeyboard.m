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
#import "ZBEmotionTool.h"

@interface ZBEmotionKeyboard()<ZBEmotionTabBarDelegate>


/** 保存正在显示的listView*/
@property(nonatomic,weak)ZBEmotionListView *SaveShowingListView;

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
        // init会调用ZBEmotionListView中的initWithFrame方法
        self.RecentListView = [[ZBEmotionListView alloc] init];
        // 虽然没有设置_RecentListView界面的颜色，但是在ZBEmotionListView中的initWithFrame方法中已经设置了默认的红色
        
        // 加载沙盒中的表情(只会调用一次，如果没有这句代码，程序初始运行时，"表情"选项卡空白一片，没有任何表情。因为你切换到表情按钮，就会执行RecentListView的getter方法，你在getter方法里面，没有加载沙盒中的表情，能显示之前的表情才怪呢)
        self.RecentListView.emotions = [ZBEmotionTool recentEmotions];
    }
  

    return _RecentListView;
}

-(ZBEmotionListView *)DefaultListView{
    if (_DefaultListView == nil) {
        // init会调用ZBEmotionListView中的initWithFrame方法
        self.DefaultListView = [[ZBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        // 字典数组转为ZBEmotion类型的模型数组，并将转成功之后模型数组中的"默认"表情存储到ZBEmotionListView类的emotions数组中
        // 调用emotions属性的setter方法，在setter方法内部，设置pageControl的页数,以及创建用于显示表情的控件
        self.DefaultListView.emotions = [ZBEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];// emotions存储着99个表情对象
    }
    return _DefaultListView;
}

-(ZBEmotionListView *)EmojiListView{
    if (_EmojiListView == nil) {
        // init会调用ZBEmotionListView中的initWithFrame方法
        self.EmojiListView = [[ZBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        // 字典数组转为ZBEmotion类型的模型数组，并将转成功之后模型数组中的"emoji"表情存储到ZBEmotionListView类的emotions数组中
         // 调用emotions属性的setter方法，在setter方法内部，设置pageControl的页数,以及创建用于显示表情的控件
        self.EmojiListView.emotions = [ZBEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];// emotions存储着80个表情对象
    }
    return  _EmojiListView;
}

-(ZBEmotionListView *)LxhListView{
    if (_LxhListView == nil) {
        // init会调用ZBEmotionListView中的initWithFrame方法
        self.LxhListView = [[ZBEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        // 字典数组转为ZBEmotion类型的模型数组，并将转成功之后模型数组中的"Lxh"表情存储到ZBEmotionListView类的emotions数组中
         // 调用emotions属性的setter方法，在setter方法内部，设置pageControl的页数,以及创建用于显示表情的控件
        self.LxhListView.emotions = [ZBEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];// emotions存储着40个表情对象
    }
    return _LxhListView;
}


// 外界的ZBComposeController类调用了emotionKeyboard的getter方法，并在方法里执行了ZBEmotionKeyboard的init方法，所以会来到这个方法的initWithFrame:方法.
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // tabbar
        ZBEmotionTabBar *tabBar = [[ZBEmotionTabBar alloc] init];
        //tabBar.backgroundColor = [UIColor greenColor];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 让键盘监听(监听就是拦截)表情选中的通知.目的:将点击的表情添加到“最近”选项卡中
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionDidSelect) name:@"ZBEmotionDidSelectNofication" object:nil];
    }
    return self;
}
// 将点击的表情添加到“最近”选项卡中
-(void)emotionDidSelect{
    // 加载沙盒中的表情
    self.RecentListView.emotions = [ZBEmotionTool recentEmotions];
}
// 移除监听者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.SaveShowingListView.zb_width = self.zb_width;
    self.SaveShowingListView.zb_height = self.zb_height - self.tabBar.zb_height;
    
    // x和y都为0，因为键盘没有父控件，系统默认从底往上弹出，弹出的高度就是你设定的高度。键盘停在哪里，哪里就为(0,0)
    self.SaveShowingListView.zb_X = 0;
    self.SaveShowingListView.zb_Y = 0;
    
}

#pragma mark - ZBEmotionTabBarDelegate
// 点击键盘底部的tabbar就会调用
-(void)emotionTabBar:(ZBEmotionTabBar *)tabBar didSelectButton:(ZBEmotionTabBarButtonType)buttonType{
    
    // 把SaveShowingListView上之前显示的表情从父控件(当前类)移除，保证每次点击键盘底部的tabbar，只会把 最近/默认/Emoji/Lxh中的一个显示在表情键盘的SaveShowingListView中，不会存在覆盖的现象。
    // 为什么SaveShowingListView的父控件是当前类。因为RecentListView，DefaultListView，EmojiListView，LxhListView都是添加到self，也就是当前类中的。而RecentListView又赋值给了SaveShowingListView，所以SaveShowingListView也相当于添加的哦啊了当前类中，所以SaveShowingListView的父控件就是当前类
       [self.SaveShowingListView removeFromSuperview];
    
    // 根据键盘底部tabbar中按钮的类型，切换对应的表情
    switch (buttonType) { 
        case ZBEmotionTabBarButtonTypeRecent:{// "最近"
            // 调用 RecentListView的懒加载方法,将"最近"表情添加到当前类中
            [self addSubview:self.RecentListView];
            // 将"最近"表情赋值给SaveShowingListView，这样SaveShowingListView中就保存了"最近"表情。
            /* 
             1.为什么可以赋值？
             答:因为两个对象的类型一致，所以SaveShowingListView等价RecentListView
             
             2.赋值之后的结果是什么？
             答:RecentListView有啥，SaveShowingListView就有啥。RecentListView是经过alloc init创建出来的，那么SaveShowingListView也是经过alloc init创建出来的(虽然代码中没有使用alloc init创建出SaveShowingListView对象，但是因为赋值的关系，SaveShowingListView就是相当于利用alloc init创建出来的)。
            
             3.为什么要赋值给SaveShowingListView？
            因为 RecentListView，DefaultListView，EmojiListView，LxhListView要显示出来，必须设置frame，我们把这四个对象都赋值给同一个对象SaveShowingListView，那么我们只需拿到SaveShowingListView，然后在layoutSubviews方法中设置4个表情的frame。
             如果不赋值给同一个对象，那么我们在layoutSubviews方法中就得设置4个对象，来分别对这4个表情设置frame
             */
            self.SaveShowingListView = self.RecentListView;
            break;
        }
        case ZBEmotionTabBarButtonTypeDefault:{ // "默认"
            // 调用 DefaultListView的懒加载方法,将"默认"表情添加到当前类中
            [self addSubview:self.DefaultListView];
            // 将"默认"表情赋值给SaveShowingListView，这样SaveShowingListView中就保存了"默认"表情。
            // 为什么可以赋值？因为两个对象的类型一致，所以SaveShowingListView等价DefaultListView
            self.SaveShowingListView = self.DefaultListView;
            break;
        }
        case ZBEmotionTabBarButtonTypeEmoji:{ // "emoji"
            // 调用 EmojiListView的懒加载方法,将"emoji"表情添加到当前类中
            [self addSubview:self.EmojiListView];
            // 将"emoji"表情赋值给SaveShowingListView，这样SaveShowingListView中就保存了"emoji"表情。
            // 为什么可以赋值？因为两个对象的类型一致，所以SaveShowingListView等价EmojiListView
            self.SaveShowingListView = self.EmojiListView;
            break;
        }
        case ZBEmotionTabBarButtonTypeLxh:{ // "lxh"
            // 调用 LxhListView的懒加载方法将"lxh"表情添加到当前类中
            [self addSubview:self.LxhListView];
            // 将"lxh"表情赋值给SaveShowingListView，这样SaveShowingListView中就保存了"最近"表情。
            // 为什么可以赋值？因为两个对象的类型一致，所以SaveShowingListView等价LxhListView
            self.SaveShowingListView = self.LxhListView;
            break;
        }
    }

     }

@end
