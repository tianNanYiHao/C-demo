//
//  SureBuyViewController.m
//  QuickPos
//
//  Created by Aotu on 16/1/13.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "SureBuyViewController.h"
#import "Masonry.h"
#import "SureBuyTableViewCell.h"
#import "hongBaoModel.h"
#import "Request.h"
#import "Common.h"
#import "MangePayViewController.h"

#import "BoRefreshHeader.h"
#import "BoRefreshAutoStateFooter.h"

@interface SureBuyViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData,SureBuyTableviewCellDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIView *_bottomV;
    hongBaoModel *_hongBaoModel;
    NSMutableArray *_dataArray;
    Request *_request;
    SureBuyTableViewCell *_cell;
    NSInteger _index;
    int _numberCount;  //计数加减
    
    
    
}
@property (weak, nonatomic) IBOutlet UIView *headView;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *hejiMoney; //合计money

@property (weak, nonatomic) IBOutlet UIButton *nowBuy; //立即购买




@end

@implementation SureBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购买";
     _view1.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    _nowBuy.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _request = [[Request alloc] initWithDelegate:self];
    
    
    _numberCount = 1;
    _numberLab.text = [NSString stringWithFormat:@"%d",_numberCount];
    if (_numberCount == 1) {
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateNormal];
        
    }
    
    
    _titleName.text = _SureBuyTitleName;
    _yearRate.text = _SureBuyYearRate;
    _danjia.text = _SureBuyDanjia ;
    _hejiMoney.text = _danjia.text;
    NSLog(@"idididididididididid%@",_lccPID);

    [self createTableView];
    _index = -1;
    
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_dataArray removeAllObjects];
    [_request getHongBaoList];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"红包加载中..."];
    [_tableView reloadData];
    
    
    
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == REQUSET_getHongBaolist) {
        [_tableView.header endRefreshing];
        _hongBaoModel = [[hongBaoModel alloc] initWithDict:dict];
        
        if ([_hongBaoModel.num isEqualToString:@"0"]) { //判断如果红包个数为零 则不显示红包cell
              [_dataArray removeAllObjects]; //清空红包数组
            
        }
        else{
             [_dataArray addObject:_hongBaoModel];
              _tableView.tableFooterView = _bottomV;
             [_tableView reloadData];
            
        }
    }
    
    if (type == REQUSET_MyMangeZiChanList) {
        // 我的理财资产接口
        if ([[dict objectForKey:@"msgcode"] isEqualToString:@"04"]) { //开通理财账户
            if(iOS8){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您还未开通理财账户" message:[dict objectForKey:@"msgtext"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [_request getZhuce];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MangePayViewController *mangePayVC = [mainStory  instantiateViewControllerWithIdentifier:@"MangePayViewController"];
                    mangePayVC.productID = _lccPID;
                    mangePayVC.number = [NSNumber numberWithInt:_numberCount];
                    mangePayVC.amt = [NSNumber numberWithInt:[_hejiMoney.text integerValue]];
                    mangePayVC.hongBaoID = _hongBaoModel.lccp_hb_id;
                    mangePayVC.num = _hongBaoModel.num;
                    [self.navigationController pushViewController:mangePayVC animated:YES];

                    
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
        }else  //如果已经开通 则直接跳过
        {
            
            UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MangePayViewController *mangePayVC = [mainStory  instantiateViewControllerWithIdentifier:@"MangePayViewController"];
            mangePayVC.productID = _lccPID;
            mangePayVC.number = [NSNumber numberWithInt:_numberCount];
            mangePayVC.amt = [NSNumber numberWithInt:[_hejiMoney.text integerValue]];
            mangePayVC.hongBaoID = _hongBaoModel.lccp_hb_id;
            mangePayVC.num = _hongBaoModel.num;
            [self.navigationController pushViewController:mangePayVC animated:YES];

        }

    }
    
    
    
    
    
    
}


