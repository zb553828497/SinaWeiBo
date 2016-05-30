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
        /*
         UIViewContentModeScaleToFill :显示全部图片,图片不等比例拉伸
         (图片不等比例拉伸至填充整个UIImageView)
         
         UIViewContentModeScaleAspectFit :显示全部图片,图片等比例拉伸
         图片等比例拉伸至完全显示在UIImageView里面为止
         (ScaleAspectFit不会破坏原来宽高比，保持等比例放大或缩小，直到宽或高有一个等于uiimage就停止放大或缩小，此时，图片能显示全貌)
         
         UIViewContentModeScaleAspectFill :显示图片中间区域，图片等比例拉伸
         图片等比例拉伸至 图片的宽度等于UIImageView的宽度 或者 图片的高度等于UIImageView的高度时,就停止拉伸。
         (ScaleAspectFill属性不会破坏原来的宽高比，只会保持宽高比放大伸缩。
         如果图片过大，将会等比例缩小，缩小至宽度或高度等于uiimage，就停止缩小，且只会显示图片中间的区域，不会显示全部的图片。
         如果图片过小，会等比例放大，原理同上，图片只能显示图片中间的区域，不能显示全貌)
         
         UIViewContentModeRedraw : 调用了setNeedsDisplay方法时，就会将图片重新渲染
         
         UIViewContentModeCenter : 居中显示
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         
         经验规律：
         1.凡是带有Scale单词的，图片都会拉伸(分为等比例拉伸和非等比例拉伸),没有Scale，图片不会拉伸，原始多大就多大
         2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形,宽或高有一个等于UIImageView控件的宽或高,就停止拉伸
        */
        
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        //超出图片控件的部分剪切到
        self.clipsToBounds = YES;
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
    // gif图片的x值 = 当前某一张配图的宽度 - gif图片的宽度
    self.gifView.zb_X = self.zb_width - self.gifView.zb_width;
    // gif图片的y值 = 当前某一张配图的高度 - gif图片的高度
    self.gifView.zb_Y = self.zb_height - self.gifView.zb_height;
}
@end
