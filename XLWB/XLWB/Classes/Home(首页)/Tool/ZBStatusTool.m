//
//  ZBStatusTool.m
//  XLWB
//
//  Created by zhangbin on 16/6/23.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatusTool.h"
#import "FMDB.h"

@implementation ZBStatusTool

static FMDatabase *_db;

+(void)initialize{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    NSLog(@"%@",path);
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    // 2.创建t_status表
    // blob是一种类型，用于存储二进制数据
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);"];
}

// 加载微博数据
+(NSArray *)LoadingStatusWithParams:(NSDictionary *)params{
    // 根据请求参数生成对应的查询SQL语句
    
    NSString *sql = nil;
    if (params[@"since_id"]) {// 下拉刷新中的请求参数since_id满足这个条件
        // 找到满足idstr大于since_id的数据并按降序排序，然后从高到底取出20个数据
        // 降序原因:idstr越大，越显示在微博数据的最前面
        // 所有的idstr都是小于等于params[@"since_id"],所以t_status表中找不到满足这样条件的数据
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",params[@"since_id"]];
    }else if(params[@"max_id"]){// 上拉刷新中的请求参数max_id满足这个条件
    // 因为上拉，所以显示id更小的微博，所以所有的idstr都是大于params[@"max_id"]，所以t_status表中找不到这样条件的数据
    sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;",params[@"max_id"]];
    }else{// 如果请求参数中没有since_id，max_id，就降序显示t_status表中的20个数据
    sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
    }
    // 根据上面的sql中的命令,执行SQL语句
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statuses = [NSMutableArray array];
    while (set.next) {
        // 取出status字段中的每一个NSData类型的数据
        NSData *statusData = [set objectForColumnName:@"status"];
        // NSData转成NSDictionary类型，因为NSData只有0和1，我们必须转为NSDictionary类型，才能看到汉字嘛
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        // 将objectForColumnName的参数status 这个字段的对应的数据添加到statuses数组中返回给外界
        [statuses addObject:status];
    }
    return statuses;
    
}
 // 存微博数据
+(void)SaveStatuses:(NSArray *)statuses{
    // 要将一个对象存进数据库的blob字段,最好先转为NSData
    // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData。因为NSDictionary和NSArray的系统底层已经遵守了NSCoding协议，所以我们可以直接转成NSData
    for (NSDictionary *status in statuses) {
        // NSDictionary转成NSData类型(NSData类型只有0和1)
        NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
        // 插入新数据到数据库的t_status表中。以后只要执行statusesWithParams:方法,在方法中拿到t_status表是插入了新数据的表。
        [_db executeUpdateWithFormat:@"INSERT INTO t_status(status, idstr) VALUES (%@, %@);",statusData,status[@"idstr"]];
    }
}

@end