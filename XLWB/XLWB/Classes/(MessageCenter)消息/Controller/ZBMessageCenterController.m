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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];

  }

-(void)composeMsg{
    
    
NSLog(@"%s",__func__);
}
@end
