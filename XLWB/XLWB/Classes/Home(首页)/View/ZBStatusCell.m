//
//  ZBStatusCell.m
//  XLWB
//
//  Created by zhangbin on 16/5/19.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatusCell.h"
#import "ZBStatusFrame.h"
#import "ZBStatus.h"
#import "ZBUser.h"
#import <UIImageView+WebCache.h>
#import "ZBPhoto.h"
#import "ZBStatusToolbar.h"
#import "NSString+extension.h"
#import "ZBStatusPhotosView.h"


@interface ZBStatusCell()
//原创微博

/** 原创微博整体*/
@property(nonatomic,weak)UIView *originalView;

/** 头像*/
@property(nonatomic,weak)UIImageView *iconView;
/** 会员图标*/
@property(nonatomic,weak)UIImageView *vipView;
/** 配图*/
@property(nonatomic,weak)ZBStatusPhotosView *photosView;
/** 昵称*/
@property(nonatomic,weak)UILabel *nameLabel;
/** 发微博的时间*/
@property(nonatomic,weak)UILabel *timeLabel;
/** 发微博的来源、途径*/
@property(nonatomic,weak)UILabel *sourceLabel;
/** 正文*/
@property(nonatomic,weak)UILabel *contentLabel;

//转发微博
/** 转发微博的整体*/
@property(nonatomic,weak)UIView *retweetedView;
/** 转发微博的正文+昵称*/
@property(nonatomic,weak)UILabel *retweetedContentAndName;
/** 转发微博的配图*/
@property(nonatomic,weak)ZBStatusPhotosView *retweetedPhotosView;


/** 工具条*/
@property(nonatomic,weak)ZBStatusToolbar *toolBar;// 注意是ZBStatusToolbar类型

@end

@implementation ZBStatusCell



// 封装cellWithTableView。
//本来cellWithTableView方法中的内容写在外面ZBHomeViewController,经过封装,外界只需执行cellWithTableView这个接口，就可以创建ZBStatusCell类型的cell。外界不需要知道接口内部是怎么实现的
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    ZBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 调用下面的initWithStyle方法，用于添加子控件
        cell = [[ZBStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

//-(void)setFrame:(CGRect)frame{
//    frame.origin.y += ZBCellMargin;
//       [super setFrame:frame];
//}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
// 添加子控件
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        // 让cell的背景颜色变为透明色
        self.backgroundColor = [UIColor clearColor];
        // 点击cell时,cell不会变色,因为设置样式为None。如果没有这句代码,点击cell,cell默认为灰色gray
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 点击cell时，cell的背景颜色为紫色
//        UIView *bg = [[UIView alloc] init];
//        bg.backgroundColor = [UIColor purpleColor];
//        self.selectedBackgroundView = bg;
       
        
        // 初始化原始微博
        [self setupOriginal];
        
        // 初始化转发微博
        [self setupRetweeted];
        
        // 初始化工具条
        [self setupToolBar];
    }
    return self;
}
/**
 *  初始化工具条
 */
-(void)setupToolBar{
    // 调用toolbar类方法
    ZBStatusToolbar *toolb = [ZBStatusToolbar toolbar];
   // toolb.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:toolb];
    self.toolBar = toolb;

}

/**
 *  初始化转发微博
 */
-(void)setupRetweeted{
    /** 转发微博的整体*/
    UIView *All = [[UIView alloc] init];
    All.backgroundColor = ZBColor(247, 247, 247
                                  );
    // 转发微博的整体 添加到当前的cell的contentView中
    [self.contentView addSubview:All];
    self.retweetedView = All;
    
    /** 转发微博的正文+昵称*/
    UILabel *CN = [[UILabel alloc] init];
    CN.numberOfLines = 0;
    CN.font = ZBStatusCellRetweetContentFont;
    // 转发微博正文 + 昵称添加到转发微博整体中。所以父控件不是cell的contentView，而是UIView类型的All
    [All addSubview:CN];
    self.retweetedContentAndName = CN;
    
    /** 转发微博配图*/
    ZBStatusPhotosView *PV = [[ZBStatusPhotosView alloc]init];
    
    [All addSubview:PV];
    self.retweetedPhotosView = PV;
}

/**
 *  初始化原创微博
 */
