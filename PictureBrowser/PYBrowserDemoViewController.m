//
//  PYBrowserDemoViewController.m
//  PictureBrowser
//
//  Created by cocoa on 17/3/31.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import "PYBrowserDemoViewController.h"
#import <SDCycleScrollView.h>
#import <PYPhotoBrowser.h>

@interface PYBrowserDemoViewController ()<SDCycleScrollViewDelegate>

@property(strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property(strong,nonatomic) NSArray *imageStrings;

@end

@implementation PYBrowserDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageStrings = @[
                      @"http://img2.mtime.com/mg/2009/36/9a1d9903-71c6-4654-8b42-673bdad3aaef.jpg",
                      @"http://d.3987.com/yjyy_131018/001.jpg",
                      @"http://img5q.duitang.com/uploads/item/201309/05/20130905161817_5UwYS.thumb.700_0.jpeg",
                      @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg"];
    
    CGFloat kLMBannerHeight = self.view.frame.size.width *3 / 4;
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15 , 64, self.view.bounds.size.width-30, kLMBannerHeight) shouldInfiniteLoop:YES imageNamesGroup:_imageStrings];
    _cycleScrollView.showPageControl = YES;
    [_cycleScrollView setPageControlAliment:SDCycleScrollViewPageContolAlimentCenter];
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"test_image"];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_cycleScrollView];
    _cycleScrollView.delegate = self;
    
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    PYPhotoBrowseView *browserView = [[PYPhotoBrowseView alloc] init];
    [browserView setImagesURL:_imageStrings];
    [browserView setHiddenToView:_cycleScrollView];
    [browserView setShowFromView:_cycleScrollView];
    [browserView setCurrentIndex:index];
    [browserView.photosView setPageType:PYPhotosViewPageTypeLabel];
    [browserView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
