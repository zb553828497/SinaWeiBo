//
//  ZBStatusPhotosView.m
//  XLWB
//
//  Created by zhangbin on 16/5/23.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatusPhotosView.h"
#import "ZBPhoto.h"
#import <UIImageView+WebCache.h>
#import "ZBStatusEveryPhotoView.h"


#define ZBStatusPhotosMaxCol(Count)  ((Count == 4)?2:3)
#define ZBStatusPhotoWH 70
#define ZBStatusPhotoMargin 10


@implementation ZBStatusPhotosView
// ZBStatusCell类中 有利用ZBStatusPhotosView+init的方式创建对象，所以肯定会调用initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];;
    }
    return self;
}

/* 
 //只要滚动cell就会调用setAllPhotos方法。因为滚动cell肯定会调用setStatusFrame。setStatusFrame方法中又会调用setAllPhotos。
 
 // 设置数据
 
 外界的ZBStatusCell类中，这两句代码调用setAllPhotos方法
 self.photosView.AllPhotos = status.pic_urls;
 self.retweetedPhotosView.AllPhotos = retweet_status.pic_urls;
 */
 -(void)setAllPhotos:(NSArray *)AllPhotos{
     // 将AllPhotos用_AllPhotos存起来，以后可能会用到_AllPhotos
     _AllPhotos = AllPhotos;
     // 将从新浪服务器得到的配图的个数赋值给AllPhotosCount
    int AllPhotosCount = AllPhotos.count;
     // self内部的图片子控件不够用(小于AllPhotosCount)，就创建一个控件，直到等于AllPhotosCount，就停止创建图片控件。这里的AllPhotosCount就是请求过来的配图的个数,也就是AllPhotos中的对象的个数。
     // 强烈注意:self.subviews.count是控件的个数，仅仅是个空的图片控件，里面没有图片数据。
     while (self.subviews.count < AllPhotosCount) {
         // 创建一个图片控件
         ZBStatusEveryPhotoView *NewAddPhoto = [[ZBStatusEveryPhotoView alloc] init];
         // 将图片控件添加到当前类中存储起来
         [self addSubview:NewAddPhoto];
     }
// 能来到这里，说明self内部的图片子控件够用（并且一定是大于等于请求过来的配图的个数）。大于的情况:没有执行while，上次存储在当前类中的图片够用。等于的情况:执行了while，当等于请求过来的配图的个数,就退出循环，停止创建图片。所以下面还得隐藏大于配图的图片
     
     // 遍历当前类每个元素(图片)--->图片的个数一定是大于等于配图的哦
     for (int i = 0; i < self.subviews.count; i++) {
         // 根据下标取出当前类中存储的图片控件，放到SeeEveryPhoto中保存,仅仅是空的控件哦，没有图片哦。
         ZBStatusEveryPhotoView *SeeEveryPhoto = self.subviews[i];
         // 如果self内部的图片控件的下标i小于服务器返回过来的配图的个数，就显示图片。否则，就隐藏。为什么隐藏，隐藏是为了解决循环利用的问题。因为self内部的图片控件如果为6，这个6是循环出来的图片控件，这个循环利用出来的图片控件将要传递给现在的cell上，而现在的cell中,这次从服务器请求过来的配图个数为2，只需要显示两个图片，那4个就不要显示了。如果没有这个if else，那么这次就会显示2张配图+4张循环利用的图片，很明显，就会造成数据错乱，并且4张循环利用的图片位置偏移cell固定的高度，因为cell的高度已经确定了，比如cell的高度为200，你在200的高度上再60的高度，所以就会在这个cell的下面显示了。

         if (i < AllPhotosCount) {
             // 取出从新浪服务器请求到的每一张图片，放到photo中保存
            //ZBPhoto *photo = AllPhotos[i];
             // 调用ZBStatusEveryPhotoView类中photo属性的setter方法，并取出从新浪服务器请求到的每一张图片(作为setter方法的参数)，在setter方法里面下载图片，并在图片中显示或者隐藏gif的标志
             SeeEveryPhoto.photo = AllPhotos[i];
             
             
             // 显示图片控件
             SeeEveryPhoto.hidden = NO;
        // 将photo.thumbnail_pic这个url中存储的图片地址下载下来，然后存储到SeeEveryPhoto图片控件中显示。
//             [SeeEveryPhoto sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
         }else{
             // 将多余的图片控件隐藏
             SeeEveryPhoto.hidden = YES;
        }
     }
  }
// 布局每一张图片
-(void)layoutSubviews{
    [super layoutSubviews];
    // AllPhotos是配图的个数
    int photosCount = self.AllPhotos.count;
    int maxCol = ZBStatusPhotosMaxCol(photosCount);
    for (int i = 0; i < photosCount; i++) {
        ZBStatusEveryPhotoView *photoV = self.subviews[i];
        int col = i % maxCol;
        photoV.zb_X = col * (ZBStatusPhotoWH + ZBStatusPhotoMargin);
        int row = i / maxCol;
        photoV.zb_Y = row * (ZBStatusPhotoWH + ZBStatusPhotoMargin);
        photoV.zb_width = ZBStatusPhotoWH;
        photoV.zb_height = ZBStatusPhotoWH;
        
    }
}

/*  外界的ZBStatusFrame类中，这两句代码调用CalculateSizeWithPhotosCount:方法
CGSize photosSize = [ZBStatusPhotosView CalculateSizeWithPhotosCount:status.pic_urls.count];
CGSize retweetPhotosSize = [ZBStatusPhotosView CalculateSizeWithPhotosCount:retweet_status.pic_urls.count];
 */

/**
 *  count就是外界的pic_urls.count，也就是配图的个数
 *
 *  @return 配图整体的尺寸(宽高)--->就是所有配图加起来的宽高
 */
+(CGSize)CalculateSizeWithPhotosCount:(int)Count{
    
    /*
     代码1+代码2的结合,实现了如下功能:
     4张配图时，显示两行两列，且每行2个
     不是4张配图时，按正常的从左到右，每行三个配图排列
     
     代码1+代码2就是计算列数的公式
     */
    
     // 最大列数（一行最多有多少列） 如果配图有4张，那么最大列数为两列，如果配图不是4张，最大列数为三列
    int maxCols = ZBStatusPhotosMaxCol(Count);// 代码1
    
    // 列数  (上面的maxCols也会同时参与比较哦)
    // 假设:如果配图大于4张(例如5张),那么5>=3,则列数为3
    // 假设：配图为4张，那么 4>=2满足，则列数为2
    // 假设:如果配图为3张，那么3>=3,则列数为3
    // 假设:如果配图为2张，那么2>=3不满足，所以列数取后者，列数为2
    // 假设:如果配图为1张,那么1>=3不满足,所以列数取后者,列数为1
    int cols = (Count >=maxCols)?maxCols:Count;// 代码2
    
    // 行数(公式)
    int rows = (Count + maxCols - 1) / maxCols;
    
    // 配图整体的宽度 = 列数 * 每张配图的宽度 + (列数 - 1) * 两张配图的间距
    CGFloat photosW = cols * ZBStatusPhotoWH + (cols - 1) * ZBStatusPhotoMargin;
    
    // 配图整体的高度 = 行数 * 每张配图的高度 + (行数 - 1) * 两张配图的间距
    CGFloat photosH = rows * ZBStatusPhotoWH + (rows - 1) * ZBStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}
@end
