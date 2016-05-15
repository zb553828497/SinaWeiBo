//
//  ZBAccountTool.h
//  XLWB
//
//  Created by zhangbin on 16/5/13.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
// 只要导入了ZBAccountTool类的头文件就相当于也导入了ZBAccount类的头文件
#import "ZBAccount.h"

@interface ZBAccountTool : NSObject
// 处理账号相关的所有操作：存储账号、取出账号、验证账号


/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount : (ZBAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型(如果账号过期,返回nil)
 */
+(ZBAccount *)account;

@end
