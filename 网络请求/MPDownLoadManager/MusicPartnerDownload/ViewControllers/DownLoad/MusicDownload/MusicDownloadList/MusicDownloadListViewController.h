//
//  MusicDownloadListViewController.h
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MusicDownloadListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

+(MusicDownloadListViewController *)shareManager;


@end
