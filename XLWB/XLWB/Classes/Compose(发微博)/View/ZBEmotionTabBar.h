//
//  ZBEmotionTabBar.h
//  XLWB
//
//  Created by zhangbin on 16/5/31.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZBEmotionTabBarButtonTypeRecent, // 最近
    ZBEmotionTabBarButtonTypeDefault, // 默认
    ZBEmotionTabBarButtonTypeEmoji,// emoji
    ZBEmotionTabBarButtonTypeLxh  // 浪小花
}ZBEmotionTabBarButtonType;

@class ZBEmotionTabBar;

@protocol ZBEmotionTabBarDelegate <NSObject>

@optional
-(void)emotionTabBar:(ZBEmotionTabBar *)tabBar didSelectButton:(ZBEmotionTabBarButtonType)buttonType;
@end

@interface ZBEmotionTabBar : UIView
@property(nonatomic,weak)id<ZBEmotionTabBarDelegate> delegate;


@end
