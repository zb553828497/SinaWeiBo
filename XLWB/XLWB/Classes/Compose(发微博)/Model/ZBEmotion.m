
//
//  ZBEmotion.m
//  XLWB
//
//  Created by zhangbin on 16/6/1.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotion.h"

@implementation ZBEmotion

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法.类似于dealloc啥时候调用
 *  通俗理解:外界调用archiveRootObject方法进行归档(存储)至沙盒时，会先调用encodeWithCoder方法，然后才真正调用encodeWithCoder方法进行归档
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

/**
*  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会先调用这个方法。类似于dealloc啥时候调用
*  通俗理解:外界调用unarchiveObjectWithFile方法进行解档(取出沙盒中的数据)时,会先调用initWithCoder方法，然后才真正调用unarchiveObjectWithFile方法进行解档
*  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

@end
