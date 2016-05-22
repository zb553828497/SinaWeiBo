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
#import "NSDate+Extension.h"

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


// 日期转换写在get方法中.(不执行上拉刷新或下拉刷新,只是滚动最初的20cell,那么cell的时间会实时更新)
// 重写ZBStatus模型created_at属性的get方法
-(NSString *)created_at{
       NSDateFormatter *format= [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    // format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    
    /* 系统底层通过下面的关键字识别时间
      E:星期几
      M:月份
      d:几号(这个月的第几天)
      H:24小时制的小时
      m:分钟
      s:秒
      y:年
     */
    // 设置日期格式（声明字符串里面每个数字和单词的含义）告诉系统，日期的格式是如下类型的。这样代码2中才能将NSString转成NSDate。
    // 设置三个E，系统就会知道星期几，三个MMM，系统就会知道是几月,.......系统底层就是通过这几个字符串识别年月日,固定写法,不能随便写哦
    // 默认时间格式:Thu Oct 21 12:08:32 +0800 2013
    format.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    // 一条微博的创建时间(将NSString转成NSDate。因为NSDate之间是可以进行比较的)
    NSDate *createDate = [format dateFromString:_created_at];// 2
    
    // 获取当前时间
    NSDate *now = [NSDate date];
    
    // 获取日历对象(里面集成了万年历,啥年月的日历都有。方便比较两个日期之间的差距,因为我们就不用考虑闰年，平年了，底层帮我们做好了)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //通过|运算法，获得NSCalendarUnit枚举中的年月日时分秒
    NSCalendarUnit unit= NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
   
    // 计算两个日期(微博创建日期和当前日期)之间的差值
    NSDateComponents *CompareResult = [calendar components:unit fromDate:createDate toDate:now options:0];
    ZBLog(@"%@ %@ %@",createDate,now,CompareResult);
    
    if ([createDate isThisYear]) {// 一条微博的创建时间是今年
        if([createDate isYesterday]){// 一条微博的创建时间是昨天
        format.dateFormat = @"昨天 HH:mm";
            // 返回到哪里？，谁调用created_at方法，就返回给哪个对象。外界的为self.timeLabel.text = status.created_at;调用的。所以返回给外界的status。
            return [format stringFromDate:createDate];
        }else if([createDate isToday]){// 一条微博的创建时间不是昨天,而是今天
            if (CompareResult.hour >= 1) {// 大于1小时
                return [NSString stringWithFormat:@"%ld小时前",CompareResult.hour];
            }else if(CompareResult.minute >2){// 大于2分钟小于1小时
                return [NSString stringWithFormat:@"%ld分钟前",CompareResult.minute];
            }else{// 小于2分钟
            return @"刚刚";
            }
        }else{// 一条微博的创建时间不是昨天,也不是今天，而是今年的其他日子
        format.dateFormat = @"MM-dd HH:mm";
            return [format stringFromDate:createDate];
        }
        
    }else{// 一条微博的创建时间不是今年
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        return [format stringFromDate:createDate];
    }
}

// 日期转换写在set方法中(不执行上拉刷新或者下拉刷新操作，cell的时间永远不会更新)
/*
-(void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    
        NSDateFormatter *format= [[NSDateFormatter alloc] init];
format.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
        // 一条微博的创建时间(将NSString转成NSDate。因为NSDate之间是可以进行比较的)
        NSDate *createDate = [format dateFromString:_created_at];// 2
    
        // 获取当前时间
        NSDate *now = [NSDate date];
    
        // 获取日历对象(里面集成了万年历,啥年月的日历都有。方便比较两个日期之间的差距,因为我们就不用考虑闰年，平年了，底层帮我们做好了)
        NSCalendar *calendar = [NSCalendar currentCalendar];
    
        //通过|运算法，获得NSCalendarUnit枚举中的年月日时分秒
        NSCalendarUnit unit= NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
        // 计算两个日期(微博创建日期和当前日期)之间的差值
        NSDateComponents *CompareResult = [calendar components:unit fromDate:createDate toDate:now options:0];
        ZBLog(@"%@ %@ %@",createDate,now,CompareResult);
    
        if ([createDate isThisYear]) {// 一条微博的创建时间是今年
            if([createDate isYesterday]){// 一条微博的创建时间是昨天
            format.dateFormat = @"昨天 HH:mm";
                // 返回到哪里？，谁调用created_at方法，就返回给哪个对象。外界的为self.timeLabel.text = status.created_at;调用的。所以返回给外界的status。
               _created_at =  [format stringFromDate:createDate];
            }else if([createDate isToday]){// 一条微博的创建时间不是昨天,而是今天
                if (CompareResult.hour >= 1) {// 大于1小时
                   _created_at = [NSString stringWithFormat:@"%ld小时前",CompareResult.hour];
                }else if(CompareResult.minute >2){// 大于2分钟小于1小时
                   _created_at = [NSString stringWithFormat:@"%ld分钟前",CompareResult.minute];
                }else{// 小于2分钟
                _created_at = @"刚刚";
                }
            }else{// 一条微博的创建时间不是昨天,也不是今天，而是今年的其他日子
            format.dateFormat = @"MM-dd HH:mm";
               _created_at = [format stringFromDate:createDate];
            }
            
        }else{// 一条微博的创建时间不是今年
            format.dateFormat = @"yyyy-MM-dd HH:mm";
            _created_at = [format stringFromDate:createDate];
        }


}

*/



// 不需要重写get方法，因为微博的来源是固定的，不需要滚动cell时候调用重写Source的getter方法(时时刻刻的刷新微博的来源)，只需要重写setter方法，这样滚动cell时，微博的来源始终是不变的
// source = <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>

// 目的:截取微博来源的关键字，显示在cell上
-(void)setSource:(NSString *)source{
    NSRange range;// 声明结构体类型的变量
    // 从左向右检索包含>的字符串，并获取到>的位置，然后+1
    range.location = [source rangeOfString:@">"].location + 1;
    // 从左向右检索包含</的字符串，并获取到</的位置，然后减去>的位置，得到的就是> </中包含的字符串长度。
    range.length = [source rangeOfString:@"</"].location -range.location;
    // 将处理过的字符串(其实就是结构体类型的成员变量）赋值给_source;
    //做法1: _source = [source substringWithRange:range];
    // 做法2:拼接"来自"字符串，显得好看一点
    NSString *DealString = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    _source = DealString;

}


@end
