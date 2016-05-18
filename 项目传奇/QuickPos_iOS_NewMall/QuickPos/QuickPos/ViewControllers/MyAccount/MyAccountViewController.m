//
//  MyAccountViewController.m
//  YoolinkIpos
//
//  Created by 张倡榕 on 15/3/4.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountHeaderTableViewCell.h"
#import "MyAccountTableViewCell.h"
#import "PerfectInformationViewController.h"
#import "WithdrawalViewController.h"
#import "TransactionRecordsViewController.h"
#import "MyCreditCardMachineViewController.h"
#import "DDMenuController.h"
#import "QuickPosTabBarController.h"
#import "MyMessageViewController.h"
#import "MyChangePasswordViewController.h"
#import "PayType.h"
#import "UserInfo.h"
#import "Common.h"
#import "CodeView.h"
#import "LoginViewController.h"
#import "MyAccount2TableViewCell.h"
#import "HelpViewController.h"

@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData,UIAlertViewDelegate,getRespDesc>{
    
    NSDictionary *dataDic;//金额的字典
    
    NSDictionary *UserdataDic;//用户的字典
    
    NSString *availableAmtStr;//账户余额
    
    NSString *cashAvailableAmtStr;//可提现余额
    
    NSString *realNameStr;//用来取用户名
    
    Request *requst;
    
    NSUserDefaults *userDefaults;//存取
    
    NSString *state;//认证状态
    
    NSString *stateRemake; //返回未通过状态
    
    NSString *picStr;//头像str
    
    UIImage *image;//GCD头像用
    
    NSData *data;//GCD转换数据库的头像用
    
    NSString *ID;//身份证
    
    UserInfo *info;
}
@property (nonatomic ,strong)CodeView *codeView;
@property (weak, nonatomic) IBOutlet UITableView *myAccountTableView;//tableview

@property (weak, nonatomic) IBOutlet UIView *OutFootView;//tableview尾view
@property (weak, nonatomic) IBOutlet UIButton *tuichu;


@end

@implementation MyAccountViewController
@synthesize codeView;

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [Common hexStringToColor:@"4a4848"];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = L(@"MyAccount");
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:63/255.0 green:146/255.0 blue:236/255.0 alpha:1];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [Common setExtraCellLineHidden:self.myAccountTableView];//去除多余的线
    
    self.myAccountTableView.delaysContentTouches = NO; //值为NO时，UIScrollView会立马将接收到的手势分发到子视图上。
    
    [self.myAccountTableView registerNib:[UINib nibWithNibName:@"MyAccount2TableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAccount2TableViewCell"];
    //self.myAccountTableView.separatorStyle = NO;
    self.myAccountTableView.tableFooterView = self.OutFootView;
    
    requst = [[Request alloc]initWithDelegate:self];
    
    self.tuichu.layer.cornerRadius = 5;
    self.tuichu.titleLabel.textColor = [UIColor whiteColor];
    self.tuichu.backgroundColor = [Common hexStringToColor:@"fe976f"];
    //    [self.tuichu setImage:[Common createImageWithColor:[Common hexStringToColor:@"fe976f"]] forState:UIControlStateNormal];
    //    [self.tuichu setImage:[Common createImageWithColor:[Common hexStringToColor:@"ef865e"]] forState:UIControlStateHighlighted];
    self.OutFootView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}



