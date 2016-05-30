//
//  ZBTextView.h
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBTextView : UITextView
/** 占位文字*/
@property(nonatomic,copy)NSString *placeholder;
/** 占位文字的颜色*/
@property(nonatomic,strong)UIColor *placeholderColor;

@end
