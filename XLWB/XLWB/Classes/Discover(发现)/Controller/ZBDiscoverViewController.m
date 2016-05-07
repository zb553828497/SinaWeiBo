//
//  ZBDiscoverViewController.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBDiscoverViewController.h"
#import "ZBSearchBar.h"
@interface ZBDiscoverViewController ()

@end

@implementation ZBDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZBLog(@"ZBMessageCenterController--viewDidLoad");
    // 导航栏搜索框
    UITextField *searchBar = [ZBSearchBar searchBar];
    searchBar.zb_width = 400;
    searchBar.zb_height = 30;
    self.navigationItem.titleView = searchBar;
}
@end
