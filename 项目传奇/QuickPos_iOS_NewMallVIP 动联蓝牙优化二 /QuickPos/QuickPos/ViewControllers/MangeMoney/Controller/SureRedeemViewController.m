//
//  SureRedeemViewController.m
//  QuickPos
//
//  Created by Aotu on 16/1/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "SureRedeemViewController.h"
#import "Masonry.h"
#import "SureBuyTableViewCell.h"
#import "hongBaoModel.h"
#import "Request.h"
#import "Common.h"
#import "MangePayViewController.h"
#import "SureNowRedeemViewController.h"

@interface SureRedeemViewController ()<ResponseData>
{

    hongBaoModel *_hongBaoModel;
    NSMutableArray *_dataArray;
    Request *_request;
    SureBuyTableViewCell *_cell;
    NSInteger _index;
    int _numberCount;  //计数加减
    
    
    
}
@property (weak, nonatomic) IBOutlet UIView *headView;



@property (weak, nonatomic) IBOutlet UIButton *nowBuy; //立即赎回


@end

@implementation SureRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赎回";
    
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _view1.backgroundColor = [Common hexStringToColor:@"47a8ef"];
        _nowBuy.layer.cornerRadius = 5;
    _nowBuy.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    _lineView.backgroundColor = [Common hexStringToColor:@"dddddd"];
    

    _request = [[Request alloc] initWithDelegate:self];
    
    
    _numberCount = 1;
    _numberLab.text = [NSString stringWithFormat:@"%d",_numberCount];
    if (_numberCount == 1) {
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateNormal];
        
    }
    
    
    _titleName.text = _SureBuyTitleName;
    _yearRate.text = _SureBuyYearRate;
    _danjia.text = _SureBuyDanjia ;
//    _hejiMoney.text = _danjia.text;
    NSLog(@"idididididididididid%@",_lccPID);
    

    _index = -1;
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (type == REQUSET_getRedeemOrderID) { //如果超限 就让他重输入
        if ([[dict objectForKey:@"msgcode"] isEqualToString:@"09"]||[[dict objectForKey:@"msgcode"] isEqualToString:@"96"]) {
            
                [MBProgressHUD showHUDAddedTo:self.view WithString:[dict objectForKey:@"msgtext"]];
            _numberCount = 1; //重置为1
            _numberLab.text = [NSString stringWithFormat:@"%d",_numberCount];
            if (_numberCount == 1) {
                [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateNormal];
                
            }
        }else{
            SureNowRedeemViewController *nowC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SureNowRedeemViewController"];
            
            nowC.redemOrderID = [dict objectForKey:@"orderid"];
            nowC.redemRealMoney = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"shhamt"] floatValue]/100];
            
            [self.navigationController pushViewController:nowC animated:YES];

        }
        
    }
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
//        _hejiMoney.text = [NSString stringWithFormat:@"%.2f",_numberCount*[_danjia.text floatValue]];
        
        
    }
}

//加
- (IBAction)jiaBTN:(id)sender {
    if (_numberCount<199) {
        
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@normal"] forState:UIControlStateNormal];
        [_jianBtn setImage:[UIImage imageNamed:@"financialjian@dis"] forState:UIControlStateHighlighted];
        
        _numberCount++;
        _numberLab.text = [NSString stringWithFormat:@"%d",_numberCount];
//        _hejiMoney.text = [NSString stringWithFormat:@"%.2f",_numberCount*[_danjia.text floatValue]];
    }
    
    
}

//确定
- (IBAction)sureBuy:(id)sender {
    [_request getRedeemOrderIDWithChiyouNum:_chiyouCode withCountNum:[NSNumber numberWithInt:_numberCount]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"赎回订单申请中..."];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
