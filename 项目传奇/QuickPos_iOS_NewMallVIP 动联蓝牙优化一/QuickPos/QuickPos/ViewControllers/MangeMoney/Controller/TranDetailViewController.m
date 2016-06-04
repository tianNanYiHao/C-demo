//
//  transactionDetailViewController.m
//  QuickPos
//
//  Created by Aotu on 15/12/24.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "TranDetailViewController.h"
#import "Masonry.h"
#import "HoldingModel.h"
#import "TranDetailModel.h"
#import "TranDetailTableViewCell.h"
#import "Common.h"
#import "Tool.h"
#import "Request.h"
#import "SureRedeemViewController.h"
#import "HoldingDetailModel.h"
#import "HoldingEveryModel.h"
#import "ProductDetailModel.h"
#import "NewProductDetailsViewController.h"
#import "BoRefreshHeader.h"
#import "BoRefreshAutoStateFooter.h"




@interface TranDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData>
{
    UILabel *_titleDetailName;
    UILabel *_yestDayProfit ; //昨日收益
    UILabel *_allProfit; //累计收益
    UILabel *_haveMoney; //持有金额
    UIView *_headView; //头部试图
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    TranDetailModel *_tranDetailModel;
    Request *_request;
    HoldingEveryModel *_holdingEveryModel;
    
    BOOL _justGet; //是否仅仅通过id获取产品年化收益数据

    

}
@end

@implementation TranDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"持有详情";
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _request = [[Request alloc] initWithDelegate:self];
 
    [self createUI];
    [self creataTableview];
    
    [self initData];
    
}

