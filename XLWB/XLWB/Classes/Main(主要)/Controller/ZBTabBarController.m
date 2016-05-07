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
#import "ZBNavigationController.h"
@interface ZBTabBarController ()

@end

@implementation ZBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 3.设置子控制器
    ZBHomeViewController *home = [[ZBHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected" bgColor:ZBRandomColor];

    ZBMessageCenterController *messageCenter = [[ZBMessageCenterController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected" bgColor:ZBRandomColor];
    
      ZBDiscoverViewController *discover = [[ZBDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected" bgColor:ZBRandomColor];
     ZBProfileViewController *profile = [[ZBProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected" bgColor:ZBRandomColor];

}
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         子控制器标题
 *  @param image         图片
 *  @param selectedImage 选中图片
 *  @param bgColor       背景图片
 */
-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage: (NSString *)selectedImage bgColor:(UIColor *)bgColor{
    
    // 设置子控制器的文字和图片
    childVc.title = title;   // 同时设置tabbar和navigationBar的文字(底部和顶部)
    
    /*
    childVc.navigationItem = title;    // 设置navigationBar的文字(底部)
    childVc.tabBarItem.title = title; // // 设置tabbar的文字(顶部)
     */
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = ZBColor(123, 123, 123);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //设置颜色时用到了控制器的view，所以就会调用各个控制器的loadView->viewDidLoad方法，过程一气呵成
    //因为ZBNavigationController和childVc(加载4个控制器)的代码在view的后面,所以ZBNavigationController和4个控制器是在viewDidLoad方法后面才调用的，执行到ZBNavigationController时,已经执行完了按钮不可点击的代码,
    /*
        假设传进来的控制器childVc为ZBMessageCenterController
     
     那么, 1的代码中有view,所以ZBMessageCenterController就会执行viewDidLoad方法,将不可点击的"写私信"显示在屏幕上
          2的代码创建了导航控制器ZBNavigationController,在控制器里面拿到了整个项目所有item的主题样式，
     
     
     A控制器的view设置完了按钮状态之后，就无法设置A的按钮样式了
     */
   
    childVc.view.backgroundColor = bgColor;// 1
    
    /*
     
     只要写了1处的代码，必定有右侧的执行过程:  childVc.view--->loadView--->viewDidLoad
     
     控制器的view是懒加载的，使用到并且是第一次使用的时候才调用。loadView和ViewDidLoad都是懒加载
     
     
     
     */
    
    
    
    //导航控制器的4个根控制器会执行 pushViewController方法，但是因为不满足条件if条件,所以不会执行if的内容,，所以这4个根控制器不会有自定设定的返回按钮,更多按钮。自定义设定的返回，更多按钮就是if的代码中设定的 
    ZBNavigationController *nav = [[ZBNavigationController alloc] initWithRootViewController:childVc];//2
    // 添加为子控制器
    [self addChildViewController:nav];
    
    
}
@end
