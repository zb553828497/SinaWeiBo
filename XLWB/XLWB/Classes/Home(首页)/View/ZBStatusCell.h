//
//  ZBStatusCell.h
//  XLWB
//
//  Created by zhangbin on 16/5/19.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBStatusFrame;

@interface ZBStatusCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

// 声明了模型类中的一个属性，那么就拿到了HWStatusFrame类，也就拥有了HWStatusFrame的所有属性和方法。
// 所以HWStatusFrame类中设置的数据模型 + 所有子控件的frame + cell的高度，在HWStatusCell中都能拿到他们
@property(nonatomic,strong)ZBStatusFrame *statusFrame;

@end
