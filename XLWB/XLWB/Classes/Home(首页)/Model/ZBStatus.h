//
//  ZBStatus.h
//  XLWB
//
//  Created by zhangbin on 16/5/17.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
// 一定写在@interface的上面。
@class ZBUser;
@interface ZBStatus : NSObject


// 返回字段说明

/** ￼ string  字符串型的微博ID*/
@property(nonatomic,copy) NSString *idstr;

/**  string  微博信息内容*/
@property(nonatomic,copy) NSString *text;

/**  object  微博作者的用户信息字段 详细*/
@property(nonatomic,strong)ZBUser *user;

/** string 微博创建时间*/
@property(nonatomic,copy)NSString *created_at;

/** string 微博来源*/
@property(nonatomic,copy)NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property(nonatomic,strong)NSArray *pic_urls;


/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
// 为什么是ZBStatus类型？因为从responseObject返回的内容看retweeted_status也是一个微博，只不过不是原创的微博，而是转发的微博，但是转发的微博也有ID,内容，配图等等，所以转发的微博也是一个模型，并且是ZBStatus模型，因为ZBStatus中的属性包含转发微博中的所有属性。所以为ZBStatus，一点都没有问题。
@property(nonatomic,strong)ZBStatus *retweeted_status;

/** int 转发数*/
@property(nonatomic,assign)int reposts_count;
/** int 评论数*/
@property(nonatomic,assign)int comments_count;
/** int 表态数*/
@property(nonatomic,assign)int attitudes_count;

@end
