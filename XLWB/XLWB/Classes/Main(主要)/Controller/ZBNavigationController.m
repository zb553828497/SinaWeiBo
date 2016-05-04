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

// 重写这个方法，用于拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [super pushViewController:viewController animated:animated];
    // 初次运行，发现各个控制器的self.viewControllers.count都为1
    // 点击首页控制器,发现self.viewControllers.count为2，
//    NSLog(@"%ld %@",self.childViewControllers.count,viewController);
//    
//    
//    NSLog(@"%--ld--%@--",self.viewControllers.count,viewController);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
   
    // 设置图片
    [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];

    [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];

    // 设置尺寸
    backBtn.zb_size = backBtn.currentBackgroundImage.size;
    // 一定是viewController，不是self，否则设置的按钮图片不显示。浪费了1小时
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    
    moreBtn.zb_size = moreBtn.currentBackgroundImage.size;
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
}
-(void)back{
    [self popViewControllerAnimated:YES];

}
-(void)more{
    [self popViewControllerAnimated:YES];
}

@end
