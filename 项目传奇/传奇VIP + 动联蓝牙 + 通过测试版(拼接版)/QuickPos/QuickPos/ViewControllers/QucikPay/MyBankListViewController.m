//
//  MyBankListViewController.m
//  QuickPos
//
//  Created by 胡丹 on 15/4/8.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "MyBankListViewController.h"
#import "Request.h"
#import "OrderData.h"
#import "QuickPayOrderViewController.h"
#import "QuickBankData.h"
#import "BankCardBindViewController.h"
#import "Common.h"
#import "AddBankcardViewController.h"

@interface MyBankListViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData>{
    QuickBankData *bankData;
    QuickBankItem *bankItem;
    NSIndexPath *indexpath;
//    OrderData *orderData;
}
@property (weak, nonatomic) IBOutlet UITableView *bankTableView;
@property (nonatomic, strong) UIImageView *noBankCark;//没有银行卡的图片
@property (nonatomic, strong) UILabel *noBankCarktip;//没有银行卡的提示
@end

@implementation MyBankListViewController
@synthesize name;
@synthesize destinationType;

- (UIImageView *)noBankCark{
    if (!_noBankCark) {
        _noBankCark = [[UIImageView alloc]initWithFrame:CGRectZero];
        _noBankCark.image = [UIImage imageNamed:@"bankcard_card"];
    }
    return _noBankCark;
}

- (UILabel *)noBankCarktip{
    if (!_noBankCarktip) {
        _noBankCarktip = [[UILabel alloc]initWithFrame:CGRectZero];
        _noBankCarktip.text = @"你还没有绑定过银行卡哦";
        _noBankCarktip.font = [UIFont systemFontOfSize:13];
        _noBankCarktip.textColor = [UIColor lightGrayColor];
        _noBankCarktip.textAlignment = NSTextAlignmentCenter;;
    }
    return _noBankCarktip;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Request *req = [[Request alloc]initWithDelegate:self];
    [req getQuickPayMyCardList];
    
    
//    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    self.bankTableView.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor colorWithRed:30/255.0 green:40/255.0 blue:67/255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //没有绑定过银行卡时添加提示
    [self.view addSubview:self.noBankCark];
    [self.view addSubview:self.noBankCarktip];
    self.noBankCark.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - 45, 200, 85, 55);
    self.noBankCarktip.frame = CGRectMake(0, 255, CGRectGetWidth(self.view.frame), 55);
    //导航栏右边按钮
    UIButton *addbank = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [addbank setImage:[UIImage imageNamed:@"bankcard_add"] forState:UIControlStateNormal];
    [addbank addTarget:self action:@selector(addBankCard:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addbank];
}
//添加卡
- (void)addBankCard:(UIButton *)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"QuickPay" bundle:nil];
    BankCardBindViewController *addBankcardVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BankCardBindViewController"];
    addBankcardVC.hidesBottomBarWhenPushed = YES;
    addBankcardVC.orderData = self.orderData;    
    [self.navigationController pushViewController:addBankcardVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    //有数据返回
    if ([[[dict objectForKey:@"data"] objectForKey:@"resultBean"] count] >0) {
        self.noBankCark.hidden = YES;
        self.noBankCarktip.hidden = YES;
    }
    
    
    if([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]){
        if(type == REQUEST_GETQUICKBANKCARD){
            bankData = [[QuickBankData alloc]initWithData:dict];
            [self.bankTableView reloadData];
            
        }else if(type == REQUSET_MYPOS){
            //无卡支付申请
//            orderData = [[OrderData alloc]initWithData:dict];
//            [self performSegueWithIdentifier:@"NoCardPaySegue" sender:nil];
        
        }else if(type == REQUEST_UNBINDQUICKBANKCARD){
            [bankData.bankCardArr removeObjectAtIndex:indexpath.row];
            [self.bankTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.bankTableView reloadData];
        
        }
    }else{
        [Common showMsgBox:nil msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
    }

}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bankData.bankCardArr.count>0? bankData.bankCardArr.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    indexpath = indexPath;
    bankItem = [bankData.bankCardArr objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"MyCardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIImageView *icon = (UIImageView*)[cell.contentView viewWithTag:1];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 10.0;
    if (bankItem.iconUrl) {
        [icon sd_setImageWithURL:[NSURL URLWithString:bankItem.iconUrl]];
    }else{
        [icon setImage:[UIImage imageNamed:@"icon"]];

    }
    [(UILabel*)[cell.contentView viewWithTag:2] setText:bankItem.bankName];//银行名称
    [(UILabel*)[cell.contentView viewWithTag:3] setText:[Common bankCardNumSecret:bankItem.cardNo]];//银行卡账号
    [(UIImageView*)[cell.contentView viewWithTag:4] setFrame:cell.bounds];//背景
    
    cell.backgroundColor  = [UIColor clearColor];
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    bankItem = bankData.bankCardArr[indexPath.row];
    bankItem.isBind = YES;
    [self performSegueWithIdentifier:@"NoCardPaySegue" sender:cell];
//    NSString *payInfo = @"";
//    Request *req = [[Request alloc]initWithDelegate:self];
//    //无卡支付申请
//    [req applyForQuickPay:payInfo orderID:orderData.orderId];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        indexpath = indexPath;
        bankItem = [bankData.bankCardArr objectAtIndex:indexPath.row];
//        [self.arrayValue removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
        Request *req = [[Request alloc]initWithDelegate:self];
        [req quickPayBankCardUnbind:bankItem.bindID];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"NoCardPaySegue"]) {
        return NO;
    }
    
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"NoCardPaySegue"]) {
        if([segue.destinationViewController isKindOfClass:[QuickPayOrderViewController class]]){
            [(QuickPayOrderViewController*)segue.destinationViewController setOrderData:self.orderData];
            [(QuickPayOrderViewController*)segue.destinationViewController setBankCardItem:bankItem];
        }
    }else if([segue.identifier isEqualToString:@"AddQuickCardSegue"]){
        if([segue.destinationViewController isKindOfClass:[BankCardBindViewController class]]){
            [(BankCardBindViewController*)segue.destinationViewController setOrderData:self.orderData];
        }

    }
}

 
@end
