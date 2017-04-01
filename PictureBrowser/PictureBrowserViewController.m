//
//  PictureBrowserViewController.m
//  PictureBrowser
//
//  Created by cocoa on 17/3/29.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import "PictureBrowserViewController.h"
#import <SDCycleScrollView.h>
#import <SDWebImageManager.h>
#import "STPhotoBrowserController.h"
#import <MWPhotoBrowser.h>
#import "SDPhotoBrowser.h"
#import <NYTPhotoViewer.h>
#import "NYTPhotoModel.h"
#import "PYBrowserDemoViewController.h"

@interface PictureBrowserViewController ()<STPhotoBrowserDelegate,SDCycleScrollViewDelegate,MWPhotoBrowserDelegate,SDPhotoBrowserDelegate,NYTPhotosViewControllerDelegate>
@property(strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property(strong,nonatomic) NSArray *imageStrings;
@property(strong,nonatomic) NSArray *photos;
@property(strong,nonatomic) MWPhotoBrowser *mwBrowser;
@property(strong,nonatomic) SDPhotoBrowser *sdBrowser;
@property(strong,nonatomic) STPhotoBrowserController *stBrowser;
@property(strong,nonatomic) UIView *viewGroup;
//@property(strong,nonatomic) NYTPhotosViewController *photosViewController;
@end


@implementation PictureBrowserViewController

static NSArray *images;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageStrings = @[
                      @"http://img2.mtime.com/mg/2009/36/9a1d9903-71c6-4654-8b42-673bdad3aaef.jpg",
                      @"http://d.3987.com/yjyy_131018/001.jpg",
                      @"http://img5q.duitang.com/uploads/item/201309/05/20130905161817_5UwYS.thumb.700_0.jpeg",
                      @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg"];
    
    if (!images) {
        images = @[
                   @"http://img2.mtime.com/mg/2009/36/9a1d9903-71c6-4654-8b42-673bdad3aaef.jpg",
                   @"http://d.3987.com/yjyy_131018/001.jpg",
                   @"http://img5q.duitang.com/uploads/item/201309/05/20130905161817_5UwYS.thumb.700_0.jpeg",
                   @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg"];
    }
    
    CGFloat kLMBannerHeight = self.view.frame.size.width *3 / 4;
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15 , 64, self.view.bounds.size.width-30, kLMBannerHeight) shouldInfiniteLoop:YES imageNamesGroup:_imageStrings];
    _cycleScrollView.showPageControl = YES;
    [_cycleScrollView setPageControlAliment:SDCycleScrollViewPageContolAlimentCenter];
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"test_image"];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_cycleScrollView];
    _cycleScrollView.delegate = self;
    
    _viewGroup = [[UIView alloc] initWithFrame:self.view.bounds];
    for (int i = 0; i < _imageStrings.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:_cycleScrollView.frame];
        [_viewGroup addSubview:view];
    }
    
    UIButton *nextPage = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 60, 40)];
    [self.view addSubview:nextPage];
    [nextPage setBackgroundColor:[UIColor redColor]];
    [nextPage setTitle:@"next" forState:UIControlStateNormal];
    [nextPage addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goToNextPage {
    PYBrowserDemoViewController *nextVC = [[PYBrowserDemoViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}


- (void)addMWPhotoBrowser:(NSInteger)index {
    _mwBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    _mwBrowser.displayActionButton = YES; // Show action button to allow sharing, copying, etc
    _mwBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar
    _mwBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image
    _mwBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed
    _mwBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are
    
    // Manipulate
    [_mwBrowser showNextPhotoAnimated:YES];
    [_mwBrowser showPreviousPhotoAnimated:YES];
    [_mwBrowser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:_mwBrowser animated:YES];

}

- (void)addSDPhotoBrowser:(NSInteger)index {
    _sdBrowser = [SDPhotoBrowser new];
    _sdBrowser.delegate = self;
    _sdBrowser.imageCount = self.imageStrings.count;
    _sdBrowser.sourceImagesContainerView = self.viewGroup;
    _sdBrowser.currentImageIndex = index % self.imageStrings.count;
    [_sdBrowser show];
}

- (void)addSTPhotoBrowser:(NSInteger)index {
    //启动图片浏览器
    _stBrowser = [[STPhotoBrowserController alloc] init];
    _stBrowser.sourceImagesContainerView = _viewGroup; // 原图的父控件
    _stBrowser.countImage = _imageStrings.count; // 图片总数
    _stBrowser.delegate = self;
    _stBrowser.currentPage = index;
    [_stBrowser show];

}

- (void)addNYPhotoBrowser {
    
    self.photos = [[self class] newTestPhotos];
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
    photosViewController.delegate = self;

    [self presentViewController:photosViewController animated:YES completion:nil];
    [self updateImagesOnPhotosViewController:photosViewController afterDelayWithPhotos:self.photos];
    
}

- (void)singleTap {
    
}

- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    CGFloat updateImageDelay = 5.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NYTPhotoModel *photo in photos) {
            if (!photo.image && !photo.imageData) {
                photo.image = [UIImage imageNamed:@"test_image"];
                [photosViewController updateImageForPhoto:photo];
            }
        }
    });
}

+ (NSArray *)newTestPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < images.count; i++) {
        NYTPhotoModel *photo = [[NYTPhotoModel alloc] init];
        
//        photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
        photo.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:images[i]]];
        photo.placeholderImage = [UIImage imageNamed:@"NYTimesBuildingPlaceholder"];
        
        
        photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
        
        [photos addObject:photo];
    }
    
    return photos;
}


#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"clicked index is %ld",(long)index);
    
    //call stPhotoBrowser
//    [self addSTPhotoBrowser:index];
    
    //call sdPhotoBrowser
//    [self addSDPhotoBrowser:index];
    
    //call mwPhotoBrowser
//    [self addMWPhotoBrowser:index];
    
    //call NYTPhotoViewer
    [self addNYPhotoBrowser];
    
    
}
#pragma mark - STphotobrowser代理方法
//- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index {
//
////    NSURL *url = [NSURL URLWithString:_imageStrings[index]];
////    NSData *data = [NSData dataWithContentsOfURL:url];
////    UIImage *image = [[UIImage alloc] initWithData:data];
//    return [UIImage imageNamed:@"test_image"];
//}
//
//- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index {
//    
//    return [NSURL URLWithString:_imageStrings[index]];
//}

#pragma mark  SDPhotoBrowserDelegate

//// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
//    return [UIImage imageNamed:@"test_image"];
//    
//}
//
//
//// 返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    return [NSURL URLWithString:self.imageStrings[index]];
//}

#pragma mark - mwPhotoBrowser
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return self.photos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < self.imageStrings.count) {
//        return [self.photos objectAtIndex:index];
//    }
//    return nil;
//}


#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
    
    return self.cycleScrollView;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo {
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.text = @"Custom Loading...";
    loadingLabel.textColor = [UIColor greenColor];
    return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Custom Caption View";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    return label;
    
    return nil;
}


- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
   
    return 2.0f;
}

- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
    return @{NSForegroundColorAttributeName: [UIColor grayColor]};
}

- (NSString *)photosViewController:(NYTPhotosViewController *)photosViewController titleForPhoto:(id<NYTPhoto>)photo atIndex:(NSUInteger)photoIndex totalPhotoCount:(NSUInteger)totalPhotoCount {
    
    return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex+1, (unsigned long)totalPhotoCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
