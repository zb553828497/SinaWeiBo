//
//  ZBStatusToolbar.h
//  XLWB
//
//  Created by zhangbin on 16/5/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBStatus;
@interface ZBStatusToolbar : UIView

+(instancetype)toolbar;

// 精华:
// 方式1:把ZBStatus模型作为ZBStatusToolbar的属性。以后再从ZBStatus的status1中取出对应的reposts_count,comments_count ,attitudes_count属性.
@property(nonatomic,strong)ZBStatus *status1;

// 方式二:直接在ZBStatusToolbar中声明reposts_count,comments_count ,attitudes_count三个属性,但是繁琐.
@end
