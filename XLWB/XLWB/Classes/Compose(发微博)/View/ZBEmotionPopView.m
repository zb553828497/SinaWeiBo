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

@end
