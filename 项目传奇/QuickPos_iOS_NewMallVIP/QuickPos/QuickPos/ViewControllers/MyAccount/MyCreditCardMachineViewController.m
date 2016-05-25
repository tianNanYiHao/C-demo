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
#import "MyCreditCardMachineModel.h"

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
    
    Request  *_req;
    
    MyCreditCardMachineModel  *_model;  //
    
    MBProgressHUD *_hud;
    
    
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *myCreditCardMachineTableView;

@end

@implementation MyCreditCardMachineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _req = [[Request alloc] initWithDelegate:self];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    //查询蓝牙机器
    [_req getBuleToothDeviceNumberWithInteger:@"1" deviceId:@"" psamId:@"" PhoneNumber:nil];
    [self showHUDWithString:@"正在核对您的蓝牙"];
    
    
    _blueToothNumberSaveArray = [NSMutableArray arrayWithCapacity:0];
    self.myCreditCardMachineTableView.scrollEnabled = YES;
    _myCreditCardMachineTableView.userInteractionEnabled = YES;
    _myCreditCardMachineTableView.dataSource = self;
    _myCreditCardMachineTableView.delegate  = self;
    
    self.title = L(@"MyCreditCardMachine");
    
    self.navigationController.navigationBarHidden = NO;
    

    [Common setExtraCellLineHidden:self.myCreditCardMachineTableView];
    
    
    
   
    
    

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}

-(void)showHUDWithString:(NSString*)message{
    _hud.labelText = message;
    _hud.delegate = self;
    [_hud show:YES];
    
}
-(void)endHUD{
    [_hud hide:YES];
}
-(void)addNumber{
    
    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"欢迎使用" message:@"请绑定您的蓝牙刷卡器"];
    [gotoPageController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = @"请输入蓝牙刷卡头编号(YL开头)";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"取消" handler:^(PSTAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myCreditCardMachineTableView reloadData];
        });
    }]];
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"绑定" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        if ([action.alertController.textField.text length]>0){
            NSString *deviceID =[NSString stringWithFormat:@"YL%@",action.alertController.textField.text];
            NSString *psamId   = [NSString stringWithFormat:@"8257000%@",action.alertController.textField.text];
            [_req getBuleToothDeviceNumberWithInteger:@"2" deviceId:deviceID psamId:psamId PhoneNumber:nil];
            [self showHUDWithString:@"正在绑定..."];
            
        }else{
             [MBProgressHUD showHUDAddedTo:self.view WithString:@"蓝牙刷卡头绑定码未填写"];
        }
        
    }]];
    [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];
}


- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    if (type == REQUEST_GETBULETOOHTHNUMBER) {

        [self endHUD];
        NSArray *tsf = [[dict objectForKey:@"data"] objectForKey:@"tsf"];
        if (tsf.count == 0) {
            // here  do nothing
        }else {
            if (_blueToothNumberSaveArray.count >0) {
                [_blueToothNumberSaveArray removeAllObjects];
            }
            
            for (int i=0; i<tsf.count; i++) {
                _model = [[MyCreditCardMachineModel alloc] init];
                _model.psamId = [tsf[i] objectForKey:@"psamId"];
                _model.deviceId = [tsf[i] objectForKey:@"deviceId"];
                _model.mobileNo = [tsf[i] objectForKey:@"mobileNo"];
                [_blueToothNumberSaveArray addObject:_model];
            }
           
            
        }
        
        if ([[[dict objectForKey:@"data"] objectForKey:@"optType"] isEqualToString:@"1"]) {  //查询
           
            NSArray *tsf = [[dict objectForKey:@"data"] objectForKey:@"tsf"];
            if (tsf.count == 0) {
                [Common showMsgBox:nil msg:@"您还未绑定蓝牙,请绑定" parentCtrl:self];
            }else {

                // here  do nothing
            }
           [_myCreditCardMachineTableView reloadData];
        }
        
        if ([[[dict objectForKey:@"data"] objectForKey:@"optType"] isEqualToString:@"2"]) { //绑定
            if ([[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"resultCode"]isEqualToString:@"7781"]) {
               [MBProgressHUD showHUDAddedTo:self.view WithString:[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"message"]];
            }
           else if ([[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"resultCode"]isEqualToString:@"7782"]) {
              [MBProgressHUD showHUDAddedTo:self.view WithString:[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"message"]];
            }
           else if ([[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"resultCode"]isEqualToString:@"7783"]) {
                [MBProgressHUD showHUDAddedTo:self.view WithString:[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"message"]];
            }
            else{ //绑定成功
                [_myCreditCardMachineTableView reloadData];
                 [[NSUserDefaults standardUserDefaults] setObject:[_blueToothNumberSaveArray.lastObject deviceId] forKey:@"uuidName"];
            }
            
        }
        if ([[[dict objectForKey:@"data"] objectForKey:@"optType"] isEqualToString:@"3"]) { //解绑
            [Common showMsgBox:@"" msg:@"删除成功" parentCtrl:self];
            [_myCreditCardMachineTableView reloadData];
             [[NSUserDefaults standardUserDefaults] setObject:[_blueToothNumberSaveArray.lastObject deviceId] forKey:@"uuidName"];
        }
      
        
        
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
    
    MachineCell.CardMachineLabel.text = [_blueToothNumberSaveArray[indexPath.row] deviceId];
    
   
    return MachineCell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

    [[NSUserDefaults standardUserDefaults] setObject:[_blueToothNumberSaveArray[indexPath.row] deviceId] forKey:@"uuidName"];
    
    PSTAlertController *pstaCont = [PSTAlertController alertWithTitle:@"" message:[NSString stringWithFormat:@"选择型号为:%@的蓝牙",[_blueToothNumberSaveArray[indexPath.row] deviceId]]];
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
        
        NSString *deviceID = [_blueToothNumberSaveArray[indexPath.row] deviceId];
        NSString *psamId   =  [_blueToothNumberSaveArray[indexPath.row] psamId];
        [_req getBuleToothDeviceNumberWithInteger:@"3" deviceId:deviceID psamId:psamId PhoneNumber:nil];
        [self showHUDWithString:@"正在删除..."];
        
        [_blueToothNumberSaveArray removeObjectAtIndex:indexPath.row];
        
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
