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
#import "ZBDropDownMenu.h"
#import "ZBTitleMenuViewController.h"
#import "ZBAccountTool.h"
#import "ZBTitleButton.h"
#import <MJExtension/MJExtension.h>
#import "ZBUser.h"
#import "ZBStatus.h"
#import <UIImageView+WebCache.h>// 下载图片


#import <AFNetworking/AFNetworking.h>// 向服务器请求数据


@interface ZBHomeViewController ()<ZBDropDownMenuDelegate>
@property(nonatomic,weak)UIButton *titleButton;
/**
 *  微博数组（里面放的都是HWStatus模型，一个HWStatus对象就代表一条微博）
 */
@property(nonatomic,strong)NSMutableArray *statuses;

@end

@implementation ZBHomeViewController

-(NSArray *)statuses{
    
    if (_statuses == nil) {
        self.statuses = [NSMutableArray array];
        
    }
    return _statuses;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获取用户信息(昵称)
    [self setupUserInfo];
    
    // 加载最新的微博数据
  //  [self loadNewStatus];
    // 集成刷新控件
    [self setupRefresh];
}

-(void)setupRefresh{
    UIRefreshControl *Ref = [[UIRefreshControl alloc]init];
    [Ref addTarget:self action:@selector(StateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:Ref] ;
    

}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 *
 *  @param control 用于结束刷新
 */
-(void)StateChange:(UIRefreshControl *)control{
    
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    ZBAccount *account = [ZBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面(时间最新，ID最大)的微博
    ZBStatus *firstStatus = [self.statuses firstObject];
    
//判断firstStatus是否有数据,必须得判断,因为如果没有数据,firstStatus.idstr就为空,给since_id赋空值,程序被崩掉
// 如果判断不满足，则向下执行，把responseObject中的数据显示在cell上。如果满足,则把最新的微博插入到最前面
    if (firstStatus != nil) {
 // 若指定此参数(since_id)，则只返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0.
// 因为上面的代码中,firstStatus是ID最大的微博，又把firstStatus.idstr赋值给了since_id，又因为指定了since_id，则只返回ID比since_id大的微博，所以就保证了不会把之前显示的微博内容再次返回给用户(之前显示的微博内容对应的ID肯定比firstStatus小，因为最前面的微博,ID就是最大的)。这个就是since_id的作用，我们不需要问为什么,底层开发人员就是这么设计的
        params[@"since_id"] = firstStatus.idstr;
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dictArray = responseObject[@"statuses"];
        // 将字典数组转为模型数组
        NSArray *newStatuses = [ZBStatus mj_objectArrayWithKeyValuesArray:dictArray];
        
        
        // 将最新的微博数据，添加到总数组的最前面
        // NSMakeRange的第一个参数:将最新返回的newStatuses插入到大数组的第0个元素的位置，就是最前面的位置
        // NSMakeRange的第二个参数:最新返回的newStatuses中的元素的个数.如果最新返回的数据有3个,则newStatuses.count为3
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuses insertObjects:newStatuses atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [control endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [control endRefreshing];
    }];

}

-(void)loadNewStatus{
    /*
     URL:
     https://api.weibo.com/2/statuses/friends_timeline.json
     
     请求参数:
     
     
     */
    
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    ZBAccount *account = [ZBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"count"] = @20;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"请求成功-%@",responseObject);
       
        // 取得 “微博字典”数组
    // statuses 是服务器返回的responseObject(响应体)中的key，这个key可不能随便写，否则找不到value哦
    // responseObject[@"statuses"]的整体含义:根据key得到的value

        NSArray *dictArray = responseObject[@"statuses"];
        
        // 将字典数组转为模型数组
        for (NSDictionary *dict in dictArray) {
            ZBStatus *status = [ZBStatus objectWithKeyValues:dict];
            [self.statuses addObject:status];
                  }
       // 刷新表格
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败-%@",error);
    }];
    
    
}
/**
 *  获取用户信息(昵称)
 */
