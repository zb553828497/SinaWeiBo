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

@interface ZBStatusCell()
//原创微博

/** 原创微博整体*/
@property(nonatomic,weak)UIView *originalView;

/** 头像*/
@property(nonatomic,weak)UIImageView *iconView;
/** 会员图标*/
@property(nonatomic,weak)UIImageView *vipView;
/** 配图*/
@property(nonatomic,weak)UIImageView *photoView;
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
@property(nonatomic,weak)UIImageView *retweetedPhotoView;


/** 工具条*/
@property(nonatomic,weak)UIView *toolBar;

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

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
// 添加子控件
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
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
    
    UIView *toolb = [[UIView alloc] init];
    toolb.backgroundColor = [UIColor redColor];
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
    UIImageView *PV = [[UIImageView alloc]init];
    
    [All addSubview:PV];
    self.retweetedPhotoView = PV;
}

/**
 *  初始化原创微博
 */
-(void)setupOriginal{
    /** 原创微博整体*/
    UIView *originalView = [[UIView alloc] init];
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
    UIImageView *photoView = [[UIImageView alloc] init];
    [self.contentView addSubview:photoView];
    self.photoView = photoView;
    
    /** 昵称*/
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 发微博的时间*/
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源*/
    UILabel *sourceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文*/
    UILabel *contentLabel = [[UILabel alloc] init];
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
        self.photoView.frame = statusFrame.photoViewFrame;// 设置frame
        #warning 不太懂
        ZBPhoto *photo = [status.pic_urls firstObject];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];// 显示配图
        // 循环利用一定要有 xxxx.hidden = NO； xxxx.hidden = YES;否则数据会错乱
        self.photoView.hidden = NO;
    }else {
        
        self.photoView.hidden = YES;
    
    }

    /** 昵称*/
    self.nameLabel.frame = statusFrame.nameLabelFrame;// 设置frame
    // 模型中的属性(里面存储着数据哦)，赋值给系统的属性，就能把微博的作者显示在当前cell上
    self.nameLabel.text = Oneuser.name;// 显示昵称
    
    /** 发微博的时间*/
    self.timeLabel.frame = statusFrame.timeLabelFrame;// 设置frame
    self.timeLabel.text = status.created_at;// 显示发微博的时间
    
    /** 微博的来源途径*/
    self.sourceLabel.frame = statusFrame.sourceLabelFrame;// 设置frame
    self.sourceLabel.text = status.source;// 显示微博的来源途径
    
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
            self.retweetedPhotoView.frame = statusFrame.retweetPhotoViewFrame;
            ZBPhoto *retweetPhoto = [retweet_status.pic_urls firstObject];
            [self.retweetedPhotoView sd_setImageWithURL:[NSURL URLWithString:retweetPhoto.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetedPhotoView.hidden = NO;
        }else{
            self.retweetedPhotoView.hidden = YES;
        }
    }else{
    
        self.retweetedView.hidden = YES;
    
    }
    
    /** 工具条*/
    self.toolBar.frame = statusFrame.toolBarFrame;
}

@end