-(void)createUI{
    _headView = [Tool createViewWithFrame:CGRectMake(0, 0, kScreenWidth, (365/2.0)+146) background:[UIColor whiteColor]];
   
    UIView *bgView = [Tool createViewWithFrame:CGRectMake(0, 0, kScreenWidth, 365/2.0) background:[Common hexStringToColor:@"47a8ef"]];
    [self.view addSubview:bgView];
    
    //1 名字
    _titleDetailName = [Tool createLabWithFrame:CGRectMake(15, 20, kScreenWidth-30, 20) title:@"上海亚科金融######" font:[UIFont systemFontOfSize:13] color:[UIColor whiteColor]];
    _titleDetailName.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_titleDetailName];
    _titleDetailName.text = _holodingDetailModel.lccp_name;
    //添加按钮事件
    UIButton *clickEnterProductDetaileBtn = [Tool createBtnWithFrame:CGRectMake(15, 20, kScreenWidth-30, 20) backgroudColor:[UIColor clearColor] title:nil font:nil textColor:nil target:self select:@selector(clickEnterProductDetaileBtn)];
    [bgView addSubview:clickEnterProductDetaileBtn];
    
    
    
    UIImageView *jiantouView = [Tool createImageWithFrame:CGRectMake(0, 0, 9, 16) imageName:@"financial_whitearrows"];
    [bgView addSubview:jiantouView];

    UIView *lineView = [Tool createViewWithFrame:CGRectMake(15, CGRectGetMaxY(_titleDetailName.frame)+15, kScreenWidth-30, 0.5) background:[Common hexStringToColor:@"83c4fb"]];
    [bgView addSubview:lineView];
    
    //2 昨日收益
    UILabel *yestDayProfitLab = [Tool createLabWithFrame:CGRectMake(15, 0, kScreenWidth-30, 15) title:@"昨日收益(元)" font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor]];
    yestDayProfitLab.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:yestDayProfitLab];
    
    _yestDayProfit = [Tool createLabWithFrame:CGRectMake(15, 0, kScreenWidth-30, 60) title:@"0.00" font:[UIFont systemFontOfSize:60] color:[UIColor whiteColor]];
    [bgView addSubview:_yestDayProfit];
    _yestDayProfit.textAlignment = NSTextAlignmentLeft;
    _yestDayProfit.text =[NSString stringWithFormat:@"%.2f",[_holodingDetailModel.lccp_zrshy_amt floatValue]/100] ;
    
    [_headView addSubview:bgView];
    
    //3 累计搜易
    UIView *v1 = [Tool createViewWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), kScreenWidth, 90) background:[UIColor whiteColor]];

    UILabel *allProtitLab = [Tool createLabWithFrame:CGRectMake(15, 0, kScreenWidth/2, 20) title:@"累计收益(元)" font:[UIFont systemFontOfSize:14] color:[Common hexStringToColor:@"757575"]];
    allProtitLab.center = v1.center;
    [v1 addSubview:allProtitLab];
    
    UIView *midLine = [Tool createViewWithFrame:CGRectMake(15, 45, kScreenWidth-30, 0.5) background:[Common hexStringToColor:@"dddddd"]];
    
    [v1 addSubview:midLine];
    UIView *bottomLine = [Tool createViewWithFrame:CGRectMake(0, 90, kScreenWidth, 0.5) background:[Common hexStringToColor:@"dddddd"]];
    [v1 addSubview:bottomLine];
    
    _allProfit = [Tool createLabWithFrame:CGRectMake(0, 0, kScreenWidth/2, 20) title:@"103.00" font:[UIFont systemFontOfSize:14] color:[Common hexStringToColor:@"333333"]];
    [v1 addSubview:_allProfit];
    _allProfit.text = [NSString stringWithFormat:@"%.2f",[_holodingDetailModel.lccp_shy_amt floatValue]/100];
    [_headView addSubview:v1];
    
    
    //4 持有金额
    UILabel *haveMoney = [Tool createLabWithFrame:CGRectMake(15, 0, kScreenWidth/2, 20) title:@"持有金额(元)" font:[UIFont systemFontOfSize:14] color:[Common hexStringToColor:@"757575"]];
    haveMoney.center = v1.center;
    [v1 addSubview:haveMoney];
    
    _haveMoney = [Tool createLabWithFrame:CGRectMake(0, 0, kScreenWidth/2, 20) title:@"1200.00" font:[UIFont systemFontOfSize:14] color:[Common hexStringToColor:@"333333"]];
    [v1 addSubview:_haveMoney];
    _haveMoney.text = [NSString stringWithFormat:@"%.2f",[_holodingDetailModel.lccp_chy_amt floatValue]/100];
    [_headView addSubview:v1];
    
    UIView *greayVIew = [Tool createViewWithFrame:CGRectMake(0, CGRectGetMaxY(v1.frame), kScreenWidth, 10) background:[Common hexStringToColor:@"dddddd"]];
    [_headView addSubview:greayVIew];
    
    //5 每日盈亏
    UIView *everyDayView = [Tool createViewWithFrame:CGRectMake(0, CGRectGetMaxY(greayVIew.frame), kScreenWidth, 45) background:[UIColor whiteColor]];
    UILabel *everyDayLav = [Tool createLabWithFrame:CGRectMake(15, 0, kScreenWidth, 45) title:@"每日盈亏(元)" font:[UIFont systemFontOfSize:15] color:[Common hexStringToColor:@"757575"]];
    everyDayLav.textAlignment = NSTextAlignmentLeft;
    [everyDayView addSubview:everyDayLav];
    UIView *bottomLine2 = [Tool createViewWithFrame:CGRectMake(0, 45, kScreenWidth, 0.5) background:[Common hexStringToColor:@"dddddd"]];
    [everyDayView addSubview:bottomLine2];
    
    [_headView addSubview:everyDayView];
    
    [jiantouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_top).with.offset(20);
        make.right.mas_equalTo(_headView.mas_right).with.offset(-15);

    }];
    
    [yestDayProfitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(28);
        make.left.mas_equalTo(bgView.mas_left).with.offset(15);
    }];
    
    [_yestDayProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yestDayProfitLab.mas_bottom).with.offset(0);
        make.left.mas_equalTo(bgView.mas_left).with.offset(15);
    }];
    
    [allProtitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(v1.mas_top).with.offset(15);
        make.left.mas_equalTo(v1.mas_left).with.offset(15);
    }];
    [_allProfit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(allProtitLab.mas_centerY);
        make.right.mas_equalTo(v1.mas_right).with.offset(-15);
    }];

    [haveMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(v1.mas_left).with.offset(15);
        make.top.mas_equalTo(midLine.mas_bottom).with.offset(15);
    }];
    [_haveMoney mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(midLine.mas_bottom).with.offset(15);
       make.right.mas_equalTo(v1.mas_right).with.offset(-15);
   }];
    [everyDayLav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(everyDayView.mas_top).with.offset(15);
        make.left.mas_equalTo(everyDayView.mas_left).with.offset(15);
    }];
    
}
-(void)initData{
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [_request getEveryDayPrifitWithHoldingCode:_holodingDetailModel.lccp_chy_no];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"历史收益加载中..."];
    
  
   
}

