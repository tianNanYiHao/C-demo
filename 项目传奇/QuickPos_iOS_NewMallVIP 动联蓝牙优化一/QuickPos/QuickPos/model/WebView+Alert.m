//
//  WebView+Alert.m
//  AlertProject
//
//  Created by Peter.Kang on 14-1-23.
//  Copyright (c) 2014年 Peter.Kang. All rights reserved.
//

#import "WebView+Alert.h"

@implementation UIWebView (JavaScriptAlert)

static BOOL diagStat = NO;


-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame{
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [dialogue show];;
}


@end
