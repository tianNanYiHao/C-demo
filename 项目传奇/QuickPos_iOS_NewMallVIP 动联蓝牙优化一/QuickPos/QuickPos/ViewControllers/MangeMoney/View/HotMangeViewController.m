//
//  HotMangeViewController.m
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "HotMangeViewController.h"
#import "HotMangeTableViewCell.h"
#import "HotMangerModel.h"
#import "MyMangeViewController.h"

#import "NewProductDetailsViewController.h"
#import "BoRefreshHeader.h"
#import "BoRefreshAutoStateFooter.h"
#import "ProductDetailModel.h"
#import "SureBuyViewController.h"

#import "Common.h"


@interface HotMangeViewController ()<UITableViewDataSource,UITableViewDelegate,WithBankingDetailsTableViewCellDelegate,ResponseData>
{


    HotMangerModel *_model;
//    UIView *_contentsView;
     Request *_request;
    NewProductDetailsViewController *_newProductDetailVC;
    ProductDetailModel *_productInfoModel;
    
    
    
}

@end

@implementation HotMangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    

    [self requestNetWork];
    
    [self createTableview];  //获得数据之后 创建tableview


}
-(void)requestNetWork{

    _request = [[Request alloc] initWithDelegate:self];
    

}


-(void)createTableview{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-100) style:UITableViewStyleGrouped];
    
    [_tableview registerNib:[UINib nibWithNibName:@"HotMangeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotMangeTableViewCell"];

    _tableview.separatorStyle = NO;
    _tableview.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.sectionFooterHeight = 1;
    [Common setExtraCellLineHidden:_tableview];
    
    _tableview.header = [BoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDown1)];

    [self.view addSubview:_tableview];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    if (type == REQUSET_Lccplist) {
        
        [_tableview.header endRefreshing];
       
        NSArray *retdate = [dict objectForKey:@"retdate"];
       
        
        for (NSDictionary *dictt  in retdate) {
            
            HotMangerModel *model = [[HotMangerModel alloc] initWithDict:dictt];
            _model = model;

            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            
            [arr addObject:model];
            
            [_dataArray addObject:arr];
        }
        [_tableview reloadData];
      
        
    }
    if (type == REQUSET_GETPRODUCTDITAIL) { //进入产品详情
        _productInfoModel = [[ProductDetailModel alloc] initWithDict:dict];
        //赋值
        
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _newProductDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"NewProductDetailsViewController"];
        
        _newProductDetailVC.productID = _productInfoModel.lccp_id;
        _newProductDetailVC.titleLabb = _productInfoModel.lccp_name;
        _newProductDetailVC.yearProfitt = _productInfoModel.lccp_rate;
        _newProductDetailVC.lastMoneyy = [NSString stringWithFormat:@"%.2f",[_productInfoModel.lccp_shyu_amt floatValue]/10000];
        _newProductDetailVC.qigouMoneyy = [NSString stringWithFormat:@"%.2f",[_productInfoModel.lccp_amt floatValue]/100];
        _newProductDetailVC.touziDayy = _productInfoModel.lccp_date;
        
        NSString *str = [NSString stringWithFormat:@"%@",_productInfoModel.lccp_mjjs_date];
        _newProductDetailVC.mujiOverDayy = [NSString stringWithFormat:@"%@-%@-%@",
                             [str substringWithRange:NSMakeRange(0, 4)],
                             [str substringWithRange:NSMakeRange(4, 2)],
                             [str substringWithRange:NSMakeRange(6, 2)]
                             ];
        _newProductDetailVC.productInfoString = _productInfoModel.lccp_info;
        _newProductDetailVC.productSMMString = _productInfoModel.lccp_shm;
        
        [self.navigationController pushViewController:_newProductDetailVC animated:YES];
    }
}


#pragma mark -tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 217;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* ID = @"HotMangeTableViewCell";
    
    HotMangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *arr = _dataArray[indexPath.section];
    
    cell.model = arr[0];
    
    cell.delegate = self;
    cell.clickBtn.tag = 10000+row;
    cell.nowBuyBtn.tag = 10000+row;
    
    cell.indexPath = indexPath;
    
    return cell;
    
}




#pragma WithButtonTableViewCellDelegate

-(void)sendBtnAction:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath
{
     NSArray *arr = _dataArray[indexPath.section];
    [_request getProductDitailWithID:[arr[0] lccp_id]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中..."];
    
    
}


-(void)sendNowBuyBtnAction:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath
{

//    NSArray *arr = _dataArray[indexPath.section];
//    [_request getProductDitailWithID:[arr[0] lccp_id]];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中..."];

    
    SureBuyViewController *sur = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SureBuyViewController"];
    
    NSArray *arr = _dataArray[indexPath.section];
    NSString *str = [arr[0] lccp_name];
    sur.SureBuyTitleName = [NSString stringWithFormat:@"%@",str];
    sur.SureBuyDanjia = [NSString stringWithFormat:@"%.2f",[[arr[0] lccp_amt] floatValue]/100] ;
    sur.SureBuyYearRate = [arr[0] lccp_rate];
    sur.lccPID = [arr[0] lccp_id];
    
    [self.navigationController pushViewController:sur animated:YES];
    
}




-(void)dropDown1{ //下拉加载
    NSLog(@"下拉下拉下拉");
    [_dataArray removeAllObjects];
    
    [_request getManageListWithBranchname:@"bmqhchqvip" userid:nil];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中..."];
  
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
