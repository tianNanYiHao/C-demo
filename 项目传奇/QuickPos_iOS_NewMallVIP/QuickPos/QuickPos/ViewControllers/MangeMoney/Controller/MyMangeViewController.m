//
//  MyMangeViewController.m
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "MyMangeViewController.h"
#import "MyMangeView.h"
#import "HMSegmentedControl.h"

#import "HotMangeTableViewCell.h"
#import "RedeemTableViewCell.h"
#import "HoldingModel.h"
#import "RedeemModel.h"

#import "BoRefreshHeader.h"
#import "BoRefreshAutoStateFooter.h"
#import "Masonry.h"
#import "TranDetailViewController.h"
#import "Common.h"
#import "HoldingDetailModel.h"


#define iSHOLDING @"isholding"
#define iSNOTHOLDING @"isNotHolding"
#import "Request.h"

@interface MyMangeViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData,UIAlertViewDelegate>
{
    HMSegmentedControl *_segmentControl;
    UIView *_uPView;
    UIView *_uPBackGroundView;
    
    UITableView *_tableview;
    
    HoldingModel *_holdingModel;
    RedeemModel  *_redeemModel;
    HoldingDetailModel *_holdingDetailModel;
   
    
    
    
    NSMutableArray *_holdingDataArray;
    NSMutableArray *_redeemDataArray;
    
    Request *_request;

    
    
}


@end

@implementation MyMangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _isHolding = iSHOLDING;
    _holdingDataArray = [NSMutableArray arrayWithCapacity:0];
    _redeemDataArray = [NSMutableArray arrayWithCapacity:0];
    
    _request = [[Request alloc] initWithDelegate:self];
    

    
    [self createUI];
    [self createHMsegementController];
    
    [self createTableview];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
}

