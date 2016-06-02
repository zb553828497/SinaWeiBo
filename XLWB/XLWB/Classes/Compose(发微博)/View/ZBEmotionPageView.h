//
//  ZBEmotionPageView.h
//  XLWB
//
//  Created by zhangbin on 16/6/2.
//  Copyright © 2016年 zhangbin. All rights reserved.
//  用来表示一页的表情（里面显示1~20个表情

#import <UIKit/UIKit.h>
// 一页中最多3行
#define  ZBEmotionEveryPageMaxRows 3
// 一行中最多7列
#define  ZBEmotionEveryPageMaxColums 7

@interface ZBEmotionPageView : UIView
/** 这一页显示的表情（里面都是ZBEmotion模型） */
@property(nonatomic,strong)NSArray *emotions;
@end
