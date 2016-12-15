//
//  CarBuyViewController.m
//  QuickPos
//
//  Created by Lff on 16/12/7.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "CarBuyViewController.h"
#import "CarBuyListCell.h"
#import "CarBuyHeadListCell.h"
#import "JFShopCarModel.h"
#import "MJExtension.h"
#import "SDImageCache.h"
#import "Common.h"

@interface CarBuyViewController ()<UITableViewDelegate,UITableViewDataSource,CarBuyListCellDelegate,CarBuyHeadListCellDelegate>
{
    
    
}
@property (nonatomic,strong) NSMutableArray *arrSection;
@property (nonatomic,strong) NSMutableDictionary *shopCarDic;
@property (nonatomic,strong) NSMutableArray *selectedShopArray;
@property (nonatomic,strong) NSMutableArray *selectedStoreArray;
@property (nonatomic,strong) JFShopCarModel *model;

@property (weak, nonatomic) IBOutlet UITableView *tableShowView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;//结算按钮
@property (weak, nonatomic) IBOutlet UILabel *moneyShowLab;//金额Lab
@end

@implementation CarBuyViewController
/**
 店铺名称数组
 */
-(NSMutableArray*)arrSection{
    if (!_arrSection) {
        _arrSection = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrSection;
}

/**
 JFShopCarModel 模型字典
 */
-(NSMutableDictionary *)shopCarDic{
    if (!_shopCarDic) {
        _shopCarDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }return _shopCarDic;
}
-(JFShopCarModel *)model{
    if (!_model) {
        _model = [[JFShopCarModel alloc] init];
    }
    return _model;
}

/**
 选中的商品数组
 */
- (NSMutableArray *)selectedShopArray{
    if (!_selectedShopArray) {
        _selectedShopArray = [NSMutableArray new];
    }return _selectedShopArray;
}

/**
 选中的商店数组
 */
- (NSMutableArray *)selectedStoreArray{
    if (!_selectedStoreArray) {
        _selectedStoreArray = [NSMutableArray new];
    }return _selectedStoreArray;
}



//结算点击事件
- (IBAction)buyBtnClick:(UIButton*)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = [Common hexStringToColor:@"ECEBF5"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [Common hexStringToColor:@"#068bf4"];//导航栏颜色
    self.navigationController.navigationBar.tintColor = [Common hexStringToColor:@"#ffffff"];//返回键颜色
    self.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createTableView];
    [self setModel];
}

-(void)setModel{
    //清空
    [self.selectedShopArray removeAllObjects];
    [self.selectedStoreArray removeAllObjects];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shoppingCar" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
    //根据sotre_id 获取Section个数
    for (NSDictionary *dict  in arr) {
        JFShopCarModel *model = [JFShopCarModel mj_objectWithKeyValues:dict];
        if (![self.arrSection containsObject:@(model.store_id)]) {
            [self.arrSection addObject:@(model.store_id)];
        }
    }

    //字典数组 ==> 模型数组
    NSArray *modelArr = [JFShopCarModel mj_objectArrayWithKeyValuesArray:arr];
    for (NSNumber *store_id in self.arrSection) {
        NSMutableArray *arrayModel = [NSMutableArray new];
        for (JFShopCarModel *model  in modelArr) {
            if (model.store_id == [store_id integerValue]) {
                [arrayModel addObject:model];
            }
        }
        [self.shopCarDic setObject:arrayModel forKey:store_id];
    }
    [_tableShowView reloadData];
}