-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  
    if (type == REQUSET_HoldingList) {  //持有中列表
        [_tableview.header endRefreshing];
        if ([[dict objectForKey:@"retdate"] count]>0) {
            
            for (NSDictionary *dictt in [dict objectForKey:@"retdate"]) {
                _holdingModel = [[HoldingModel alloc] initWithDict:dictt];
                [_holdingDataArray addObject:_holdingModel];
            }
        }
            [_tableview reloadData];

        
    }
    if (type == REQUSET_showHadRedeem) {  //赎回列表
        [_tableview.header endRefreshing];
        for (NSDictionary *dictt in [dict objectForKey:@"retdate"]) {
            _redeemModel = [[RedeemModel alloc] initWtihDict:dictt];
            [_redeemDataArray addObject:_redeemModel];
            
        }
        
        
        if ([_redeemModel.lccp_flag isEqualToString:@"00"]) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
            view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
            UILabel *l = [Tool createLabWithFrame:CGRectMake(0, 0, kScreenWidth, 15) title:@"0-3个工作日内,赎到账户上" font:[UIFont systemFontOfSize:11] color:[UIColor lightGrayColor]];
            [view addSubview:l];
            _tableview.tableFooterView = view;
        }
        [_tableview reloadData];
    }
    
    if (type == REQUSET_getHoldingCode ) {
        
        TranDetailViewController *tranDetailVC = [[TranDetailViewController alloc] init];
        _holdingDetailModel = [[HoldingDetailModel alloc] initWithDict:dict];
        tranDetailVC.holodingDetailModel = _holdingDetailModel;
        
        [self.navigationController pushViewController:tranDetailVC animated:YES];
    }
    
    
    
    
}
-(void)createUI{
    
    _uPBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    _uPBackGroundView.backgroundColor = [UIColor whiteColor];
    _uPBackGroundView.userInteractionEnabled = YES;
    
    _uPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    _uPView.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    
    UILabel *yesetDayPfofit = [Tool createLabWithFrame:CGRectMake(0, 50, kScreenWidth, 20) title:@"理财总资产(元)" font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor]];
    [_uPView addSubview:yesetDayPfofit];
    
    _mangeAllProfit = [Tool createLabWithFrame:CGRectMake(0, CGRectGetMaxY(yesetDayPfofit.frame)+8, kScreenWidth, 50) title:@"" font:[UIFont systemFontOfSize:50] color:[UIColor whiteColor]];
    [_uPView addSubview:_mangeAllProfit];
    
    
    
    UIImageView *lineImage = [Tool createImageWithFrame:CGRectMake(0, CGRectGetMaxY(_mangeAllProfit.frame)+40, kScreenWidth, 8) imageName:[NSString stringWithFormat:@"my_money"]];
    [_uPView addSubview:lineImage];
    
    UILabel *yestDayProfitLab = [Tool createLabWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/3, 15) title:@"昨日收益(元)" font:[UIFont systemFontOfSize:11] color:[UIColor whiteColor]];
    [_uPView addSubview:yestDayProfitLab];
    
    UILabel *allProfitlab =[Tool createLabWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/3, 15) title:@"累计收益(元)" font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor]];
    [_uPView addSubview:allProfitlab];
    
    UILabel *mangeProfitLab = [Tool createLabWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/3, 15) title:@"持有金额(元)" font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor]];
    [_uPView addSubview:mangeProfitLab];
    
    
    _yestDayProfit = [Tool createLabWithFrame:CGRectMake(0, 0,(kScreenWidth-30)/3, 25) title:@"" font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor]];
    [_uPView addSubview:_yestDayProfit];
    
    _allProfit = [Tool createLabWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/3, 25) title:@"" font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor]];
    [_uPView addSubview:_allProfit];
    
    _mangeProfit = [Tool createLabWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/3, 25) title:@"" font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor]];
    [_uPView addSubview:_mangeProfit];
    
    
    
    _uPView.userInteractionEnabled = YES;
    
    [_uPBackGroundView addSubview:_uPView];
    //1
    [yestDayProfitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_uPView.mas_left).with.offset(15);
        make.top.mas_equalTo(lineImage.mas_bottom).with.offset(20);
    }];
    //2
    [allProfitlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_uPView.mas_centerX);
        make.top.mas_equalTo(lineImage.mas_bottom).with.offset(20);
    }];
    //3
    [mangeProfitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_uPView.mas_right).with.offset(-15);
        make.top.mas_equalTo(lineImage.mas_bottom).with.offset(20);
    }];
    
    //4
    [_yestDayProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_uPView.mas_left).with.offset(15);
        make.top.mas_equalTo(yestDayProfitLab.mas_bottom).with.offset(4);
    }];
    //5
    [_allProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_uPView.mas_centerX);
        make.top.mas_equalTo(yestDayProfitLab.mas_bottom).with.offset(4);
    }];
    
    //6
    [_mangeProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_uPView.mas_right).with.offset(-15);
        make.top.mas_equalTo(yestDayProfitLab.mas_bottom).with.offset(4);
    }];
    
}

-(void)createHMsegementController{
    
    _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"持有中",@"已赎回"]];
    _segmentControl.textColor = [Common hexStringToColor:@"757575"];
    _segmentControl.selectedTextColor = [Common hexStringToColor:@"47a8ef"];
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //    [_segmentControl addTarget:self action:@selector(clickController:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.selectionIndicatorColor = [Common hexStringToColor:@"47a8ef"];
    _segmentControl.selectionIndicatorHeight = 1.5f;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.font = [UIFont systemFontOfSize:13];
    _segmentControl.backgroundColor = [UIColor whiteColor];
    [_segmentControl setFrame:CGRectMake(0, CGRectGetMaxY(_uPView.frame), kScreenWidth, 40)];
    
    [_uPBackGroundView addSubview:_segmentControl];
    
    
}
-(void)createTableview{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-100)];
    _tableview.userInteractionEnabled = YES;
    _tableview.separatorStyle = NO;    //去除cell之间的分割线
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableHeaderView = _uPBackGroundView;
    _tableview.tableHeaderView.userInteractionEnabled = YES;
    [self.view addSubview:_tableview];
    
    _tableview.header = [BoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDown2)];

    
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.backgroundColor = [UIColor clearColor];
    [btnleft setFrame:CGRectMake(0, CGRectGetMaxY(_uPView.frame), kScreenWidth/2, 40)];
    [btnleft addTarget:self action:@selector(btn1) forControlEvents:UIControlEventTouchUpInside];
    [_uPBackGroundView addSubview:btnleft];
    
    
    UIButton *btnright = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnright.backgroundColor = [UIColor clearColor];
    [btnright setFrame:CGRectMake(kScreenWidth/2, CGRectGetMaxY(_uPView.frame), kScreenWidth/2, 40)];
    [btnright addTarget:self action:@selector(btn2) forControlEvents:UIControlEventTouchUpInside];
    [_uPBackGroundView addSubview:btnright];
    
    //默认加载一个xib
    [_request getHoldingList];
    [_tableview registerNib:[UINib nibWithNibName:@"HoldingTableViewCell" bundle:nil] forCellReuseIdentifier:@"HoldingTableViewCell"];
  
    
}


