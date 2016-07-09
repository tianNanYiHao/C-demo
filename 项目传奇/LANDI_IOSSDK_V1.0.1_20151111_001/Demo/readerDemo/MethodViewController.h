//
//  MethodViewController.h
//  readerDemo
//
//  Created by lvv on 14-3-16.
//  Copyright (c) 2014年 landi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandiMPOS.h"

@interface MethodViewController : UIViewController

@property (nonatomic,copy) NSString *deviceIndentifier;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) LandiMPOS * readerManager;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//+ (void) test;
//+(NSMutableArray *) getAIDDicWapper:(NSString *) str;
//+(Byte) getByteFromNSdata:(NSData *) data;

@end
  