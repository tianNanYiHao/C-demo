//
//  mallViewController.m
//  QuickPos
//
//  Created by 张倡榕 on 15/3/9.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "MallViewController.h"
#import "ShoppingCartViewController.h"
#import "MallCollectionViewCell.h"
#import "Request.h"
#import "MJRefresh.h"
#import "MallData.h"
#import "UIImageView+WebCache.h"
#import "DDMenuController.h"
#import "QuickPosTabBarController.h"
#import "OrderViewController.h"
#import "EditMallViewController.h"
#import "ShopCartTableViewCell.h"
#import "MyBankListViewController.h"
#import "PayType.h"
#import "OrderData.h"
#import "Common.h"
#import "BoRefreshHeader.h"
#import "BoRefreshAutoStateFooter.h"
#import "SDCycleScrollView.h"

#define tableCellHeight 30

@interface MallViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,ResponseData,UISearchBarDelegate,getOrderTypeProtocol,UITableViewDataSource,UITableViewDelegate,getOrderTypeProtocol,SDCycleScrollViewDelegate>
{
    AVCaptureSession * _AVSession;

    BOOL state;                         //是否处于编辑状态
    BOOL addType;
    BOOL
    
    
    mobileType;                    //判断商城是否不一致
    BOOL photoType;                     //判断图片是否改变
    BOOL mallOrderType;                     //订单上是否完成
    Request *request;
    int HintCount;                      //购物车提示计数；
    int deleteIndex;                    //删除索引
    int getDataType;                    //刷新或删除索引  0 = 初始  1 = 加载新   2 = 加载旧
    NSString *mobileNO;
    NSString *FristId ;
    NSString *LastId ;
    NSInteger indexRow;                 //记录点击的cell的row；
    NSString *collectionCellID;
    UIImage *takePhoneImg;
    NSMutableArray *MerchandiseArr;     //商城数据源
    NSMutableArray *shopCartArr;        //购物车商品数组
/********************************************************************************/
    MallItem *mallItem;
    MallData *mallData;
    NSArray *titleArray;
    NSMutableArray *productListArray;
    NSString *refeshcardId;
    NSMutableArray *orderListArray;
    NSDictionary *detailDic;
    int prodetailNum;
    
    
    NSMutableArray *commodityIDArr;
    NSString *orderDesc;
    NSString *payTool;
//    OrderData *orderData;
    NSUInteger payType;
    NSString *commodityIDs;
    NSString *merchantId;
    NSString *productId;
    NSString *fromType;
    NSMutableArray *cartArray;
    NSMutableArray *CartArr;
    long long  Sumprice;
    NSDictionary *oneProductDic;
    NSDictionary *oneProductMoneyDic;
    NSDictionary *productlistDic;
    NSMutableArray *buttonArray;
    NSString *cartTotalMount;
}
@property (weak, nonatomic) IBOutlet UIButton *editAction;
@property (weak, nonatomic) IBOutlet UILabel *shopHint;                     //购物车计数label
@property (weak, nonatomic) IBOutlet UICollectionView *mallCollectionView;
@property (weak, nonatomic) IBOutlet UIView *seachingView;
@property (weak, nonatomic) IBOutlet UIView *navView;           //
@property (weak, nonatomic) IBOutlet UISearchBar *SearchMall;
@property (weak, nonatomic) IBOutlet UIView *segview1;
@property (weak, nonatomic) IBOutlet UIView *segview2;
@property (weak, nonatomic) IBOutlet UIView *segview3;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITableView *shopcarttable;
@property (weak, nonatomic) IBOutlet UIView *shopcarttableFootView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *shoplist1;
@property (weak, nonatomic) IBOutlet UIView *shoplist2;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UIView *mallDetailView;
@property (weak, nonatomic) IBOutlet UIView *shopCateView;
@property (weak, nonatomic) IBOutlet UIView *sureCateView;
@property (weak, nonatomic) IBOutlet UIView *consigneeView;  //
@property (weak, nonatomic) IBOutlet UIButton *historyAddressBtn;  //历史地址按钮


@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIView *choiceView;

@property (weak, nonatomic) IBOutlet UITableView *surecarttable;
@property (weak, nonatomic) IBOutlet UIView *surecarttableFootView;


@property (weak, nonatomic) IBOutlet UITableView *shopCateTable;


@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView4;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *original;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *express;
@property (weak, nonatomic) IBOutlet UILabel *detailattribute;
@property (weak, nonatomic) IBOutlet UILabel *detailNum;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UIView *prodetailView;

@property (weak, nonatomic) IBOutlet UITextField *nametext;
@property (weak, nonatomic) IBOutlet UITextField *phonetext;
@property (weak, nonatomic) IBOutlet UITextView *addresstext;
@property (strong, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *lasttotalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;


@end

@implementation MallViewController
@synthesize editAction;
@synthesize seachingView;
@synthesize shopHint;
@synthesize SearchMall;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];                                //初始化数据
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;//解决向下偏移
    }
    SearchMall.layer.masksToBounds = YES;
    SearchMall.layer.cornerRadius = 5.0;
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getOrderFinish:) name:@"ClearShoppingCartNotification" object:nil];
    [self.segview1 setHidden:YES];
    [self.segview2 setHidden:NO];
    [self.segview3 setHidden:YES];
    [self.mainView bringSubviewToFront:self.segview2];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载商品数据."];
    [hud hide:YES afterDelay:1];
    [request sendInfo];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tag = 50001;
    self.table.header = [BoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    titleArray =[[NSArray alloc] init];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.table.frame = CGRectMake(0, 0, self.table.frame.size.width - 40, (tableCellHeight+10) *[titleArray count] );
    self.table.scrollEnabled = YES;
    self.table.sectionFooterHeight = 0;
    self.table.sectionHeaderHeight = 0;
    
    self.shopcarttable.sectionHeaderHeight = 0;
    self.shopcarttable.sectionFooterHeight = 120;
    self.shopcarttable.delegate = self;
    self.shopcarttable.dataSource = self;
    self.shopcarttable.tag = 50002;
    self.shopcarttable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shopcarttable.tableFooterView = self.shopcarttableFootView;
    [self.mainView bringSubviewToFront:self.segview1];
    [self.view sendSubviewToBack:self.choiceView];
    
    
    self.surecarttable.sectionHeaderHeight = 0;
    self.surecarttable.sectionFooterHeight = 120;
    self.surecarttable.delegate = self;
    self.surecarttable.dataSource = self;
    self.surecarttable.tag = 50003;
    self.surecarttable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.surecarttable.tableFooterView = self.surecarttableFootView;
    
    self.shopCateTable.sectionHeaderHeight = 0;
    self.shopCateTable.sectionFooterHeight = 120;
    self.shopCateTable.delegate = self;
    self.shopCateTable.dataSource = self;
    self.shopCateTable.tag = 50004;
    self.shopCateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.totalMoneyLabel.text = @"合计（不含运费）：60";
    self.totalMoneyLabel.text = @"";
    buttonArray =[[NSMutableArray alloc] init];
    
    [self.button1 setTitleColor:[Common hexStringToColor:@"14b9d5"] forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
- (void)loadNewData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.table reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.table.header endRefreshing];
    });
}

