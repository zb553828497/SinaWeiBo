//
//  ZBStatusTool.h
//  XLWB
//
//  Created by zhangbin on 16/6/23.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBStatusTool : NSObject

/**
 *  根据请求参数去沙盒中加载缓存的微博数据
 *
 *  @param params 请求参数
 */
+(NSArray *)LoadingStatusWithParams:(NSDictionary *)params;


/**
 *  存储微博数据到沙盒中
 *
 *  @param statuses 需要存储的微博数据
 */
+(void)SaveStatuses:(NSArray *)statuses;
@end
