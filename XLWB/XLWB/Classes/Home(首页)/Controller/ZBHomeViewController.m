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
#import "ZBLoadMoreFooter.h"


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
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    // 获得未读数(每隔5秒钟调用setupUnreadCount方法,也就是每隔60秒钟给新浪服务器发送一个请求,这个请求就是获取某个用户的各种消息未读数)
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(UnReadCount) userInfo:nil repeats:YES];
    
    // 写上这句代码,主线程也会执行NSTimer当中的任务（不管主线程是否正在其他事件）.
    // 如果没有这句代码，当主线程正在处理其他事件时(例如滚动UITableView时，调用scrollViewDidScroll方法),就不会执行NSTimer的setupUnreadCount方法。
    // 因为正常情况下,主线程是串行执行任务的。如果正在处理A任务，只有当A任务处理完，才会处理B任务
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)UnReadCount{
    /*
     
     URL: https://rm.api.weibo.com/2/remind/unread_count.json
     
     返回字段说明:
     status         int     新微博未读数
     follower       int     新粉丝数
     cmt            int     新评论数
     dm             int     新私信数
     mention_status	int     新提及我的微博数
     mention_cmt	int     新提及我的评论数
     group          int     微群消息未读数
     private_group	int     私有微群消息未读数
     notice         int     新通知未读数
     invite         int     新邀请未读数
     badge          int     新勋章数
     photo          int     相册消息未读数
     msgbox         int     {{{3}}}
     
     */
    
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    ZBAccount *account = [ZBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送网络请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        /* 面向字典开发
         
         // 微博的未读数。对象转成整形。对象就是responseObject[@"status"],从返回的结果可以看出来，也就是NSNumber.  整形就是intValue。  所以这行句代码也就等价于 NSNumber转成整形
         int status = [responseObject[@"status"] intValue];
         
         // 设置提醒数字(将未读数赋给badgeValue，就能在tabBar上显示数字了)
         self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
         
         */
        
        
        //设置提醒数字(微博的未读数)
        // status这个key的作用:新微博未读的数量
        //因为responseObject[@"status"]这个对象里面装的是NSNumber,所以这行代码就是NSNumber转成NSString。
        // 以后NSNumber转NSString，直接调用description方法即可。
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            // 清空tabBar图标当中的提醒数字
            self.tabBarItem.badgeValue = nil;
            // 清空app应用图标当中的提醒数字
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{
            // 把提醒数字显示到tabBar的图标上
            self.tabBarItem.badgeValue = status;
       
            
            
            // 把提醒数字显示到app的应用图标上
            //因为applicationIconBadgeNumber是NSInteger类型，所以必须把字符串类型的status转成整形,调用intValue的getter方法
            UIApplication *app = [UIApplication sharedApplication];
            
            // iOS 8 系统要求设置通知的时候必须经过用户许可。
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            
            [app registerUserNotificationSettings:settings];
            // 把status代表的微博未读数赋值给应用程序右上角的"通知图标"Badge
            app.applicationIconBadgeNumber = status.intValue;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

-(void)setupUpRefresh{
    
    ZBLoadMoreFooter *footer = [ZBLoadMoreFooter footer];
    // 程序初始运行,就会显示xib中的内容，所以为了不让它显示，先隐藏起来，实际上是存在的
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

-(void)loadMoreStatus{

    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    ZBAccount *account = [ZBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博.这个微博相对于下面的微博，当然是最新的微博，ID最大的微博
    ZBStatus *lastStatus = [self.statuses lastObject];
    if (lastStatus != nil) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatus.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 将字典数组转为模型数组
        NSArray *newStatuses = [ZBStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将更多的微博数据，添加到总数组的最后面
        [self.statuses addObjectsFromArray:newStatuses];
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏tabBar)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];

}


// 只会调用1次。因为setupRefresh是viewDidLoad中的方法，viewDidLoad方法只会调用1次，所以他里面的方法也只会调用一次
-(void)setupDownRefresh{
    // 1.添加刷新控件
    UIRefreshControl *Ref = [[UIRefreshControl alloc]init];
    // 只有用户通过手动下拉刷新(注意)，才会触发UIControlEventValueChanged事件,否则不执行StateChange:
    [Ref addTarget:self action:@selector(StateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:Ref] ;
    // 2.程序运行,自动进入刷新状态(仅仅是显示刷新状态,并不会触发UIControlEventValueChanged事件)
    // 只会调用1次
    [Ref beginRefreshing];
    // 3.程序运行自动调用StateChange方法加载最新数据。
    // 只会调用1次，以后不会再调用.因为本质上这些方法是在viewDidLoad中调用的。又因为整个过程只会执行一次viewDidLoad方法，所以StateChange:方法从始至终只会调用一次
    [self StateChange:Ref];
    
    
}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 *
 *  @param control 用于结束刷新
 */
-(void)StateChange:(UIRefreshControl *)control{
    /*
         URL:   https://api.weibo.com/2/statuses/friends_timeline.json
     
     返回字段:
     
     created_at	string	微博创建时间
     id                         int64                微博ID
     mid                        int64                微博MID
     idstr                      string               字符串型的微博ID
     text                       string               微博信息内容
     source                     string               微博来源
     favorited                  boolean              是否已收藏，true：是，false：否
     truncated                  boolean              是否被截断，true：是，false：否
     in_reply_to_status_id      string              （暂未支持）回复ID
     in_reply_to_user_id        string              （暂未支持）回复人UID
     in_reply_to_screen_name	string              （暂未支持）回复人昵称
     thumbnail_pic              string               缩略图片地址，没有时不返回此字段
     bmiddle_pic                string               中等尺寸图片地址，没有时不返回此字段
     original_pic               string               原始图片地址，没有时不返回此字段
     geo                        object               地理信息字段 详细
     user                       object               微博作者的用户信息字段 详细
     retweeted_status           object               被转发的原微博信息字段，当该微博为转发微博时返回 详细
     reposts_count              int                  转发数
     comments_count             int                  评论数
     attitudes_count            int                  表态数
     mlevel                     int                  暂未支持
     visible                    object               微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
     
     pic_ids                    object               微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
     
     ad                         object array         微博流内的推广微博ID
     
     */
    
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
        
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [control endRefreshing];
    }];
    
}
/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
-(void)showNewStatusCount:(int)count{
    
    // 刷新成功,则清空tabBar图标当中的提醒数字
    self.tabBarItem.badgeValue = nil;
    // 刷新成功，则清空app应用图标当中的提醒数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.zb_width = [UIScreen mainScreen].bounds.size.width;
    label.zb_height = 35;
    
    // 2.设置其他属性
    if(count == 0){
    label.text = @"没有新的数据,请稍后再试";
    }else{
        label.text = [NSString stringWithFormat:@"共有%d条新的微博数据",count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.zb_Y = 64 - label.zb_height;
    //[self.tableView addSubview:label]; // label会跟随tableview滚动,不满足要求
    //[self.navigationController.view addSubview:label];// label会挡住航控制器的view,不满足要求
    
    // 将label插入到导航栏的下面(below)，tableView的上面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    
    // 先利用1s的时间,让label往下移动一段距离
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        
        //等价  label.zb_Y += label.zb_height;
        label.transform = CGAffineTransformMakeTranslation(0, label.zb_height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0;
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            // 等价  label.zb_Y -=label.zb_height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
      // 总结:如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
    
}

-(void)loadNewStatus{
    /*
     URL:
     https://api.weibo.com/2/statuses/friends_timeline.json
     
     返回字段:同StateChange方法里面的内容
     
     
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
// 不用设置代理，直接就可以打出来这个方法。
// scrollView只要滚动就会调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.statuses.count == 0 || self.tableView.tableFooterView.isHidden == NO) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;

    CGFloat judgeOffsetY = scrollView.contentSize.height  - scrollView.zb_height;
    //NSLog(@"%lf",scrollView.contentInset.bottom);
    if (offsetY >= judgeOffsetY) {
        self.tableView.tableFooterView.hidden = NO;
        // 加载更多微博数据
        [self loadMoreStatus];
    }
    
}

@end