-(void)createTableView
{
    _tableShowView.delegate = self;
    _tableShowView.dataSource = self;
    _tableShowView.backgroundColor = [Common hexStringToColor:@"ECEBF5"];
    [_tableShowView registerNib:[UINib nibWithNibName:@"CarBuyHeadListCell" bundle:nil] forCellReuseIdentifier:@"CarBuyHeadListCell"];
    [_tableShowView registerNib:[UINib nibWithNibName:@"CarBuyListCell" bundle:nil] forCellReuseIdentifier:@"CarBuyListCell"];
    
}
#pragma mark - tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrSection.count != 0) {
        return self.arrSection.count;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.arrSection.count != 0) {
        if (section != self.arrSection.count) {
            NSMutableArray *arr = [self.shopCarDic objectForKey:self.arrSection[section]];
            return  (arr.count+1);
        }else{
            return 0;
        }
    }
    else{
        return 0;
    }
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
//    bgView.backgroundColor = [Common hexStringToColor:@"ECEBF5"];
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.arrSection.count != 0) {
        if (indexPath.section != self.arrSection.count) {
            if (indexPath.row == 0) {
                return 40;
            }else{
                return 90;
            }
        }else{
            return 0;
        }
    }
    else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != self.arrSection.count) {
        NSMutableArray *array = [self.shopCarDic objectForKey:self.arrSection[indexPath.section]];
        if (indexPath.row == 0) {
            static NSString * iDD = @"CarBuyHeadListCell";
            CarBuyHeadListCell *cell = [tableView dequeueReusableCellWithIdentifier:iDD forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = array[indexPath.row];
            cell.delegate = self;
            if ([self.selectedStoreArray containsObject:@(cell.model.store_id)]) {
                cell.selectedBtn.selected = YES;
            }else{
                cell.selectedBtn.selected = NO;
            }
            return cell;
        }
        else{
            static NSString *stt = @"CarBuyListCell";
            CarBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:stt forIndexPath:indexPath];
            cell.model = array[indexPath.row -1];  //取后一位
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }else{
        static NSString *s = @"error";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:s];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - CarBuyListDelete
-(void)chooseBtnClickDelegate:(UIButton *)btn model:(JFShopCarModel *)model{
    //1:判断:修改选中商店的状态
    if ([self.selectedShopArray containsObject:model]) {
        [self.selectedShopArray removeObject:model];
        model.isSelected = NO;
    }
    else{
        [self.selectedShopArray addObject:model];
        model.isSelected = YES;
    }
    //2.判断:是否店铺名下所有店铺被选中
    BOOL isExist = YES;
    NSArray *arrModel = [self.shopCarDic objectForKey:@(model.store_id)];
    for (JFShopCarModel *model in arrModel) {
        if (![self.selectedShopArray containsObject:model]) {
            isExist = NO;
            break;
        }
    }
    //3.判断:如果店铺名下商品全选,则添加店铺名入数组
    if (isExist && ![self.selectedStoreArray containsObject:@(model.store_id)]) {
        [self.selectedStoreArray addObject:@(model.store_id)];
    }
    //4.判断:如果店铺名下商品未全选,则删除此店铺名
    if (!isExist && [self.selectedStoreArray containsObject:@(model.store_id)]) {
        [self.selectedStoreArray removeObject:@(model.store_id)];
    }
    
    [_tableShowView reloadData];
}
-(void)CarBuyListCellGoods_numChange:(CarBuyListCell *)cell{
    
}

#pragma mark - CarBuyHeadviewListDelegate
-(void)chooseStoreBtn:(UIButton *)btn store_id:(NSInteger)store_id{
    NSArray *arrayModel = [self.shopCarDic objectForKey:@(store_id)];
    //1.判断:删除店铺名
    if ([self.selectedStoreArray containsObject:@(store_id)]) {
        [self.selectedStoreArray removeObject:@(store_id)];
        //同时:此店铺名下所有商品 循环删除
        for (JFShopCarModel *model  in arrayModel) {
            [self.selectedShopArray removeObject:model];
            model.isSelected = NO;
        }
    }else{
        //2.判断:添加店铺名进数组
        [self.selectedStoreArray addObject:@(store_id)];
        //同时:此店铺名下所有商品  循环添加
        for (JFShopCarModel *model in arrayModel) {
            if (![self.selectedShopArray containsObject:model]) {
                [self.selectedShopArray addObject:model];
                model.isSelected = YES;
            }
        }
    }
    [_tableShowView reloadData];
    
}




@end