-(void)initData
{
    mobileNO = [AppDelegate getUserBaseData].mobileNo;
    HintCount = 0;
    getDataType = 0;
    shopCartArr = [NSMutableArray array];
    MerchandiseArr = [NSMutableArray array];
    request = [[Request alloc]initWithDelegate:self];
    state = NO;
    mobileType = YES;
    addType = NO;
    seachingView.hidden = YES;
    shopHint.hidden = YES;
    shopHint.layer.masksToBounds = YES;
    shopHint.layer.cornerRadius = 10;
    collectionCellID = @"MallCollectionViewCellID";
    
    //下拉,上拉
    self.mallCollectionView.header = [BoRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//    [self.mallCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self cancelFristResponder]; //取消第一响应者
    
}

-(IBAction)tapBackToHide:(id)sender{
    UIButton *button = (id)sender;
    [button setHidden: YES];
}

//立即购买
- (IBAction)mallDetailToconsigneeView:(id)sender{
    [self.mainView bringSubviewToFront:self.consigneeView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在计算金额."];
    [hud hide:YES afterDelay:1];
    productlistDic = @{@"productId":[detailDic objectForKey:@"productId"],
            @"discount":[NSString stringWithFormat:@"%li",[[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"discount"] longValue]],
            @"count":[NSString stringWithFormat:@"%d",prodetailNum],
            @"expressId":[[[detailDic objectForKey:@"express"] objectAtIndex:0] objectForKey:@"expressId"],
            @"expressprice":[[[detailDic objectForKey:@"express"] objectAtIndex:0] objectForKey:@"amount"],
            @"productAttributeId":[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"productAttributeId"]
            };
    fromType = @"detail";
    [request getMoneyInfoWithProductId:[oneProductDic objectForKey:@"productId"] productList:[NSArray arrayWithObjects:productlistDic, nil]];
}
//加入购物车
- (IBAction)mallDetailToChoiceView:(id)sender{
    [self.view bringSubviewToFront:self.choiceView];
    productlistDic = @{@"productId":[detailDic objectForKey:@"productId"],
                       @"discount":[NSString stringWithFormat:@"%li",[[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"discount"] longValue]],
                       @"count":[NSString stringWithFormat:@"%d",prodetailNum],
                       @"expressId":[[[detailDic objectForKey:@"express"] objectAtIndex:0] objectForKey:@"expressId"],
                       @"expressprice":[[[detailDic objectForKey:@"express"] objectAtIndex:0] objectForKey:@"amount"],
                       @"productAttributeId":[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"productAttributeId"]
                       };
    
    
    
    HintCount++;
    shopHint.hidden = NO;
    shopHint.text = [NSString stringWithFormat:@"%d",HintCount];
    
    NSMutableArray *copyShopArr = [NSMutableArray arrayWithArray:shopCartArr];
    
    int index = 0;
    BOOL yno = NO;
    //拷贝数组用于循环取值。
    //不为空。进入判断。
    if (shopCartArr.count != 0) {
        //取标示用于for循环比较。
        NSString *Tag = [(MallItem*)mallData.mallArr[indexRow] commodityID] ;
        //进入循环。。dic循环copy数组。
        for (MallItem *dic in copyShopArr) {
            NSString *TagT = dic.commodityID;
            //判断是标示，如相同，再次进入循环。
            if ([Tag isEqualToString:TagT]) {
                //取出计数
                NSString *sum = dic.sum;
                int temp = [sum intValue];
                //计数+1
                temp=temp +prodetailNum;
                //写入计数
                [(MallItem*)shopCartArr[index] setSum:[NSString stringWithFormat:@"%d",temp]];
                //修改判断为YES
                yno = YES;
                //跳出循环
                break;
            }
            index ++;
        }
        //判断是否修改如，如果修改判断为NO。则点击item数据在原有数据中没有存在。则
        if (yno == NO) {
            [(MallItem*)mallData.mallArr[indexRow] setSum:[NSString stringWithFormat:@"%d",prodetailNum]];
            [(MallItem*)mallData.mallArr[indexRow] setDic:productlistDic];
            [shopCartArr addObject:mallData.mallArr[indexRow]];
        }
    }
    //如果为空则直接加入。
    else if (shopCartArr.count == 0) {
        [(MallItem*)mallData.mallArr[indexRow] setSum:[NSString stringWithFormat:@"%d",prodetailNum]];
        [(MallItem*)mallData.mallArr[indexRow] setDic:productlistDic];
        [shopCartArr addObject:mallData.mallArr[indexRow]];
    }

}

- (IBAction)controlTap:(id)sender{
    [self.view sendSubviewToBack:self.choiceView];
}

- (IBAction)choiceViewToShopList:(id)sender{
    [self.view sendSubviewToBack:self.choiceView];
    [self.mainView bringSubviewToFront:self.shoplist1];
}

- (IBAction)choiceViewToShopCartView:(id)sender{
    [self.view sendSubviewToBack:self.choiceView];
    [self.segview3 setHidden:NO];
    [self.mainView bringSubviewToFront:self.segview3];
    float total =0.0;
    for (MallItem * item  in shopCartArr) {
        total = total + [item.price floatValue]*[item.sum intValue];
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat: @"合计（不含运费）：%.2f",total/100.0f];
    [self.shopcarttable reloadData];
}

- (IBAction)shopCartToSureView:(id)sender{
    [self.mainView bringSubviewToFront:self.sureCateView];
    NSMutableArray *array =[[NSMutableArray alloc] init];
    for (MallItem * a in shopCartArr) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:a.dic];
        [dic setObject:a.sum forKey:@"count"];
        [array addObject: dic];
    }
    [self.surecarttable reloadData];
    fromType = @"cart";
    [request getMoneyInfoWithProductId:nil productList:array];
}