-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == REQUSET_getEveryDayPrifit) {
   
        [_tableView.header endRefreshing];
        NSArray *d = [dict objectForKey:@"retdate"];
        for (NSDictionary *dictt in d) {
            
            _holdingEveryModel = [[HoldingEveryModel alloc] initWithDict:dictt];
            
            [_dataArray addObject:_holdingEveryModel];
        }
            [_tableView reloadData];
    }
    
    if (type == REQUSET_GETPRODUCTDITAIL) {  //调用产品详情
        
        if (_justGet) {
            SureRedeemViewController *surRedeem = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SureRedeemViewController"];
            ProductDetailModel *productModel = [[ProductDetailModel alloc] initWithDict:dict];
            surRedeem.SureBuyDanjia = [NSString stringWithFormat:@"%.2f",[productModel.lccp_amt floatValue]/100];
            surRedeem.SureBuyTitleName = productModel.lccp_name;
            surRedeem.SureBuyYearRate = productModel.lccp_rate;
            
            //持有编码
            surRedeem.chiyouCode = _holodingDetailModel.lccp_chy_no;
            
            [self.navigationController pushViewController:surRedeem animated:YES];

        }
        else{   //否则 进入产品详情

            ProductDetailModel *model = [[ProductDetailModel alloc] initWithDict:dict];
            //赋值
            
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NewProductDetailsViewController *newProductDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewProductDetailsViewController"];
            
            newProductDetailVC.productID = model.lccp_id;
            newProductDetailVC.titleLabb = model.lccp_name;
            newProductDetailVC.yearProfitt = model.lccp_rate;
            newProductDetailVC.lastMoneyy = [NSString stringWithFormat:@"%.2f",[model.lccp_shyu_amt floatValue]/10000];
            newProductDetailVC.qigouMoneyy = [NSString stringWithFormat:@"%.2f",[model.lccp_amt floatValue]/100];
            newProductDetailVC.touziDayy = model.lccp_date;
            
            NSString *str = [NSString stringWithFormat:@"%@",model.lccp_mjjs_date];
            newProductDetailVC.mujiOverDayy = [NSString stringWithFormat:@"%@-%@-%@",
                                               [str substringWithRange:NSMakeRange(0, 4)],
                                               [str substringWithRange:NSMakeRange(4, 2)],
                                               [str substringWithRange:NSMakeRange(6, 2)]
                                               ];
            newProductDetailVC.productInfoString = model.lccp_info;
            newProductDetailVC.productSMMString = model.lccp_shm;
            
            [self.navigationController pushViewController:newProductDetailVC animated:YES];

        }

}


    
}
-(void)creataTableview{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-120) style:UITableViewStylePlain];
    _tableView.tableHeaderView = _headView;
  
    
    _tableView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    _tableView.header = [BoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDown1)];
    [self.view addSubview:_tableView];
    
    
    
    //赎回按钮
    UIButton *getBtn = [Tool createBtnWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 60) backgroudColor:[Common hexStringToColor:@"47a8ef"] title:@"赎回" font:[UIFont systemFontOfSize:17] textColor:[Common hexStringToColor:@"FFFFFF"] target:self select:@selector(btnGetMoney)];
    [self.view addSubview:getBtn];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(self.view.mas_top).offset(kScreenHeight-120);
    }];
    
}




#pragma mark tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TranDetailTableViewCell *cell = [TranDetailTableViewCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];

    if (indexPath.row%2 ==0) {
        cell.backgroundColor = [Common hexStringToColor:@"ffffff"];
        
    }else{
        cell.backgroundColor = [Common hexStringToColor:@"f8f8f8"];
    }
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    return cell;

}


-(void)btnGetMoney{
    NSLog(@"赎回0000000000");


    //根据产品id再次调用查询产品详情接口 保证产品信息最新
    
    _justGet = YES;
    [_request getProductDitailWithID:_holodingDetailModel.lccp_chy_id];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"赎回产品查询中...."];

}


-(void)dropDown1{
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    [_request getEveryDayPrifitWithHoldingCode:_holodingDetailModel.lccp_chy_no];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在为您刷新历史收益..."];
    [_tableView reloadData];
}




-(void)clickEnterProductDetaileBtn{
    
    NSLog(@"555555555555    %@  ",_holodingDetailModel.lccp_chy_id);
    
    [_request getProductDitailWithID:_holodingDetailModel.lccp_chy_id];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中..."];
}
@end
