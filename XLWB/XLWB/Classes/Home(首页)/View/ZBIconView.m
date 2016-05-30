//
//  ZBIconView.m
//  XLWB
//
//  Created by zhangbin on 16/5/24.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBIconView.h"
#import <UIImageView+WebCache.h>
// 一定要导入ZBUser.h
#import "ZBUser.h"
@interface ZBIconView()
@property(nonatomic,weak)UIImageView *verifiedView;
@end

@implementation ZBIconView
// 懒加载的方式创建认证图片的控件。(注意是控件哦，创建出来的仅仅是一个没有内容的控件)
-(UIImageView *)verifiedView{
    if (_verifiedView == nil) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self == nil) {
        
    }
    return self;
}



- (void)setEveryuser:(ZBUser *)Everyuser{
    _Everyuser = Everyuser;
    // 1.下载图片，将来作为用户的头像显示
    [self sd_setImageWithURL:[NSURL URLWithString:Everyuser.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 2.设置认证(加V)图片，将来加在用户头像的右下角显示
    switch (Everyuser.verified_type) {
        case ZBUserVerifiedTypePersonal:// 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
         case ZBUserVerifiedTypeOrgEnterprice:
            case ZBUserVerifiedTypeOrgMedia:
            case ZBUserVerifiedTypeOrgWebsite:// 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            case ZBUserVerifiedTypeFamous:// 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
        default:
            self.verifiedView.hidden = YES;// 没有任何认证
            break;
    }
    
}
// 只布局认证图片的位置即可。因为认证图片还没有设置显示的位置，而用户的头像在外界已经固定好位置了，不需要设置显示的位置。
- (void)layoutSubviews{
    [super layoutSubviews];
    //认证图片的原始尺寸赋值给认证图片最终显示的尺寸
    self.verifiedView.zb_size = self.verifiedView.image.size;
    
    CGFloat scale = 0.6;
    /* 在ZBstatusCell中有self.iconView.frame = statusFrame.iconViewFrames;
     因为iconViewFrames(头像的位置+尺寸)已经在ZBStatusFrame类中确定了(头像宽高为35)，所以赋值给等号左边的iconView时,iconView也为35,所以如下代码的self.zb_width， 其中self就是iconView，为35
     */
    // 认证图片的X值 = 头像的宽度 - 认证图片的宽度 * 0.6
    self.verifiedView.zb_X = self.zb_width - self.verifiedView.zb_width  * scale;
    // 认证图片的Y值 = 头像的高度 - 认证图片的高度 * 0.6
    self.verifiedView.zb_Y = self.zb_height - self.verifiedView.zb_height * 0.6;
}
@end
