//
//  AppDelegate.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "AppDelegate.h"

#import "ZBTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置根控制器
    ZBTabBarController *tabbarVC = [[ZBTabBarController alloc] init];
    self.window.rootViewController = tabbarVC;
    
  
    
    
    // 4.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;

}




@end
