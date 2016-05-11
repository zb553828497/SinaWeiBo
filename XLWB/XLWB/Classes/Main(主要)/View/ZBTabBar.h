//
//  ZBTabBar.h
//  XLWB
//
//  Created by zhangbin on 16/5/10.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#warning 因为ZBTabBar继承自UITabBar，所以成为ZBTabBar的代理，也必须实现UITabBar的代理协议

@class ZBTabBar;
@protocol ZBTabBarDelegate <UITabBarDelegate>
@optional
-(void)tabBarDidClickPlusButton:(ZBTabBar *)tabBar;
@end



@interface ZBTabBar : UITabBar
@property(nonatomic,weak) id<ZBTabBarDelegate> delegate;

@end
