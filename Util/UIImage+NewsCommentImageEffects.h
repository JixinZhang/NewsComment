//
//  UIImage+NewsCommentImageEffects.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 12/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NewsCommentImageEffects)

- (UIImage *)newsCommentBlurImageWithVIImageOfBlur:(CGFloat)blur;

+ (UIImage *)newsCommentImageFromColor:(UIColor *)color withSize:(CGSize)size;
@end
