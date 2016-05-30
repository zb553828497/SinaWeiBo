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
#import "ZBStatusCell.h"
#import "ZBStatusFrame.h"

#import <AFNetworking/AFNetworking.h>// 向服务器请求数据


@interface ZBHomeViewController ()<ZBDropDownMenuDelegate>
@property(nonatomic,weak)UIButton *titleButton;
/**
 *  微博数组（里面放的都是ZBStatusFrame模型，一个ZBStatusFrame对象就代表一条微博）
 */
@property(nonatomic,strong)NSMutableArray *statusesFrames;

@end

@implementation ZBHomeViewController

-(NSArray *)statusesFrames{
    
    if (_statusesFrames == nil) {
        self.statusesFrames = [NSMutableArray array];
        
    }
    return _statusesFrames;
}

/**
 *  将ZBStatus模型转为ZBStatusFrame模型
 */
/*
 Q:为什么将ZBStatus模型转为ZBStatusFrame模型?
 
 A1:因为一个ZBStatusFrame模型里面声明了很多属性(详细看ZBStatusFrame.h文件)。这些属性的整体作用(1,2,3):
 1.存放着一个cell内部所有子控件的frame数据
 2.存放一个cell的高度
 3.存放着一个数据模型ZBStatus
 
 A2:ZBStatusFrame模型包括ZBStatus模型.
 因为ZBStatusFrame模型类中声明了ZBStatus类型的一个属性，那么就拿到了ZBStatus类，也就拥有了ZBStatus的所有属性和方法
 也就是说ZBStatus模型中有的属性,ZBStatusFrame中有,ZBStatus没有的属性,ZBStatusFrame也有.
 
 A3:ZBStatusFrame的很多属性的综合作用，具备了能将从新浪服务器请求来的数据精确的显示到cell的指定位置(因为.h文件中有设置frame的属性、有设置cell的高度的属性)
 ZBStatus中的属性只能将从新浪服务器请求来的数据显示到cell上，但是位置无法确定(因为.h文件没有设置frame的属性)
 
 A4:这是模型开发,我们是从模型中的属性中拿到数据，然后显示到cell上
 ZBStatus中有5个属性，我们只能在cell上显示五个内容
 ZBStatusFrame中有10多个属性，我们可以在cell上显示10多个内容
 
 A5:总结:
    转成ZBStatusFrame模型,我们既能将从服务器请求来的数据显示到cell上，也能将数据放到cell的指定位置，更能指定每个cell的高度。外界不需要设置位置和cell的高度
    转成ZBStatus模型模型，我们只能将从服务器请求来的数据放到cell上，但是位置不确定,cell的高度也不确定.只能通过外界来设置位置和cell的高度。
 
 */

