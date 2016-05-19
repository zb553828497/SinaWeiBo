//
//  ZBTitleButton.m
//  XLWB
//
//  Created by zhangbin on 16/5/15.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTitleButton.h"

@implementation ZBTitleButton

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor]; 导航栏标题TitleView的按钮的背景颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
         // 调用重写的setImage方法，在里面执行[self sizeToFit]
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];

    }
    return self;
}


/**
 *  想要在系统计算和设置完按钮的尺寸之后,再修改以下尺寸,可以用setFrame:方法
 *  重写setFrame:方法的目的:拦截设置按钮尺寸的过程(只要我们设置或者修改按钮的frame,一定会调用重写的setFrame方法)
 *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
 */
-(void)setFrame:(CGRect)frame{
    
    //frame.size.width += 30;// 设置按钮整体宽度增加30
    [super setFrame:frame];
}


// 重写 按钮中设置文字的方法
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    // 只要修改了按钮中的文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

// 重写 按钮中设置图片的方法
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    // 只要修改了按钮中的图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}


// 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中设置位置即可
-(void)layoutSubviews{
    [super layoutSubviews];
    
    // 互换按钮中 文字和图片的位置
    
    // 1.计算titleLabel的frame
    self.titleLabel.zb_X = self.imageView.zb_X;// 图片的x赋值给文字的x
    
    // 2.计算imageView的frame
    self.imageView.zb_X = CGRectGetMaxX(self.titleLabel.frame)  ;// 文字最大的x值赋值给图片的x
    
}
@end
