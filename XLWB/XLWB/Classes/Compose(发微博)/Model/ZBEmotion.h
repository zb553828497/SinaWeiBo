//
//  ZBEmotion.h
//  XLWB
//
//  Created by zhangbin on 16/6/1.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBEmotion : NSObject
/** 表情的文字描述*/
@property(nonatomic,copy)NSString *chs;

/** 表情的png图片*/
@property(nonatomic,copy)NSString *png;

/** Emoji表情的16进制编码*/
@property(nonatomic,copy)NSString *code;
@end