-(void)btn1{
    
    [_holdingDataArray removeAllObjects];

    _segmentControl.selectedSegmentIndex = 0;
    _isHolding = iSHOLDING;
    [_tableview registerNib:[UINib nibWithNibName:@"HoldingTableViewCell" bundle:nil] forCellReuseIdentifier:@"HoldingTableViewCell"];
    [self initData1];
     [_tableview reloadData];

}
-(void)btn2{
    [_redeemDataArray removeAllObjects];
    
    _segmentControl.selectedSegmentIndex = 1;
    [_tableview registerNib:[UINib nibWithNibName:@"RedeemTableViewCell" bundle:nil] forCellReuseIdentifier:@"RedeemTableViewCell"];
    _isHolding = iSNOTHOLDING;
    [self initData2];
    [_tableview reloadData];
 
}

-(void)initData1{
    
    [_request getHoldingList];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"请稍后..."];
}

-(void)initData2{
    
    [_request showHadRedeem]; //已赎回请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"请稍后..."];
    
}

#pragma mark tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_isHolding isEqualToString:iSHOLDING]) {
        return _holdingDataArray.count;
    }else if([_isHolding isEqualToString:iSNOTHOLDING]){
        return _redeemDataArray.count;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_isHolding isEqualToString:iSHOLDING]) {
        static NSString *ID = @"HoldingTableViewCell";
        HotMangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.model = _holdingDataArray[indexPath.row];
        return cell;
        
    }else if ([_isHolding isEqualToString:iSNOTHOLDING]){
        
        static NSString *IDD = @"RedeemTableViewCell";
        RedeemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDD forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.model = _redeemDataArray[indexPath.row];
        return cell;
        
    }
    
    return nil;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_isHolding isEqualToString:iSHOLDING]) {
        NSLog(@"111");
        
        [_request getHoldingDetailWithHoldingCode:[_holdingDataArray[indexPath.row] lccp_chy_no]]; //请求持有详情 传持有编码
        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"持有详情查询中..."];

        
    }else if([_isHolding isEqualToString:iSNOTHOLDING]){
        NSLog(@"22");
        //        TranDetailViewController *tranDetaiVc = [[TranDetailViewController alloc] init];
        //        tranDetaiVc.model = _redeemDataArray[indexPath.row];
        //        [self.navigationController pushViewController:tranDetaiVc animated:YES];
        //
    }
}

-(void)dropDown2{ //下拉加载
    
    [_request getMyMangeZiChanList];
    
    
    if ([_isHolding isEqualToString:iSHOLDING]) {
        [_holdingDataArray removeAllObjects];
        [_request getHoldingList];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"请稍后..."];
        [_tableview reloadData];
        
    }
    else if([_isHolding isEqualToString:iSNOTHOLDING]){
        [_redeemDataArray removeAllObjects];
        [_request showHadRedeem]; //已赎回请求
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"请稍后..."];
        [_tableview reloadData];
        
    }

}

@end
