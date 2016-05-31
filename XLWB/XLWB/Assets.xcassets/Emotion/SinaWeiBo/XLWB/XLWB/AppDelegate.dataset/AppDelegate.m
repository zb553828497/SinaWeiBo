//
//  AppDelegate.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBOAuthViewController.h"

#import "ZBAccountTool.h"
#import "UIWindow+SwitchRootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// 程序启动，一定先执行application方法来创建窗口.
// 注意:可以创建多个窗口。程序默认只创建了一个窗口。平时创建的view都是这个窗口上的。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;

    
    // 解档账号的存储信息
    //在account方法中，如果沙盒路径中没有账号信息，那么解档出来的account就为空,说明之前没有存储账号信息到沙盒中
    ZBAccount *account = [ZBAccountTool account];
    
    // 判断沙盒中有没有account.archive
    if(account) {
        // 调用switchRootViewController来实现,选择跳转至窗口的哪个根控制器
        [self.window switchRootViewController];
    }else{//如果沙盒中没有account.archive，前面的if else都不会执行，只会执行如下代码,重新在授权页面进行登录
    
        ZBOAuthViewController *VC3 = [[ZBOAuthViewController alloc] init];
        self.window.rootViewController = VC3;
    
    }

    // 4.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;

}
/**
 *  当app进入后台时调用
 */
-(void)applicationDidEnterBackground:(UIApplication *)application{
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作,很难再做其他操作(系统默认情况,只要app进入后台,就是暂停状态)
     *  4.后台运行状态
     */
    
    // 向操作系统申请后台运行的资格,这个资格能维持多久,是不确定的
    // task不要加星号
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
     
    
}



@end
