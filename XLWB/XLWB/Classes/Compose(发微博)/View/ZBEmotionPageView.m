
//
//  ZBEmotionPageView.m
//  XLWB
//
//  Created by zhangbin on 16/6/2.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionPageView.h"
#import "ZBEmotion.h"
#import "ZBEmotionButton.h"
#import "NSString+Emoji.h"
#import "ZBEmotionPopView.h"
#import "ZBEmotionTool.h"
@interface ZBEmotionPageView()
/** 点击表情后弹出的放大镜 */
@property(nonatomic,strong)ZBEmotionPopView *popView;
/** 删除按钮*/
@property(nonatomic,weak)UIButton *deleteBtn;
@end

@implementation ZBEmotionPageView


-(ZBEmotionPopView *)popView{
    if (_popView == nil) {
        // 调用popView，就会显示xib中的放大镜控件
        self.popView = [ZBEmotionPopView popView];
    }
    return _popView;

}

// ZBEmotionListView类的setEmotions方法中利用alloc init的形式创建了ZBEmotionPageView的对象，所以会执行下面的initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        // 监听删除按钮的点击
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        // 2.给删除按钮添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
/** 监听删除按钮的点击*/
-(void)deleteBtnClick{
    // 删除按钮被点击之后，删除按钮发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZBEmotionDidDeleteBtnNotification" object:nil];
}

/**
 *  根据手指的位置得到所在的表情按钮
 */
-(ZBEmotionButton *)emotionButtonWithLocation:(CGPoint)location{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        ZBEmotionButton *btn  = self.subviews[i+1];
        if (CGRectContainsPoint(btn.frame,location)) {
            
            // 已经找到手指所在的表情按钮了，就没必要再往下遍历
            return  btn;
        }
    }
    return nil;
}

/**
 *  处理长按手势的操作
 *
 *  @param recognizer
 */
-(void)longPressPageView:(UILongPressGestureRecognizer *)recognizer{
    // 获得手指所在的位置\所在的表情按钮
    CGPoint location = [recognizer locationInView:recognizer.view];
    ZBEmotionButton *btn = [self emotionButtonWithLocation:location];
    // 手势的状态。根据手势的不同状态，来执行不同的操作
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:// 手指不再触摸当前页
             NSLog(@"------------ 手势结束");
            // 手指不在触摸当前页了就把放大镜移除。如果不移除，放大镜一致显示在屏幕上
            [self.popView removeFromSuperview];
            // 手指不再触摸当前页，但是手指仍然在表情按钮上
            if (btn) {
                NSLog(@"------------ 松手了,但手势停留在了表情按钮上");
                
                // 发出通知。目的：插入表情到textView中，并将插入的表情显示到"最近“表情中存储
                [self selectEmotion:btn.emotion];
                
                return;
            }
             NSLog(@"------------ 松手了，并且手势没有停留在表情按钮上");
            break;
         case UIGestureRecognizerStateBegan:// 手势开始(刚检测到长按)
             NSLog(@"------------ 手势开始，按住了表情按钮");
         case UIGestureRecognizerStateChanged:// 手势改变(手指的位置改变)
            NSLog(@"------------ 手势改变，在表情按钮上按住并移动");
            // 目的:手势开始或手势改变就显示放大镜
            [self.popView showFrom:btn];
            break;
            }
}

