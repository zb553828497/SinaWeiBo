//
//  ZBComposePhotosView.m
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBComposePhotosView.h"
@interface ZBComposePhotosView()
// 不需要在类扩展中写上@property(nonatomic,strong)NSMutableArray *photos;
// 因为类扩展中的声明属性的代码已经写在了.h文件。

@end

@implementation ZBComposePhotosView


// 懒加载(也就是photos属性的getter方法)
-(NSMutableArray *)photos{

   if (_photos == nil) {
       // 分配存储空间，使photos能够存储图片
       self.photos = [NSMutableArray array];
   }
    return _photos;
}

-(void)addPhoto:(UIImage *)photo{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    // 调用photos的懒加载方法(getter方法)，用于存储图片到可变数组中
    [self.photos addObject:photo];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat photoWH = 70;
    CGFloat photoMargin = 10;
    for (int i = 0 ; i < count; i ++) {
        UIImageView *photo = self.subviews[i];
        int col = i % maxCol;
        photo.zb_X = col * (photoWH + photoMargin);
        
        int row = i / maxCol;
        photo.zb_Y = row * (photoWH + photoMargin);
        photo.zb_width = photoWH;
        photo.zb_height = photoWH;
    }
    
}


@end
