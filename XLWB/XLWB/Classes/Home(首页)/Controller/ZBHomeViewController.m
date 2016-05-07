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
#import "ZBSearchBar.h"
@interface ZBHomeViewController ()

@end

@implementation ZBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 必须有self作为参数，这样ZBItemTool类才能拿到self，才能在ZBItemTool类中将self作为addTarget的参数，如果没有self作为参数，ZBItemTool类直接使用self，这个self就是ZBItemTool类的对象
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(friendsearch) image:@"navigationbar_friendsearch" HighlightImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" HighlightImage:@"navigationbar_pop_highlighted"];
    
    ZBLog(@"ZBMessageCenterController--viewDidLoad");
    
    /** 中间的标题按钮*/
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.zb_width = 150;
    titleButton.zb_height = 30;

    // 方法1:设置按钮:文字在左，图片在右。默认文字在右，图片在左边
    
    //方法2:设置按钮:文字在左,图片在右边
    
    [titleButton setTitle:@"首页" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    //2 设置图片和文字的内边距，最终的效果:图片距离左边越来越远，文字距离右边原来越远，所以最终效果,文字在左,图片在右
    // 2.1 图片的内边距，70是距离左边的间距，值越大，距离左边的距离越远，最终图片向右移动
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    // 2.2 文字的内边距，40是距离右边的间距，值越大，距离右边的距离越远，最终文字向左移动
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 把设置的标题按钮添加到导航栏的titleView中
    self.navigationItem.titleView = titleButton;
    // 如果图片的某个方向上不规则，比如有突起，那么这个方向最好不要拉伸,否则凸起可能消失，或者凸起会移动位置
    // 原因: 保护凸起部位，拉伸图片之后,凸起部位会移动位置。拉伸凸起部位，拉伸图片之后凸起部位会消失
    
    
    
    
   }
/**
 *  标题点击
 */
-(void)titleClick{
    /*
     如果当前有1个窗口,那么通过.keyWindow这种形式获得的的主窗口，就是显示在屏幕最上面的窗口，因为当前就一个窗口
     如果当前有2个窗口(系统自带的窗口和键盘窗口)，那么通过.keyWindow这种形式获得的主窗口，不是显示在屏幕最上面的窗口,而是被键盘窗口挡住
     两个窗口放到windows数组中，肯定是有顺序的，序号小的肯定会被序号大的挡住
     总结:以后要想获得主窗口，并且是显示在屏幕最上面的窗口，用.windows lastObject。
     
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     
     */
    // 通过.windows lastObject的形式获得到的的窗口，是目前显示在屏幕最上面的窗口。
    // 因为取得的是windows数组中的最后一个元素，最后的元素是最后显示的，所以会挡住前面显示的窗口
    // 这样滚动tableView，灰色图片就不会跟着移动了
    UIWindow  *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 添加蒙版(用于拦截灰色图片外面的点击事件）
    UIView *cover = [[UIView alloc] init];
    
    // 精:将蒙版设置成透明色，并将蒙版添加到window上。当点击TableView时，实际上是点击了透明色的蒙版。用户虽然能看到TableView上、导航栏、tabBar上的东西(蒙版是透明色,所以能看到蒙版后面的东西啊）,但是就是点击不了，用户傻傻的以为点击的是TableView、导航栏、tabBar
    cover.backgroundColor = [UIColor clearColor];
    // 把当前窗口的大小赋值给蒙版的大小
    
    cover.frame = window.bounds;
    
    // 将蒙版添加到当前的窗口上
    [window addSubview:cover];
    
    // 添加带箭头的灰色图片
    UIImageView *dropdownMenu = [[UIImageView alloc] init];
    dropdownMenu.image = [UIImage imageNamed:@"popover_background"];
    dropdownMenu.zb_width = 217;
    dropdownMenu.zb_height = 217;
    dropdownMenu.zb_Y = 40;
    [dropdownMenu addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    // 将灰色图片添加到当前的窗口上。
    //灰色图片肯定是在蒙版的上面，根据程序执行顺序或者窗口数组中的元素下标，下标越大，越显示在最外面
    [window addSubview:dropdownMenu];


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