// 将当前页的20个表情或不足20个表情放到UIButton中
-(void)setEmotions:(NSArray *)emotions{// emotions存储着20个表情或不足20个表情
    _emotions = emotions;
    // 当前页的表情个数
    NSUInteger count = emotions.count;
    for (int i = 0; i< count; i++) {
        ZBEmotionButton *btn = [[ZBEmotionButton alloc] init];
        // 设置表情数据,将emotions数组中的每一个表情赋值给模型emotion
        // 封装思想将表情图片显示在自定义的HWEmotionButton按钮中，只给外界提供一个emotion接口。
        // 一个表情模型绑定一个按钮。例如emotions[2]，第三个表情绑定了点击的第三个按钮
        btn.emotion = emotions[i];
        // 将按钮中存储的表情添加到当前类中
        [self addSubview:btn];
        
        // 监听表情按钮的点击
        [btn addTarget:self action:@selector(EmotionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}
// 计算当前页表情的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    // 内边距(四周)
    CGFloat inset = 20;
    // 用count保存emotions数组中的20个表情或不足20个表情
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.zb_width - 2 * inset) / ZBEmotionEveryPageMaxColums ;
    CGFloat btnH = (self.zb_height - inset ) / ZBEmotionEveryPageMaxRows;
    // count就是20个表情或不足20个表情
    for (int i = 0; i < count;i++) {
        // 取出当前类中的按钮(按钮中有表情哦)
        // self.subviews中的第一个元素是删除按钮哦，因为删除按钮首先在initWithFrame方法中被添加到当前类中，所以想让第一个按钮为表情，就得把i变为i+1，这样第一个表情按钮才会显示在键盘的左上角。
        UIButton *btn = self.subviews[i + 1];
        btn.zb_width = btnW;
        btn.zb_height = btnH;
        // 如果有20个表情，那么20个表情的排布情况如下
        // 第0行表情从左到右对应的下标: 0-6
        // 第1行表情从左到右对应的下标: 7-13
        // 第2行表情从左到右对应的下标:7-19
        btn.zb_X = inset + (i % ZBEmotionEveryPageMaxColums) * btnW;
        btn.zb_Y = inset + (i / ZBEmotionEveryPageMaxColums) * btnH;
    }
    // 删除按钮的frame
    // 因为删除按钮的位置是固定的，即使当前页中只有1个表情，删除按钮也在当前页的右下角
    self.deleteBtn.zb_width = btnW;
    self.deleteBtn.zb_height = btnH;
    self.deleteBtn.zb_Y = self.zb_height - btnH;
    self.deleteBtn.zb_X = self.zb_width - inset - btnW;
    
}
/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
-(void)EmotionBtnClick:(ZBEmotionButton *)btn{// 点击一个表情按钮就会调用，注意:是一个哦。

    /**************************未封装,实现过程暴露的彻彻底底***********************************
    // 最终实现的效果:点击哪个按钮，哪个按钮就会显示在放大镜中的UIImageView上
    
    // 给popView传递数据(传递一个表情)
    // 1.调用popView的懒加载方法，在懒加载方法中显示xib中的放大镜控件
    // 2.调用HWEmotionPopView类的setEmotion方法，并将等号右边的代码作为参数传递进去
    // 3.因为btn.emotion = emotions[i];，所以下面代码等号右边的btn.emotion就是emotions[i],而emotions[i]中存储着20个表情或不足20个表情，因为btnClick:是点击每一个按钮才会调用的，所以emotions[i]中的i每次只能为一个数字，也就是说只能为一个表情，所以步骤2中，参数就是一个表情，所以跳转至ZBEmotionPopView时，传进去一个表情
    self.popView.emotion = btn.emotion; // 根据setEmotions:方法可知bt.emotion等价emotions[i]
     // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 将放大镜添加到最上面的window，也就是屏幕左上角.
    // 目的:保证放大镜显示在所有控件的最上面,不会被其他控件挡住
    [window addSubview:self.popView];
    // 将被点击按钮的坐标原点由ZBEmotionPageView变为屏幕左上角，计算被点击按钮相对于屏幕左上角(window)的frame
    CGRect btnFrame = [btn convertRect:btn.bounds toView:window];
    // 放大镜按钮的中心点X值 = 被点击按钮的中心点X值
    self.popView.zb_centerX = CGRectGetMidX(btnFrame);
    
    // 放大镜按钮的y值 = 被点击按钮的中心点的Y值(屏幕左上角为坐标原点) - 放大镜按钮的高度
    // 细节:放大镜按钮的最大Y值等于被点击按钮中心点的Y值,也就是说放大镜按钮的底部和被点击按钮的中心点在同一水平线上
    self.popView.zb_Y = CGRectGetMidY(btnFrame) - self.popView.zb_height;
     */
    
    /************已封装在showFrom方法,外界无法知道是如何实现的*****************************/
    // 显示放大镜
    [self.popView showFrom:btn];

    
    // 让放大镜过0.25秒后就消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知。目的：插入表情到textView中，并将插入的表情显示到"最近“表情中存储
    [self selectEmotion:btn.emotion];
}
-(void)selectEmotion:(ZBEmotion *)emotion{
    // 将点击的这个表情存进沙盒
    [ZBEmotionTool addRecentEmotion:emotion];
    // 发出通知。目的：插入表情到textView中，并将插入的表情显示到"最近“表情中存储
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // 因为一个表情绑定了一个按钮，所以emotion这个表情对应着一个特定的按钮
    userInfo[@"ZBSelectEmotionKey"] = emotion;
    // postNotificationName:通知的名称
    // object:表示谁发出通知，当参数为nil时,表示匿名发出通知
    // userInfo:字典类型，用于传递额外的数据给监听者
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZBEmotionDidSelectNofication" object:nil userInfo:userInfo];
}
@end