-(void)setupUserInfo{
    /*
     URL:
     https://api.weibo.com/2/users/show.json
     
     请求参数:
     ccess_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户ID。
     screen_name	false	string	需要查询的用户昵称。
     */
    
    // 1.请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    
   
    // account方法返回值类型为ZBAccount，所以=左边用ZBAccount类型的对象接收
    ZBAccount *account = [ZBAccountTool account];
   
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // account.access_token 存储着用户的access_token。
    // 相当于等号左边:请求参数access_token这个key，对应等号右边:account.access_token这个value
    params[@"access_token"] = account.access_token;// 简写形式
    // 全写形式: [params setObject:@"account.access_token" forKey:@"access_token"];
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"请求成功%@",responseObject);
        
        NSString *name = responseObject[@"name"];
        // 将导航栏中间的titleView强转成按钮，这样就能修改按钮中的文字还有图片了
        UIButton *titleButton =(UIButton *)self.navigationItem.titleView;
        // 将微博的昵称添加到按钮上
        [titleButton setTitle:name forState:UIControlStateNormal];
        
        // 存储用户昵称到沙盒中
        account.name = name;
        [ZBAccountTool saveAccount:account];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
    }];
}
/**
 *  设置导航栏内容
 */
-(void)setupNav{
    
    // 必须有self作为参数，这样ZBItemTool类才能拿到self，才能在ZBItemTool类中将self作为addTarget的参数，如果没有self作为参数，ZBItemTool类直接使用self，这个self就是ZBItemTool类的对象
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(friendsearch) image:@"navigationbar_friendsearch" HighlightImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" HighlightImage:@"navigationbar_pop_highlighted"];
   
    
    /** 中间的标题按钮*/
    ZBTitleButton *titleButton = [[ZBTitleButton alloc] init];
//    titleButton.zb_width = 150;
//    titleButton.zb_height = 30;
    
    // [ZBAccountTool account]的作用:从沙盒中解档用户信息，得到的返回值是account.account里面有用户信息
    // [ZBAccountTool account].name 其实就是account.name，作用:从用户信息中取出用户的昵称
    NSString *name = [ZBAccountTool account].name;
    // 昵称name如果有值，打印用户的昵称name·，没有值打印"首页"
    // 调用重写的setTitle方法，在里面执行[self sizeToFit]
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 把设置的标题按钮添加到导航栏的titleView中
    self.navigationItem.titleView = titleButton;
    // 如果图片的某个方向上不规则，比如有突起，那么这个方向最好不要拉伸,否则凸起可能消失，或者凸起会移动位置
    // 原因: 保护凸起部位，拉伸图片之后,凸起部位会移动位置。拉伸凸起部位，拉伸图片之后凸起部位会消失
    self.titleButton = titleButton;

    /*
     //2 设置图片和文字的内边距，最终的效果:图片距离左边越来越远，文字距离右边原来越远，所以最终效果,文字在左,图片在右
     // 2.1 图片的内边距，70是距离左边的间距，值越大，距离左边的距离越远，最终图片向右移动
     titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
     // 2.2 文字的内边距，40是距离右边的间距，值越大，距离右边的距离越远，最终文字向左移动
     titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
     
     */

}


/**
 *  标题点击
 */
-(void)titleClick:(UIButton *)titleButton{
    // 1.创建下拉菜单
    ZBDropDownMenu *menu = [ZBDropDownMenu menu];
    // 设置ZBDropDownMenu的代理为当前控制器，如果不写这句，代理方法将不会执行。浪费1小时
    menu.delegate = self;
    
    // 2.设置内容
    ZBTitleMenuViewController *VC = [[ZBTitleMenuViewController alloc] init];
    VC.view.zb_width = 150;
    VC.view.zb_height = 150;
    menu.contentController = VC;
    
    // 3.显示
    [menu Show:titleButton];

}
/**
 *  下拉菜单被销毁了
 */
-(void)DropDownMenuDidDismiss:(ZBDropDownMenu *)menu{
    NSLog(@"箭头朝下");
    // 让箭头向下
    [self.titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

-(void)DropDownMenuDidShow:(ZBDropDownMenu *)menu{
NSLog(@"箭头朝上");
    // 箭头朝上
    [self.titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];

}



-(void)friendsearch{

}
-(void)pop{


}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.statuses.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // 取出这行对应的字典
    ZBStatus *status = self.statuses[indexPath.row];
    
    // 取出这条微博的作者
   ZBUser *user =  status.user;
    cell.textLabel.text = user.name;
    
    // 设置微博的文字
    cell.detailTextLabel.text = status.text;
    
    // 设置头像
    UIImage *placeHD = [UIImage imageNamed:@"avatar_default_small"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:placeHD];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZBTestController *test = [[ZBTestController alloc] init];
    test.title = @"我是测试控制器1";
    
    test.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test animated:YES];
    
}

@end
