//
//  ZBEmotionPopView.m
//  XLWB
//
//  Created by zhangbin on 16/6/2.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionPopView.h"
#import "ZBEmotionButton.h"

@interface ZBEmotionPopView()
// 一定要导入ZBEmotionButton的头文件

// 为什么要xib中的按钮一定要绑定ZBEmotionButton类。因为ZBEmotionButton类就是显示表情到按钮上的。xib中的这个按钮也是用来显示表情的，并且xib中的按钮和ZBEmotionButton类本质都是UIButton类型.实现的功能都是显示表情的，用ZBEmotionButton有何过错？并且ZBEmotionButton已经封装好了，只要调用emotion接口,就会显示表情到按钮上
// 绑定ZBEmotionButton类，将来将一个表情emotion赋值给ZBEmotionButton类型的对象emotionButton，然后再调用对象的emotion属性，就会跳转至ZBEmotionButton类中，执行setEmotion来将这个表情显示到xib的按钮上.
// 只有赋值给系统的属性，才会将表情显示到xib的按钮上，你调用对象的emotion属性，而emotion属性不是系统的属性，为什么就能够将表情显示到xib的按钮上？因为调用对象的emotion属性，就会调用setEmotion:方法，在setEmotion:方法中，执行系统的setTitle:forState:，所以表情就会显示到xib的按钮上。(的setTitle:forState:是系统的属性).

@property (weak, nonatomic) IBOutlet ZBEmotionButton *emontionButton;


@end

@implementation ZBEmotionPopView

+(instancetype)popView{

    return [[[NSBundle mainBundle] loadNibNamed:@"ZBEmotionPopView" owner:nil options:nil] lastObject];
}


-(void)setEmotion:(ZBEmotion *)emotion{
    _emotion = emotion;
    // 将等号右边的确定的一个表情赋值给关联的emotionButton属性，然后属性又会调用ZBEmotionButton的set方法，将一个表情显示在放大镜上(也就是xib中的"表情按钮")
    self.emontionButton.emotion = emotion;
    
}

-(void)showFrom:(ZBEmotionButton *)btn{
    if (btn == nil) {
        return;
    }
      self.emontionButton.emotion = btn.emotion;
    // 下面代码中出现的self既指当前类的对象，也指 外界谁调用了showFrom:方法，谁就是self.因为外界的self.popView调用了showFrom:方法，而外界的self.popView就是ZBEmotionPopView类型的，所以两个"既指 也指"指的都是同一个对象。只是"也指"是程序员们一起总结总出来的思想。
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 将放大镜添加到最上面的window，也就是屏幕左上角.
    // 目的:保证放大镜显示在所有控件的最上面,不会被其他控件挡住
    [window addSubview:self];
    // 将被点击按钮的坐标原点由ZBEmotionPageView变为屏幕左上角，计算被点击按钮相对于屏幕左上角(window)的frame
    CGRect btnFrame = [btn convertRect:btn.bounds toView:window];
    // 放大镜按钮的中心点X值 = 被点击按钮的中心点X值
    self.zb_centerX = CGRectGetMidX(btnFrame);
    
    // 放大镜按钮的y值 = 被点击按钮的中心点的Y值(屏幕左上角为坐标原点) - 放大镜按钮的高度
    // 细节:放大镜按钮的最大Y值等于被点击按钮中心点的Y值,也就是说放大镜按钮的底部和被点击按钮的中心点在同一水平线上
    self.zb_Y = CGRectGetMidY(btnFrame) - self.zb_height;

}

@end
