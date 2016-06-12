//
//  MessageDetailViewController.m
//  QuickPos
//
//  Created by caiyi on 16/3/23.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

{
    Request *request;
}




@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题Label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间label

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;//描述label





@property (weak, nonatomic) IBOutlet UIView *lineView;//分割线


@end



@implementation MessageDetailViewController
//@synthesize TitleLabel;
//@synthesize TimeLabel;
//@synthesize DescriptionLabel;

@synthesize timeStr;
@synthesize titleStr;
@synthesize descriptionStr;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息详情";

    self.TitleLabel.text = titleStr;
    self.TimeLabel.text = timeStr;
    self.DescriptionLabel.text = descriptionStr;
    
    
    NSLog(@"%@%@%@",titleStr,timeStr,descriptionStr);
    NSLog(@"%@%@%@",self.TitleLabel.text,self.TimeLabel.text,self.DescriptionLabel.text);
    NSLog(@"%@%@%@",self.TitleLabel,self.TimeLabel,self.DescriptionLabel);
    
//    _titleLabel.text = titleStr;
//    _timeLabel.text = timeStr;
//    _descriptionLabel.text = descriptionStr;
//    
//    NSLog(@"%@%@%@",titleStr,timeStr,descriptionStr);
//    NSLog(@"%@%@%@",_titleLabel,_timeLabel,_descriptionLabel);
//    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
