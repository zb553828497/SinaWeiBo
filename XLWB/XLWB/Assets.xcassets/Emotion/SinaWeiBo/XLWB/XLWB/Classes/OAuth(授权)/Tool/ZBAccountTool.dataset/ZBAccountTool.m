//
//  ZBAccountTool.m
//  XLWB
//
//  Created by zhangbin on 16/5/13.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBAccountTool.h"


/**
 *  存储账号信息
 */
#define ZBAccountPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"account.archive"]
@implementation ZBAccountTool

// 做法3
// 存储用户信息
+(void)saveAccount:(ZBAccount *)account{
    

    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:ZBAccountPath];
}

// 取出 存储的用户信息
+(ZBAccount *)account{
    
    // 加载模型(解档)。
    //如果解档成功，这个account对象里面存储着用户的信息。例如:以后我们可以通过account.uid(对象.属性)的形式获得用户的uid.  因为返回值类型为ZBAccount，所以我们ZBAccount.h中的属性都可以通过这对象.属性获得。
    ZBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:ZBAccountPath];
    
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期的时间（账号存储的时间+过期的秒数）
    NSDate *expiresTime = [account.createdTime dateByAddingTimeInterval:expires_in];

    
    // 获得当前时间
    NSDate *nowDate =[NSDate date];
        // 比较当前时间和过期时间 如果expiresTime<=nowDate，那么账号过期
    /* NSOrderedAscending = -1L=升序, NSOrderedSame=相等, NSOrderedDescending=降序 */
    
    NSComparisonResult result = [expiresTime compare:nowDate];
    
    //result的结果为升序或者相等，表示:expiresTime<=nowDate，比如2016<=2017，说明过期一年了
    if( result == NSOrderedSame || result == NSOrderedAscending     ){//过期
        result ;//不往下执行
    }
    //ZBLog(@"过期时间--%@,当前时间--`%@",expiresTime,nowDate);
    
    return account;
}
// 做法1
/*
 +(void)saveAccount:(ZBAccount *)account{
 
 // 沙盒路径
 NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
 // 归档
 [NSKeyedArchiver archiveRootObject:account toFile:path];
 }
 
 +(ZBAccount *)account{
 // 沙盒路径
 NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 NSString *path = [doc stringByAppendingPathComponent:@"account.archive"];
 
 // 加载模型(解档)
 ZBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
 
 return account;
 
 }
 */

// 做法2

/*
 +(NSString *)path{
 // 沙盒路径
 NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 return [doc stringByAppendingString:@"account.archive"];
 }
 +(void)saveAccount:(ZBAccount *)account{
 // 归档
 [NSKeyedArchiver archiveRootObject:account toFile:[self path]];
 }
 
 +(ZBAccount *)account{
 
 // 加载模型(解档)
 ZBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
 return account;
 }
 
 */




@end
