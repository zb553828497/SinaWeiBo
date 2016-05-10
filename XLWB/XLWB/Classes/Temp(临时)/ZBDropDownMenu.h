//
//  ZBDropDownMenu.h
//  XLWB
//
//  Created by zhangbin on 16/5/7.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBDropDownMenu : UIView
+(instancetype)menu;
/**
 *  UITableView的内容
 */
@property(nonatomic,strong)UIView *content;

/**
 *  UITableView的控制器
 */
@property(nonatomic,strong)UIViewController *contentController;

/**
 *  显示
 */
-(void)Show:(UIView *)titleButton;

@end
