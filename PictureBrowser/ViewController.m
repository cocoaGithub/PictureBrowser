//
//  ViewController.m
//  PictureBrowser
//
//  Created by cocoa on 17/2/7.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ScanImage.h"
#import "SecondViewController.h"

#define BIG_IMG_WIDTH 325
#define BIG_IMG_HEIGHT 325

@interface ViewController ()
@property (strong,nonatomic) UIImageView *minImageView;
@end

@implementation ViewController {
    UIView *_background;
    CGRect _oldFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _minImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    [_minImageView setImage:[UIImage imageNamed:@"test_image"]];
    [self.view addSubview:_minImageView];
    _minImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPicture:)];
    [_minImageView addGestureRecognizer:tapGesture];
    
    UIImageView *secondView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 64, 100, 100)];
    [secondView setImage:[UIImage imageNamed:@"test_image"]];
    [self.view addSubview:secondView];
    secondView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapNd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondViewClicked:)];
    [secondView addGestureRecognizer:tapNd];
    
    UIButton *nextPage = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 60, 40)];
    [self.view addSubview:nextPage];
    [nextPage setBackgroundColor:[UIColor redColor]];
    [nextPage setTitle:@"next" forState:UIControlStateNormal];
    [nextPage addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)goToNextPage {
    SecondViewController *nextVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (void)secondViewClicked:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    [ScanImage scanBigImageWithImageView:imageView];
}

- (void)showBigPicture:(UITapGestureRecognizer *)tap {
    UIImageView *minView = (UIImageView *)tap.view;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _background = bgView;
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bgView];
    
    UIImage *image = minView.image;
    _oldFrame = _minImageView.frame;
    UIImageView *maxImageView = [[UIImageView alloc] initWithFrame:_oldFrame];
    [maxImageView setImage:image];
    [maxImageView setTag:10];
    [bgView addSubview:maxImageView];
    
    maxImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [maxImageView addGestureRecognizer:tapGesture];
    [bgView addGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        y = ([UIScreen mainScreen].bounds.size.height - height - 64) * 0.5;
        [maxImageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [bgView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)closeView:(UIGestureRecognizer *)tap {
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:10];
    //恢复
    
    [UIView animateWithDuration:0.3 animations:^{
        [backgroundView setBackgroundColor:[UIColor clearColor]];
    }];
    [UIView animateWithDuration:0.6 animations:^{
        //        backgroundView.frame = oldFrame;
        imageView.frame = _oldFrame;
        //        imageView.frame = backgroundView.bounds;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
