//
//  ZBOAuthViewController.m
//  XLWB
//
//  Created by zhangbin on 16/5/12.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBOAuthViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIWindow+SwitchRootVC.h"
#import <SVProgressHUD/SVProgressHUD.h>

#import "ZBAccountTool.h"
@interface ZBOAuthViewController ()<UIWebViewDelegate>

@end

@implementation ZBOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建一个webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    // 2.用webView加载登录页面（新浪提供的）

    
    /* 
     请求地址:https://api.weibo.com/oauth2/authorize
     
     请求参数:
    client_id	    true	string	申请应用时分配的AppKey。
    redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     
     
    redirect_uri这个回调地址，不设置时，默认为http://

     查看新浪微博回调地址如下步骤:
     1.http://open.weibo.com/
     2.点击"我的应用"
     3.打开应用名"ZBXLWB"
     4.点击应用信息
     5.点击高级信息
     6.在“OAuth2.0 授权设置”选项中，找到"授权回调页"
     7.默认为http://,你也可以自定义设置
     
     client_id的目的：运行模拟器时，能显示项目的名字
     redirect_uri的目的:授权成功之后,才会进入redirect_uri指定的url.
     
     新浪微博官网的授权回调页就是：模拟器的授权中存储的链接
     新浪微博官网的取消授权回调页: 模拟起的取消张存储的链接
     
     
    App Key：2862394703
    App Secret：c3e8864d690cfa5759798295a2f2c424
    */
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2862394703&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];


}


#pragma mark - UIWebViewDelegate代理

// 登陆界面加载成功,2秒后弹框消失
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [SVProgressHUD dismiss];
    });
  
}
// 加载登陆界面时，弹框提示
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载登陆界面🐷"];
}
// 加载网页失败，弹框提示
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}

// 程序初始运行时,会提前执行一次，因为这时候还没有输入账号和密码，所以不执行if (range.length != 0) {}的内容
// 当你输入用户名和密码，然后点击登录按钮(请求加载数据)时，也会调用，这次range有值,所以会执行{}的内容,在{}又会调用accessTokenWithCode方法。
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 拦截URL
    
    // 1.获得URL
    NSString *url = request.URL.absoluteString;
    
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        // 截取code=后面的参数值
        int fromIndex = range.location + range.length;// 不懂
        NSString *code = [url substringFromIndex:fromIndex];
      //  ZBLog(@"%@      %@",code,url);
        
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调地址
        return  YES;
    }
    
    
   // ZBLog(@"shouldStartLoadWithRequest--%@",request.URL.absoluteString);
    
        return  YES;
}

/**
 *  点击登录按钮时，才调用这个方法.因为这个方法是在shouldStartLoadWithRequest方法中
 *  利用code(授权成功后的request token) 换取一个accessToken
 */
-(void)accessTokenWithCode:(NSString *)code{
  
   /*
    URL   https://api.weibo.com/oauth2/access_token
    
    请求参数
    client_id	     true	  string	申请应用时分配的AppKey。
    client_secret	 true	  string	申请应用时分配的AppSecret。
    grant_type	     true	  string	请求的类型，填写authorization_code
    code             true	  string	调用authorize获得的code值。
    redirect_uri	 true	  string	回调地址，需需与注册应用里的回调地址一致。
    */
    
    /*
     向服务器请求数据时候提示unacceptable content-type: text/plain" 的解决办法:
     1.找到AFN框架自带的类：AFURLResponseSerialization.h"
     2.搜索 @"text/json"
     3.增加 @"text/plain"
     4.完毕
     */
    
    /*
    
     "access_token" = "2.00_7_m_DVc_iHD3f4deb56d5j2cR8D";这个令牌中包含两个信息:应用信息和用户信息
     作用:一个用户给一个应用授权成功后，就会获得唯一对应的access_token。这样这个应用就可以访问这个用户的信息
     例子：3个不同的用户给4个不同的应用授权成功后,会获得12个不同的access_token。因为是一一对应的关系
     
     uid = 3040663291
     作用：1个用户对应一个uid
     例子：3个不同的用户给4个不同的应用授权成功后,会获得个3不同的uid
     
     access_token和uid区别:
     一个用户 + 一个应用 = access_token
     一个用户 = uid
     
     */
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"2862394703";// 简写形式
    //全写形式:  [params setObject:@"2862394703" forKey:@"client_id"];
   
    params[@"client_secret"] = @"c3e8864d690cfa5759798295a2f2c424";
    params[@"grant_type"] = @"authorization_code";// 固定。官方文档让写这个
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.baidu.com";
    // 发送POST请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //ZBLog(@"请求成功-%@",responseObject);
        
        // 字典转模型
        ZBAccount *account = [ZBAccount accountWithDict:responseObject];
        // 存储账号信息，存进沙盒
        [ZBAccountTool saveAccount:account];
        
        /*
         系统的字典，数组，字符串这些类，可以使用对象调用writeToFile方法，将对象中的数据写入沙盒中。
         自定义的类，不能使用对象调用writeToFile方法，所以就不能将对象中的数据存入沙盒
         
         那么如何将自定义的类ZBAccount如何使用它的对象将数据存入沙盒中呢？
         答:利用NSKeyedArchiver,可以将对象中包含的数据存入沙盒.
         最重要的三点:
         1.ZBAccount必须遵守<NSCoding>协议，
         2.ZBAccount.m要实现encodeWithCoder方法.
         3.ZBAccount.m要实现initWithCoder方法.
         设置全局断点检测错误时,如果不实现2方法，就会报如下错误
         -[ZBAccount encodeWithCoder:]: unrecognized selector sent to instance 0x7fd0d9c29e50
         设置全局断点检测错误时,如果不实现3方法，就会报如下错误
         -[ZBAccount initWithCoder:]: unrecognized selector sent to instance 0x7f9399609b60
         */
        
        // 沙盒路径
//        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *path = [doc stringByAppendingPathComponent:@"account.plist"];
//        ZBLog(@"%@",path);
        // 将返回的账号数据，存进沙盒
//        [responseObject writeToFile:path atomically:YES];
       
        
        
        /*
        不能使用这句代码，因为这句代码获得的窗口不是ZBOauthViewController，而是显示在最外面的键盘窗口.
         通过打印window可知，获得的窗口是UITextEffectsWindow，就是键盘的窗口。所以window此时是键盘。
         要实现vc1是当前窗口的根控制器，窗口必须是控制器。因为键盘不是控制器，所以会提示错误。
         
         所以应该通过.keyWindow的形式获得当前窗口.这个窗口不一定是显示在最外面的窗口，这个窗口是由你决定的.
         通过window.rootViewController = vc1;的形式，获得的窗口就是ZBTabBarController
         通过window.rootViewController = vc2;的形式，获得的窗口就是ZBNewFeatureController
         
         UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        NSLog(@"%@",window);
         // 打印的内容
        <UITextEffectsWindow: 0x7f89ba4afd80; frame = (0 0; 414 736); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x7f89ba491640>>
         */
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
      
        [window switchRootViewController];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        ZBLog(@"请求失败-%@",error);
    }];
    
}














@end
