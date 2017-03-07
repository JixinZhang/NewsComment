//
//  ANPlaceholderTextView.m
//  tinker
//
//  Created by hushaohua on 15/6/7.
//  Copyright (c) 2015年 wallstreetcn. All rights reserved.
//

#import "ANPlaceholderTextView.h"

@interface ANPlaceholderTextView()

@property(nonatomic,strong) UITextView* textView;

@end

@implementation ANPlaceholderTextView

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initSubviews];
        [self listenTextView];
        [self addObservers];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initSubviews];
        [self listenTextView];
        [self addObservers];
    }
    return self;
}

- (void) addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentTextDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
}


- (void) textViewDidChange:(UITextView *)textView{
    [self contentTextDidChange:nil];
}

- (void) contentTextDidChange:(id)sender{
    [self resetPlaceholderLabel];
}

- (void) listenTextView{
    [self.textView addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
    [self.textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) dealloc{
    [self.textView removeObserver:self forKeyPath:@"font"];
    [self.textView removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.textView){
        if ([keyPath isEqualToString:@"font"]){
            self.placeholderLabel.font = self.textView.font;
        }
        else if ([keyPath isEqualToString:@"text"]){
            [self resetPlaceholderLabel];
        }
    }
}

- (void) initSubviews{
    
    self.textView = [[UITextView alloc] initWithFrame:self.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.textView.contentInset = UIEdgeInsetsZero;
    
    [self addSubview:self.textView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 0, 0)];
    self.placeholderLabel.textColor = [UIColor grayColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:17];
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.userInteractionEnabled = NO;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeholderLabel];
}

- (void) setPlaceholder:(NSString *)placeholder{
    if (_placeholder != placeholder){
        _placeholder = placeholder;
    }
    [self resetPlaceholderLabel];
}

- (void) resetPlaceholderLabel{
    if (self.textView.text.length == 0){
        self.placeholderLabel.text = self.placeholder;
    }
    else{
        self.placeholderLabel.text = @"";
    }
    
    CGSize placeholderLabelSize = [self sizeWithString:self.placeholderLabel.text font:[UIFont systemFontOfSize:15] constraintSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
    CGRect placeholderLabelFrame = self.placeholderLabel.frame;
    self.placeholderLabel.frame = CGRectMake(placeholderLabelFrame.origin.x, placeholderLabelFrame.origin.y,placeholderLabelSize.width, placeholderLabelSize.height);
    
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    if (!string) {
        return CGSizeZero;
    }
    CGSize stringSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
        stringSize = stringRect.size;
    } else {
        stringSize = [string sizeWithFont:font constrainedToSize:constraintSize];
        stringSize.height += font.lineHeight;
    }
    return stringSize;
}

//- (NSString *) placeholder{
//    return self.placeholderLabel.text;
//}

@end
