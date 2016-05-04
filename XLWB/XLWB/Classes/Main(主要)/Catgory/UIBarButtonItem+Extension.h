//
//  UIBarButtonItem+Extension.h
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)ItemWithTarget:(id)target action:(SEL)action image:(NSString *)image HighlightImage:(NSString *)HighlightImage;
@end