- (IBAction)sureCartToconsigneeView:(id)sender {
    [self.mainView bringSubviewToFront:self.consigneeView];
    
}


//判断输入收货信息,并跳转支付方式页面
- (IBAction)consigneeViewTopayView:(id)sender {
    if ([self.nametext.text length] ==0) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"请输入姓名"];
    }else{
        if ([self.phonetext.text length] ==0) {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"请输入手机号码"];
        }else{
            if ([self.addresstext.text length] ==0) {
                [MBProgressHUD showHUDAddedTo:self.view WithString:@"请输入收货地址"];
            }else{
                
                [self.mainView bringSubviewToFront:self.payView];
                
                
            }
        }
    }
    
}


- (void)computePrice
{
    for (MallItem *dic  in CartArr) {
        int sum = [dic.sum intValue];
        NSString *pr = [NSString stringWithFormat:@"%.2f",[dic.price doubleValue]];
        long long price = [[pr stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        Sumprice += sum * price;
        
        [commodityIDArr addObject:dic.commodityID];
    }
    
    NSMutableString *temp = [NSMutableString string];
    for (NSMutableString *str in commodityIDArr) {
        [temp appendFormat:@"%@,",str];
    }
    
    orderDesc = self.phonetext.text;
    commodityIDs = [temp substringToIndex:temp.length-1];
    
//    finalPrice.text = [NSString stringWithFormat:@"%.2f",Sumprice / 100.0];
//    totalPrice.text = [NSString stringWithFormat:@"%.2f",Sumprice / 100.0];
    
    
}

- (IBAction)onlinePay:(id)sender{
    payType = QuickPayType;
    commodityIDArr = [NSMutableArray array];
    orderDesc = [NSMutableString string];
    payTool = @"01";
    
    if ([fromType isEqualToString:@"detail"]) {
        [request gettotalMoneyWithProductLists:[NSArray arrayWithObjects:productlistDic, nil] withMobile:self.phonetext.text withTotal:[NSString stringWithFormat:@"%li",[[oneProductMoneyDic objectForKey:@"totalAmount"] longValue]]];
    }else{
        NSMutableArray *array =[[NSMutableArray alloc] init];
        for (MallItem * a in shopCartArr) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:a.dic];
            [dic setObject:a.sum forKey:@"count"];
            [array addObject: dic];
        }

        [request gettotalMoneyWithProductLists:array withMobile:self.phonetext.text withTotal:cartTotalMount];
    }
    
}

- (IBAction)userCardToPay:(id)sender{
    payType = CardPayType;
    commodityIDArr = [NSMutableArray array];
    orderDesc = [NSMutableString string];
    payTool = @"01";
    if ([fromType isEqualToString:@"detail"]) {
        [request gettotalMoneyWithProductLists:[NSArray arrayWithObjects:productlistDic, nil] withMobile:self.phonetext.text withTotal:[NSString stringWithFormat:@"%li",[[oneProductMoneyDic objectForKey:@"totalAmount"] longValue]]];
    }else{
        NSMutableArray *array =[[NSMutableArray alloc] init];
        for (MallItem * a in shopCartArr) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:a.dic];
            [dic setObject:a.sum forKey:@"count"];
            [array addObject: dic];
        }

        [request gettotalMoneyWithProductLists:array withMobile:self.phonetext.text withTotal:cartTotalMount];
    }
    
}

- (void)toordViewwith:(OrderData *)orderData{
    OrderViewController *shopVc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
    shopVc.orderData = orderData;
    for (UIViewController *v in self.navigationController.viewControllers) {
        if ([v isKindOfClass:[MallViewController class]]) {
            shopVc.delegate = v;
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController pushViewController:shopVc animated:YES];
}


- (IBAction)switchButton:(UIButton *)sender{
    
    //线动画
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.line.frame;
        frame.origin.x = sender.frame.origin.x;
        self.line.frame = frame;
        self.line.backgroundColor = [Common hexStringToColor:@"14b9d5"];
    }];
    
    
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 101:
        {
            [self.button1 setTitleColor:[Common hexStringToColor:@"14b9d5"] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateNormal];
            [self.button3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
//            [self.segview1 setHidden:NO];
//            [self.segview2 setHidden:YES];
//            [self.segview3 setHidden:YES];
//            [self.mainView bringSubviewToFront:self.segview1];
            [self.segview1 setHidden:YES];
            [self.segview2 setHidden:NO];
            [self.segview3 setHidden:YES];
            [self.mainView bringSubviewToFront:self.segview2];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载商品数据."];
            [hud hide:YES afterDelay:1];
            [request sendInfo];
            
        }
            break;
        case 102:
        {
            
            [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateNormal];
            [self.button3 setTitleColor:[Common hexStringToColor:@"14b9d5"] forState:UIControlStateNormal];

            
             [self.mainView bringSubviewToFront:self.shopCateView];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载订单信息."];
            [hud hide:YES afterDelay:1];
            [request getInfoWithMobile:@"13818218401"];
//            [request getInfoWithMobile:[AppDelegate getUserBaseData].mobileNo];
//            [self.segview1 setHidden:YES];
//            [self.segview2 setHidden:NO];
//            [self.segview3 setHidden:YES];
//            [self.mainView bringSubviewToFront:self.segview2];
        }
            break;
        case 103:
        {
            [self.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.button2 setTitleColor:[Common hexStringToColor:@"14b9d5"]  forState:UIControlStateNormal];
            [self.button3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            
            [self.segview1 setHidden:YES];
            [self.segview2 setHidden:YES];
            [self.segview3 setHidden:NO];
            [self.mainView bringSubviewToFront:self.segview3];
            [self.shopcarttable reloadData];
            float total =0.0;
            for (MallItem * item  in shopCartArr) {
                total = total + [item.price floatValue]*[item.sum intValue];
            }
            self.totalMoneyLabel.text = [NSString stringWithFormat: @"合计（不含运费）：%.2f",total/100.0f];
        }
            break;
        default:
            break;
    }
}

