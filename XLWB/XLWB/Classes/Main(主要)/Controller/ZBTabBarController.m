//
//  ZBTabBarController.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTabBarController.h"
#import "ZBHomeViewController.h"
#import "ZBDiscoverViewController.h"
#import "ZBMessageCenterController.h"
#import "ZBProfileViewController.h"

@interface ZBTabBarController ()

@end

@implementation ZBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 3.设置子控制器
    //   UIViewController *vc1 = [[UIViewController alloc] init];
    //vc1.view.backgroundColor = ZBRandomColor;
    //    vc1.tabBarItem.title = @"首页";
    //    vc1.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    //   vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ZBHomeViewController *home = [[ZBHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected" bgColor:ZBRandomColor];
    
    //    UIViewController *vc2 = [[UIViewController alloc] init];
    //    vc2.view.backgroundColor = ZBRandomColor;
    //    vc2.tabBarItem.title = @"消息";
    //    vc2.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
    //    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_message_center_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ZBMessageCenterController *messageCenter = [[ZBMessageCenterController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected" bgColor:ZBRandomColor];
    
    
    //    UIViewController *vc3 = [[UIViewController alloc] init];
    //    vc3.view.backgroundColor = ZBRandomColor;
    //    vc3.tabBarItem.title = @"发现";
    //    vc3.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    //    vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZBDiscoverViewController *discover = [[ZBDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected" bgColor:ZBRandomColor];
    
    //    UIViewController *vc4 = [[UIViewController alloc] init];
    //    vc4.view.backgroundColor = ZBRandomColor;
    //    vc4.tabBarItem.title = @"我";
    //    vc4.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    //    vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZBProfileViewController *profile = [[ZBProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected" bgColor:ZBRandomColor];

}

-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage: (NSString *)selectedImage bgColor:(UIColor *)bgColor{
    // 设置子控制器的文字和图片
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = ZBColor(123, 123, 123);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    childVc.view.backgroundColor = bgColor;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
    
    
}
@end
