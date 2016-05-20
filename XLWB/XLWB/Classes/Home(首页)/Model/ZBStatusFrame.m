//
//  ZBStatusFrame.m
//  XLWB
//
//  Created by zhangbin on 16/5/19.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatusFrame.h"
#import "ZBStatus.h"
#import "ZBUser.h"

// cell的边框宽度
#define ZBStatusCellBorderW 10

@implementation ZBStatusFrame

// 自定义的方法
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{// 方法1
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
     // 最大宽度为maxW，最大高度不限制
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
// boundingRectWithSize：约束最大尺寸。因为参数是上面的maxSize，所以约束的是最大宽度为maxW,不能超过这个宽度
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}
// 自定义的方法 外界调用方法2,间接的调用了方法1
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{ // 方法2
     // maxW为MAXFLOAT,表示没有最大宽度，宽度由我们自己决定
    return [self sizeWithText:text font:font maxW:MAXFLOAT];

}

// 仅仅是计算frame，将来用于给系统的frame赋值
-(void)setStatus:(ZBStatus *)status{
    
    _status = status;
    // status.user是模型中取模型，得到的是ZBUser模型，可以用ZBUser模型的Oneuser对象，去访问ZBUser中的属性，例如name属性
    ZBUser *Oneuser = status.user;
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 原创微博*/
    
    /** 头像*/
    CGFloat iconWH = 35;
    CGFloat iconX = ZBStatusCellBorderW;
    CGFloat iconY = ZBStatusCellBorderW;
    self.iconViewFrames = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称*/
    CGFloat nameX = CGRectGetMaxX(self.iconViewFrames) + ZBStatusCellBorderW;
    CGFloat nameY = iconY;
    // 取出ZBUser模型中的name属性,(这个name属性里面是有数据的)，然后给name属性设置字体。
    CGSize nameSize = [self sizeWithText:Oneuser.name font:ZBStatusCellNameFont];
    // 装逼写法1:   (CGRect){ {CGPoint} , CGSize }
    self.nameLabelFrame = (CGRect){{nameX,nameY},nameSize};
    // 普通写法2:self.nameLabelF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    /** 会员图标*/
    if(Oneuser.isVip){
        CGFloat vipX = CGRectGetMaxX(self.nameLabelFrame) + ZBStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipW = 14;
        // 从nameSize(包含宽,高)中取出高度
        CGFloat vipH = nameSize.height;
        self.vipViewFrame = CGRectMake(vipX, vipY, vipW
                                       , vipH);
    }
    /** 发微博的时间*/
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelFrame) + ZBStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:ZBStatusCellTimeFont];
    self.timeLabelFrame = (CGRect){{timeX,timeY},timeSize};
    
    /** 微博的来源途径*/
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelFrame) + ZBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:ZBStatusCellSourceFont];
    self.sourceLabelFrame = (CGRect){{sourceX,sourceY},sourceSize};
    
    /** 正文*/
    CGFloat contentX = iconX;
    // 正文的y值 = 取出self.iconViewF和self.timeLabelF当中最大的y值 + 10
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewFrames), CGRectGetMaxY(self.timeLabelFrame)) + ZBStatusCellBorderW;
    // 正文的最大宽度 = cell的宽度- 2 * 图片距离屏幕左侧的x值
    CGFloat maxW = cellW - 2 * contentX;
    // maxW的作用:限制正文的最大宽度
    CGSize contentSize = [self sizeWithText:status.text font:ZBStatusCellContentFont maxW:maxW];
    self.contentLableFrame = (CGRect){{contentX,contentY},contentSize};
    
    /** 配图*/
    CGFloat originalH = 0;
    if (status.pic_urls.count) {// 有配图
        CGFloat PhotoX = contentX;
        CGFloat PhotoY = CGRectGetMaxY(self.contentLableFrame) + ZBStatusCellBorderW;
        CGFloat photoWH = 100;
        self.photoViewFrame = CGRectMake(PhotoX, PhotoY, photoWH, photoWH);
        // 原创微博的高度 = 配图最大的Y值 + 10
        originalH  = CGRectGetMaxY(self.photoViewFrame) + ZBStatusCellBorderW;
    }else{// 没配图
        // 原创微博的高度  = 正文的最大Y值 + 10
        originalH = CGRectGetMaxY(self.contentLableFrame) + ZBStatusCellBorderW;
    }
    
    
    /** 原创微博整体*/
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    // 原创微博的整体的宽度 = cell的宽度
    CGFloat originalW = cellW;
    
    // originalH是上面计算好的 原创微博的高度
    self.originalViewFrame = CGRectMake(originalX, originalY, originalW, originalH);
    // 原创微博整体的cell的高度
    self.cellHeight = CGRectGetMaxY(self.originalViewFrame);

    
}


@end
