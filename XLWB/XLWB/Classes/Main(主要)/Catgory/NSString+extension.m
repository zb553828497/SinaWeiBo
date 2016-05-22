//
//  NSString+extension.m
//  XLWB
//
//  Created by zhangbin on 16/5/23.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)
// 自定义的方法
-(CGSize)sizeWithfont:(UIFont *)font maxW:(CGFloat)maxW{// 方法1
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    // 最大宽度为maxW，最大高度不限制
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    // boundingRectWithSize：约束最大尺寸。因为参数是上面的maxSize，所以约束的是最大宽度为maxW,不能超过这个宽度
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}
// 自定义的方法 外界调用方法2,间接的调用了方法1
-(CGSize)sizeWithfont:(UIFont *)font{ // 方法2
    // maxW为MAXFLOAT,表示没有最大宽度，宽度由我们自己决定
    return [self sizeWithfont:font maxW:MAXFLOAT];
    
}
@end
