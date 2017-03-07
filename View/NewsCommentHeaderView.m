//
//  NewsCommentHeaderView.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentHeaderView.h"

@implementation NewsCommentHeaderView

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self){
        [self setupNewsCommentHeaderView];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupNewsCommentHeaderView];
    }
    return self;
}

- (void)setupNewsCommentHeaderView {
    self.contentView.backgroundColor = [UIColor getColor:@"F0F2F5" alpha:0.5];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftColorView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _titleLabel.textColor = [UIColor getColor:@"333333"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.frame = CGRectMake(15, 7, 66, 18);
    }
    return _titleLabel;
}

- (UIView *)leftColorView {
    if (!_leftColorView) {
        _leftColorView = [[UIView alloc] init];
        _leftColorView.backgroundColor = [UIColor whiteColor];
        _leftColorView.frame = CGRectMake(0, 8, 5, 16);
    }
    return _leftColorView;
}

@end
