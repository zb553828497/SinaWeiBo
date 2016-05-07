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

// 程序启动，一定先执行application方法来创建窗口.
// 注意:可以创建多个窗口。程序默认只创建了一个窗口。平时创建的view都是这个窗口上的。
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
