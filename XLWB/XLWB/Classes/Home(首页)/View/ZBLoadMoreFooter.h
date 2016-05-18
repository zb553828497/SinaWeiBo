//
//  ZBLoadMoreFooter.h
//  XLWB
//
//  Created by zhangbin on 16/5/18.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
//继承UIView，不是NSObject，否则xib无法关联ZBLoadMoreFooter类，因为类型不一致
@interface ZBLoadMoreFooter : UIView
+(instancetype)footer;
@end
