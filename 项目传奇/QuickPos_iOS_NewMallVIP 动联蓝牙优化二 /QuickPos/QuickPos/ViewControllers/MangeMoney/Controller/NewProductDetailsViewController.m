//
//  NewProductDetailsViewController.m
//  QuickPos
//
//  Created by Aotu on 16/1/6.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "NewProductDetailsViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "MangePayViewController.h"
#import "SureBuyViewController.h"
#import "UMSocial.h"
#import "WebAgreementViewController.h"

@interface NewProductDetailsViewController ()<ResponseData,UMSocialDataDelegate,UMSocialUIDelegate>{
    
    UIView *_View8;
    UIView *_view9;
    int _buyNumberIntt;
    NSNumber* _buyNumberInt; //购买数量
    Request *_req;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew; //滚动Scrollview
@property (weak, nonatomic) IBOutlet UIView *bgVIew;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab; //标题
@property (weak, nonatomic) IBOutlet UILabel *yearProfit; //年化收益率

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *lastMoney; //剩余金额
@property (weak, nonatomic) IBOutlet UILabel *qigouMoney;//气狗金额
@property (weak, nonatomic) IBOutlet UILabel *touziDay; //投资期限

@property (weak, nonatomic) IBOutlet UIView *greyVIew;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiguize;

@property (weak, nonatomic) IBOutlet UIButton *TransferBtn; //交易合同按钮

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *mujijieshu;

@property (weak, nonatomic) IBOutlet UILabel *mujiOverDay; //募集结束日期

@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UILabel *backWay;


@property (weak, nonatomic) IBOutlet UILabel *redeemWay; //还款方式

@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UILabel *rengouAgeAge;

@property (weak, nonatomic) IBOutlet UILabel *rengouAge; //认购年龄


@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UILabel *baozfangs;

@property (weak, nonatomic) IBOutlet UILabel *safeguardWay; //保障方式

@property (weak, nonatomic) IBOutlet UIView *buyView; //点击购买view

@property (weak, nonatomic) IBOutlet UILabel *hejiLab; //合计
@property (weak, nonatomic) IBOutlet UILabel *buyNumber; //购买数量

@end

@implementation NewProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"产品详情";
    
    self.view.userInteractionEnabled = YES;
    
    _scrollVIew.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _greyVIew.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _view4.backgroundColor = [Common hexStringToColor:@"f8f8f8"];
    _view6.backgroundColor = [Common hexStringToColor:@"f8f8f8"];

    
    _req = [[Request alloc] initWithDelegate:self];
    
      
    
    _scrollVIew.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*3/2.0);
    _buyNumberIntt = 1;
    _buyNumberInt = [NSNumber numberWithInt:_buyNumberIntt];
    
    _buyNumber.text = [NSString stringWithFormat:@"%d",_buyNumberIntt];
    _hejiLab.text = [NSString stringWithFormat:@"合计:%d元",_buyNumberIntt*[_qigouMoneyy intValue]];
    
    [self getInfoBySb];
    [self createView8];
    [self createRightBtn];
    
    _buyView.hidden = YES; //隐藏sb中的view (暂时不用了)
    
    _view7.hidden = YES;
    
}
-(void)getInfoBySb{
    _qigouMoney.textColor = [Common hexStringToColor:@"333333"];
    _touziDay.textColor = [Common hexStringToColor:@"333333"];
    _mujiOverDay.textColor = [Common hexStringToColor:@"333333"];
    _redeemWay.textColor = [Common hexStringToColor:@"333333"];
    _rengouAge.textColor = [Common hexStringToColor:@"333333"];
    _safeguardWay.textColor = [Common hexStringToColor:@"333333"];
    
    _jiaoyiguize.textColor = [Common hexStringToColor:@"757575"];
    _mujijieshu.textColor = [Common hexStringToColor:@"757575"];
    _backWay.textColor = [Common hexStringToColor:@"757575"];
    _rengouAgeAge.textColor = [Common hexStringToColor:@"757575"];
    _baozfangs.textColor = [Common hexStringToColor:@"757575"];
    

    _titleLab.text = _titleLabb;
    _yearProfit.text = _yearProfitt;
    _lastMoney.text = _lastMoneyy;
    _qigouMoney.text = _qigouMoneyy;
    _touziDay.text = _touziDayy;
    _mujiOverDay.text = _mujiOverDayy;

    
}

