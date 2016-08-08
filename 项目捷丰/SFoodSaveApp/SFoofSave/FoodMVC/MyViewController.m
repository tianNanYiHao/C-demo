//
//  MyViewController.m
//  SFoofSave
//
//  Created by Lff on 16/8/4.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "MyViewController.h"
#import "ComplaintViewController.h"
#import "AboutUSViewController.h"
#import "VensionInfoViewController.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableview;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
//    _tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableview];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section ==1) {
        return 2;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *s = @"s";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:s];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"投诉建议";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"版本信息";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"关于我们";
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //投诉建议
        ComplaintViewController *v = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        v.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:v animated:YES];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //版本信息
            VensionInfoViewController *v = [[VensionInfoViewController alloc] initWithNibName:@"VensionInfoViewController" bundle:nil];
            v.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:v animated:YES];
        }else if (indexPath.row ==1){
            //关于我们
            VensionInfoViewController *v = [[VensionInfoViewController alloc] initWithNibName:@"VensionInfoViewController" bundle:nil];
            v.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:v animated:YES];
        }
    }
    
    
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