- (IBAction)showSetup:(UIBarButtonItem *)sender {
    [(DDMenuController *)[(QuickPosTabBarController *)self.tabBarController parentCtrl] showRightController:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[Common createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[Common createImageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar setShadowImage:[Common createImageWithColor:[UIColor clearColor]]];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:63/255.0 green:146/255.0 blue:236/255.0 alpha:1];
    self.tabBarController.tabBar.hidden = NO;
    
    dataDic = [NSMutableDictionary dictionary];
    
    //登陆判断
    if ([[AppDelegate getUserBaseData].mobileNo length] > 0) {

        //已经登陆
        [requst userInfo:[AppDelegate getUserBaseData].mobileNo];
        [requst getVirtualAccountBalance:@"00" token:[AppDelegate getUserBaseData].token];
        [requst userInfo:[AppDelegate getUserBaseData].mobileNo];
        
    }else{
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"QuickPosNavigationController"];
        [self presentViewController:login animated:YES completion:nil];
    }

}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    if(type == REQUSET_USERINFOQUERY && [dict[@"respCode"] isEqual:@"0000"]){
        
        NSMutableDictionary *getDic = [NSMutableDictionary dictionary];
        
        getDic = dict[@"data"];
        
        info = [[UserInfo alloc]initWithData:getDic[@"resultBean"]];
        
        realNameStr = info.realName;
        state = info.authenFlag;
        stateRemake = info.remark;
        picStr = info.pic;
        ID = info.certPid;
        [self.myAccountTableView reloadData];
        
        //GCD操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            image = [UIImage imageWithData:[self headImage:picStr]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                //[self.myAccountTableView reloadData];
                
            });
        });
        
    }
    
    
    if(type == REQUEST_ACCTENQUIRY && [dict[@"respCode"] isEqual:@"0000"] ){
        
        dataDic = dict;
        
        double userSum = [[dataDic objectForKey:@"availableAmt"] doubleValue];
        double withdrawSum = [[dataDic objectForKey:@"cashAvailableAmt"] doubleValue];
        
        availableAmtStr = [NSString stringWithFormat:@"%0.2f",userSum/100];
        cashAvailableAmtStr = [NSString stringWithFormat:@"%0.2f",withdrawSum/100];
        
        if(availableAmtStr == nil){
            
            availableAmtStr = @"0.00";
            
        }else if (cashAvailableAmtStr == nil){
            
            cashAvailableAmtStr = @"0.00";
            
        }
        
        [self.myAccountTableView reloadData];
        
    }
    if(type == REQUEST_QUICKPAYSTATE && [dict[@"respCode"] isEqual:@"0000"] ){
        
        NSString *message = [[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"resultCode"];
        if ([message isEqualToString:@"8895"]) {
            [CodeView showVersionView:self lab:L(@"NoRecord")];
        }
        else
        {
            [CodeView showVersionView:self lab:[[dict objectForKey:@"data"] objectForKey:@"psamid"]];
        }
        
        
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 1;
        
    }
    if (section == 1){
        
        return 2;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 2;
    }
    if (section == 4) {
        return 2;
    }
    if (section == 5) {
        return 2;
    }
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 0) {
        return 0;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 10;
    }else{
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        return 88;
        
    }
    if(indexPath.section == 1){
        
        return 44;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //头像cell
    if(indexPath.section == 0){
        
        static NSString *headerCellCellIdentifier = @"MyAccountHeaderCell";
        
        MyAccountHeaderTableViewCell *headerCell =(MyAccountHeaderTableViewCell *) [tableView dequeueReusableCellWithIdentifier:headerCellCellIdentifier];
        
        headerCell.usernameLabel.text = realNameStr;
        headerCell.moneyLabel.text = availableAmtStr;
        headerCell.withdrawalLabel.text = cashAvailableAmtStr;
        
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerCell.headicon.image = [UIImage imageNamed:@"account_logo"];
        headerCell.contentView.backgroundColor = [UIColor colorWithRed:63/255.0 green:146/255.0 blue:236/255.0 alpha:1];
        return headerCell;
    }
    
    
    //列表cell绑定
    static NSString *CellIdentifier = @"MyAccountCell";
    
    MyAccountTableViewCell *cell = (MyAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0){
            
            MyAccount2TableViewCell *Cell2 =(MyAccount2TableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"MyAccount2TableViewCell"];
            Cell2.titleLabel.text = @"账户余额";
            
            if ([availableAmtStr length]>0) {
                Cell2.titleLabel2.text = [NSString stringWithFormat:@"%@元",availableAmtStr];
            }else{
                Cell2.titleLabel2.text = @"";
            }
            
            Cell2.userInteractionEnabled = NO;
            Cell2.logoImageView.image = [UIImage imageNamed:@"account_amount"];
            
            return Cell2;
            }
        if (indexPath.row == 1){
            
            MyAccountTableViewCell *cell3 = (MyAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell3.titleLabel.text = @"可提现余额";
            
            if ([cashAvailableAmtStr length]>0) {
                cell3.titleLabel2.text = [NSString stringWithFormat:@"可提现:%@元",cashAvailableAmtStr];
            }else{
                cell3.titleLabel2.text = @"";
            }
            cell3.userInteractionEnabled = YES;
            cell3.logoImageView.image = [UIImage imageNamed:@"account_available"];
            cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell3;
        }
        
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = L(@"TransactionRecords"); //交易记录
            cell.logoImageView.image = [UIImage imageNamed:@"account_trading"];
            
                    }
        //        if (indexPath.row == 1){
        
        //            cell.titleLabel.text = L(@"MyMoney");
        //            cell.userInteractionEnabled = NO;
        //            cell.logoImageView.image = [UIImage imageNamed:@"account_financial"];//我的理财

        
        //        }
        }
    if (indexPath.section == 3) {
        //认证状态显示
        if(indexPath.row == 0){
            if([state isEqual:@"3"]){
                
                cell.titleLabel.text = L(@"ImproveInformationForCertified");
                cell.userInteractionEnabled = NO;
                cell.logoImageView.image = [UIImage imageNamed:@"account_Real"];
                
            }else if ([state isEqual:@"4"]){
                if ([stateRemake isEqualToString:@""]) {
                    cell.titleLabel.text = L(@"ImproveInformationForNotThrough");//未通过
                }else
                {
                    NSString *str = [NSString stringWithFormat:@"%@-[%@]",L(@"ImproveInformationForNotThrough"),stateRemake];
                    cell.titleLabel.text = str;
                }
                cell.userInteractionEnabled = YES;
                cell.logoImageView.image = [UIImage imageNamed:@"account_Real"];
                
            }else if ([state isEqual:@"2"]){
                
                cell.titleLabel.text = L(@"ImproveInformationForReviewing");
                cell.userInteractionEnabled = NO;
                cell.logoImageView.image = [UIImage imageNamed:@"account_Real"];
                
            }else if ([state isEqual:@"0"] || [state isEqual:@""]){
                
                cell.titleLabel.text = L(@"ImproveInformationForUnauthorized");
                cell.userInteractionEnabled = YES;
                cell.logoImageView.image = [UIImage imageNamed:@"account_Real"];
                
            }else if ([state isEqual:@"1"]){
                
                cell.titleLabel.text = L(@"ImproveInformationForLackOfPhotos");
                cell.userInteractionEnabled = YES;
                cell.logoImageView.image = [UIImage imageNamed:@"account_Real"];
            }else if ([state isEqual:@"5"]){
                
                cell.titleLabel.text = L(@"ImproveInformationForCross");
                cell.logoImageView.image = [UIImage imageNamed:@"account_Real"];
            }
            
        }
        
        
        
        if (indexPath.row == 1){
            
            cell.titleLabel.text = L(@"MyMessage");//我的消息
            cell.logoImageView.image = [UIImage imageNamed:@"account_news"];
            
        }
        
        
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0){
            
            cell.titleLabel.text = L(@"QuickPosCode");//快捷支付认证码
            cell.logoImageView.image = [UIImage imageNamed:@"account_quick"];
            
        }
        if (indexPath.row == 1){
            
            cell.titleLabel.text = L(@"ChangePassword");//修改密码
            cell.logoImageView.image = [UIImage imageNamed:@"account_lock"];
        }
        
    }
    if (indexPath.section == 5) {
        
        if (indexPath.row == 0){
            
            cell.titleLabel.text = [NSString stringWithFormat:@"费率说明"];
            cell.logoImageView.image = [UIImage imageNamed:@"account_rate"];
        }
        if (indexPath.row == 1){
            cell.titleLabel.text = L(@"MyCreditCardMachine");//我的刷卡器
            cell.logoImageView.image = [UIImage imageNamed:@"account_my"];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;  //第一组第一行没有小箭头
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
    
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 1 && indexPath.row == 1){
        
        WithdrawalViewController *withdrawalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawalVC"];
        
        withdrawalVC.destinationType = WITHDRAW;
//        withdrawalVC.navigationItem.title = L(@"Withdrawal");
//        withdrawalVC.name = realNameStr;
        withdrawalVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:withdrawalVC animated:YES];//提现
        
    }
    else if(indexPath.section == 2 && indexPath.row == 0){
        
        TransactionRecordsViewController *transactionRecordsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"transactionrecordsVC"];
        
        transactionRecordsVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:transactionRecordsVC animated:YES];//交易记录
        
        
    }
    
    else if(indexPath.section == 3 && indexPath.row == 0){
        
        PerfectInformationViewController *informationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"informationVC"]; //加载故事板中的viewController
        
        informationVC.IDstr = ID;//传值
        informationVC.realNameStr = realNameStr;//传值
        informationVC.hidesBottomBarWhenPushed = YES;//隐藏tabbar
        
        [self.navigationController pushViewController:informationVC animated:YES];//完善资料
        
        
    }
    
    else if(indexPath.section == 3 && indexPath.row == 1){
        
        MyMessageViewController *myMessageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyMessageViewControllerVC"];
        
        myMessageVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myMessageVC animated:YES];//我的消息
        
    }
    else if(indexPath.section == 4 && indexPath.row == 0){
        
        [requst quickPayCodeState];
        
    }
    
    else if(indexPath.section == 4 && indexPath.row == 1){
        
        MyChangePasswordViewController *myChangePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyChangePasswordVC"];
        
        myChangePasswordVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myChangePasswordVC animated:YES];//修改密码
        
    }
    else if(indexPath.section == 5 && indexPath.row == 0){
        HelpViewController * helpViewController = [[HelpViewController alloc] init];
        helpViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:helpViewController animated:YES];//费率说明
        
    }
    
    else if(indexPath.section == 5 && indexPath.row == 1){
        
        MyCreditCardMachineViewController *myCreditCardMachineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCreditCardMachineVC"];
        
        myCreditCardMachineVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myCreditCardMachineVC animated:YES];//我的刷卡器
        
    }
    
}

- (IBAction)OutAct:(UIButton *)sender {
        NSLog(@"退出了");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:L(@"ExitLogin") delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"sure"), nil];
    
    [alert show];
    
}
//UIalert... 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        [[QuickPosTabBarController getQuickPosTabBarController] gotoLoginViewCtrl];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 414, 5)];
    sectionFooterView.backgroundColor = [UIColor clearColor];
    if(section == 0){
        
        return sectionFooterView;
        
    }else if(section == 1){
        
        return sectionFooterView;
    }
    
    return sectionFooterView;
}


//imagedata解压
- (NSData *)headImage:(NSString *)icon{
    
    int len = [icon length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [icon length]/ 2; i++) {
        byte_chars[0] = [icon characterAtIndex:i*2];
        byte_chars[1] = [icon characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    data = [NSData dataWithBytes:buf length:len];
    
    
    return data;
}

- (void)getRespDesc:(NSString *)desc
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:desc message:nil delegate:self cancelButtonTitle:L(@"sure") otherButtonTitles:nil, nil];
    [alert show];
}



@end
