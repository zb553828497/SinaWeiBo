//
//  ZBEmotionTextView.h
//  XLWB
//
//  Created by zhangbin on 16/6/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTextView.h"
@class  ZBEmotion;

@interface ZBEmotionTextView : ZBTextView
-(void)insertEmotion:(ZBEmotion *)emotion;
-(NSString *)fullText;
@end
