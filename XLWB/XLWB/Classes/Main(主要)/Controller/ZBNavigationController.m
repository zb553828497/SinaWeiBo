//
//  ZBNavigationController.m
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBNavigationController.h"
#import "ZBItemTool.h"
@interface ZBNavigationController ()

@end

@implementation ZBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 重写这个方法，用于拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
   
    // 初次运行，发现各个控制器的self.viewControllers.count都为1
    // 点击首页控制器,发现self.viewControllers.count为2，
    //    NSLog(@"%ld %@",self.childViewControllers.count,viewController);//NSLog(@"%--ld--%@--",self.viewControllers.count,viewController);
    
    // 非根控制器才执行{}的内容
    if(self.viewControllers.count > 0){
        /* 当push时，隐藏底部的tabBar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        
        /* 设置导航栏的内容 */
      
         // 一定是viewController，不是self，否则设置的按钮图片不显示。浪费了1小时
        viewController.navigationItem.leftBarButtonItem = [ZBItemTool ItemWithTarget:self action:@selector(back) image:@"navigationbar_back" HighlightImage:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem = [ZBItemTool ItemWithTarget:self action:@selector(more) image:@"navigationbar_more" HighlightImage:@"navigationbar_more_highlighted"];
    
    }
    
     [super pushViewController:viewController animated:animated];
    
}
    -(void)back{
    [self popViewControllerAnimated:YES];

}
-(void)more{
    [self popViewControllerAnimated:YES];
}

@end
