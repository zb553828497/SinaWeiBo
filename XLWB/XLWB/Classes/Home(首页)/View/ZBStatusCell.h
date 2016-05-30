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

// 声明了模型类中的一个属性，那么就拿到了ZBStatusFrame类，也就拥有了ZBStatusFrame的所有属性和方法。
// 所以ZBStatusFrame类中设置的数据模型 + 所有子控件的frame + cell的高度，在ZBStatusCell中都能拿到他们
@property(nonatomic,strong)ZBStatusFrame *statusFrame;

@end
