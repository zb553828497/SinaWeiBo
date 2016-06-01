//
//  ZBEmotionListView.m
//  XLWB
//
//  Created by zhangbin on 16/5/31.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBEmotionListView.h"

#define ZBEmotionEveryPageCount 20

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
        scrollView.showsHorizontalScrollIndicator = NO;
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
// ZBEmotionKeyboard类中的懒加载方法中调用了emotions的setter方法
-(void)setEmotions:(NSArray *)emotions{
    
    _emotions = emotions;
    // 根据表情的个数计算出来的用几页UIView来存放这些表情
    NSUInteger count = (emotions.count  + ZBEmotionEveryPageCount - 1) / ZBEmotionEveryPageCount;
    // 1.设置页数
    self.pageControl.numberOfPages = count;
    // 2.创建用来显示每一页表情的控件
    for(int i = 0; i < self.pageControl.numberOfPages; i++){
        UIView *pageView = [[UIView alloc] init];
        pageView.backgroundColor = ZBRandomColor;
        // 为每一页设置一个UIView，并添加到scrollView上
        [self.scrollView addSubview:pageView];
    }
}

-(void)layoutSubviews{
    
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
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i ++) {
        // 把scrollView中存储的子控件，根据下标依次取出来，用pageView对象保存
        UIView *pageView = self.scrollView.subviews[i];
        pageView.zb_height = self.scrollView.zb_height;
        pageView.zb_width = self.scrollView.zb_width;
        // 每一页的X值 = 子控件的下标 * 每一页固定的宽度
        pageView.zb_X = i * pageView.zb_width;
        pageView.zb_Y = 0;
    }
    // 4.设置scrollView的ContentSize
    // x轴的滚动范围是 计算出来的存放表情的UIView的个数 * 屏幕的宽度
#warning 平白无故能多滚出一页，所以我这里将count减去了1，为什么能多滚出一页？现在还无法解释
    self.scrollView.contentSize = CGSizeMake((count - 1) * self.scrollView.zb_width, 0);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double  PageNumber = scrollView.contentOffset.x / scrollView.zb_width;
    self.pageControl.currentPage = (int)(PageNumber + 0.5);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",self.scrollView.subviews);
}

@end
