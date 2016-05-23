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
    
  // 创建搜索框对象
    ZBSearchBar *searchBar = [ZBSearchBar searchBar];
    searchBar.zb_width = 300;
    searchBar.zb_height = 30;
    self.navigationItem.titleView = searchBar;
  
}
@end
