//
//  NewsCommentAppDelegate.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentAppDelegate.h"
#import "NewsCommentViewController.h"

@implementation NewsCommentAppDelegate

- (UIViewController *)rootViewControllerInApplication:(BGMicroApplication *)application
{
    return [[NSClassFromString(@"YNewsCommentViewController") alloc] init];
//    return [[NSClassFromString(@"YNewsCommentViewController") alloc] initWitNewsId:@"267456"];
}

@end