- (void)orderSearch{
    [self.mainView bringSubviewToFront:self.shopCateView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载订单信息."];
    [hud hide:YES afterDelay:1];
    [request getInfoWithMobile:@"13818218401"];
}

-(void)viewWillAppear:(BOOL)animated
{
//    if (mallData.mallArr.count != 0) {
//        FristId = [mallData.mallArr[0] commodityID];
//        LastId = [mallData.mallArr[mallData.mallArr.count-1] commodityID];
//    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39/255.0 green:44/255.0 blue:54/255.0 alpha:1];
    self.title = @"商城";
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //设置标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor,
                                      [UIFont systemFontOfSize:17], UITextAttributeFont,
                                                                     nil]];
    
    UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 45)];
    [rightbtn setTitle:@"订单查询" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(orderSearch) forControlEvents:UIControlEventTouchUpInside];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
//    self.navigationItem.rightBarButtonItem = rightbar;
    self.navigationItem.rightBarButtonItem = nil;
    
//    if (!mallData.mallArr.count) {
//        [self setUpCollection];
//    }
//    else
//    {
//        [self.mallCollectionView headerBeginRefreshing];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (IBAction)showSetup:(UIBarButtonItem *)sender {
    
//    [(DDMenuController*)[(QuickPosTabBarController*)self.tabBarController parentCtrl] showRightController:YES];
     [(DDMenuController*)[(QuickPosTabBarController*)self.tabBarController parentCtrl] showLeftController:YES];
}


-(void)cancelFristResponder
{
    UIControl *backGroundControl = [[UIControl alloc] initWithFrame:
                                    CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backGroundControl.backgroundColor = [UIColor clearColor];
    [backGroundControl addTarget:self
                          action:@selector(backgroundTab)
                forControlEvents:UIControlEventTouchUpInside];
    UIControl *backGroundControl1 = [[UIControl alloc] initWithFrame:
                                    CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backGroundControl1.backgroundColor = [UIColor clearColor];
    [backGroundControl1 addTarget:self
                          action:@selector(backgroundTab)
                forControlEvents:UIControlEventTouchUpInside];
    [self.seachingView addSubview:backGroundControl1];
}
//取消第一响应者事件
- (void)backgroundTab
{
    [SearchMall resignFirstResponder];
    seachingView.hidden = YES;
}
//图片data转成字符串
- (NSString *)stringWithData:(NSData *)data
{
       //获取到之后要去掉尖括号和中间的空格
    NSString *strdata = [NSString stringWithFormat:@"%@",data];
    NSMutableString *st = [NSMutableString stringWithString:strdata];
    [st deleteCharactersInRange:NSMakeRange(0, 1)];
    [st deleteCharactersInRange:NSMakeRange(st.length-1, 1)];
    NSString *imageStr = [st stringByReplacingOccurrencesOfString:@" " withString:@""];
    return imageStr;
}
//下拉
-(void)headerRereshing
{
    getDataType = 1;
//    [request getMallListmobile:mobileNO firstData:FristId lastData:@"0" dataSize:@"20" requestType:@"02"];
    
    [request getProductWithCardId:refeshcardId];
}
//上拉
- (void)footerRereshing
{
    getDataType = 2;
    [request getMallListmobile:mobileNO firstData:@"0" lastData:LastId dataSize:@"20" requestType:@"01"]; 
}
//网络接口加载collection数据。
- (void)setUpCollection
{
    getDataType = 0;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载商品数据."];
    [hud hide:YES afterDelay:10];
    [request getMallListmobile:mobileNO firstData:@"0" lastData:@"0" dataSize:@"20" requestType:@"02"];
    
}
//网络数据返回
- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (type == REQUSET_AD) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
            NSLog(@"data:%@",[[dict objectForKey:@"REP_BODY"] objectForKey:@"mallAdvs"]);
            NSArray *array = [[dict objectForKey:@"REP_BODY"] objectForKey:@"mallAdvs"];
            NSMutableArray *mutableArray =[[NSMutableArray alloc] init];
            for (int i = 0; i < [array count]; i++) {
                NSDictionary * dic = [array objectAtIndex:i];
                [mutableArray addObject:[dic objectForKey:@"image"]];
                
            }

        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@""];
        }
    }
    else if (type == REQUSET_PRODUCTLIST) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dict);
        [self.mallCollectionView.header endRefreshing];

        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
            productListArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"REP_BODY"] objectForKey:@"mallProducts"]];
            mallData = [[MallData alloc]initWithData:productListArray];
            [self.mallCollectionView reloadData];
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"查询失败！"];
        }
    }
    else if (type == REQUSET_ORDER_INQUIRY) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dict);
        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
            orderListArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"REP_BODY"] objectForKey:@"termPrdOrders"]];