-(void)createView8{
   
    _View8 = [Tool createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_view7.frame)+1, kScreenWidth, 0) background:[UIColor whiteColor]];
    [_bgVIew addSubview:_View8];
    
    UILabel *jibenDetail = [Tool createLabWithFrame:CGRectMake(15, 15, kScreenWidth-30, 15) title:@"基本信息" font:[UIFont systemFontOfSize:16] color:[Common hexStringToColor:@"333333"]];
    jibenDetail.textAlignment = NSTextAlignmentLeft;
    [_View8 addSubview:jibenDetail];
    
    _productDetail = [Tool createLabWithFrame:CGRectMake(0, 0, kScreenWidth-30, 40) title:_productInfoString font:[UIFont systemFontOfSize:14] color:[Common hexStringToColor:@"757575"]];
    _productDetail.numberOfLines = 0;
    
    _productDetail.textAlignment = NSTextAlignmentLeft;
    
    [_View8 addSubview:_productDetail];
    CGFloat productDetailLabH = [self labelAutoCalculateRectWith:_productInfoString Font:[UIFont systemFontOfSize:14] MaxSize:CGSizeMake(kScreenWidth-30, CGFLOAT_MAX)].height;
    //重置高度
    
    _view9 = [Tool createViewWithFrame:CGRectMake(0, 0, kScreenWidth, 80) background:[UIColor whiteColor]];
    [_bgVIew addSubview:_view9];
    
    UILabel *productSM = [Tool createLabWithFrame:CGRectMake(15, 15, kScreenWidth-30, 20) title:@"产品说明" font:[UIFont systemFontOfSize:16] color:[Common hexStringToColor:@"333333"]];
    productSM.textAlignment = NSTextAlignmentLeft;
    [_view9 addSubview:productSM];
    
    _productSMM = [Tool createLabWithFrame:CGRectMake(0, 0, kScreenWidth-30, 20) title:_productSMMString font:[UIFont systemFontOfSize:14] color:[Common hexStringToColor:@"757575"]];
    _productSMM.textAlignment = NSTextAlignmentLeft;
    [_view9 addSubview:_productSMM];
    
    
    [_productDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgVIew.mas_left).offset(15);
        make.right.mas_equalTo(_bgVIew.mas_right).offset(-15);
        make.top.mas_equalTo(jibenDetail.mas_bottom).offset(5);
        make.height.mas_equalTo(productDetailLabH);
        //重置view8fram
        _View8.frame = CGRectMake(0, CGRectGetMaxY(_view7.frame)+1, kScreenWidth, productDetailLabH+45);
        _view9.frame = CGRectMake(0, CGRectGetMaxY(_View8.frame)+10, kScreenWidth, 65);
        
    }];
    
    [_productSMM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgVIew.mas_left).offset(15);
        make.right.mas_equalTo(_bgVIew.mas_right).offset(-15);
        make.top.mas_equalTo(productSM.mas_bottom).offset(2);
        
    }];

    //重置bgviewframe
    _bgVIew.frame = CGRectMake(0, 0, kScreenWidth,CGRectGetMaxY(_view9.frame)+10);
    
    //重置滚动量frame
    _scrollVIew.contentSize = CGSizeMake(kScreenWidth,CGRectGetMaxY(_bgVIew.frame)+100);
    
    
    
    
    //赎回按钮
    UIButton *getBtn = [Tool createBtnWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 60) backgroudColor:[Common hexStringToColor:@"47a8ef"] title:@"立即购买" font:[UIFont systemFontOfSize:17] textColor:[Common hexStringToColor:@"FFFFFF"] target:self select:@selector(btnGetMoney)];
    [self.view addSubview:getBtn];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(self.view.mas_top).offset(kScreenHeight-120);
    }];

    
}

- (void)createRightBtn
{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 20, 21, 21)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"financial_share"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}


-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    if (type == REQUSET_getManageProductOrder) {
        NSLog(@"qingqiuqingiqu");
        
    }
    
}

- (void)rightBtn:(UIButton *)btn
{
    [UMSocialData openLog:YES];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5695bb63e0f55a6749000609"
                                      shareText:@"传奇金融VIP,让您理财更方便/快捷,http://www.pgyer.com/3zy8"
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToAlipaySession, nil]
                                       delegate:self];
    
    
    
    
}


//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


////减
//- (IBAction)missBtn:(id)sender {
//    if (_buyNumberIntt>0) {
//        _buyNumberIntt--;
//        _buyNumber.text = [NSString stringWithFormat:@"%d",_buyNumberIntt];
//        _hejiLab.text = [NSString stringWithFormat:@"合计:%d元",_buyNumberIntt*[_qigouMoneyy intValue]];
//        
//    }
//
//}
//
//
////加
//- (IBAction)addBtn:(id)sender {
//    
//    if (_buyNumberIntt<200) {
//        _buyNumberIntt++;
//        _buyNumber.text = [NSString stringWithFormat:@"%d",_buyNumberIntt];
//        _hejiLab.text = [NSString stringWithFormat:@"合计:%d元",_buyNumberIntt*[_qigouMoneyy intValue]];
//    }
//}

//新 买
-(void)btnGetMoney{
    
    SureBuyViewController *sur = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SureBuyViewController"];

    sur.SureBuyTitleName = _titleLabb;
    sur.SureBuyDanjia = _qigouMoneyy;
    sur.SureBuyYearRate = _yearProfitt;
    sur.lccPID = _productID;
    
    [self.navigationController pushViewController:sur animated:YES];
    

    
}

////买
//- (IBAction)buyBtn:(id)sender {
//    
//    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MangePayViewController *mangePayVC = [mainStory  instantiateViewControllerWithIdentifier:@"MangePayViewController"];
//    
//    mangePayVC.productID = _productID;
//    mangePayVC.number = [NSNumber numberWithInt:_buyNumberIntt];
//    mangePayVC.amt = [NSNumber numberWithInt:_buyNumberIntt*[_qigouMoneyy intValue]];
//    
//    [self.navigationController pushViewController:mangePayVC animated:YES];
//    
//}


- (IBAction)licenseAgreement:(id)sender {
    
    WebAgreementViewController *web = [[WebAgreementViewController alloc] init];
    
    web.hidesBottomBarWhenPushed = YES;
    web.url = [NSURL URLWithString:@"http://112.65.206.146:8000/get/account/licenseAgreement"];
    web.titleName = @"授权协议";
    
    [self.navigationController pushViewController:web animated:YES];
    
    
    
}



- (IBAction)loanAgreement:(id)sender {
    
    WebAgreementViewController *web = [[WebAgreementViewController alloc] init];
    
    web.hidesBottomBarWhenPushed = YES;
    web.url = [NSURL URLWithString:@"http://112.65.206.146:8000/get/account/loanAgreement"];
    web.titleName = @"借款协议";
    
    
    [self.navigationController pushViewController:web animated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 计算传递的文字的宽度
/**
 *  根据文字算出文字所占区域大小
 *
 *  @param text    文字内容
 *  @param font    字体
 *  @param maxSize 最大尺寸
 *
 *  @return 实际尺寸
 */
- (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

@end
