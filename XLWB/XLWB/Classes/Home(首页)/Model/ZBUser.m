//
//  ZBUser.m
//  XLWB
//
//  Created by zhangbin on 16/5/17.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBUser.h"

@implementation ZBUser

// 字典转模型的过程中,肯定会调用这个mbtype属性的set方法(为什么会调用?没有为什么，就是这么规定的)。
// 这里我们利用了MJ框架进行了字典转模型，MJ框架底层也会通过调用set方法来实现字典转模型
// 我们重写set方法，在字典转模型时，拦截对mbtype的赋值，最终也能赋值，只不过,我增加了self.vip = mbtype > 2;代码

-(void)setMbtype:(int)mbtype{
    _mbtype = mbtype;
// 如果mbtype大于2满足条件,那么该用户是会员，vip的值为1.如果mbtype>2不满足条件，那么该用户不是会员,vip的值为0.
    self.vip = mbtype > 2;
}

@end
