//
//  ZBEmotionTool.h
//  XLWB
//
//  Created by zhangbin on 16/6/5.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBEmotion;
@interface ZBEmotionTool : NSObject
+(void)addRecentEmotion:(ZBEmotion *)emotion;
+(NSMutableArray *)recentEmotions;
@end