-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-150)];
    _tableView.tableHeaderView = _headView;
    _tableView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册nib'
    [_tableView registerNib:[UINib nibWithNibName:@"SureBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"SureBuyTableViewCell"];
    
    [self.view addSubview:_tableView];
    
    _bottomV = [Tool createViewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) background:[Common hexStringToColor:@"eeeeee"]];

    UILabel *tisLab = [Tool createLabWithFrame:CGRectMake(15, 0, kScreenWidth-30, 30) title:@"*仅限使用1个红包" font:[UIFont systemFontOfSize:10] color:[Common hexStringToColor:@"b3b3b3"]];
    tisLab.textAlignment = NSTextAlignmentLeft;
    [_bottomV addSubview:tisLab];
    _tableView.header = [BoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDown1)];
//    _tableView.tableFooterView = _bottomV;
    
    

}

#pragma  - mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"SureBuyTableViewCell";
    
    _cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _cell.model = _dataArray[indexPath.row];
    _cell.delegate = self;
    
    _cell.indexPath = indexPath;

    return _cell;

}


//actionBTN
//减
- (IBAction)jianBtn:(UIButton *)sender {
    if (_numberCount == 1) {
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateNormal];
        
    }
    else if (_numberCount>1) {
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@normal"] forState:UIControlStateNormal];
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateHighlighted];
        
        _jianBtn.highlighted = NO;
        _numberCount--;
        _numberLab.text = [NSString stringWithFormat:@"%d",_numberCount];
        _hejiMoney.text = [NSString stringWithFormat:@"%.2f",_numberCount*[_danjia.text floatValue]];
        
        
        }
}

//加
- (IBAction)jiaBTN:(id)sender {
    if (_numberCount<199) {
        
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@normal"] forState:UIControlStateNormal];
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateHighlighted];
        
        _numberCount++;
        _numberLab.text = [NSString stringWithFormat:@"%d",_numberCount];
        _hejiMoney.text = [NSString stringWithFormat:@"%.2f",_numberCount*[_danjia.text floatValue]];
    }
    
    
}

//确认购买
- (IBAction)sureBuy:(id)sender {
    
    
    //检测是否开通理财账户
    
    
    [_request getMyMangeZiChanList];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES str:@"请稍后..."];

    
}



#pragma - mark 勾选红包代理按钮
-(void)sendBtnActionWithBtn:(UIButton *)btn withIndexpath:(NSIndexPath *)indexPath{
    
    NSLog(@"%d",indexPath.row);
    
    if (_index == -1) {
        btn.selected = YES;
        _index = indexPath.row;
        
        float hongbaomoney;
        hongbaomoney = [[_dataArray[indexPath.row] lccp_hb_amt] floatValue]/100;
        
        _hejiMoney.text = [NSString stringWithFormat:@"%.2f",_numberCount*[_danjia.text floatValue]-hongbaomoney];
        _jia.userInteractionEnabled = NO;
        _jianBtn.userInteractionEnabled = NO;
        

    }
    else if (_index == indexPath.row) {
        btn.selected = NO;
        _index = -1;
        _hejiMoney.text = [NSString stringWithFormat:@"%.2f",_numberCount*[_danjia.text floatValue]];
        _jia.userInteractionEnabled = YES;
        _jianBtn.userInteractionEnabled = YES;
    }

    
}
-(void)dropDown1{ //下拉加载
    NSLog(@"下拉下拉下拉");
    [_dataArray removeAllObjects];
    
    [_request getHongBaoList];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"红包刷新中..."];

    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


    
    
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        if (buttonIndex == 1) {
            [_request getZhuce];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MangePayViewController *mangePayVC = [mainStory  instantiateViewControllerWithIdentifier:@"MangePayViewController"];
            mangePayVC.productID = _lccPID;
            mangePayVC.number = [NSNumber numberWithInt:_numberCount];
            mangePayVC.amt = [NSNumber numberWithInt:[_hejiMoney.text integerValue]];
            mangePayVC.hongBaoID = _hongBaoModel.lccp_hb_id;
            mangePayVC.num = _hongBaoModel.num;
            [self.navigationController pushViewController:mangePayVC animated:YES];

        }
    }



@end
