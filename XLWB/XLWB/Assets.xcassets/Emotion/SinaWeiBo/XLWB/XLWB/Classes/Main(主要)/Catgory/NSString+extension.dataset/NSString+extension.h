//
//  NSString+extension.h
//  XLWB
//
//  Created by zhangbin on 16/5/23.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)
-(CGSize)sizeWithfont:(UIFont *)font maxW:(CGFloat)maxW;
// 自定义的方法 外界调用方法2,间接的调用了方法1
-(CGSize)sizeWithfont:(UIFont *)font;
@end
