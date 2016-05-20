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
    return self;
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
}

@end
