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
    
    // 监听文字改变的通知,实现导航栏右边的发送按钮可以点击/不可点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangedToControlSend) name:UITextViewTextDidChangeNotification object:textView];
    
}
#pragma mark - 监听方法
-(void)cacel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send{

}
/**
 *  监听文字改变
 */
-(void)textChangedToControlSend{
    // textView有文字,那么self.textView.hasText为YES，所以导航栏右侧的导航条设置为可点击状态.没有文字，不可点击
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}


@end
