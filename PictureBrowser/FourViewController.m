//
//  FourViewController.m
//  PictureBrowser
//
//  Created by cocoa on 17/3/17.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *minImageView;// 小图视图
@property (nonatomic, strong) UIImageView *bigImageView;// 大图视图
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIScrollView *bgView;

@end

@implementation FourViewController {
    UIView *_background;
    CGRect _oldFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"大图展示手势缩放"];
    // 小图
    _image = [UIImage imageNamed:@"test_image"];
    _minImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 200, 200)];
    [_minImageView setImage:[UIImage imageNamed:@"test_image"]];
    [self.view addSubview:_minImageView];
    _minImageView.userInteractionEnabled = YES;
    [_minImageView setContentMode:UIViewContentModeScaleAspectFit];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPicture:)];
    [_minImageView addGestureRecognizer:tapGesture];
    
    _oldFrame = _minImageView.frame;
}


// 大图视图
- (UIImageView *)createBigImageView:(CGRect)frame {
    if (nil == _bigImageView) {
        _bigImageView = [[UIImageView alloc] initWithFrame:frame];
        [_bigImageView setContentMode:UIViewContentModeScaleAspectFit];
        // 设置大图的点击响应，此处为收起大图
        _bigImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
        [_bigImageView addGestureRecognizer:imageTap];
        if (_bgView) {
            [_bgView addSubview:_bigImageView];
        }
        
        _bigImageView.multipleTouchEnabled = YES;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [_bigImageView addGestureRecognizer:doubleTap];//添加双击手势
    }
    return _bigImageView;
}

// 阴影视图
- (UIScrollView *)createBgView {
    if (nil == _bgView) {
        _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        
        // 设置阴影背景的点击响应，此处为收起大图
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
        [_bgView addGestureRecognizer:bgTap];
        
        _bgView.delegate = self;
        _bgView.maximumZoomScale = 3.0;//最大缩放倍数
        _bgView.minimumZoomScale = 1.0;//最小缩放倍数
        _bgView.showsVerticalScrollIndicator = NO;
        _bgView.showsHorizontalScrollIndicator = NO;
    }
    return _bgView;
}


- (void)showBigPicture:(UITapGestureRecognizer *)tap {
    
    UIImageView *minView = (UIImageView *)tap.view;
    UIImage *image = minView.image;
    
    [self createBgView];
    [self.view addSubview:_bgView];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self createBigImageView:_oldFrame];
    [_bigImageView setImage:image];
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        y = ([UIScreen mainScreen].bounds.size.height - height - 64) * 0.5;
        [_bigImageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [_bgView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeView:(UIGestureRecognizer *)tap {
    
    //恢复
    [UIView animateWithDuration:0.3 animations:^{
        [_bgView setBackgroundColor:[UIColor clearColor]];
    }];
    [UIView animateWithDuration:0.6 animations:^{
        _bigImageView.frame = _oldFrame;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
    }];
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer
{
    UIGestureRecognizerState state = recongnizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            //以点击点为中心，放大图片
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.bgView.zoomScale == self.bgView.minimumZoomScale;
            CGFloat scale = zoomOut?self.bgView.maximumZoomScale:self.bgView.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.zoomScale = scale;
                if(zoomOut){
                    CGFloat x = touchPoint.x*scale - self.bgView.bounds.size.width / 2;
                    CGFloat maxX = self.bgView.contentSize.width-self.bgView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.bgView.bounds.size.height / 2;
                    CGFloat maxY = self.bgView.contentSize.height-self.bgView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.bgView.contentOffset = CGPointMake(x, y);
                }
            }];
            
        }
            break;
        default:break;
    }
}

#pragma mark UIScrollViewDelegate
//指定缩放UIScrolleView时，缩放UIImageView来适配
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.bigImageView;
}

//缩放后让图片显示到屏幕中间
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize originalSize = _bgView.bounds.size;
    CGSize contentSize = _bgView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.bigImageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
