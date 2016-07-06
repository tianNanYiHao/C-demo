//
//  WithdrawalViewController.m
//  QuickPos
//
//  Created by Leona on 15/3/12.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "TakeCashViewController.h"
#import "BankcardTableViewCell.h"
#import "AddBankcardCell.h"
#import "AddBankcardViewController.h"
#import "TakeCashViewController.h"
#import "BankCardData.h"
#import "Common.h"
#import "PayType.h"
#import "TransferViewController.h"
#import "ROllLabel.h"



@interface WithdrawalViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData>{
    
    NSDictionary *dataDic;//请求返回字典
    
    NSString *newCardNumber;//截取卡号后的赋值
    
    BankCardData *bankCardData;//类为属性
    
    NSString *cardNumber;//传值用-卡号
    
    NSString *cardIdx;//传值用-卡索引
    
    Request *requst;
    
    NSIndexPath *indexpath;//indexpath索引
    
    int Viewtype ;//复用页面标示 1=提现，2=转账。
    
}
@property (weak, nonatomic) IBOutlet UITableView *withdrawalTableView;

@property (nonatomic, strong) UIImageView *noBankCark;//没有银行卡的图片
@property (nonatomic, strong) UILabel *noBankCarktip;//没有银行卡的提示
@end

@implementation WithdrawalViewController

@synthesize name;
@synthesize destinationType;
@synthesize Notes;
@synthesize item;

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
    
    
//    if (!item) {
//        
//        Notes.text = L(@"Transfer");
//        
//    }

//        Notes.hidden = NO;
    
    if (destinationType == TRANSFER) {
        self.navigationItem.title = [item objectForKey:@"title"];
        [ROllLabel rollLabelTitle:[self.item objectForKey:@"announce"] color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:17.0] superView:Notes fram:CGRectMake(0, 0, Notes.frame.size.width, Notes.frame.size.height)];
    }else{
        self.navigationItem.title = L(@"Withdrawal");
        Notes.hidden = YES;
    }

    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    self.withdrawalTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.withdrawalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    requst = [[Request alloc]initWithDelegate:self];
    [requst userInfo:[AppDelegate getUserBaseData].mobileNo];
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


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (destinationType == WITHDRAW) {
        [requst bankListAndbindType:@"01"];
    }else{
        [requst bankListAndbindType:@"02"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"MBPLoading")];
    
    [hud hide:YES afterDelay:1];
}
- (void)addBankCard:(UIButton *)sender {
    
    AddBankcardViewController *addBankcardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBankcardVC"];
    
    addBankcardVC.hidesBottomBarWhenPushed = YES;
    addBankcardVC.name = name;
    addBankcardVC.destinationType = self.destinationType;
    
    [self.navigationController pushViewController:addBankcardVC animated:YES];
}


- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{

    //有数据返回
    if ([[[dict objectForKey:@"data"] objectForKey:@"resultBean"] count] >0) {
        self.noBankCark.hidden = YES;
        self.noBankCarktip.hidden = YES;
    }
    
    
    if ([dict[@"respCode"]isEqualToString:@"0000"]) {
        
        if (type == REQUSET_USERINFOQUERY) {
            name = [[[dict objectForKey:@"data"] objectForKey:@"resultBean"] objectForKey:@"customerName"];
            
        }
        
        if(type == REQUSET_BANKLIST){
            
            bankCardData = [[BankCardData alloc]initWithData:dict];
            [self.withdrawalTableView reloadData];
            
        }else if(type == REQUSET_BankCardUnBind){
            
            [bankCardData.bankCardArr removeObjectAtIndex:indexpath.row];
            
            [self.withdrawalTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.withdrawalTableView reloadData];
        }
        
    }else{
        
            [Common showMsgBox:nil msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
    }
    
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return bankCardData.bankCardArr.count > 0 ? bankCardData.bankCardArr.count:0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *bankcardCellCellIdentifier = @"BankcardTableViewCell";
    
    BankcardTableViewCell *bankcardCell = (BankcardTableViewCell *) [tableView dequeueReusableCellWithIdentifier:bankcardCellCellIdentifier];
    
    if (!bankcardCell) {
        bankcardCell = [[BankcardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankcardCellCellIdentifier];
    }
    
    BankCardItem *bcItem = [bankCardData.bankCardArr objectAtIndex:indexPath.row];
    
    bankcardCell.bankNameLabel.text = bcItem.bankName;
    bankcardCell.cardTypeLabel.text = bcItem.remark;
    
    NSInteger xuhao = [bcItem.accountNo length]-4;
    NSString *num = [bcItem.accountNo substringFromIndex:xuhao];
//    bankcardCell.cardNumberLabel.text = [Common bankCardNumSecret:bcItem.accountNo];
    bankcardCell.cardNumberLabel.text = [NSString stringWithFormat:@"尾号%@储蓄卡",num];

    bankcardCell.bankLogoImageView.layer.masksToBounds = YES;
    bankcardCell.bankLogoImageView.layer.cornerRadius = 20;
    [bankcardCell.bankLogoImageView sd_setImageWithURL:[NSURL URLWithString:bcItem.iconUrl]];
    
    bankcardCell.backgroundColor = [UIColor whiteColor];
    bankcardCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return bankcardCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BankCardItem *bcItem = [bankCardData.bankCardArr objectAtIndex:indexPath.row];
    
    cardNumber = bcItem.accountNo;
    cardIdx = bcItem.cardIdx;

    
    if (destinationType == WITHDRAW) {
        
        TakeCashViewController *takecashVC = [self.storyboard instantiateViewControllerWithIdentifier:@"takecashVC"];
        
        takecashVC.cardNumber = cardNumber;
        takecashVC.cardIdx = cardIdx;
        
        
        
        
        [self.navigationController pushViewController:takecashVC animated:YES];

    }else if(destinationType == TRANSFER){
        
        TransferViewController *tr = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferViewController"];
        
        tr.bankCardItem = bcItem;
        
        [self.navigationController pushViewController:tr animated:YES];
    }
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        indexpath = indexPath;
        
        BankCardItem *bcItem = [bankCardData.bankCardArr objectAtIndex:indexPath.row];
        
        cardNumber = bcItem.accountNo;
        cardIdx = bcItem.cardIdx;
        
        //        [self.arrayValue removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
        
        [requst BankCardUnBind:cardIdx];
    }
    
}



@end
