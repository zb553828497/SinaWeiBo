//
//  ZBStatusEveryPhotoView.m
//  XLWB
//
//  Created by zhangbin on 16/5/24.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatusEveryPhotoView.h"
#import <UIImageView+WebCache.h>
#import "ZBPhoto.h"
@interface ZBStatusEveryPhotoView()
@property(nonatomic,weak)UIImageView *gifView;

@end

@implementation ZBStatusEveryPhotoView
// 懒加载的方式创建gif标志
-(UIImageView *)gifView{
    
    if (_gifView == nil) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifV = [[UIImageView alloc]initWithImage:image];
        // 因为类扩展中giftView是弱指针，所以我们利用addSubview加到self中，然后再赋值给全局变量self.gifView。如果顺序相反了，那么gifView为nil
        [self addSubview:gifV];
        self.gifView = gifV;
    }
    return _gifView;

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)setPhoto:(ZBPhoto *)photo{
    _photo = photo;
    // 将photo.thumbnail_pic这个url中存储的图片地址下载下来，然后存储到self对应的图片控件中显示。
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    // 显示/隐藏gif标志
    // 判断是够以gif或者GIF结尾(lowercaseString作用:将大写的GIF变为小写的gif---->忽略大小写)
    // 先将图片的名字变为小写，然后再检索有没有gif这个字符串。有则显示gif图片;无则隐藏gif图片
    if([photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"]){// 繁琐写法
        self.gifView.hidden = NO;
    }else{
        self.gifView.hidden = YES;
    }
    
    // 简单写法:self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}
// 计算gif显示在每一张图片的位置
- (void)layoutSubviews{
    [super layoutSubviews];
    self.gifView.zb_X = self.zb_width - self.gifView.zb_width;
    self.gifView.zb_Y = self.zb_height - self.gifView.zb_height;
}
@end
