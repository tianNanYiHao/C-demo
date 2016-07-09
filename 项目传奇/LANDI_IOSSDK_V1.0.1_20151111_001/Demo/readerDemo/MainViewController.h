//
//  MainViewController.h
//  readerDemo
//
//  Created by lvv on 14-3-11.
//  Copyright (c) 2014年 landi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)searchAction:(id)sender;

- (IBAction)stopSearchAction:(id)sender;

@end