//            [self.shopCateTable reloadData];//订单去掉，不要显示出来
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"查询失败！"];
        }
    }
    else if(type == REQUSET_FIRST){//产品类别
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
            
            titleArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"REP_BODY"] objectForKey:@"MainCateInfs"]];
//            [self.collView reloadData];
            [self.table reloadData];
            
        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"查询失败！"];
        }
    }
    else if(type == REQUSET_PRODUCTDETAIL){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
            detailDic = [[NSDictionary alloc] initWithDictionary:[dict objectForKey:@"REP_BODY"]];
            [self loadDetail];
            
//            titleArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"REP_BODY"] objectForKey:@"MainCateInfs"]];
//            //            [self.collView reloadData];
            [self.table reloadData];
            
        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"查询失败！"];
        }
    }
    
    else if (type == REQUSET_GETMONEY) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",dict);
        [self.mallCollectionView.header endRefreshing];
        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
             if ([fromType isEqualToString:@"detail"]) {
                 oneProductMoneyDic = [[NSDictionary alloc] initWithDictionary:[dict objectForKey:@"REP_BODY"]];
             }else{
                 cartTotalMount = [NSString stringWithFormat:@"%f", [[[dict objectForKey:@"REP_BODY"] objectForKey:@"totalAmount"] floatValue]];
                 self.lasttotalMoneyLabel.text = [NSString stringWithFormat:@"合计：%.2f", [[[dict objectForKey:@"REP_BODY"] objectForKey:@"totalAmount"] floatValue]/100.0f];
             }
            
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"查询失败！"];
        }
    }
    
    else if (type == REQUSET_GETORDER) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if([[[dict objectForKey:@"REP_HEAD"] objectForKey:@"TRAN_CODE"] isEqualToString:@"000000"]){
            if ([fromType isEqualToString:@"detail"]) {
                NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[dict objectForKey:@"REP_BODY"]];
                OrderData *orderData = [[OrderData alloc] init];
                orderData.orderId = [dic objectForKey:@"orderid"];//订单编号
                orderData.orderAmt = [NSString stringWithFormat:@"%li",[[oneProductMoneyDic objectForKey:@"totalAmount"] longValue]];//订单金额
                orderData.orderDesc = [dic objectForKey:@"mercId"] ;//订单详情
                orderData.realAmt = [dic objectForKey:@"totalAmount"];//实际交易金额
                orderData.orderAccount = mobileNO;
                orderData.orderPayType = payType;
                orderData.merchantId = merchantId;
                orderData.productId = productId;
                [self toordViewwith:orderData];
            }else{
                NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[dict objectForKey:@"REP_BODY"]];
                OrderData *orderData = [[OrderData alloc] init];
                orderData.orderId = [dic objectForKey:@"orderid"];//订单编号
                orderData.orderAmt = cartTotalMount;//订单金额
                orderData.orderDesc = [dic objectForKey:@"mercId"] ;//订单详情
                orderData.realAmt = [dic objectForKey:@"totalAmount"];//实际交易金额
                orderData.orderAccount = mobileNO;
                orderData.orderPayType = payType;
                orderData.merchantId = merchantId;
                orderData.productId = productId;
                [self toordViewwith:orderData];
            }
            
            
            //        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"提交失败！"];
        }
    }
    
    else{
        
        if([[dict objectForKey:@"respCode"] isEqualToString:@"0000"]){
            if (mobileType == NO) {
                [MerchandiseArr removeAllObjects];
                mobileType = YES;
            }
            //获取数据
            if (type == REQUEST_COMMODITYLIST)
            {
                if (getDataType == 0) {
                    //            正常获取
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    MerchandiseArr = [[dict objectForKey:@"data"] objectForKey:@"list"];
                    mallData = [[MallData alloc]initWithData:MerchandiseArr];
                    
                }
                else if (getDataType == 1) {
                    int index = 0;
                    for (NSDictionary *DI in [[dict objectForKey:@"data"] objectForKey:@"list"]) {
                        [MerchandiseArr insertObject:DI atIndex:index];
                        index++;
                    }
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:MerchandiseArr];
                    for (int i = 0 ; i < arr.count - 1; i ++) {
                        for (int j = i + 1; j < arr.count; j ++) {
                            if ([[arr[i]  objectForKey:@"commodityID"] isEqualToString:[arr[j] objectForKey: @"commodityID"]])
                            {
                                [MerchandiseArr removeObjectAtIndex:j];
                            }
                            //                        NSLog(@"%@",[MerchandiseArr[i]  objectForKey:@"commodityID"]);
                        }
                    }
                    mallData = [[MallData alloc]initWithData:MerchandiseArr];
                }
                else if (getDataType == 2)
                {
                    [MerchandiseArr addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"list"]];
                    mallData = [[MallData alloc]initWithData:MerchandiseArr];
                }
                [self.mallCollectionView.header endRefreshing];
                [self.mallCollectionView.footer endRefreshing];
                NSLog(@"获取数据回调");
                
            }
            if (mallData.mallArr.count != 0) {
                FristId = [mallData.mallArr[0] commodityID];
                LastId = [mallData.mallArr[mallData.mallArr.count-1] commodityID];
            }
            [self.mallCollectionView reloadData];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }

}

