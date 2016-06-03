//
//  ZBEmotionPopView.h
//  XLWB
//
//  Created by zhangbin on 16/6/2.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBEmotion;
@class ZBEmotionButton;
@interface ZBEmotionPopView : UIView

// 用于加载xib中的控件
+(instancetype)popView;
// 让ZBEmotionPopView控件显示一个表情，就得给ZBEmotionPopView控件声明一个模型属性，外界通过调用这个模型属性的set方法来将一个表情传递给这个属性，这样声明的模型属性 就存储着一个表情。
// 详细:     ZBEmotionPageView类中的btnClick:方法，在方法中执行self.popView.emotion = btn.emotion;来给ZBEmotionPopView类中emotion属性传递一个表情。一定是一个表情，不可能大于一个，因为只有点击某一个表情按钮才会调用btnClick:
@property(nonatomic,strong)ZBEmotion *emotion;// 一个放大镜就对应一个表情

-(void)showFrom:(ZBEmotionButton *)btn;

@end
