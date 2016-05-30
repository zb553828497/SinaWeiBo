//
//  ZBDropDownMenu.m
//  XLWB
//
//  Created by zhangbin on 16/5/7.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBDropDownMenu.h"

@interface ZBDropDownMenu ()
/**
 *  灰色图片
 */
@property(nonatomic,weak)UIImageView *containerView;

@end

@implementation ZBDropDownMenu

-(UIImageView *)containerView{
    
    if (_containerView == nil) {
        // 添加带箭头的灰色图片
        UIImageView *c = [[UIImageView alloc] init];
        c.image = [UIImage imageNamed:@"popover_background"];
        // 开启灰色图片的与用户交互的功能
        c.userInteractionEnabled = YES;
        // 将灰色图片添加到当前的ZBDropDownMenu上。
        [self addSubview:c];
        self.containerView = c;
        
    }
    return _containerView;

}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
       // 设置ZBDropdownMenu类的背景颜色为透明色，充满整个屏幕
      // 本质是添加蒙版(用于拦截灰色图片外面的点击事件）.但是因为下面点击屏幕就调用dismiss方法,这一添加蒙版的代码就没有作用了。如果没有调用dismiss方法，请看下面的精华解释
      // 精华:将蒙版设置成透明色，当点击屏幕时，实际上是点击了透明色的蒙版。用户虽然能看到导航栏、tabBar上的东西(蒙版是透明色,所以能看到蒙版后面的东西啊）,但是就是点击不了，用户傻傻的以为点击了他们，却没反应，他们以为这是bug
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;

}

+(instancetype)menu{
    // init本质调用initWithFrame方法。
    return [[self alloc] init];

}

-(void)setContent:(UIView *)content{
    _content = content;
    
    // 调整UITableView内容的位置
    content.zb_X = 10;
    content.zb_Y = 15;
    
    // 设置灰色图片的高度
    self.containerView.zb_height = CGRectGetMaxY(content.frame) + 11;
    
    // 设置灰色图片的宽度
    self.containerView.zb_width = CGRectGetMaxX(content.frame) + 10;
    
    // 添加UITableView到灰色图片
    
    [self.containerView addSubview:content];
    
}
-(void)setContentController:(UIViewController *)contentController{
    
    _contentController = contentController;
    // 把contentController对象的view赋值给ZBDropdownMenu类的对象
    self.content = contentController.view;
    
}
/**
 *  显示
 *
 *  @param titleButton 点击的按钮
 */
-(void)Show:(UIView *)titleButton{
    /*
     如果当前有1个窗口,那么通过.keyWindow这种形式获得的的主窗口，就是显示在屏幕最上面的窗口，因为当前就一个窗口
     如果当前有2个窗口(系统自带的窗口和键盘窗口)，那么如果弹出了键盘， .keyWindow这种形式获得的的主窗口，是键盘窗口，不是系统自带的窗口
     两个窗口放到windows数组中，肯定是有顺序的，序号小的肯定会被序号大的挡住
     总结:以后要想获得主窗口，并且是显示在屏幕最上面的窗口，用.windows lastObject。
     
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     
     */
    // 通过.windows lastObject的形式获得到的的窗口，是目前显示在屏幕最上面的窗口。
    // 因为取得的是windows数组中的最后一个元素，最后的元素是最后显示的，所以会挡住前面显示的窗口
    // 这样滚动tableView，灰色图片就不会跟着移动了
    
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 2.把ZBDropDownMenu的对象添加到窗口上
    [window addSubview:self];
    // 3.设置尺寸.把当前窗口的大小赋值给ZBDropDownMenu
    self.frame = window.bounds;
    
    // 4.调整灰色图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点。可以通过转换坐标系原点，改变frame的参照点,例如改为屏幕左上角为坐标原点
    // 核心+精华+记住:转换坐标系，控件的位置是不变的，变化的只是参照物
    // 转换坐标系:将titleButton.bounds相对于titleButton的坐标,转换成titleButton.bounds相对于window的坐标
    // 例如: A点相对于父控件坐标原点的y值为50，如果将坐标原点改为控制器，A点的位置不变哦，那么此时计算A距离控制器的原点为200。

    
    // 点击了哪个按钮，就把这个按钮相对于父控件的坐标改为相对于窗口的坐标，按钮的位置是不变的哦
    CGRect newFrame = [titleButton convertRect:titleButton.bounds toView:window];
    /*
     将from.frame相对于from.superview的坐标，转换成from.frame相对于window的坐标
     等价于 CGRect newFrame = [titleButton.superview convertRect:titleButton.frame toView:window];
     */
    
    // 将转换坐标系之后，系统重新计算得到的坐标,取出点击按钮时,按钮的中心点的X坐标，赋值给灰色图片的中心点坐标的x的值。保证了灰色图片的中心点和按钮的中心点一致。这样灰色图片中间的三角就能和按钮的中心点在一条竖线上了
    self.containerView.zb_centerX = CGRectGetMidX(newFrame);
    // 将转换坐标系之后，系统重新计算得到的坐标，获得按钮的最大Y值，赋值给灰色图片的y值
    self.containerView.zb_Y = CGRectGetMaxY(newFrame);
    
    
    // 通知外界的代理，自己显示了
    if ([self.delegate respondsToSelector:@selector(DropDownMenuDidShow:)]) {
        [self.delegate DropDownMenuDidShow:self];
    }
}
/**
 *  销毁
 */
-(void)dismiss{
    [self removeFromSuperview];
    
    // 通知代理，自己被销毁了。
    // 目的:改变标题的图片按钮方向
    if([self.delegate respondsToSelector:@selector(DropDownMenuDidDismiss:)]){
        // 通过代码最后面的self 理解代理的作用   传值？？
        [self.delegate DropDownMenuDidDismiss:self];
    }
}
// 点击屏幕，移除当前的ZBDropdownMenu。这样就能点击之前被ZBDropdownMenu覆盖的界面了
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];

}
@end
