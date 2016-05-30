//
//  ZBIconView.h
//  XLWB
//
//  Created by zhangbin on 16/5/24.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBUser;
@interface ZBIconView : UIImageView

// 声明了模型类中的一个属性，那么当前类就拿到了ZBUser类，也就拥有了ZBUser的所有属性和方法
@property(nonatomic,strong)ZBUser *Everyuser;
@end
