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
    
    // 初始化tooBarY为0，将来要计算toolBarY
    CGFloat toolBarY = 0;

    /** 被转发的微博*/
    if(status.retweeted_status != nil){
        
        ZBStatus *retweet_status = status.retweeted_status;
        ZBUser *retweet_status_user = retweet_status.user;
        
    /** 被转发的微博正文*/
    // 被转发微博正文的X值为10
    CGFloat retweetContentX = ZBStatusCellBorderW;
        // 因为被转发文博整体 的Y值为原创微博的最大Y值，所以被转发文博整体的位置已经确定了
        // 因为所以被转发微博正文的父控件是被转发文博整体，所以被转发微博正文的Y值也就确定了
    CGFloat retweetContentY = ZBStatusCellBorderW;
        // 拿到被转发微博的内容，用于下面计算被转发微博的尺寸
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweet_status_user.name,retweet_status.text];
        // 根据被转发微博的正文内容来计算转发微博正文的尺寸
        CGSize retweetContentSize = [self sizeWithText:retweetContent font:ZBStatusCellRetweetContentFont maxW:maxW];
    
        self.retweetContentAndNameFrame = (CGRect){{retweetContentX,retweetContentY},retweetContentSize};
        
        /** 被转发微博配图*/
        CGFloat retweetH = 0;// 声明一个变量，初始化为0，为的只是将来拿到retweetH使用
        if (retweet_status.pic_urls.count ) {// 转发微博有配图
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentAndNameFrame) + ZBStatusCellBorderW;
            CGFloat retweetPhotoWH = 100;
            self.retweetPhotoViewFrame = CGRectMake(retweetPhotoX, retweetPhotoY, retweetPhotoWH, retweetPhotoWH);
            retweetH = CGRectGetMaxY(self.retweetPhotoViewFrame) + ZBStatusCellBorderW;
        }else{// 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentAndNameFrame) + ZBStatusCellBorderW;
        
        }
        /** 被转发的微博的整体*/
        CGFloat retweetX = 0;
        // 被转发微博整体 的Y值为原创微博的最大Y值
        CGFloat retweetY = CGRectGetMaxY(self.originalViewFrame);
        CGFloat retweetW = cellW;
        self.retweetViewFrame = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        // 转发微博时，工具条的Y值就是转发微博的最大Y值
        toolBarY = CGRectGetMaxY(self.retweetViewFrame);
    }else{
        
        // 没有转发微博时,工具条的Y值就是原始微博的最大Y值
        toolBarY = CGRectGetMaxY(self.originalViewFrame);
    }
    
    /** 工具条*/
    CGFloat toolBarX = 0;
    CGFloat toolBarW = cellW;
    CGFloat toolBarH = 35;
    self.toolBarFrame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    /** cell的高度*/
    // ZBCellMargin作用:让cell和cell之间有间距
    self.cellHeight = CGRectGetMaxY(self.toolBarFrame) + ZBCellMargin;
}


@end
