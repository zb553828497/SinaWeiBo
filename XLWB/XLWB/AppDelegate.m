//
//  AppDelegate.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "AppDelegate.h"

#import "ZBTabBarController.h"
#import "ZBNewFeatureController.h"

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
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本(存储在沙盒中的版本号)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号(从Info.plist中获得)
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 版本号相同：这次打开和上次打开的是同一个版本
    if ([currentVersion isEqualToString:lastVersion]) {
        ZBNewFeatureController * VC = [[ZBNewFeatureController alloc] init];
        self.window.rootViewController = VC;
        
    }else{// 这次打开的版本和上一次不一样，显示新特性
        
        ZBNewFeatureController * VC2 = [[ZBNewFeatureController alloc] init];
        self.window.rootViewController = VC2;
        
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //ZBTabBarController *tabbarVC = [[ZBTabBarController alloc] init];
    //self.window.rootViewController = tabbarVC;

    // 4.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;

}




@end
