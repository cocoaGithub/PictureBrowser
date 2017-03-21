//
//  SecondViewController.m
//  PictureBrowser
//
//  Created by cocoa on 17/2/7.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#define SCREENWIDTH 325
#define SCREENHEIGHT 325

@interface SecondViewController ()
@property (nonatomic, strong) UIImageView *smallImageView;// 小图视图
@property (nonatomic, strong) UIImageView *bigImageView;// 大图视图
@property (nonatomic, strong) UIView *bgView;// 阴影视图
@property(nonatomic,strong) UIImage *image;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"图片点击全屏展示"];
    // 小图
    _image = [UIImage imageNamed:@"test_image"];
    self.smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.smallImageView setContentMode:UIViewContentModeScaleAspectFit];
    // 添加点击响应
    self.smallImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBigImage)];
    [self.smallImageView addGestureRecognizer:imageTap];
    [self.view addSubview:self.smallImageView];
    [self.smallImageView setImage:_image];
    
    UIButton *nextPage = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 60, 40)];
    [self.view addSubview:nextPage];
    [nextPage setBackgroundColor:[UIColor redColor]];
    [nextPage setTitle:@"next" forState:UIControlStateNormal];
    [nextPage addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];

}

- (void)goToNextPage {
    ThirdViewController *nextVC = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

// 大图视图
- (UIImageView *)bigImageView {
    if (nil == _bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        [_bigImageView setImage:_image];
        // 设置大图的点击响应，此处为收起大图
        _bigImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigImage)];
        [_bigImageView addGestureRecognizer:imageTap];
        [_bigImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _bigImageView;
}

// 阴影视图
- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        // 设置阴影背景的点击响应，此处为收起大图
        _bgView.userInteractionEnabled = YES;
        _bgView.multipleTouchEnabled = YES;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigImage)];
        [_bgView addGestureRecognizer:bgTap];
    }
    return _bgView;
}

// 显示大图
- (void)viewBigImage {
    [self bigImageView];// 初始化大图
    
    // 让大图从小图的位置和大小开始出现
    CGFloat y,width,height;
    //宽度为屏幕宽度
    width = [UIScreen mainScreen].bounds.size.width;
    //高度 根据图片宽高比设置
    height = _image.size.height * [UIScreen mainScreen].bounds.size.width / _image.size.width;
    y = ([UIScreen mainScreen].bounds.size.height - height) * 0.5;
    CGRect newFrame = CGRectMake(0, y, width, height);
    _bigImageView.frame = self.smallImageView.frame;
    [self.view addSubview:_bigImageView];
    
    // 动画到大图该有的大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        _bigImageView.frame = newFrame;
        // 改变位置
//        _bigImageView.center = self.view.center;// 设置中心位置到新的位置
    }];
    
    // 添加阴影视图
    [self bgView];
    [self.view addSubview:_bgView];
    
    // 将大图放到最上层，否则会被后添加的阴影盖住
    [self.view bringSubviewToFront:_bigImageView];
}

// 收起大图
- (void)dismissBigImage {
    [self.bgView removeFromSuperview];// 移除阴影
    
    // 将大图动画回小图的位置和大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        _bigImageView.frame = self.smallImageView.frame;
        // 改变位置
//        _bigImageView.center = self.smallImageView.center;// 设置中心位置到新的位置
    }];
    
    // 延迟执行，移动回后再消灭掉
    double delayInSeconds = 0.3;
    __block SecondViewController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself.bigImageView removeFromSuperview];
        bself.bigImageView = nil;
        bself.bgView = nil;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