// 抽取一个stausFramesWithStatuses类,将具体实现的代码写在外面,简化代码。你写在里面也行,不过乱罢了.
-(NSArray *)statusFrameWithStatuses:(NSArray *)statuses{
    NSMutableArray *frames = [NSMutableArray array];
    // 遍历 statuses中的每一个元素，放到ZBStatus类型的status中,遍历一次，就调用f的set方法,也就是setStatus:方法，就将status作为方法的参数传递进去,这样参数也是ZBStatus类型的
    for (ZBStatus *sta in statuses) {
        ZBStatusFrame *statusFrame = [[ZBStatusFrame alloc] init];
        //调用statusFrame对象的set方法，也就是setStatus:,
        // 在setStatus:方法中,计算frame，将来用于给系统的frame赋值
        statusFrame.status =sta;
        // 此时的statusFrame对象里面已经计算好了要显示的控件的frame，并将对象添加到frames中
        [frames addObject:statusFrame];
    }
    return frames;
}
// 想让TableView的背景颜色变为灰色时,发现ZBTabBarController.m文件中的 childVc.view.backgroundColor = bgColor;会覆盖掉灰色，所以就注释掉了那句代码，但是就出现了导航栏中间的标题不居中的bug。解决办法:将TableView设置灰色的代码放在viewWillApper中
-(void)viewWillAppear:(BOOL)animated{
self.tableView.backgroundColor = ZBColor(211, 211, 211);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(ZBCellMargin, 0,0, 0);
    // 设置导航栏内容
    [self setupNav];
    
    // 获取用户信息(昵称)
    [self setupUserInfo];
    
    // 加载最新的微博数据。 不需要了。因为下面的setupDownRefresh方法也实现了这个功能
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


/**
 *  下拉刷新
 */
// 只会调用1次。因为setupRefresh是viewDidLoad中的方法，viewDidLoad方法只会调用1次，所以他里面的方法也只会调用一次
-(void)setupDownRefresh{
    // 1.添加刷新控件
    UIRefreshControl *Ref = [[UIRefreshControl alloc]init];
    // 只有用户通过手动下拉刷新(注意)，才会触发UIControlEventValueChanged事件,否则不执行loadNewStatus:
    [Ref addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:Ref] ;
    // 2.程序运行,自动进入刷新状态(仅仅是显示刷新状态,并不会触发UIControlEventValueChanged事件)
    // 只会调用1次
    [Ref beginRefreshing];
    // 3.程序运行自动调用loadNewStatus方法加载最新数据。
    // 只会调用1次，以后不会再调用.因为本质上这些方法是在viewDidLoad中调用的。又因为整个过程只会执行一次viewDidLoad方法，所以loadNewStatus:方法从始至终只会调用一次
    [self loadNewStatus:Ref];
    // 注意:有两段代码有重复的loadNewStatus:方法，这里你就认为这两个方法不一样就行，只是因为代码太多了，所以将下拉刷新时调用的方法和程序初始运行时调用的方法整合在一块了(主要是因为两个方法上面的注释太精华了,要保证两个方法上面的解释是正确的，所以我提到了这个注意点)
}


/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 *
 *  @param control 用于结束刷新
 */
-(void)loadNewStatus:(UIRefreshControl *)control{
    /*
     URL:   https://api.weibo.com/2/statuses/friends_timeline.json
     
     返回字段:
     
     created_at                 string               微博创建时间
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
     retweeted_status           object               被转发的原微博信息字段，当该微博为转发微博时返回 
     reposts_count              int                  转发数
     comments_count             int                  评论数
     attitudes_count            int                  表态数
     mlevel                     int                  暂未支持
     visible                    object               微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
     
     pic_ids(改为pic_urls)       object               微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
     
     ad                         object array         微博流内的推广微博ID
     
     */
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    ZBAccount *account = [ZBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面(时间最新，ID最大)的微博
    ZBStatusFrame *firstStatus = [self.statusesFrames firstObject];// 注意
    
    //判断firstStatus是否有数据,必须得判断,因为如果没有数据,firstStatus.idstr就为空,给since_id赋空值,程序被崩掉
    // 如果判断不满足，则向下执行，把responseObject中的数据显示在cell上。如果满足,则把最新的微博插入到最前面
    if (firstStatus != nil) {
        // 若指定此参数(since_id)，则只返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0.
        // 因为上面的代码中,firstStatus是ID最大的微博，又把firstStatus.idstr赋值给了since_id，又因为指定了since_id，则只返回ID比since_id大的微博，所以就保证了不会把之前显示的微博内容再次返回给用户(之前显示的微博内容对应的ID肯定比firstStatus小，因为最前面的微博,ID就是最大的)。这个就是since_id的作用，我们不需要问为什么,底层开发人员就是这么设计的
        params[@"since_id"] = firstStatus.status.idstr;
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 取得 “微博字典”数组
        // statuses 是服务器返回的responseObject(响应体)中的key，这个key可不能随便写，否则找不到value哦
        // responseObject[@"statuses"]的整体含义:根据key得到的value
        NSArray *dictArray = responseObject[@"statuses"];
        //ZBLog(@"%@",responseObject);
        // 将字典数组转为模型数组
        // 这句代码之后，新浪微博服务器返回的数据存到了ZBStatus模型类的对应的各个属性中
        NSArray *newStatuses = [ZBStatus mj_objectArrayWithKeyValuesArray:dictArray];
        
        // newFrames数组拿到等号右侧返回过来的newStatuses数组。
        // 抽出来stausFramesWithStatuses，具体怎么执行，在stausFramesWithStatuses方法中
        
       // 等号右边返回过来的已经计算好控件的frames 赋值给等号左边的newFrames,然后添加到statusesFrames数组的里面
   
    /*
    newFrames里面既有数据，又有frame(位置+尺寸)。
    1.newStatuses的数据是把新浪服务器的数据利用MJ字典转模型得到的,赋值给newFrames,所以newFrames里面也有数据
    2.newStatuses作为statusFrameWithStatuses方法的参数，在方法里面计算数据的frame(尺寸+位置)，然后赋值给newFrames,所以newFrames里面有数据的frame(尺寸和位置）
    */
         NSArray *newFrames = [self statusFrameWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        // NSMakeRange的第一个参数:将最新返回的newStatuses插入到大数组的第0个元素的位置，就是最前面的位置
        // NSMakeRange的第二个参数:最新返回的newStatuses中的元素的个数.如果最新返回的数据有3个,则newStatuses.count为3
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        // 将具有数据和frame的newFrames对象添加到statusesFrames数组中的第0个位置
        [self.statusesFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        // 刷新表格(内部调用数据源方法numberOfRowsInSection、cellForRowAtIndexPath等,把内容显示在cell上)
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
 *  上拉刷新
 */

-(void)setupUpRefresh{
    
    ZBLoadMoreFooter *footer = [ZBLoadMoreFooter footer];
    // 程序初始运行,就会显示xib中的内容，所以为了不让它显示，先隐藏起来，实际上是存在的
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

/**
 *  上拉加载更多数据
 */
-(void)loadMoreStatus{

    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    ZBAccount *account = [ZBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博.这个微博相对于下面的微博，当然是最新的微博，ID最大的微博
    ZBStatusFrame *lastStatusFrame = [self.statusesFrames lastObject];
    if (lastStatusFrame != nil) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusFrame.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 将字典数组转为模型数组
        NSArray *newStatuses = [ZBStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        NSArray *newFrames = [self statusFrameWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusesFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏tabBar)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];

}

/**
 *  微博的未读数
 */

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


// 不用设置代理，直接就可以打出来这个方法。
// scrollView只要滚动就会调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.statusesFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) {
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.statusesFrames.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    // 获得cell
    ZBStatusCell *cell = [ZBStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.statusFrame= self.statusesFrames[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ZBTestController *test = [[ZBTestController alloc] init];
//    test.title = @"我是测试控制器1";
//    
//    test.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:test animated:YES];
//    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBStatusFrame *fram = self.statusesFrames[indexPath.row];
    return fram.cellHeight;
}

@end
