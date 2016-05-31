//
//  ZBProfileViewController.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBProfileViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "ZBTestController.h"
@interface ZBProfileViewController ()

@end

@implementation ZBProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:0 target:self action:@selector(setting)];
    
     }

-(void)setting{
    
    ZBTestController *test = [[ZBTestController alloc] init];
    test.title = @"设置界面";
    [self.navigationController pushViewController:test animated:YES];

}



@end