- (void)loadDetail{
    self.prodetailView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.prodetailView.layer.borderWidth = 0.5f;
    [self.bigImageView sd_setImageWithURL:[[[detailDic objectForKey:@"images"] objectAtIndex:0] objectForKey:@"smallImage"] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
    [self.smallImageView1 sd_setImageWithURL:[[[detailDic objectForKey:@"images"] objectAtIndex:0] objectForKey:@"bigImage"] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
    [self.smallImageView2 sd_setImageWithURL:[[[detailDic objectForKey:@"images"] objectAtIndex:0] objectForKey:@"bigImage"] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
    [self.smallImageView3 sd_setImageWithURL:[[[detailDic objectForKey:@"images"] objectAtIndex:0] objectForKey:@"bigImage"] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
    [self.smallImageView4 sd_setImageWithURL:[[[detailDic objectForKey:@"images"] objectAtIndex:0] objectForKey:@"bigImage"] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
    self.productName.text = [detailDic objectForKey:@"productName"];
    self.original.text = [NSString stringWithFormat:@"促销价：%.2f", [[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"original"] intValue]/100.0f];
    self.marketPrice.text = [NSString stringWithFormat:@"原价：%.2f", [[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"marketPrice"] intValue]/100.0f];
    self.discount.text = [NSString stringWithFormat:@"库存量：%@", [[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"discount"]];
    int width =0;
    for (int i = 0; i < [[detailDic objectForKey:@"express"] count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[[detailDic objectForKey:@"express"] objectAtIndex:0] objectForKey:@"expressName"] forState:UIControlStateNormal];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        CGSize size = [[[[detailDic objectForKey:@"express"] objectAtIndex:0] objectForKey:@"expressName"] boundingRectWithSize:CGSizeMake(MAXFLOAT, button.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        button.frame = CGRectMake(self.express.frame.origin.x + self.express.frame.size.width +5 +width /1.0f  , self.express.frame.origin.y , size.width +10 , self.express.frame.size.height);
        
        width = button.frame.size.width;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =[[UIColor redColor] CGColor];
        button.layer.cornerRadius = 3.0f;
        [self.prodetailView addSubview:button];
        [buttonArray addObject:button];
    }
    
    {
        int width = 0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"attribute2"] forState:UIControlStateNormal];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        CGSize size = [[[[detailDic objectForKey:@"MODEL"] objectAtIndex:0] objectForKey:@"attribute2"] boundingRectWithSize:CGSizeMake(MAXFLOAT, button.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        button.frame = CGRectMake(self.detailattribute.frame.origin.x + self.detailattribute.frame.size.width +5 +width /1.0f  , self.detailattribute.frame.origin.y , size.width +10 , self.detailattribute.frame.size.height);
        
        width = button.frame.size.width;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor =[[UIColor redColor] CGColor];
        button.layer.cornerRadius = 3.0f;
        [self.prodetailView addSubview:button];
        [buttonArray addObject:button];
    }
}

- (IBAction)tapAdd{
    prodetailNum++;
    self.detailNum.text =[NSString stringWithFormat:@"%i",prodetailNum];
}

- (IBAction)tapDelete{
    if (prodetailNum >1) {
        prodetailNum--;
    }else{
        prodetailNum = 1;
    }
    self.detailNum.text =[NSString stringWithFormat:@"%i",prodetailNum];
}


- (IBAction)callTelephone:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006787575"];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


//购物车按钮
- (IBAction)shoppingCartAction:(id)sender {

    shopHint.hidden = YES;
    HintCount = 0;
    ShoppingCartViewController *shopVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartViewController"];
    
    if (shopCartArr) {
            shopVc.CartArr = [NSMutableArray arrayWithArray:shopCartArr];
    }
    
    shopVc.mobileNo = mobileNO;
    
    if (shopVc.CartArr.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"你的购物车没有商品"];
    }
    else
    {
        shopVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopVc animated:YES];
    }
}
//编辑商城按钮事件
- (IBAction)EditMall:(id)sender {
    if ([mobileNO isEqualToString:[AppDelegate getUserBaseData].mobileNo]) {
//        self.navView.hidden = YES;
//        self.editNavView.hidden = NO;
        state = YES;
        [shopCartArr removeAllObjects];
        //初始化商品计数
        for (int i = 0; i < mallData.mallArr.count; i++) {
            [mallData.mallArr[i] setSum:@"1"];
        }
        HintCount = 0;
        shopHint.hidden = YES;
//        [self.mallCollectionView reloadData];
        EditMallViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMallViewController"];
        editVC.mallData = mallData;
        editVC.editMerchandiseArr = MerchandiseArr;
        [self.navigationController pushViewController:editVC animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return mallData.mallArr.count;
    return [productListArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    MallCollectionViewCell *cell = (MallCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if ([[[productListArray objectAtIndex:indexPath.row] objectForKey:@"image"] isKindOfClass:[NSString class]]) {
        [cell.MerchandiseImage  sd_setImageWithURL:[NSURL URLWithString:[[productListArray objectAtIndex:indexPath.row] objectForKey:@"image"]]];
        
        
    }
    if ([[[productListArray objectAtIndex:indexPath.row] objectForKey:@"name"] isKindOfClass:[NSString class]]) {
        cell.MerchandiseNameLbl.text = [[productListArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
    }
//    MallItem *dic    = mallData.mallArr[indexPath.row];
//
//    [cell.MerchandiseImage sd_setImageWithURL:[NSURL URLWithString:dic.iconurl] placeholderImage:[UIImage imageNamed:@"tick"]];
//    cell.MerchandiseNameLbl.text = dic.title;
//    cell.MerchandisePrice.text = [NSString stringWithFormat:@"¥%@", dic.price];
//    if (state == NO)
//    {
//        cell.deleteBtn.hidden = YES;
//    }
//    else if (state == YES)
//    {
//        cell.deleteBtn.hidden = NO;
//    }
    return cell;
}

////根据机型改变cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2-20, 210);
    CGFloat width =  CGRectGetWidth(collectionView.frame)/2.0f;
    CGFloat height = width*19/16;
    return CGSizeMake(width, height);
    
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//定义每个collectionCell 的边缘
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(5, 15, 15, 15);//上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    indexRow = indexPath.row;
//    NSLog(@"%@", [mallData.mallArr[indexPath.row] commodityID]);
//    HintCount++;
//    shopHint.hidden = NO;
//    shopHint.text = [NSString stringWithFormat:@"%d",HintCount];
//    
//    NSMutableArray *copyShopArr = [NSMutableArray arrayWithArray:shopCartArr];
//    
//    int index = 0;
//    BOOL yno = NO;
//    //拷贝数组用于循环取值。
//    //不为空。进入判断。
//    if (shopCartArr.count != 0) {
//        //取标示用于for循环比较。
//        NSString *Tag = [(MallItem*)mallData.mallArr[indexPath.row] commodityID] ;
//        //进入循环。。dic循环copy数组。
//        for (MallItem *dic in copyShopArr) {
//            NSString *TagT = dic.commodityID;
//            //判断是标示，如相同，再次进入循环。
//            if ([Tag isEqualToString:TagT]) {
//                //取出计数
//                NSString *sum = dic.sum;
//                int temp = [sum intValue];
//                //计数+1
//                temp++;
//                //写入计数
//                [(MallItem*)shopCartArr[index] setSum:[NSString stringWithFormat:@"%d",temp]];
//                //修改判断为YES
//                yno = YES;
//                //跳出循环
//                break;
//            }
//            index ++;
//        }
//        //判断是否修改如，如果修改判断为NO。则点击item数据在原有数据中没有存在。则
//        if (yno == NO) {
//            [shopCartArr addObject:mallData.mallArr[indexPath.row]];
//        }
//    }
//    //如果为空则直接加入。
//    else if (shopCartArr.count == 0) {
//        [shopCartArr addObject:mallData.mallArr[indexPath.row]];
//    }
    [self.mainView bringSubviewToFront:self.mallDetailView];
    for (id v in buttonArray) {
        if ([v isKindOfClass:[UIButton class]]) {
            [(UIButton *)v removeFromSuperview];
        }
    }
    [buttonArray removeAllObjects];
    prodetailNum = 1;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载商品数据."];
    [hud hide:YES afterDelay:1];
    
    oneProductDic = [[NSDictionary alloc] initWithDictionary:[productListArray objectAtIndex:indexPath.row]];
    [request getDetailInfoWithProductId:[[productListArray objectAtIndex:indexPath.row] objectForKey:@"productId"] withTraceabilityId:[[productListArray objectAtIndex:indexPath.row] objectForKey:@"traceability"]];
    
}

#pragma mark - searchBar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![SearchMall.text isEqualToString:mobileNO]) {
        mobileNO = SearchMall.text;
        mobileType = NO;
        editAction.highlighted = YES;
        editAction.userInteractionEnabled = NO;
    }
    if ([[AppDelegate getUserBaseData].mobileNo isEqualToString:mobileNO])
    {
        editAction.highlighted = NO;
        editAction.userInteractionEnabled = YES;
    }
    [shopCartArr removeAllObjects];
    seachingView.hidden = YES;
    [SearchMall resignFirstResponder];
    [self setUpCollection];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    seachingView.hidden = NO;
}


#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:matchedStr];
}

#pragma mark - 获取订单是否完成协议
-(void)getOrderType:(BOOL)orderType
{
    mallOrderType = orderType;
    if (mallOrderType == YES)
    {
        [shopCartArr removeAllObjects];
        mallOrderType = NO;
        //订单完成后将数据模型里的商品计数全初始化为1，用于重新计数
        for (int i = 0; i < mallData.mallArr.count; i++) {
            [mallData.mallArr[i] setSum:@"1"];
        }
    }
    
}


-(void)getOrderFinish:(NSNotification*)n
{
    BOOL isFinish = [(NSString*)n.object boolValue];
    mallOrderType = isFinish;
    if (mallOrderType == YES)
    {
        [shopCartArr removeAllObjects];
        mallOrderType = NO;
        //订单完成后将数据模型里的商品计数全初始化为1，用于重新计数
        for (int i = 0; i < mallData.mallArr.count; i++) {
            [mallData.mallArr[i] setSum:@"1"];
        }
    }
    
}

#pragma table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 50001) {
        
        if (indexPath.row == 0) {
            return 150;
        }else if (indexPath.row == 4){
        return 200;
        }
        else{
            return 130;
        }

        
    }else if (tableView.tag == 50002) {
        return 140;
    }
    else if (tableView.tag == 50003) {
        return 140;
    }
    else if (tableView.tag == 50004) {
        return 140;
    }
    else{
        return tableCellHeight;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 50001) {
//        return [titleArray count];
        return 5;
    }else if (tableView.tag == 50002) {
        return [shopCartArr count];
    }else if (tableView.tag == 50003) {
        return [shopCartArr count];
    }else if (tableView.tag == 50004) {
        return [orderListArray count];
    }else{
        return [titleArray count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cell";
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    
    if (tableView.tag == 50001) {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {//广告图
            NSArray *imageArrays = @[[UIImage imageNamed:@"newbanner"]];
            SDCycleScrollView * sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, 150) imagesGroup:imageArrays];
            sdcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            sdcycleScrollView.delegate = self;
            sdcycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
            [cell addSubview:sdcycleScrollView];
//            UIImageView *imageA = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, 150)];
//            imageA.image = [UIImage imageNamed:@"banner3"];
//            [cell addSubview:imageA];
        }
        
        if (indexPath.row == 1) {
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/2, 150)];
            [btn1 setImage:[UIImage imageNamed:@"shopping_Grain"] forState:UIControlStateNormal];
            btn1.tag = 0;
            [btn1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width/2, 0, width/2, 150)];
            [btn2 setImage:[UIImage imageNamed:@"shopping_wine"] forState:UIControlStateNormal];
            btn2.tag = 1;
            [btn2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn2];
        }
        
        if (indexPath.row == 2) {
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/2, 150)];
            [btn1 setImage:[UIImage imageNamed:@"shopping_fitness"] forState:UIControlStateNormal];
            btn1.tag = 2;
            [btn1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width/2, 0, width/2, 150)];
            [btn2 setImage:[UIImage imageNamed:@"shopping_appliance"] forState:UIControlStateNormal];
            btn2.tag = 3;
            [btn2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn2];
        }
        
        if (indexPath.row == 3) {
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/2, 150)];
            [btn1 setImage:[UIImage imageNamed:@"shopping_food"] forState:UIControlStateNormal];
            btn1.tag = 4;
            [btn1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width/2, 0, width/2, 150)];
            [btn2 setImage:[UIImage imageNamed:@"shopping_phone"] forState:UIControlStateNormal];
            btn2.tag = 5;
            [btn2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn2];
        }
        
        if (indexPath.row == 4) {
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/3, 150)];
            [btn1 setImage:[UIImage imageNamed:@"shopping_tea"] forState:UIControlStateNormal];
            btn1.tag = 7;
            [btn1 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(width/3, 0, width/3, 150)];
            [btn2 setImage:[UIImage imageNamed:@"shopping_activity"] forState:UIControlStateNormal];
            btn2.tag = 6;
            [btn2 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn2];
            
            UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(2*width/3, 0, width/3, 150)];
            [btn3 setImage:[UIImage imageNamed:@"shopping_study"] forState:UIControlStateNormal];
            btn3.tag = 8;
            [btn3 addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn3];
        }
        
        
