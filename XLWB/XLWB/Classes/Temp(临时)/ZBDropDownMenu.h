//
//  ZBDropDownMenu.h
//  XLWB
//
//  Created by zhangbin on 16/5/7.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBDropDownMenu;

@protocol ZBDropDownMenuDelegate <NSObject>

@optional

-(void)DropDownMenuDidShow:(ZBDropDownMenu *)menu;
-(void)DropDownMenuDidDismiss:(ZBDropDownMenu *)menu;

@end



@interface ZBDropDownMenu : UIView

@property(nonatomic,weak)id<ZBDropDownMenuDelegate>  delegate;
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
