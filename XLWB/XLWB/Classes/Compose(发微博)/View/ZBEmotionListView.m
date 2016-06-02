//
//  ZBEmotionListView.m
//  XLWB
//
//  Created by zhangbin on 16/5/31.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionListView.h"
#import "ZBEmotionPageView.h"



@interface ZBEmotionListView()<UIScrollViewDelegate>

@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIPageControl *pageControl;

@end

@implementation ZBEmotionListView
// 初始化要显示的控件
// ZBEmotionKeyboard类中的懒加载方法中对BEmotionListView类进行了alloc init操作,所以会来到initWithFrame:
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 1.初始化UIScrollView控件
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor redColor];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.初始化UIPageControl控件
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = YES;
        // 设置pageControl中普通状态下的图片
        // pageImage是系统的私有属性，利用kvc给私有属性赋值，从而没有选中的页就会变成自己设置的图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        // 设置pageControl中选中状态下的图片
         // currentPageImage是系统的私有属性，利用kvc给私有属性赋值，从而选中的页就会变成自己设置的图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

// 根据传递过来的“默认”/"Emoji"/"Lxh"其中一类表情，计算这一类表情对一个的每一页表情个数
// emotions只能为99/80/40中的一个，因为ZBEmotionKeyboard类中已经执行了[self.showingListView removeFromSuperview];保证了每一调用setEmotions，emotions数组中之前存储的表情会被移除
// ZBEmotionKeyboard类中的懒加载方法中调用了emotions的setter方法
-(void)setEmotions:(NSArray *)emotions{
    
    _emotions = emotions;

//    NSUInteger count = (emotions.count  + ZBEmotionEveryPageCount - 1) / ZBEmotionEveryPageCount;

    // 根据表情的个数计算出来的用几页UIView来存放这些表情
    
    // 浮点类型的页数 = 浮点类型的表情总数 除以 浮点类型的每一页的表情总数
    CGFloat RealCount = (CGFloat)emotions.count / (CGFloat)ZBEmotionEveryPageCount;
    // 整形类型的页数 = 整形类型的表情证书 除以 整形类型的每一页的表情总数
    NSUInteger count = emotions.count / ZBEmotionEveryPageCount;
    
    //NSLog(@"%zd,%lf",emotions.count,RealCount);
    
    // 如果浮点类型的页数 >  整形类型的页数，表示有多余的表情，并且多余的表情不够20个(例如2个表情)，这时也要分配一页给这2个表情
    if (RealCount > count) {
        count = count + 1;
    }

    
    // 1.设置页数
    self.pageControl.numberOfPages = count;
    // 2.创建用来显示每一页表情的控件
    for(int i = 0; i < self.pageControl.numberOfPages; i++){
        ZBEmotionPageView *pageView = [[ZBEmotionPageView alloc] init];
        // 计算这一页的表情范围
        // NSRange有两个属性location和length属性.location表示表情的开始位置,length表示需要的表情的长度
        NSRange range;
        // 字符串开始的位置
        // 假设一共99个表情
        // i = 0时,也就是第一页，从第0个表情开始截取，计算剩余的表情，如果剩余的表情99>=20，就仅仅截取20个表情显示在第一页上，如果剩余的表情小于20个，截取的长度就是 不足20个的表情
        // i = 1时,也就是第二页，从第20个表情开始截取，计算剩余的表情，如果剩余的表情79>=20，就仅仅截取20个表情显示在第二页上
        // i = 2时，也就是第三页，同上，59>=20,截取20个表情显示在第三页上
        // i = 3时，也就是第四页，同上，39>=20,截取20个表情显示在第四页上
        // i = 4时，也就是第五页，同上，19<20,所以仅仅把19个表情显示在第五页上。

        range.location = i * ZBEmotionEveryPageCount;
        // 剩余的表情个数remainsCount = 表情总数 - 表情开始的位置(这个位置之前的表情不参与计算，所以要减去嘛)
        NSUInteger remainsCount = emotions.count - range.location;
        if (remainsCount >= ZBEmotionEveryPageCount) {// 这一页足够20个，length就为20
            range.length = ZBEmotionEveryPageCount;
        }else{// 这一页足够20个，length就为remainsCount
            range.length = remainsCount;
        }
        // 封装HWEmotionPageView类来设置这一页的表情
        // 等号右侧的emotions是 99/80/40这三个表情数量中的一个，然后调用subarrayWithRange方法，将range中的location和length传递进去，从location的位置上截取length个表情(20或不足20)，并存进ZBEmotionPageView的emotions数组中，而且还调用emotions的setter方法来显示这20个表情或不足20个表情到当前页上。注意:是当前页哦，因为这句代码是在for循环中执行的。
        pageView.emotions = [emotions subarrayWithRange:range];
        pageView.backgroundColor = ZBRandomColor;
        // 将每一页添加到scrollView中
        [self.scrollView addSubview:pageView];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    // 1.pageControl
    self.pageControl.zb_width = self.zb_width;
    self.pageControl.zb_height = 35;    
    self.pageControl.zb_X = 0;
    // pageControl的Y值 = ZBEmotionListView的高度 - pageControl的高度
    // ZBEmotionListView的高度就是ZBEmotionKeyboard类中的layoutSubviews方法中的SaveShowingListView的高度，即self.SaveShowingListView.zb_height = self.zb_height - self.tabBar.zb_height;
    self.pageControl.zb_Y = self.zb_height - self.pageControl.zb_height;
    
    // 2.scrollView
    self.scrollView.zb_width = self.zb_width;
    self.scrollView.zb_height = self.pageControl.zb_Y;
    self.scrollView.zb_X = 0;
    self.scrollView.zb_Y = 0;
    
    // 3.设置scrollView内部每一页的尺寸
    // 若想得到添加到scrollView中子控件(ZBEmotionPageView)的个数，必须将横竖滚动条隐藏，否则count会多出2个，因为横、竖滚动条(本质是UIImageView)也是scrollView的子控件
    NSUInteger count = self.scrollView.subviews.count;
  //  ZBLog(@"%@",self.scrollView.subviews);
    for (int i = 0; i < count; i ++) {
        // 把scrollView中存储的子控件，根据下标依次取出来，用pageView对象保存
        ZBEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.zb_height = self.scrollView.zb_height;
        pageView.zb_width = self.scrollView.zb_width;
        // 每一页的X值 = 子控件的下标 * 每一页固定的宽度
        pageView.zb_X = i * pageView.zb_width;
        pageView.zb_Y = 0;
    }
    // 4.设置scrollView的ContentSize
    // x轴的滚动范围是 计算出来的存放表情的UIView的个数 * 屏幕的宽度
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.zb_width, 0);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double  PageNumber = scrollView.contentOffset.x / scrollView.zb_width;
    self.pageControl.currentPage = (int)(PageNumber + 0.5);
}

@end
