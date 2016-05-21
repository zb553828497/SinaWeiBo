//
//  ZBStatusToolbar.m
//  XLWB
//
//  Created by zhangbin on 16/5/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBStatusToolbar.h"
#import "ZBStatus.h"
@interface  ZBStatusToolbar()

/** btns里面存放工具栏中的3个按钮*/
@property(nonatomic,strong)NSMutableArray *btns;

/** dividers里面存放所有的分割线*/
@property(nonatomic,strong)NSMutableArray *dividers;

@property(nonatomic,weak)UIButton *repostBtn;
@property(nonatomic,weak)UIButton *commentBtn;
@property(nonatomic,weak)UIButton *attitudeBtn;

@end

@implementation ZBStatusToolbar
// 不要忘记实现懒加载方法
-(NSMutableArray *)btns{
    if (_btns == nil) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}
// 不要忘记实现懒加载方法
-(NSMutableArray *)dividers{
    if (_dividers == nil) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}


+(instancetype)toolbar{
    // init调用initWithFrame方法
    return [[self alloc]init];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        // 添加3个子按钮
        self.repostBtn =[self setupBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike"];
        // 添加分割线
        [self setupDivider];
        // 执行两次，为的是让分割线变得明显
        [self setupDivider];
    }
    return self;
}

-(void)setupDivider{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
#warning addSubview和addObject只设置一个不行吗？
    [self addSubview:divider];
    [self.dividers addObject:divider];

}
/**
 *  初始化一个按钮
 *
 *  @param title 按钮中的文字
 *  @param icon  按钮中的图片名
 *
 *  @return 返回一个存有文字和图片名的按钮
 */
-(UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon{
    UIButton *btn = [[UIButton alloc] init];
    //设置子按钮的图片
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    // 设置子按钮的字体
    [btn setTitle:title forState:UIControlStateNormal];
    // 设置子按钮字体的颜色
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    // 设置子按钮的背景图片
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

-(void)layoutSubviews{
    
    // 设置工具栏按钮中的三个子按钮的frame
    
    //btns数组中存放的是工具条中的3个按钮
    int btnCount = self.btns.count;
    // 计算工具条中三个按钮的平均宽度
    CGFloat btnW = self.zb_width / btnCount;
    // 工具条的高度赋值给btnH
    CGFloat btnH = self.zb_height;
    
    for (int i = 0; i < btnCount; i ++) {
//        UIButton *btn = [[UIButton alloc] init];
        UIButton *btn = self.btns[i];
        // 根据下标，计算按钮的x值
        btn.zb_X = i * btnW;
        btn.zb_Y = 0;
        btn.zb_width = btnW;
        // 工具条的高度赋值给下标对应的按钮
        btn.zb_height = btnH;
    }
    // 设置分割线的frame
    int dividerCount = self.dividers.count;
    for (int i = 0; i < dividerCount; i ++) {
        UIImageView *divider = self.dividers[i];
        divider.zb_X = (i + 1) *btnW;
        divider.zb_Y = 0;
        divider.zb_width = 1;
        divider.zb_height = btnH;

    }
    
}
// 给工具栏中的按钮设置数据
-(void)setStatus1:(ZBStatus *)status{
    // setter方法的规范，必须这样赋值
    _status1 = status;
    
    // 转发
    //这里的reposts_count是ZBStatus模型中的一个属性
    [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    // 评论
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];

}
// 封装的方法
-(void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title{
    if (count) {// count有值
    if (count < 10000) {
        // count有值,就把title的名字替换掉，用格式化出来的count表示
        title = [NSString stringWithFormat:@"%d",count];
    }else{
        double tenThousland = count /  10000.0;
        title = [NSString stringWithFormat:@"%.f万",tenThousland];
        // 把字符串里面的.0去掉
        [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
}
    // count没有值，就把title的名字赋值给按钮
    [btn setTitle:title forState:UIControlStateNormal];
}
@end
