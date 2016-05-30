//
//  ZBUser.h
//  XLWB
//
//  Created by zhangbin on 16/5/17.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ZBUserVerifiedTypeNone = -1,// 没有任何认证
    ZBUserVerifiedTypePersonal = 0,// 个人认证
    ZBUserVerifiedTypeOrgEnterprice = 2,// 企业官方：CSDN、EOE、搜狐新闻客户端
    ZBUserVerifiedTypeOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    ZBUserVerifiedTypeOrgWebsite = 5,// 网站官方：猫扑
    ZBUserVerifiedTypeFamous = 220 // 微博达人
    
}ZBUserVerifiedType;
@interface ZBUser : NSObject

/** ￼ string ￼ 字符串型的用户UID*/
@property(nonatomic,copy)NSString *idstr;

/** ￼ string ￼ 友好显示名称*/
@property(nonatomic,copy)NSString *name;

/** ￼ 用户头像地址(中图),50×50像素*/
@property(nonatomic,copy)NSString *profile_image_url;

/** 会员类型 > 2代表是会员  不用为为什么,底层就是这么规定的，我们拿来用就是了*/
@property(nonatomic,assign)int mbtype;
/** 会员等级*/
@property(nonatomic,assign)int mbrank;

@property(nonatomic,assign,getter=isVip)BOOL vip;

/** 认证类型*/
@property(nonatomic,assign)ZBUserVerifiedType verified_type;

@end
