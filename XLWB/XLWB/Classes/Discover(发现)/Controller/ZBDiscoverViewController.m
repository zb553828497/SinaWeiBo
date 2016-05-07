//
//  ZBDiscoverViewController.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBDiscoverViewController.h"

@interface ZBDiscoverViewController ()

@end

@implementation ZBDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZBLog(@"ZBMessageCenterController--viewDidLoad");
    // 导航栏搜索框
    UITextField *searchBar = [[UITextField alloc] init];
    searchBar.zb_width = 400;
    searchBar.zb_height = 30;
    searchBar.background = [UIImage imageNamed:@"searchbar_textfield_background"];
    searchBar.font = [UIFont systemFontOfSize:15];
    searchBar.placeholder = @"请输入搜索条件";
    
    // 设置左边的放大镜图标
    UIImageView *searchIcon = [[UIImageView alloc]init];
    searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
    searchIcon.zb_width = 30;
    searchIcon.zb_height = 30;
    // 之所以放大镜图标能居中显示，是因为放大镜图标由两部分组成:1.图标.2.图标后面是白色背景。
    // 是这个背景居中，不是放大镜图标居中.可以通过给这个放大镜图标加背景颜色就可以看出来
    searchIcon.contentMode = UIViewContentModeCenter;
    //searchIcon.backgroundColor = [UIColor redColor];
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    
    // 搜索图标在搜索栏的左侧显示
    searchBar.leftView = searchIcon;
    
    self.navigationItem.titleView = searchBar;
}
@end