//        cell.textLabel.text = [NSString stringWithFormat:@"%i、%@", [indexPath row]+1,[[titleArray objectAtIndex:indexPath.row] objectForKey:@"cateName"]];
        
//        if (indexPath.row % 2 ==0 ) {
//            cell.backgroundColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
//        }else{
//            cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else if (tableView.tag == 50002) {
        ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MallItem *item = shopCartArr[indexPath.row];
        cell.indexLabel.text = [NSString stringWithFormat:@"%i、",[indexPath row] + 1];
        
        [cell.actor sd_setImageWithURL:[NSURL URLWithString:item.iconurl] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
        cell.name.text = item.title;
        cell.price2.text =[NSString stringWithFormat:@"%.2f", [item.price floatValue]/100.0f];
        cell.num.text = [NSString stringWithFormat:@"%d",[item.sum integerValue]];
        cell.totalprice.text = [NSString stringWithFormat:@"%.2f",[item.price floatValue] *[item.sum integerValue]/100.0f];
        return cell;
    }
    else if (tableView.tag == 50003) {
        ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MallItem *item = shopCartArr[indexPath.row];
        cell.indexLabel.text = [NSString stringWithFormat:@"%i、",[indexPath row] + 1];
        
        [cell.actor sd_setImageWithURL:[NSURL URLWithString:item.iconurl] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
        cell.name.text = item.title;
        cell.price2.text =[NSString stringWithFormat:@"%.2f", [item.price floatValue]/100.0f];
        cell.num.text = [NSString stringWithFormat:@"%d",[item.sum integerValue]];
        cell.totalprice.text = [NSString stringWithFormat:@"%.2f",[item.price floatValue] *[item.sum integerValue]/100.0f];
        return cell;
    }
    else if (tableView.tag == 50004) {
        ShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartTableViewCell" forIndexPath:indexPath];
        cell.indexLabel.text = [NSString stringWithFormat:@"%i、",[indexPath row] + 1];
        NSDictionary *mallOrders = [[[[[orderListArray objectAtIndex:indexPath.row] objectForKey:@"mallOrders"] objectAtIndex:0] objectForKey:@"mallOrderItem"] objectAtIndex:0];
        [cell.actor sd_setImageWithURL:[NSURL URLWithString:[mallOrders objectForKey:@"productImage"]] placeholderImage:[UIImage imageNamed:@"banner_default_image"]];
        cell.name.text = [mallOrders objectForKey:@"productName"];
        cell.price2.text =[NSString stringWithFormat:@"%.2f", [[mallOrders objectForKey:@"price"] floatValue]];
        cell.num.text = [NSString stringWithFormat:@"%d",[[mallOrders objectForKey:@"num"] integerValue]];
        cell.totalprice.text = [[[[orderListArray objectAtIndex:indexPath.row] objectForKey:@"mallOrders"] objectAtIndex:0] objectForKey:@"amount"];
        if (indexPath.row % 2 ==0 ) {
            cell.backgroundColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
        }
        
        return cell;
    }else{
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=[titleArray objectAtIndex:indexPath.row];
        if (indexPath.row % 2 ==0 ) {
            cell.backgroundColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];
        }
        return cell;
    }
    
}

