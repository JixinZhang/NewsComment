//
//  ANPlaceholderTextView.h
//  tinker
//
//  Created by hushaohua on 15/6/7.
//  Copyright (c) 2015年 wallstreetcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANPlaceholderTextView : UIView

@property(nonatomic, readonly) UITextView* textView;

@property(nonatomic, strong) NSString* placeholder;
@property(nonatomic, strong) UIColor* placeholderColor;
@property(nonatomic, strong) UILabel* placeholderLabel;

@end
