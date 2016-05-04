//
//  ZBNavigationController.m
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBNavigationController.h"

@interface ZBNavigationController ()

@end

@implementation ZBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [super pushViewController:viewController animated:animated];
    // 初次运行，发现各个控制器的self.viewControllers.count都为1
    // 点击首页控制器,发现self.viewControllers.count为2，
    NSLog(@"%ld %@",self.childViewControllers.count,viewController);

    
  NSLog(@"%--ld--%@--",self.viewControllers.count,viewController);

}

@end