-(void)setupOriginal{
    /** 原创微博整体*/
    UIView *originalView = [[UIView alloc] init];
    // 原创微博的背景颜色为白色
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像*/
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标*/
    UIImageView *vipView = [[UIImageView alloc] init];
    [self.contentView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图*/
    ZBStatusPhotosView *photoView = [[ZBStatusPhotosView alloc] init];
    [self.contentView addSubview:photoView];
    self.photosView = photoView;
    
    /** 昵称*/
    UILabel *nameLabel = [[UILabel alloc] init];
    // 不设置昵称字体的大小，那么最终字体显示不全。会有省略号，考虑一下为什么呢。
    // 大概原因:你在ZBStatusFrame类的setStatus:方法中设置了昵称的frame(昵称的frame是根据设置字体的大小设置的),所以你初始化昵称时，必须设置昵称的字体是多大
    nameLabel.font = ZBStatusCellNameFont;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 发微博的时间*/
    UILabel *timeLabel = [[UILabel alloc] init];
    // 不设置时间字体的大小，那么最终字体显示不全。会有省略号，考虑一下为什么呢。同上
    timeLabel.font = ZBStatusCellTimeFont;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源*/
    UILabel *sourceLabel = [[UILabel alloc] init];
    // 同上
    sourceLabel.font = ZBStatusCellSourceFont;
    [self.contentView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文*/
    UILabel *contentLabel = [[UILabel alloc] init];
    // 同上
    contentLabel.font = ZBStatusCellContentFont;
    // 自动换行
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;

}


// 给子控件的frame赋值+设置数据并显示
// 注意： 模型中的属性赋值给系统的属性,就能把微博的内容显示在当前cell上
-(void)setStatusFrame:(ZBStatusFrame *)statusFrame{
    
    _statusFrame =statusFrame;
    
    ZBStatus *status = statusFrame.status;
    
    // 精华:模型中又有模型，即ZBStatus模型中又有ZBUser模型，可以通过status.user的形式得到ZBUser模型(即:用ZBStatus模型的对象去访问ZBUser模型的对象)

    ZBUser *Oneuser = status.user;
    
    /** 原创微博整体*/
    self.originalView.frame = statusFrame.originalViewFrame;
    
    /** 头像*/
    self.iconView.frame = statusFrame.iconViewFrames;// 设置frame
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:Oneuser.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];// 下载图片并显示头像
    
    
    /** 会员图标*/
    if (Oneuser.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewFrame;// 设置frame
        // mbrank是会员等级
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d",Oneuser.mbrank];
        //  模型中的属性赋值给系统的属性,就能把微博的内容显示在当前cell上
        self.vipView.image = [UIImage imageNamed:vipName];// 显示会员图标
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
           self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    /** 配图*/
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewFrame;// 设置frame
        #warning 不太懂
        ZBPhoto *photo = [status.pic_urls firstObject];
        [self.photosView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];// 显示配图
        // 循环利用一定要有 xxxx.hidden = NO； xxxx.hidden = YES;否则数据会错乱
        self.photosView.hidden = NO;
    }else {
        
        self.photosView.hidden = YES;
    
    }

    /** 昵称*/
    self.nameLabel.frame = statusFrame.nameLabelFrame;// 设置frame
    // 模型中的属性(里面存储着数据哦)，赋值给系统的属性，就能把微博的作者显示在当前cell上
    self.nameLabel.text = Oneuser.name;// 显示昵称

    /** 发微博的时间*/
    
    // status.created_at返回的是 发微博的时间距离当前的时间的差值。例如"8分钟前"、 "1小时前"
    // 每次滚动cell就会调用created_at的getter方法，所以每次都会得到不同的时间差值,所以每次的差值都会更新在cell上
    NSString *time = status.created_at;
    // 昵称的x值就是发微博时间的x值
    CGFloat timeX = statusFrame.nameLabelFrame.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelFrame) + ZBStatusCellBorderW;
    // 重新根据字体的大小来计算时间的尺寸
    CGSize timeSize = [time sizeWithfont:ZBStatusCellTimeFont];
    // 重新计算时间的frame
    self.timeLabel.frame = (CGRect){{timeX,timeY},timeSize};
    // 将发微博的时间距离当前的时间的差值赋值给系统的text属性，从而能显示在cell上
    self.timeLabel.text = time;
    
    
    /** 微博的来源途径*/
    // 根据发微博的时间的frame重新计算x值
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + ZBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithfont:ZBStatusCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX,sourceY},sourceSize};
    self.sourceLabel.text = status.source;

    
    /** 正文*/
    self.contentLabel.frame = statusFrame.contentLableFrame;// 设置frame
    self.contentLabel.text = status.text;// 显示正文
    
    
    /** 被转发的微博*/
    if (status.retweeted_status != nil) {// 有值,说明该用转发了微博
        ZBStatus *retweet_status = status.retweeted_status;
         // 拿到转发微博模型中的ZBUser模型
         ZBUser *retweet_status_user = retweet_status.user;
        // 因为是TableView，所以有循环机制，必须得设置YES还有NO,否则数据会错乱
        self.retweetedView.hidden = NO;
        
        /** 被转发微博的整体*/
         // 设置转发微博的昵称和正文的frame .模型中的属性赋值给系统的属性
        self.retweetedView.frame = statusFrame.retweetViewFrame;
        
        
        /** 被转发微博的正文*/
        // 模型中的属性赋值给系统的属性
        self.retweetedContentAndName.frame = statusFrame.retweetContentAndNameFrame;
         // 两个参数分别为转发微博模块中用户的昵称和内容(昵称在ZBUser模型中,内容在ZBStatus中)
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweet_status_user.name,retweet_status.text];
        //将转发微博中用户的昵称和正文赋值给系统的text属性
        self.retweetedContentAndName.text = retweetContent;
        
        
        /** 被转发的微博配图*/
        if (retweet_status.pic_urls.count) {
            self.retweetedPhotosView.frame = statusFrame.retweetPhotosViewFrame;
            ZBPhoto *retweetPhoto = [retweet_status.pic_urls firstObject];
            [self.retweetedPhotosView sd_setImageWithURL:[NSURL URLWithString:retweetPhoto.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetedPhotosView.hidden = NO;
        }else{
            self.retweetedPhotosView.hidden = YES;
        }
    }else{
    
        self.retweetedView.hidden = YES;
    
    }
    
    /** 工具条*/
    self.toolBar.frame = statusFrame.toolBarFrame;
    // 设置数据(将等号右侧的ZBStatus类型的status对象作为参数传递给左侧setStatus1方法)。
     self.toolBar.status1= status;
}

@end
