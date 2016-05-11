//
//  ZBNewFeatureController.m
//  XLWB
//
//  Created by zhangbin on 16/5/11.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ZBNewFeatureController.h"
#import "ZBTabBarController.h"

#define ZBNewFeatureImageCount 4
@interface ZBNewFeatureController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIPageControl *pageControl;
@end

@implementation ZBNewFeatureController

- (void)viewDidLoad {
    
    // 1.创建一个scrollView 存储并显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    // 设置scrollView的尺寸和当前控制器的尺寸一样大。即充满这个屏幕
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.zb_width;
    CGFloat scrollH = scrollView.zb_height;
    for(int i = 0;i < ZBNewFeatureImageCount;i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.zb_width = scrollW;
        imageView.zb_height = scrollH;
        imageView.zb_X = i *scrollW;
        imageView.zb_Y = 0;
        // 显示图片(拼接图片图)
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview: imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容(按钮等)，点击这些内容，就能跳转其他界面
        if (i == ZBNewFeatureImageCount -1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3. 设置scrollView的其他属性
    
    scrollView.contentSize = CGSizeMake(ZBNewFeatureImageCount * scrollW, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置scrollView的代理为当前控制器
    scrollView.delegate = self;
    
    
    // 4. 添加pageController，展示目前看的是第几页
    //  UIPageControl就算没有设置尺寸，UIPageControl还是照常显示的
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = ZBNewFeatureImageCount;
    pageControl.backgroundColor = [UIColor redColor];
    // 当前页的颜色
    pageControl.currentPageIndicatorTintColor = ZBColor(253, 98, 42);
    // 其他页的颜色
    pageControl.pageIndicatorTintColor = ZBColor(189, 189, 189);
    pageControl.zb_centerX = scrollW * 0.5;
    pageControl.zb_centerY = scrollH - 50;
    // pageControl要添加到当前控制器的view中，不能添加到scrollView中。因为如果添加到scrollView中,滚动scrollView时，pageController也会跟着滚
    [self.view addSubview: pageControl];
    self.pageControl = pageControl;
}
// 监听scrollView的滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    double page = scrollView.contentOffset.x / scrollView.zb_width;
    // 四舍五入计算出页码(四舍五入原理:利用加0.5，例如1.3加完0.5之后,如果没有大于2，就强转成1，大于2,就强转成2)
    self.pageControl.currentPage = (int)(page + 0.5);
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
-(void)setupLastImageView:(UIImageView *)imageView{
    
    // 开启图片交互功能
    imageView.userInteractionEnabled = YES;

    // 1.按钮
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享个大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.zb_width = 200;
    shareBtn.zb_height = 30;
    shareBtn.zb_centerX = imageView.zb_width * 0.5;
    shareBtn.zb_centerY = imageView.zb_height *0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    //？？？？？？ titleEdgeInsets:只影响按钮内部的titleLabel
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // 2.开始微博
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.zb_size = startBtn.currentBackgroundImage.size;
    startBtn.zb_centerX = shareBtn.zb_centerX;
    startBtn.zb_centerY = imageView.zb_height *0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview: startBtn];

}
-(void)shareClick:(UIButton *)shareBtn{
    // 状态相反
    shareBtn.selected = !shareBtn.isSelected;
}
-(void)startClick{
    // 切换到ZBTabBarController
    UIWindow  *window = [[UIApplication sharedApplication].windows lastObject];
    window.rootViewController = [[ZBTabBarController alloc ] init];

}
@end
