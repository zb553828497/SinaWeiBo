//
//  ZBLoadMoreFooter.m
//  XLWB
//
//  Created by zhangbin on 16/5/18.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBLoadMoreFooter.h"

@implementation ZBLoadMoreFooter
+(instancetype)footer{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ZBLoadMoreFooter" owner:self options:nil] lastObject];
 
}
@end
