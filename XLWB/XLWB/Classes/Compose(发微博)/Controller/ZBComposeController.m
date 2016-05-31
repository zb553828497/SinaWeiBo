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
#import "ZBComposeToolBar.h"
#import "ZBComposePhotosView.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>


@interface ZBComposeController()<UITextViewDelegate,ZBComposeToolBarDelegate,UIImagePickerControllerDelegate>
/** 输入控件*/
@property(nonatomic,weak)ZBTextView *textView;
/** 键盘顶部的工具条*/
@property(nonatomic,weak)ZBComposeToolBar *toolbar;
/** 相册(存放拍照或者相册中选择的图片)*/
// ZBComposePhotosView就是用来封装图片的，外界只需要调用接口就可以用来存储图片
@property(nonatomic,weak)ZBComposePhotosView *photosView;

@end


@implementation ZBComposeController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏内容
    [self setUpNav];
    // 添加输入控件
    [self setUpTextView];
    // 添加工具条
    [self setUpToolBar];
    
    // 创建真实类型为UIView的控件用来放图片
    [self setupPhotosView];
}
/**
 *  创建真实类型为UIView的控件用来放图片
 */
-(void)setupPhotosView{
    ZBComposePhotosView *photosView = [[ZBComposePhotosView alloc] init];
    photosView.zb_Y = 100;
    // 随便写的，只要宽度和高度能够容纳图片就行
    photosView.zb_width = self.view.zb_width;
    photosView.zb_height = self.view.zb_height;
    // 将photosView添加到textView中.photosView是用来放图片的控件
    [self.textView addSubview:photosView];
    //photosView.backgroundColor = [UIColor redColor];
    self.photosView = photosView;
}

/**
 *  添加工具条
 */
-(void)setUpToolBar{
    ZBComposeToolBar *toolBar = [[ZBComposeToolBar alloc] init];
    toolBar.zb_width = self.view.zb_width;
    toolBar.zb_height = 44;
    toolBar.zb_Y = self.view.zb_height - toolBar.zb_height;
    // 当前控制器成为ZBComposeToolBar的代理，监听工具条中按钮的点击
    toolBar.delegate = self;
    //不应该将工具条加在键盘上，否则键盘消失,工具条也消失。解决办法:将工具条添加到控制器中。然后再让控制器监听键盘的弹出，当键盘弹出来，利用动画让工具条移动到键盘的上面
       [self.view addSubview:toolBar];

    self.toolbar = toolBar;
    /*
     inputAccessoryView:设置显示在键盘顶部的内容
     self.textView.inputAccessoryView = toolbar;// 效果:将工具条添加到键盘顶部
     
     inputView:设置弹出的view,会覆盖掉默认弹出的键盘。
     self.textView.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];// 弹出加号按钮
     */
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
   // 垂直方向上有弹簧效果.这样才能滚动textView，才会执行scrollViewWillBeginDragging代理方法实现退出键盘，如果不设置，键盘无法退出。
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    self.textView = textView;
    textView.delegate = self;
    [self.view addSubview:textView];
    
    // 让控制器监听文字改变的通知(addobserver的参数就是监听者),实现导航栏右边的发送按钮可以点击/不可点击
// object中最的参数表示只监听textview的点击。结果:只要textview中有文字的输入，那么就执行textChangedToControlSend方法，在这个方法中，实现了发送按钮能点击/不可点击。会了这个你就知道通知也就是那么回事
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedToControlSend) name:UITextViewTextDidChangeNotification object:textView];
 
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    //    UIKeyboardWillChangeFrameNotification
    //    UIKeyboardDidChangeFrameNotification
    // 键盘显示时发出的通知
    //    UIKeyboardWillShowNotification
    //    UIKeyboardDidShowNotification
    // 键盘隐藏时发出的通知
    //    UIKeyboardWillHideNotification
    //    UIKeyboardDidHideNotification

    // 让控制器监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  键盘的frame发生改变时调用（显示、隐藏等）
 *
 *  @param Notification:  NSNotification类的对象，这个对象中包含着键盘的信息.
 *  参数的类型由谁决定呢？答:不是由addObserver决定的(即不是由当前控制器决定的)，而是由控制器监听的那个对象决定，控制器监听的对象就是通知，也就是[NSNotificationCenter defaultCenter].因为[NSNotificationCenter defaultCenter]是NSNotification类型的，所以参数的类型为NSNotification
 */
