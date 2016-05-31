//
//  ZBComposeToolBar.m
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBComposeToolBar.h"
@interface ZBComposeToolBar()
@property(nonatomic,strong)UIButton *emotionButton;
@end



@implementation ZBComposeToolBar


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        // 初始化工具条上的按钮
        // 高亮状态和选中状态的区别:高亮就是点击亮一下，松手之后就不亮了。选中状态就是点了之后亮，松手之后仍然亮
        
        [self setUpBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:ZBComposeToolBarButtonTypeCamera];
        [self setUpBtn:@"compose_toolbar_picture"   highImage:@"compose_toolbar_picture_highlighted" type:ZBComposeToolBarButtonTypePicture];
        [self setUpBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:ZBComposeToolBarButtonTypeMention];
        [self setUpBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:ZBComposeToolBarButtonTypeTrend];
        // 在点击键盘图标和表情图标的时候，为什么self.emotionButton去掉就不能实现切换两个图标了呢(第4点经典)
        /* 精华解释:
         1.程序初始运行，viewDidload方法调用setUpToolBar方法，然后会执行等号右侧的代码，接着调用setUpBtn:highImage:type:方法，将表情图标显示到工具条的确定位置上(因为最终会执行layoutSubviews确定表情图标的位置)，通过将等号右边的表情图标赋值给等号左边的self.emotionButton。那么程序初始运行时，self.emotionButton就存储着已经确定位置的表情图标。
         2.当你准备切换键盘图标/表情图标时，就会执行switchKeyboard方法，然后就会执行setShowKeyboardButton:方法,在setShowKeyboardButton:方法中,通过判断,然后再重新给self.emotionButton赋键盘图标/表情图标
         3.因为self.emotionButton之前已经确定了位置，所以切换键盘图标/表情图标，图标会显示在确定的位置上(一定是工具条的最后一个位置)。如果没有下面这句赋值的代码，切换的图标显示的位置谁也不知道显示在哪里，并且按钮的大小也不知道。
         4.ZBComposeToolBar的self.emotionButton，表面上看并没有进行all init操作，但是在程序的setUpBtn:highImage:type:方法中已经执行了alloc init操作，并且创建的对象btn返回给 self.emotionButton，这样self.emotionButton就间接的执行了分配了存储空间并创建对象的操作
         */
        self.emotionButton =[self setUpBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:ZBComposeToolBarButtonTypeEmotion];
    }
    return self;
}
/**
 *  在工具条上创建按钮
 *
 *  @param image     普通图片
 *  @param highImage 高亮图片
 *  @param type      图片类型
 */
-(UIButton *)setUpBtn:(NSString *)image highImage:(NSString *)highImage type:(ZBComposeToolBarButtonType)type {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    // 监听工具条上按钮的点击
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 一个按钮对应一个类型
    btn.tag = type;
    
    // 5张图片放在工具条ZBComposeToolBar中
    [self addSubview:btn];
    return btn;
}

// 布局工具条中的5个按钮
-(void)layoutSubviews{
    [super layoutSubviews];
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    // self.zb_width就是外界(ZBComposeController类的setUpToolBar方法中)传递过来的屏幕的宽度
    CGFloat btnW = self.zb_width / count;
    // self.zb_height是外界(ZBComposeController类的setUpToolBar方法中)传递过来的44【已验证】
    CGFloat btnH = self.zb_height;
    for (NSUInteger i = 0; i < count; i ++) {
        UIButton *btn = self.subviews[i];
        btn.zb_X = i * btnW;
        btn.zb_Y = 0;
        btn.zb_width = btnW;
        btn.zb_height = btnH;
    }
}
/**
 *  监听工具条上按钮的点击
 *
 *  @param button      UIButton类的对象
 *  参数的类型由谁决定呢？答:不是由addTarget后面的self决定的，而是由self监听的那个对象决定，self监听的对象就是工具条上的按钮，也就是btn，因为btn是UIButton类型的，所以参数的类型为UIButton

 */
-(void)btnClick:(UIButton *)button{
    //如果ZBComposeToolBar类的代理对composeToolBar:didClickBtn:方法有响应，就执行括号里面的内容(调用代理方法)
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickBtn:)]) {
        // 通过上面的 btn.tag = type;可知，btn.tag对应唯一的一个按钮的类型
        [self.delegate composeToolBar:self didClickBtn:button.tag];
    }

}
-(void)setShowKeyboardButton:(BOOL)showKeyboardButton{
    _showKeyboardButton = showKeyboardButton;
    
    // 方式1
    if (showKeyboardButton) {// showKeyboardButton为YES，表示显示键盘图标
    [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }else{// showKeyboardButton为NO，表示显示表情图标
    [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
   
    /* 方式2
         NSString *image = nil;
         NSString *highImage = nil;
         // 显示键盘图标
         if (showKeyboardButton) {
         image = @"compose_keyboardbutton_background";
         highImage = @"compose_keyboardbutton_background_highlighted";
         }else{
         // 显示表情图标
         image = @"compose_emoticonbutton_background";
         highImage = @"compose_emoticonbutton_background_highlighted";
         }
         
         // 设置图片
         [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
         [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
     */
   
        
   }


@end
