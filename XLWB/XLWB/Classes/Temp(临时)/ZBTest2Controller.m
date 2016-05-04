//
//  ZBTest2Controller.m
//  XLWB
//
//  Created by zhangbin on 16/5/4.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTest2Controller.h"
#import "UIBarButtonItem+Extension.h"
@interface ZBTest2Controller ()

@end

@implementation ZBTest2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"查看" style:0 target:self action:@selector(test2)];
}
-(void)test2{

NSLog(@"---");
}



@end
