//
//  ZBComposeToolBar.h
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ZBComposeToolBarButtonTypeCamera,// 拍照
    ZBComposeToolBarButtonTypePicture,// 相册
    ZBComposeToolBarButtonTypeMention,// @
    ZBComposeToolBarButtonTypeTrend, // #
    ZBComposeToolBarButtonTypeEmotion // 表情
}ZBComposeToolBarButtonType;

@class ZBComposeToolBar;

@protocol ZBComposeToolBarDelegate <NSObject>
@optional
-(void)composeToolBar:(ZBComposeToolBar *)toolBar didClickBtn:(ZBComposeToolBarButtonType )type;
@end

@interface ZBComposeToolBar : UIView
@property(nonatomic,weak)id<ZBComposeToolBarDelegate> delegate;




@end
