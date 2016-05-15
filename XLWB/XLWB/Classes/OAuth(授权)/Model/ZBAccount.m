//
//  ZBAccount.m
//  XLWB
//
//  Created by zhangbin on 16/5/13.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBAccount.h"

@implementation ZBAccount

+(instancetype)accountWithDict:(NSDictionary *)dict{
    
    ZBAccount *account = [[ZBAccount alloc] init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];

    
    //新浪服务器返会给我们字典数据的时候，就是账号账号存储的时间(access_token的产生时间)
    account.createdTime = [NSDate date];

    // 加上存储到沙盒中
    
    return account;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法.类似于dealloc啥时候调用
 *  通俗理解:外界调用archiveRootObject方法进行归档(存储)至沙盒时，会先调用encodeWithCoder方法，然后才真正调用encodeWithCoder方法进行归档
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    [coder encodeObject:self.access_token forKey:@"access_token"];
    [coder encodeObject:self.expires_in forKey:@"expires_in"];
    [coder encodeObject:self.uid forKey:@"uid"];
    
    [coder encodeObject:self.createdTime forKey:@"createdTime"];
    [coder encodeObject: self.name forKey:@"name"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会先调用这个方法。类似于dealloc啥时候调用
 *  通俗理解:外界调用unarchiveObjectWithFile方法进行解档(取出沙盒中的数据)时,会先调用initWithCoder方法，然后才真正调用unarchiveObjectWithFile方法进行解档
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.access_token = [coder decodeObjectForKey:@"access_token"];
        self.expires_in = [coder decodeObjectForKey:@"expires_in"];
        self.uid = [coder decodeObjectForKey:@"uid"];
        self.createdTime = [coder decodeObjectForKey:@"createdTime"];
        self.name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}



@end
