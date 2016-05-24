//
//  ZBStatusPhotosView.h
//  XLWB
//
//  Created by zhangbin on 16/5/23.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBStatusPhotosView : UIImageView

// 外界调用这个属性的set方法，并将配图的个数作为set方法的参数传递给AllPhotos。
@property(nonatomic,strong)NSArray *AllPhotos;

/**
 *  count就是外界的pic_urls.count，也就是配图的个数
 *配图整体的尺寸(宽高)--->就是所有配图加起来的宽高
 */
+(CGSize)CalculateSizeWithPhotosCount:(int)Count;
@end