- (void)selectButton:(UIButton *)btn{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载商品数据."];
    [hud hide:YES afterDelay:1];
    refeshcardId = [[titleArray objectAtIndex:btn.tag] objectForKey:@"cateId"];
    [request getProductWithCardId:[[titleArray objectAtIndex:btn.tag] objectForKey:@"cateId"]];
    [self.mainView bringSubviewToFront:self.shoplist1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 50001) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在加载商品数据."];
        [hud hide:YES afterDelay:1];
        refeshcardId = [[titleArray objectAtIndex:indexPath.row] objectForKey:@"cateId"];
        [request getProductWithCardId:[[titleArray objectAtIndex:indexPath.row] objectForKey:@"cateId"]];
        [self.mainView bringSubviewToFront:self.shoplist1];
       
    }
}

- (IBAction)seg1tap:(id)sender{
    [self.mainView bringSubviewToFront:self.shoplist1];
    if (!mallData.mallArr.count) {
        [self setUpCollection];
    }
    else
    {
        [self.mallCollectionView.header endRefreshing];
    }

    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 201:
        {
            
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            
        }
            break;
        case 204:
        {
            
        }
            break;
        case 205:
        {
            
        }
            break;
        case 206:
        {
            
        }
            break;
        case 207:
        {
            
        }
            break;
        case 208:
        {
            
        }
            break;
        case 209:
        {
            
        }
            break;
        
        default:
            break;
    }
}
- (IBAction)saveHistroyAddress:(UIButton *)sender {
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