-(void)keyBoardWillChangeFrame:(NSNotification *)Notification{
    //ZBLog(@"%@",Notification); //打印键盘的相关信息
    /* 打印关键语句:
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间(系统底层设定的，默认为0.25秒)
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    
    
    // userInfo是NSDictionary类型，所以用NSDictionary类型的userInfo接收
    NSDictionary *userInfo = Notification.userInfo;
    // 动画的持续时间
    // 取出字典userInfo中 key为UIKeyboardAnimationDurationUserInfoKey对应的value，value就是duration
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    // 取出字典userInfo中 key为UIKeyboardFrameEndUserInfoKey对应的value，value就是keyboardFrame
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    // 利用动画实现键盘弹出,工具条也跟着弹出;键盘退出工具条也跟着退出。在动画的block里，让工具条的y值等于键盘的y值减去工具条的高度，正是因为这个赋值语句，才实现了工具条和键盘紧紧相连，并且一动都用。一不动都不动。

    [UIView animateWithDuration:duration animations:^{
            // 键盘的y值>当前控制器的高度，也就是相当于键盘隐藏了
           if (keyboardFrame.origin.y > self.view.zb_height) {
            //键盘隐藏后，无论键盘隐藏到什么位置，始终要让工具条紧紧贴着屏幕底部（也就是tabbar的位置），防止如果键盘隐藏到y值为2000的时候，工具条会隐藏到y值为1956的位置(看不见的位置)。
            self.toolbar.zb_Y = self.view.zb_height - self.toolbar.zb_height;
        }else{// 键盘的y值<当前控制器的高度，也就是相当于键盘出现在手机屏幕上了
            self.toolbar.zb_Y = keyboardFrame.origin.y - self.toolbar.zb_height;
        }
        ZBLog(@"%@",NSStringFromCGRect(self.toolbar.frame));
    }];

}
-(void)dealloc{
    // 移除观察者self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 监听方法
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 点击发送按钮,进行发微博
-(void)send{
    // photos是ZBComposePhotosView类中的属性，是用来存储图片的。
    // photos有图片的情况:执行了代理方法imagePickerController-->addPhoto:-->[self.photos addObject:photo]
    if(self.photosView.photos.count){
        // 发布有图片的微博
        [self sendWithImage];
    }else{
        // 发布无图片的微博
        [self sendWithoutImage];
    }
  }
/**
 *  发布有图片的微博
 */
-(void)sendWithImage{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    /* 参数:
                    必选    类型及范围  说明
     source         false   string    采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
     access_token	false	string    采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     status         true	string	  要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     visible        false	int	      微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
     list_id        false	string	  微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
     pic            true	binary	  要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     lat            false	float	  纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
     long           false	float	  经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
     annotations	false	string	  元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
     rip            false	string	  开发者上报的操作用户真实IP，形如：211.156.0.1。
     
     */
    
    // 1.请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [ZBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在constructingBodyWithBlock这个block中拼接图片的二进制数据,是系统能识别这个上传的二进制图片
        // 从photos可变数组中取出第一个元素(第一张图片)
        UIImage *image = [self.photosView.photos firstObject];
        // 上传的图片转为NSData类型 .第二个参数为图片的压缩质量
        NSData *data = UIImageJPEGRepresentation(image,1.0);
        // 拼接图片的二进制数据
        // name的参数是服务器给出的字段，必须写为pic.
        // filename的参数是指:你要上传的图片名在新浪服务器中以test.jpg显示
        // mineType:上传的图片的类型
        [formData appendPartWithFileData:data name:@"pic" fileName:@"zb.jpg" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
    // 4. 点击取消/发送按钮就会，移除当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *  发布无图片的微博
 */
-(void)sendWithoutImage{
    
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
    // 3.发送请求  get请求一般是从服务器拿数据，post请求一般是把数据上传到服务器/更新服务器中的数据
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
    // 4. 点击取消/发送按钮就会，移除当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];

}

/**
 *  监听文字改变
 */
-(void)textChangedToControlSend{
    // textView有文字,那么self.textView.hasText为YES，所以导航栏右侧的导航条设置为可点击状态.没有文字，不可点击
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}




//  只要滚动scrollView就会调用
//  监听zbtextview的滚动的目的是:当滚动zbtextview时，我想要退出键盘。可以利用监听来实现这个效果。如何监听？利用代理delegate实现监听
//  调用前提:遵守UITextViewDelegate协议+让控制器成为textView的代理+实现scrollViewWillBeginDragging方法.缺一不可.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 在代理方法中调用endEditing方法来退出键盘
    [self.view endEditing:YES];
}

#pragma mark - ZBComposeToolBarDelegate
-(void)composeToolBar:(ZBComposeToolBar *)toolBar didClickBtn:(ZBComposeToolBarButtonType)type{
    switch (type) {
        case ZBComposeToolBarButtonTypeCamera:// 拍照
            [self openCamera];
            break;
        case ZBComposeToolBarButtonTypePicture:// 相册
            [self openAlbum];
            break;
            
        case ZBComposeToolBarButtonTypeMention:// @
            ZBLog(@"@");
            break;
        
        case ZBComposeToolBarButtonTypeTrend: //#
            ZBLog(@"#");
            break;
            
        case ZBComposeToolBarButtonTypeEmotion: // 表情键盘
            ZBLog(@"表情键盘");
            break;
          }

}
/** 打开照相机*/
-(void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

/** 打开相册*/
-(void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        return;
    }
    // 图片选择控制器
    UIImagePickerController *PickerController = [[UIImagePickerController alloc] init];
    PickerController.sourceType = type;
    PickerController.delegate = self;
    // modal
    [self presentViewController:PickerController animated:YES completion:nil];
}
// 自定义代理实现监听工具条按钮的点击+用ZBComposeController代理来监听图片选择控制器,在代理方法中将图片到photosView中
#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 拍照完毕或者选择相册图片完毕，退出UIImagePickerController控制器。如果不执行这句代码，该控制器不退出
    [picker dismissViewControllerAnimated:YES completion:nil];
    // info字典中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 添加图片到photosView中.如果不将图片添加到photosView中，而将图片添加到textView中的话，那么添加的图片会挡住输入的文字。因为photosView的y值为100，所以添加的图片的y值为100。
    [self.photosView addPhoto:image];
}





@end
