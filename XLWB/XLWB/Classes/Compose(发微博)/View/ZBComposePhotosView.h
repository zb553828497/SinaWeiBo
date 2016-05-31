//
//  ZBComposePhotosView.h
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBComposePhotosView : UIView
// 添加图片
-(void)addPhoto:(UIImage *)photo;
// 存储图片到photos可变数组中
@property(nonatomic,strong)NSMutableArray *photos;

@end
