

//
//  ZBEmotionTool.m
//  XLWB
//
//  Created by zhangbin on 16/6/5.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionTool.h"
#import "ZBEmotion.h"

// "最近"表情的存储路径
#define ZBRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]
@implementation ZBEmotionTool

// 将点击的这个emotion表情存进沙盒
+(void)addRecentEmotion:(ZBEmotion *)emotion{
    
    // 调用recentEmotions，加载沙盒中之前存储的表情数据，放到emotions保存
    NSMutableArray *emotions = [self recentEmotions];
    // emotions为空，说明之前没有存储表情,那么就创建一个空的可变数组emotions用来存储表情
    if (emotions == nil) {
        emotions = [NSMutableArray array];
    }
    // 把沙盒中和emotion一样的表情删除
    [emotions removeObject:emotion];
    for (int i = 0; i < emotions.count; i++) {
        // 取出沙盒中的每一个表情
        ZBEmotion *e = emotions[i];
        if ([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString:emotion.code]){
            [emotions removeObject:e];
        }
    }
    // 将点击的表情插入到数组的最前面
    [emotions insertObject:emotion atIndex:0];
     // 将所有的表情数据(之前的+现在点击的)写入沙盒
    [NSKeyedArchiver archiveRootObject:emotions toFile:ZBRecentEmotionsPath];
    NSLog(@"%@",ZBRecentEmotionsPath);
}
/**
 *  返回装着ZBEmotion模型的数组，数组里面装的是表情
 */
+(NSMutableArray *)recentEmotions{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ZBRecentEmotionsPath];
}
@end
