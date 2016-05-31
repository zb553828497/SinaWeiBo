//
//  ZBMessageCenterController.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBMessageCenterController.h"

@interface ZBMessageCenterController ()

@end

@implementation ZBMessageCenterController

// 注意理解: viewDidLoad是懒加载，用到时才调用。
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];

//ZBLog(@"ZBMessageCenterController--viewDidLoad");
  }
//在控制器的view即将显示的时候，让导航栏右边的按钮不能点击
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //让右边的按钮不能点击
    self.navigationItem.rightBarButtonItem.enabled = NO;


}
-(void)composeMsg{
    
    
// NSLog(@"%s",__func__);
}
@end
