//
//  MangeMoneyViewController.m
//  QuickPos
//
//  Created by Aotu on 15/12/15.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "MangeMoneyViewController.h"
#import "HMSegmentedControl.h"
#import "Common.h"
#import "HotMangeViewController.h"
#import "MyMangeViewController.h"
#import "HotMangerModel.h"
@interface MangeMoneyViewController ()<ResponseData,UIAlertViewDelegate>
{
     NSMutableArray *_dataArray;
     Request *_request;
}
@property (nonatomic,strong)HotMangeViewController *hotMangeContrller;
@property (nonatomic,strong)MyMangeViewController *myMangeController;


@end

@implementation MangeMoneyViewController
//@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    self.title = @"理财";
     _request = [[Request alloc] initWithDelegate:self];
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createUI];
//
    [self createViewController];
    
    
    if ([_fromAccount isEqualToString:@"fromAccount"]){
          _myMangeController.view.hidden = NO;
    }else
    {
          _myMangeController.view.hidden = YES;
    }
  
//
//
}

-(void)createUI{
    //    HMSegmentedControl *control = [[HMSegmentedControl alloc] initWithSectionImages:@[@"financial_hot_normal",@"financial_my_normal"] sectionSelectedImages:@[@"financial_hot_press",@"financial_my_press"]];
    
    
    UIImage *image1 = [UIImage imageNamed:@"financial_hot_normal-1"];
    UIImage *image2 = [UIImage imageNamed:@"financial_my_normal-1"];
    NSArray *arr1 = [[NSArray alloc] initWithObjects:image1,image2, nil];
    
    UIImage *image3 = [UIImage imageNamed:@"financial_hot_press-1"];
    UIImage *image4 = [UIImage imageNamed:@"financial_my_press-1"];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:image3,image4, nil];
    
    HMSegmentedControl *control = [[HMSegmentedControl alloc] initWithSectionImages:arr1 sectionSelectedImages:arr2];
    
    control.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    
    control.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    control.selectionIndicatorColor = [Common hexStringToColor:@"47a8ef"];
    control.frame = CGRectMake(0, 0, kScreenWidth, 50);
    control.selectionIndicatorHeight = 3.0;
    
    
    if ([_fromAccount isEqualToString:@"fromAccount"]) {
        control.selectedSegmentIndex = 1;
        [_request getMyMangeZiChanList];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES str:@"我的理财..."];
    }
    else{
        control.selectedSegmentIndex = 0;
        
    }
    
    
    [control addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:control];
    
    
}

-(void)createViewController{
    
    
    
    _hotMangeContrller = [[HotMangeViewController alloc] init];
    _hotMangeContrller.view.frame = CGRectMake(0, 50, kScreenWidth, kScreenHeight-50);
    [self.view addSubview:_hotMangeContrller.view];
    [_request getManageListWithBranchname:@"bmqhchqvip" userid:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES str:@"热销理财..."];
    
    
    
    
    _myMangeController = [[MyMangeViewController alloc]init];
    _myMangeController.view.frame = CGRectMake(0, 50, kScreenWidth, kScreenHeight-50);
    [self.view addSubview:_myMangeController.view];
    [self addChildViewController:_hotMangeContrller];
    [self addChildViewController:_myMangeController];
    
    
}

-(void)click:(HMSegmentedControl*)click{
    if (click.selectedSegmentIndex == 0 ) {
    
        _myMangeController.view.hidden = YES;
        _hotMangeContrller.view.hidden = NO;
        
        [_dataArray removeAllObjects];
        [_request getManageListWithBranchname:@"bmqhchqvip" userid:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES str:@"热销理财..."];
        [_hotMangeContrller.tableview reloadData];

    }
    if (click.selectedSegmentIndex == 1) {
        
        _myMangeController.view.hidden = NO;
        _hotMangeContrller.view.hidden = YES;
        
        [_request getMyMangeZiChanList];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES str:@"我的理财..."];

    }
  
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == REQUSET_Lccplist) {  //热销理财列表
        
        NSArray *retdate = [dict objectForKey:@"retdate"];
        
        for (NSDictionary *dictt  in retdate) {
            
            HotMangerModel *model = [[HotMangerModel alloc] initWithDict:dictt];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            [arr addObject:model];
            [_dataArray addObject:arr];
        }
        _hotMangeContrller.dataArray = _dataArray;
        [_hotMangeContrller.tableview reloadData];
        

    }

    if (type == REQUSET_MyMangeZiChanList) {  // 我的理财资产接口
        if ([[dict objectForKey:@"msgcode"] isEqualToString:@"04"]) { //开通理财账户
            if(iOS8){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您还未开通理财账户" message:[dict objectForKey:@"msgtext"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [_request getZhuce];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                }];
                
                UIAlertAction *dosomgThingAction = [UIAlertAction actionWithTitle:@"先看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:defaultAction];
                [alert addAction:dosomgThingAction];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"您还未开通理财账户" message:[dict objectForKey:@"msgtext"] delegate:self cancelButtonTitle:@"先看看" otherButtonTitles:@"确认", nil];
                [alert show];
            }
        }else
        {
            _myMangeController.mangeAllProfit.text =[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"zzch_amt"] floatValue]/100];
            _myMangeController.yestDayProfit.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"lccp_zrshy_amt"] floatValue]/100];
            _myMangeController.allProfit.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"lccp_zshy_amt"] floatValue]/100];
            _myMangeController.mangeProfit.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"lccp_amt"] floatValue]/100];
        }
        
    }
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_request getZhuce];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }
}

@end
