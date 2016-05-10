//
//  ZBTitleMenuViewController.m
//  XLWB
//
//  Created by zhangbin on 16/5/9.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBTitleMenuViewController.h"

@interface ZBTitleMenuViewController ()

@end

@implementation ZBTitleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"好友";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"密友";
    }else if(indexPath.row == 2){
    cell.textLabel.text = @"全部";
    
    }
    return cell;
}

@end
