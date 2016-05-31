//
//  ZBPhoto.h
//  XLWB
//
//  Created by zhangbin on 16/5/20.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBPhoto : NSObject

/** thumbnail_pic  string 缩略图片地址，没有时不返回此字段*/
@property(nonatomic,copy)NSString *thumbnail_pic;
@end
