//
//  ScanImage.m
//  PictureBrowser
//
//  Created by cocoa on 17/2/7.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import "ScanImage.h"

@implementation ScanImage

static CGRect oldFrame;
static UIView *bgView;
static UIImageView *imageView;

+ (void)scanBigImageWithImageView:(UIImageView *)currentImageView {
    UIImage *image = currentImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0];
    [window addSubview:bgView];
    
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldFrame = [currentImageView convertRect:currentImageView.bounds toView:window];
    imageView = [[UIImageView alloc] initWithFrame:oldFrame];
    [imageView setImage:image];
    [window addSubview:imageView];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [bgView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        y = ([UIScreen mainScreen].bounds.size.height - height) * 0.5;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [bgView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    //恢复
//    [bgView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        [bgView setAlpha:0];
    }];
    NSLog(@"oldframe is:(%f,%f,%f,%f)",oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,oldFrame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        imageView.frame = oldFrame;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

@end
