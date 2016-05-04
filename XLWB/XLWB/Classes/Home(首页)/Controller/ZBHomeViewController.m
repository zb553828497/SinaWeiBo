//
//  ZBHomeViewController.m
//  XLWB
//
//  Created by zhangbin on 16/5/3.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBHomeViewController.h"
#import "ZBTestController.h"
#import "UIBarButtonItem+Extension.h"
@interface ZBHomeViewController ()

@end

@implementation ZBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 必须有self作为参数，这样ZBItemTool类才能拿到self，才能在ZBItemTool类中将self作为addTarget的参数，如果没有self作为参数，ZBItemTool类直接使用self，这个self就是ZBItemTool类的对象
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(friendsearch) image:@"navigationbar_friendsearch" HighlightImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" HighlightImage:@"navigationbar_pop_highlighted"];
   }


-(void)friendsearch{

}
-(void)pop{


}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据----%ld",indexPath.row
                           ];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZBTestController *test = [[ZBTestController alloc] init];
    test.title = @"我是测试控制器1";
    
    test.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test animated:YES];
    
}


@end
