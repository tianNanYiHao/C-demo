//
//  InstructionsForUseViewController.m
//  QuickPos
//
//  Created by feng Jie on 16/8/2.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "InstructionsForUseViewController.h"
#import "InstructionsForUseTableViewCell.h"
#import "OperationManualViewController.h"
#import "DDMenuController.h"
#import "SetupViewController.h"
#import "QuickPosTabBarController.h"


@interface InstructionsForUseViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_instructionsTableView;
}
@property (weak, nonatomic) IBOutlet UITableView *InstructionsForUseTableView;


@end

@implementation InstructionsForUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self creatTableView];
    
    self.title = @"捷丰生活";
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [Common hexStringToColor:@"#068bf4"];//导航栏颜色
    self.navigationController.navigationBar.tintColor = [Common hexStringToColor:@"#ffffff"];//返回键颜色
    self.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFit;
    //设置标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [Common hexStringToColor:@"#ffffff"], UITextAttributeTextColor,
                                                                     [UIFont systemFontOfSize:17], UITextAttributeFont,
                                                                     nil]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn:)];
    
    
}

- (void)backBtn:(UIButton *)Btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//APP使用说明
- (IBAction)instructionsBtn:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"1.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];
    
}

//实名认证
- (IBAction)VerifiedBtn:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"2.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];
    
}

//微信收款
- (IBAction)WechatBtn:(id)sender {
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"6.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];
}
//账户转账
- (IBAction)TransferInstructions:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"3_2.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];
}

//提款
- (IBAction)WithdrawalBtn:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"3_4.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];

}

//快捷支付
- (IBAction)QuickPayment:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"3_3.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];
}
//卡卡转账
- (IBAction)AccountTransfer:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"5.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];

}

//刷卡支付
- (IBAction)CardPayment:(id)sender {
    
    OperationManualViewController *OperationManualVc = [[OperationManualViewController alloc]init];
    OperationManualVc.str = @"3_1.jpg";
    [self.navigationController pushViewController:OperationManualVc animated:YES];

}

//tableview
//- (void)creatTableView{
//    _instructionsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//    _instructionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell分割线
//    _instructionsTableView.backgroundColor = [UIColor whiteColor];
//    _instructionsTableView.delegate = self;
//    _instructionsTableView.dataSource = self;
//    [self.view addSubview:_instructionsTableView];
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 8;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"InstructionsForUseTableViewCell";
//    
//    InstructionsForUseTableViewCell *instructionsCell = (InstructionsForUseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    return instructionsCell;
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

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
