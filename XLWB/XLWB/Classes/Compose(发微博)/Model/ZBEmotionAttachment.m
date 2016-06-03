

//
//  ZBEmotionAttachment.m
//  XLWB
//
//  Created by zhangbin on 16/6/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionAttachment.h"
#import "ZBEmotion.h"
@implementation ZBEmotionAttachment
-(void)setEmotion:(ZBEmotion *)emotion{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}
@end
