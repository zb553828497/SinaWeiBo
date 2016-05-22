//
//  NSDate+Extension.h
//  XLWB
//
//  Created by zhangbin on 16/5/22.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 判断日期是否为今年*/
-(BOOL)isThisYear;
/** 判断日期是否为昨天*/
-(BOOL)isYesterday;
/** 判断日期是否为今天*/
-(BOOL)isToday;

@end
