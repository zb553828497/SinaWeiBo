//
//  ZBTestController.m
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTestController.h"
#import "ZBTest2Controller.h"
@interface ZBTestController ()

@end

@implementation ZBTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    ZBTest2Controller *test2 = [[ZBTest2Controller alloc] init];
    [self.navigationController pushViewController:test2 animated:YES];
    
    
}

@end
