//
//  ZBStatusFrame.h
//  XLWB
//
//  Created by zhangbin on 16/5/19.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 昵称字体*/
#define ZBStatusCellNameFont [UIFont systemFontOfSize:15]
/** 时间字体*/
#define ZBStatusCellTimeFont [UIFont systemFontOfSize:12]
/** 微博来源途径字体*/
#define ZBStatusCellSourceFont [UIFont systemFontOfSize:12]
/** 正文字体*/
#define ZBStatusCellContentFont [UIFont systemFontOfSize:14]

@class ZBStatus;
@interface ZBStatusFrame : NSObject
//  一个HWStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型HWStatus(所以导入了HWStatus类，并声明了给这个类声明了一个status属性)
// 总结:HWStatusFrame模型中又包含一个HWStatus模型。HWStatusFrame模型存放着数据模型 + 所有子控件的frame + cell的高度。 HWStatus模型存放着文字数据+图片数据。总之整体都是在HWStatusFrame模型类中。
// 总结: 1,2,3全部满足,缺一不可,则cell的内容就会显示在屏幕上。



/** 数据模型HWStatus*/
@property(nonatomic,strong)ZBStatus *status;

/** 原创微博整体 */
@property(nonatomic,assign)CGRect originalViewFrame;
/** 头像 */
@property(nonatomic,assign)CGRect iconViewFrames;
/** 会员图标 */
@property(nonatomic,assign)CGRect vipViewFrame;
/** 配图*/
@property(nonatomic,assign)CGRect photoViewFrame;
/** 昵称*/
@property(nonatomic,assign)CGRect nameLabelFrame;
/** 发微博的时间*/
@property(nonatomic,assign)CGRect timeLabelFrame;
/** 发微博的来源、途径*/
@property(nonatomic,assign)CGRect sourceLabelFrame;
/** 正文*/
@property(nonatomic,assign)CGRect contentLableFrame;
/** Cell的高度*/
@property(nonatomic,assign)CGFloat cellHeight;
@end
