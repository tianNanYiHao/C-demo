//
//  MyCreditCardMachineViewController.m
//  QuickPos
//
//  Created by Leona on 15/3/18.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "MyCreditCardMachineViewController.h"
#import "CardMachineTableViewCell.h"
#import "Common.h"
#import "PSTAlertController.h"
#import "PSTAlertController.h"

@interface MyCreditCardMachineViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData,UIAlertViewDelegate>{
    
    NSArray *tableViewArray;//列表数组
    
    NSDictionary *dic;//请求返回取值字典
    
    int posDevice;//刷卡器的型号取值
    
    NSString * aichuangIC;     //艾创IC 刷卡头
    
    NSString * aichuangBlueTooth;  //艾创蓝 ⽛牙vpos,
    
    NSString * aichuangICvPos;          //艾创IC vPos,
    
    NSString * aichuangIC4000;  //艾创 4000磁条刷卡 头
    
    NSString * newLand;    //新⼤大陆 IC刷卡头,
    
    NSString * MagneticStripe;        //艾创磁条vpos或磁条⾳音 频pos
    
    NSTimer *timer;//延迟显示
    
    NSMutableArray *_blueToothNumberSaveArray;  //保存蓝牙识别号的数组
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *myCreditCardMachineTableView;

@end

@implementation MyCreditCardMachineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _blueToothNumberSaveArray = [NSMutableArray arrayWithCapacity:0];
    self.myCreditCardMachineTableView.scrollEnabled = YES;
    _myCreditCardMachineTableView.userInteractionEnabled = YES;
    _myCreditCardMachineTableView.dataSource = self;
    _myCreditCardMachineTableView.delegate  = self;
    
    self.title = L(@"MyCreditCardMachine");
    
    self.navigationController.navigationBarHidden = NO;
    
//    tableViewArray = [NSArray array];
    
//    self.myCreditCardMachineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    Request *requst = [[Request alloc]initWithDelegate:self];
    
//    [requst myCreditCardMachine];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"MBPLoading")];
    [hud hide:YES afterDelay:1];
    [Common setExtraCellLineHidden:self.myCreditCardMachineTableView];
    
    
    
   
    
    

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}
-(void)addNumber{
    
    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"欢迎使用" message:@"请绑定您的蓝牙刷卡器"];
    [gotoPageController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"] length]>0) {
            textField.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
        }else{
            textField.placeholder = @"请输入蓝牙刷卡头编号(YL开头)";
        }
    }];
    
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"取消" handler:^(PSTAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myCreditCardMachineTableView reloadData];
        });
    }]];
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"绑定" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        if ([action.alertController.textField.text length]>0){
            [_blueToothNumberSaveArray addObject:action.alertController.textField.text];
            NSLog(@"==%@",[_blueToothNumberSaveArray lastObject]);
            [[NSUserDefaults standardUserDefaults] setObject:action.alertController.textField.text forKey:@"uuidName"];
            [_myCreditCardMachineTableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *array = [[NSArray alloc] initWithArray:_blueToothNumberSaveArray];
                [Tool setobject:array forkey:@"save_blueToothNumberSaveArray"];
                
                NSLog(@"%@",[Tool objectforkey:@"save_blueToothNumberSaveArray"]);
                
            });
        }else{
             [MBProgressHUD showHUDAddedTo:self.view WithString:@"蓝牙刷卡头绑定码未填写"];
        }
        
       
    }]];
    [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableArray *arr = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"save_blueToothNumberSaveArray"];

    if (arr) {
        _blueToothNumberSaveArray = [[NSMutableArray alloc] initWithArray:arr];
    }else{
        
    }
    [_myCreditCardMachineTableView reloadData];

}
- (void)showMBP{
    
    
    [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"NoMachine")];
    
    [timer invalidate];
    
    self.myCreditCardMachineTableView.scrollEnabled = YES;
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    //无记录返回取值
    NSDictionary *resultDic = [[dict objectForKey:@"data"] objectForKey:@"result"];
    
    if([resultDic[@"resultCode"] isEqual:@"8895"]){
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(showMBP) userInfo:nil repeats:NO];
        
        
    }else if([dict[@"respCode"] isEqual:@"0000"]){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.myCreditCardMachineTableView.scrollEnabled = YES;
    
        tableViewArray = [[dict objectForKey:@"data"] objectForKey:@"resultBean"];
        
        
        [self.myCreditCardMachineTableView reloadData];
    }
    
}



#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _blueToothNumberSaveArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MachineCellCellIdentifier = @"CardMachineTableViewCell";
    
    CardMachineTableViewCell *MachineCell = (CardMachineTableViewCell *) [tableView dequeueReusableCellWithIdentifier:MachineCellCellIdentifier];
    MachineCell.userInteractionEnabled = YES;
    
    MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"22"];
    
    MachineCell.CardMachineLabel.text = _blueToothNumberSaveArray[indexPath.row];
    
    
    
//    MachineCell.CardMachineLabel.text = tableViewArray[indexPath.row][@"psam"];
//    
//    
//    NSString *device = tableViewArray[indexPath.row][@"posDevice"];
//    
//    posDevice = [device intValue];
//    
//    if(posDevice == 1){
//    
//        MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"itron_ic"];
//    
//    
//    }else if (posDevice == 10){
//    
//        MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"itron_bt_vpos"];
//    
//    }else if (posDevice == 100){
//        
//        MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"itron_audio_vpos"];
//        
//    }else if (posDevice == 1000){
//        
//        MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"itron_4k"];
//        
//    }else if (posDevice == 10000){
//        
//        MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"newland_ic"];
//        
//    }else if (posDevice == 100000){
//        
//        MachineCell.CardMachineImageView.image = [UIImage imageNamed:@"itron_audio"];
//        
//    }
//
//    
    return MachineCell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSUserDefaults standardUserDefaults] setObject:_blueToothNumberSaveArray[indexPath.row] forKey:@"uuidName"];
    
    
    
    PSTAlertController *pstaCont = [PSTAlertController alertWithTitle:@"" message:@"绑定成功"];
    [pstaCont addAction:[PSTAlertAction actionWithTitle:@"去刷卡" handler:^(PSTAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = 0;
        });
        
    }]];
    [pstaCont addAction:[PSTAlertAction actionWithTitle:@"取消" handler:^(PSTAlertAction * _Nonnull action) {
        
    }]];
    [pstaCont showWithSender:nil controller:self animated:YES completion:NULL];
   
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_blueToothNumberSaveArray removeObjectAtIndex:indexPath.row];
        
        NSArray *array = [[NSArray alloc] initWithArray:_blueToothNumberSaveArray];
        [Tool setobject:array forkey:@"save_blueToothNumberSaveArray"];
        
        if (array.count == 0) {
            //如果数组为空 则存储空字符串
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"uuidName"];
        }else {
            //重新存储上一条记录
            [[NSUserDefaults standardUserDefaults] setObject:_blueToothNumberSaveArray[indexPath.row-1] forKey:@"uuidName"];
        }
       
        [_myCreditCardMachineTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}


//  十进制转二进制
- (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal
{
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (int i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}


@end
