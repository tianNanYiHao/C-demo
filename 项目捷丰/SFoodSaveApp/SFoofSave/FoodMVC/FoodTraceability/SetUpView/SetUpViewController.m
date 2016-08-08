//
//  SetUpViewController.m
//  SFoofSave
//
//  Created by Lff on 16/8/5.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "SetUpViewController.h"
#import "ComplaintViewController.h"
@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableview
    ;
}

@end

@implementation SetUpViewController
- (void)getActionBlock:(SetUPviewControllerBlock)block{
    _block = block;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"设置";

    _tableview  = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, boundsWidth, boundsHeight-64) style:UITableViewStyleGrouped];
    
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    ;
    [self.view addSubview:_tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *s = @"sssss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:s];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
        
    }
    cell.textLabel.text = @"投诉";
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
    [self.navigationController pushViewController:complaint animated:YES];
    _block(indexPath);
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
