//
//  NSDate+Extension.m
//  XLWB
//
//  Created by zhangbin on 16/5/22.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

// self就是外界的createDate，表示一条微博创建的时间

/** 判断日期是否为今天*/
-(BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    // 这段代码的含义:获得一条微博的创建年份(年份在self中,所以可以获取到)
    NSDateComponents *WeiBoCreatedTime = [calendar components:NSCalendarUnitYear fromDate:self];
     // 获得当前的时间
    NSDateComponents *CurrentTime = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    // 如果相同，则是同一年，也就是今年,返回YES，
    if (WeiBoCreatedTime.year == CurrentTime.year) {
        return YES;
    }else{
        return NO;
    }
    
}
/**
 *  判断某个日期是否为昨天
 *  不能通过看日期是否相差1来判断是否为昨天.例如30号和1号，两个相差不是1.
 *  而是要通过看年,月，日的差值来判断是否为昨天。
 *  细节:通过将日期转成yyyy-MM-dd格式(没有时分秒),这样我们只需要判断年月日,而时分秒系统自动忽略了
 *  date ==  2016-04-30 10:05:28 --> 2016-04-30
 *  now  ==  2016-05-01 09:22:10 --> 2016-05-01
 */
-(BOOL)isYesterday{
    // 即使之前的显示年月日格式是这样4:30:2016.只要用到了NSDate,显示的年月日底层自动转成这种固定格式:2016-05-22.
    // 如果要显示 时分秒、年月日、时区,显示肯定是这种固定格式:2016-04-30 04:12:38 +0000
    // 总结:NSDate底层显示年月日的格式就是这个固定格式2016-04-30,因为NSDate底层自动帮我们重新排列年月日.同样时分秒、年月日、时区也是固定格式。
    
    
    //isYesterday方法 进行了两次格式转换:Date--->String--->Date  为的就是将时分秒清0,解决还要计算时分秒的干扰
    // 第一个Date的格式:    2016-04-30 04:12:38 +0000
    // 第二个String的格式:  2016-04-30
    // 第三个Date的格式:    2016-04-29 16:0:0 +0000(美国时间)-->2016-04-30 0:0:0 +0000(北京时间)
    // 总结：第三个Date显示的时分秒是16:0:0(美国时间).加上8小时是北京时间(东8区),加上8小时之后,第三个Date才会变为4月30日。所以从北京时间来看,时分秒自动清0了
    
    /*************************************Date***************************************************/
    // 2016-04-30 04:12:38 +0000
    NSDate *now = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //将日期变为yyyy-MM-dd格式，所以时分秒自动被忽略了
    format.dateFormat = @"yyyy-MM-dd";
    /********************************Date---->String**********************************************/
    // 一条微博的创建日期(年月日)
    // 2016-04-30
    NSString *WeiBoCreatedTimeString = [format stringFromDate:self];
    // 当前日期(年月日)
    // 2016-5-1
    NSString *CurrentTimeString = [format stringFromDate:now];
    /********************************String---->Date**********************************************/
    // 2016-4-30 00:00:00 +0000(北京时间)
    NSDate *WeiBoCreatedTimeDate = [format dateFromString:WeiBoCreatedTimeString];
    // 2014-5-1 00:00:00 +0000(北京时间)
    NSDate *CurrentTimeDate = [format dateFromString:CurrentTimeString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // 只计算年月日的差值。对于2016-4-30和2014-5-1的天数计算, NSCalendar底层自动会帮们算出来相差一天
    NSDateComponents *YearMonthDay = [calendar components:unit fromDate:WeiBoCreatedTimeDate toDate:CurrentTimeDate options:0];
    // 如果年份相差为0，月份相差为0，天数相差为1，则返回YES(今天)。否则返回为NO(不是今天)
    if (YearMonthDay.year == 0 && YearMonthDay.month == 0 && YearMonthDay.day) {
        return YES;
    }else{
        return NO;
    }
}
/** 判断日期是否为今天*/
-(BOOL)isToday{
    //isToday方法 也进行了两次格式转换:Date--->String--->Date，为的就是将时分秒清0,解决还要计算时分秒的干扰
    NSDate *CurrentTime = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    // 一条微博的创建日期(年月日)
    NSString *WeiBoCreatedTimeString = [format stringFromDate:self];
    // 当前日期(年月日)
    NSString *CurrentTimeString = [format stringFromDate:CurrentTime];
    // 因为这个错误找了1小时 WeiBoCreatedTimeString == CurrentTimeString
    // 字符串相等，说明是今天
    if ([WeiBoCreatedTimeString isEqualToString:CurrentTimeString]) {
        return  YES;
    }else{
        return NO;
    }

}

@end
