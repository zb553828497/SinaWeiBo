//
//  UIWindow+SwitchRootVC.m
//  XLWB
//
//  Created by zhangbin on 16/5/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "UIWindow+SwitchRootVC.h"
#import "ZBTabBarController.h"
#import "ZBNewFeatureController.h"

@implementation UIWindow (SwitchRootVC)

-(void)switchRootViewController{
    
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本(存储在沙盒中的版本号)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号(从Info.plist中获得)
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 沙盒中有account.plist文件，且这次打开和上次打开的是同一个版本，就显示ZBTabBarController
    if ([currentVersion isEqualToString:lastVersion]) {
        ZBTabBarController * VC = [[ZBTabBarController alloc] init];
        self.rootViewController = VC;
        
    }else{//沙盒中有account.plist文件，但是这次打开的版本和上一次不一样，仍然显示新特性
        
        ZBNewFeatureController * VC2 = [[ZBNewFeatureController alloc] init];
        self.rootViewController = VC2;
        
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


}

@end
