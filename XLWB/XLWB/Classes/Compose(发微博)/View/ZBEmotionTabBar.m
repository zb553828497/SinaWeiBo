//
//  ZBEmotionTabBar.m
//  XLWB
//
//  Created by zhangbin on 16/5/31.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionTabBar.h"
#import "ZBEmotionTabBarButton.h"

@interface ZBEmotionTabBar()
// 记录选中的按钮
@property(nonatomic,weak)ZBEmotionTabBarButton *RecordSelectedBtn;
@end

@implementation ZBEmotionTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpBtn:@"recent" buttonType:ZBEmotionTabBarButtonTypeRecent];
        [self setUpBtn:@"默认" buttonType:ZBEmotionTabBarButtonTypeDefault];
        [self setUpBtn:@"Emoji" buttonType:ZBEmotionTabBarButtonTypeEmoji];
        [self setUpBtn:@"浪校花" buttonType:ZBEmotionTabBarButtonTypeLxh];
    }
    return self;
}
/**
 *  创建键盘底部的按钮
 *
 *  @param title      按钮的名称
 *  @param buttonType 按钮的类型
 *
 *  @return   为什么是ZBEmotionTabBarButton类型?因为btn是类型，所以返回值类型为ZBEmotionTabBarButton
 */
- (ZBEmotionTabBarButton *)setUpBtn:(NSString *)title buttonType:(ZBEmotionTabBarButtonType)buttonType{
    // 创建键盘底部的按钮
    ZBEmotionTabBarButton *btn = [[ZBEmotionTabBarButton alloc] init];
    // 监听键盘底部按钮的点击    UIControlEventTouchDown:按下去的时候,按钮的反应
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    // 将按钮添加到当前类中
    [self addSubview:btn];
//    // 打开表情键盘，默认就选中"默认"按钮
//    if (buttonType == ZBEmotionTabBarButtonTypeDefault) {
//        [self btnClick1:btn];
//    }
    
    // 设置键盘底部按钮的背景图片
    if(self.subviews.count == 1){// 因为键盘底部按钮是一个一个加到当前类中的，所以当 当前类的数组中元素为1个时，就表示当前方法是添加第一个按钮的，所以满足self.subviews.count == 1,就将图片显示在键盘底部的第一个位置
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_left_selected"] forState:UIControlStateDisabled];
    }else if (self.subviews.count == 4){// 当 当前类的数组中元素为4个时，表示这个方法是添加第四个按钮的，所以满足self.subviews.count == 4，就将图片显示在键盘底部的第四个位置
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_right_selected"] forState:UIControlStateDisabled];
    }else{// 当 当前类的数组中元素为2或者3个时，将图片显示在键盘底部的第二个位置和第三个位置
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_selected"] forState:UIControlStateDisabled];
    }
    
    return btn;
}
// 布局键盘底部的按钮的位置
-(void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.zb_width / btnCount;
    CGFloat btnH = self.zb_height;
    for (int i = 0; i < btnCount; i ++) {
        ZBEmotionTabBarButton *btn = self.subviews[i];
        btn.zb_width = btnW;
        btn.zb_height = btnH;
        btn.zb_X = i * btnW;
        btn.zb_Y = 0;
    }
    
}
// 重写delegate的setter方法 ，解决点击键盘/表情图标时，没有显示"默认"对应的表情

/* 
 原理:
 1.ZBEmotionKeyboard类成为ZBEmotionTabBar的代理，即tabBar.delegate = self;
 2.就会调用delegate的setter方法，在setter方法里面，让实参view绑定一个名为ZBEmotionTabBarButtonTypeDefault的tag，调用btnClick1:方法时，把view传递给形参
 3.在btnClick1:中，self.delegate此时有值，因为重写了setDelegate就是赋值操作，即_delegate = delegate。
 4.如果不重写setDelegate:方法，而将调用btnClick1:方法的代码写在上面的setUpBtn:buttonType:方法中时,self.delegate没有值，为空，所以就造成了点击键盘/表情图标时，没有显示"默认"对应的表情
 */
 -(void)setDelegate:(id<ZBEmotionTabBarDelegate>)delegate{
    
    _delegate = delegate;
    // 强转成ZBEmotionTabBarButton类型
    ZBEmotionTabBarButton *view = (ZBEmotionTabBarButton *)[self viewWithTag:ZBEmotionTabBarButtonTypeDefault];
    
    // 选中"默认"按钮
    [self btnClick1:view];
}


/**
 *  按钮点击
 */
-(void)btnClick1:(ZBEmotionTabBarButton *)btn{
    // 让RecordSelectedBtn变为YES，这次没有什么作用，下次才有用
    self.RecordSelectedBtn.enabled = YES;// 代码1
    // 点击键盘底部的某个按钮后，让这个按钮变为不可点击状态
    btn.enabled = NO;
    // 让RecordSelectedBtn记录这个按钮是不可点击状态。只有当下次执行到代码1时才会变为可以点击的状态
    self.RecordSelectedBtn = btn;
    
    // 代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:btn.tag];
    }
    
}



@end
