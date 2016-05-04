//
//  ZBNavigationController.m
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBNavigationController.h"
#import "UIBarButtonItem+Extension.h"
@interface ZBNavigationController ()

@end

@implementation ZBNavigationController

+(void)initialize{

    // 设置整个项目所有item的主题样式
      UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    /*
     因为上面拿到了整个项目的所有的样式，
     所以无论是根控制器还是子控制器，只要在通过这种形式navigationItem.rightBarButtonItem设置右侧按钮的文字，字体大小都会变为黄色，字号为13.
     */
     textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//等价于textAttrs[NSForegroundColorAttributeName] = ZBColor(231, 179, 37); 修改alpha,就是修改透明度

    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
}


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
        // 为UIBarButtonItem类扩充分类，要用UIBarButtonItem类名直接调用分类中的方法，不要用分类的名字调用哦
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(back) image:@"navigationbar_back" HighlightImage:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(more) image:@"navigationbar_more" HighlightImage:@"navigationbar_more_highlighted"];
    
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
