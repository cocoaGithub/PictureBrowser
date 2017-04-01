//
//  NYTPhotoModel.h
//  PictureBrowser
//
//  Created by cocoa on 17/3/30.
//  Copyright © 2017年 wangbingyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhotoViewer.h>

@interface NYTPhotoModel : NSObject<NYTPhoto>

@property (nonatomic, nullable) UIImage *image;
@property (nonatomic, nullable) NSData *imageData;
@property (nonatomic, nullable) UIImage *placeholderImage;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionCredit;

- (instancetype)initWithUrl:(NSString*)url;

@end
