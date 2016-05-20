//
//  ZBStatus.m
//  XLWB
//
//  Created by zhangbin on 16/5/17.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatus.h"
#import "ZBPhoto.h"
#import <MJExtension/MJExtension.h>

@implementation ZBStatus

//将数组中存放的对象的类型,变为模型类的类型(底层我们不用管,他们自动帮我们变为模型类的类型)
+ (NSDictionary *)mj_objectClassInArray{
    /*
       key: pic_urls是数组的属性名
     value: 数组中的对象是ZBPhoto类型(ZBPhoto模型)
     这句代码的含义:pic_urls数组里面的对象类型是ZBPhoto类型(ZBPhoto模型)
    */
     return @{@"pic_urls" : [ZBPhoto class]};
}

@end
