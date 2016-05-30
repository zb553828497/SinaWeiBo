//
//  ZBComposeController.m
//  XLWB
//
//  Created by zhangbin on 16/5/30.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBComposeController.h"
#import "ZBAccountTool.h"
#import "ZBTextView.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ZBComposeController()
@property(nonatomic,weak)ZBTextView *textView;
@end


@implementation ZBComposeController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏内容
    [self setUpNav];
    // 添加输入控件
    [self setUpTextView];

    
    
}
// 在控制器的view即将显示的时候，让导航栏右边的按钮不能点击,并且显示灰色。
// 如果是在viewDidLoad方法中设置导航栏右边的按钮不能点击，按钮的颜色始终为橙色。
// 本质原因:在ZBNavigationController.m文件中设置了不可点击时的按钮颜色，只有在viewWillAppear方法中设置按钮不可点击，才会去调用ZBNavigationController.m中的代码，从而让按钮变为灰色。
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //让右边的按钮不能点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
}
/**
 *  设置导航栏内容
 */
-(void)setUpNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
   // self.navigationItem.rightBarButtonItem.enabled = NO;
    //self.navigationItem.rightBarButtonItem.
    NSString *name = [ZBAccountTool account].name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.zb_width = 200;
        titleView.zb_height = 100 ;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.zb_X = 50;
        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        //创建一个带有属性的字符串(比如颜色属性、字体属性等)
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加字体属性(NSFontAttributeName)，用来 改变"发微博"字体的尺寸
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        // 添加字体属性(NSFontAttributeName)，用来改变"丶斌先生"字体的尺寸
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:[str rangeOfString:name]];
        // 添加颜色属性(NSFontAttributeName)，用来改变"丶斌先生"字体的颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    }else{
        self.title = prefix;
    }
   
}
/**
 *  添加输入控件
 */
-(void)setUpTextView{
   // 问题1:
   /* 
    发微博时，控件不能用UITextView,因为不能换行,并且是居中显示,有placeholder属性，
    而UITextView可以换行，并且是在紧贴导航栏显示，但是没有placeholder属性。
    那么如何让UITextView有UITextView的placeholder属性的(占位文字)功能呢？
    答:
    1.创建一个继承UITextView的类，并声明两个属性，但是仅仅声明两个属性是没有效果的，必须在.m文件中实现功能.
    2.我们再在.m文件中利用drawRect方法，在方法中用到了两个属性并利用draw画出文字利用drawRect画一个占位文字。
    
    
    拓展:UITextField和UITextView的区别
    
    UITextField:
    1.文字永远是一行，不能显示多行文字
    2.有placehoder属性设置占位文字
    3.继承自UIControl
    4.监听行为的3种方式
    1> 设置代理
    2> addTarget:action:forControlEvents:
    3> 通知:UITextFieldTextDidChangeNotification
    
    UITextView:
    1.能显示任意行文字
    2.不能设置占位文字
    3.继承自UIScollView
    4.监听行为的2种方式
    1> 设置代理
    2> 通知:UITextViewTextDidChangeNotification
   */
    
    // 问题2:
    /*
    1. A控件有contentInset属性+A控件所处的控制器有导航栏/UITabBar,A控件一定会自动向下移动64/向上移动49像素吗？
    答:一定是的,无论什么控制器,例如下面的这些控制器
    (UIViewController,UITableViewController,UICollectionViewController,UINavigationController)
    都有automaticallyAdjustsScrollViewInsets属性，并且默认是打开的.
    因为任何控制器最终都是继承UIViewController,而automaticallyAdjustsScrollViewInsets是UIViewController中的属性，所以说任何控制器都有自动调整内边距的功能。
    
    2. 如何关闭控制器的自动调整内边距的功能呢？
    答: self.automaticallyAdjustsScrollViewInsets = NO;// self代表的是控制器的对象
    
    3. 总结+精华:A控件自动向下偏移64像素/向上偏移49像素的条件:
    条件1:A控件必须有contentInset属性
    条件2:A控件所处的类必须是控制器--->因为控制器才有automaticallyAdjustsScrollViewInsets属性。
    条件3:A控件所处的类必须是控制器,并且控制器必须有导航栏/UITabBar
    综合条件1，条件2，条件3:automaticallyAdjustsScrollViewInsets+contentInset+导航栏/UITabBar,三者缺一不可，同时作用才会使用A控件偏移一定的像素，使A控件不会被导航栏/UITabBar挡住
    */
    
    // 问题3:
    /*
    因为UITextView继承UIScrollView，UIScrollView有contentInset属性.
    1.当UITextView所处的控制器有导航栏时，UITextView会自动将内容向下移动64像素，所以文字正好在导航栏下面顶格显示，而不是在屏幕左上（苹果就是这么挺智能的为用户考虑，目的就是防止文字被导航栏挡住嘛).
    2.当UITextView所处的控制器没有导航栏时，UITextView才在屏幕左上角显示.
    3.当控件为不是继承UIScrollView，那么就没有contentInset属性，这样系统想把你的内容向下移动，也没法移动，因为你没有contentInset属性.
    4.当控件为UIScrollView或者继承UIScrollView，这个控件在显示的时候如果会被UINavigationBar、UITableBar、UIToolbar挡住时，那么这个控件会自动调整它的内边矩属性，移动多少距离，就要是看被导航栏挡住还是被UITabBar挡住，最终的结果是使这个控件不会被他们挡住。如果被导航栏挡住，那么控件向下偏移64像素，如果被UITabBar挡住，那么控件向上偏移49像素.    
     */
    
    ZBTextView *textView = [[ZBTextView alloc] init];
   
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    self.textView = textView;
    [self.view addSubview:textView];
    
    // 让控制器监听文字改变的通知(addobserver的参数就是监听者),实现导航栏右边的发送按钮可以点击/不可点击
// object中最的参数表示只监听textview的点击。结果:只要textview中有文字的输入，那么就执行textChangedToControlSend方法，在这个方法中，实现了发送按钮能点击/不可点击。会了这个你就知道通知也就是那么回事
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangedToControlSend) name:UITextViewTextDidChangeNotification object:textView];
    
}
#pragma mark - 监听方法
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 点击发送按钮,进行发微博
-(void)send{
    // URL: https://api.weibo.com/2/statuses/update.json
    /* 参数:
                    必选    类型及范围	说明
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     status         true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     visible        false	int     微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
     list_id        false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
     lat            false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
     long           false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
     annotations	false	string	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
     rip            false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
     
     */
    // 1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [ZBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    // 3.发送请求
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showWithStatus:@"发布成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
    
}
/**
 *  监听文字改变
 */
-(void)textChangedToControlSend{
    // textView有文字,那么self.textView.hasText为YES，所以导航栏右侧的导航条设置为可点击状态.没有文字，不可点击
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}


@end
