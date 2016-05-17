//
//  ZBStatus.h
//  XLWB
//
//  Created by zhangbin on 16/5/17.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
// 一定写在@interface的上面。
@class ZBUser;
@interface ZBStatus : NSObject


// 返回字段说明

/** ￼ string  字符串型的微博ID*/
@property(nonatomic,copy) NSString *idstr;

/**  string  微博信息内容*/
@property(nonatomic,copy) NSString *text;

/**  object  微博作者的用户信息字段 详细*/
@property(nonatomic,strong)ZBUser *user;

@end
