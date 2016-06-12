//
//  LianDiBlueToothVpos.m
//  QuickPos
//
//  Created by kuailefu on 16/2/24.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "LianDiBlueToothVpos.h"
#import "LandiMPOS.h"


@interface LianDiBlueToothVpos (){
    
}
@property(nonatomic,strong) LandiMPOS *manager;
@property (nonatomic,strong) NSString *ciTiaoCard;  //判断是否磁条卡




@end

@implementation LianDiBlueToothVpos
@synthesize manager;

- (id)init{
    if (self) {
        self.moneyNum = [NSString string];
        [self initLianDiSDK];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeDevice) name:@"closeLDBluetooth" object:nil];
    }
    return self;
}
- (void)initWithMoney:(NSString *)Num{
    self.moneyNum = Num;
}
- (void)initLianDiSDK{
    self.CardInfo = [[CardInfoModel alloc]init];
    manager = [LandiMPOS getInstance];
    NSLog(@"logVersion is:%@",[manager getLibVersion]);
    [manager startSearchDev:8000 searchOneDeviceBlcok:^(LDC_DEVICEBASEINFO *deviceInfo) {
        NSLog(@"searchOneDevice");
        NSLog(@"==== 设备名 ====%@",deviceInfo.deviceName);
        NSLog(@"==== 设备号 ====%@",deviceInfo.deviceIndentifier);
        [manager stopSearchDev];
        
        if ([deviceInfo.deviceName rangeOfString:@"M18"].location != NSNotFound) {
            
            [manager openDevice:deviceInfo.deviceIndentifier channel:deviceInfo.deviceChannel mode:COMMUNICATIONMODE_MASTER successBlock:^{
                NSLog(@"openDevice");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"hideswiperingView" object:nil];
                
                
                
                //开始刷卡
                [manager waitingCard:@"交易类型文字" timeOut:60 CheckCardTp:SUPPORTCARDTYPE_MAG_IC_RF moneyNum:@"10050.80" successBlock:^(LDE_CardType cardtype) {
                    NSLog(@"==== 卡类型 ====%d",cardtype);
                    _ciTiaoCard = [NSString stringWithFormat:@"%d",cardtype];
                    
                    if ([_ciTiaoCard isEqualToString:@"1"]) {        //**************** 磁条卡 ***********************//
                        //读取卡号
                        [manager getPAN:PANDATATYPE_PLAIN successCB:^(NSString *stringCB) {
                            NSLog(@"==== 卡号 ====%@",stringCB);
                            [self.CardInfo setCardNO:[NSString stringWithFormat:@"%@",stringCB]];
                            [self resultCardInfoModel];
                            
                        } failedBlock:^(NSString *errCode, NSString *errInfo) {
                            NSLog(@"%@",errCode);
                        }];
                        //读取磁道数据
                        [manager getTrackData:TRACKTYPE_PLAIN successCB:^(LDC_TrackDataInfo *trackData) {
                            NSLog(@"获取磁道数据一次有效,读完终端会清空磁道");
                            NSString *t1 = [NSString stringWithFormat:@"Track 1为：%@",trackData.track1];
                            NSLog(@"==== 1磁道数据 ====%@",t1);
                            NSString *t2 = [NSString stringWithFormat:@"Track 2为：%@",trackData.track2];
                            NSLog(@"==== 2磁道数据 ====%@",t2);
                            NSString *t3 = [NSString stringWithFormat:@"Track 3为：%@",trackData.track3];
                            NSLog(@"==== 3磁道数据 ====%@",t3);
                        } failedBlock:^(NSString *errCode, NSString *errInfo) {
                            NSLog(@"读取磁道数据errinfo:%@",errInfo);
                        }];
                        
                    }
                    
                    if ([_ciTiaoCard isEqualToString:@"2"]) {          //**********************  IC卡  ************************//
                        
                        //读取卡信息(EMV开始交易)
                        LFC_EMVTradeInfo * emvStart = [[LFC_EMVTradeInfo alloc] init];
                        emvStart.flag = FORCEONLINE_YES;
                        emvStart.moneyNum = @"0.57";
                        emvStart.date = @"141111";
                        emvStart.time = @"131212";
                        emvStart.type = TRADETYPE_PURCHASE;
                        [manager startPBOC:emvStart trackInfoSuccess:^(LFC_EMVProgress *emvProgress) {
                            NSLog(@"EMV开始交易");
                            NSString *t1 = [NSString stringWithFormat:@"%@",emvProgress.track2data];
                            NSLog(@"==== IC卡二磁等效数据 ====%@",t1);
                            NSString *t2 = [NSString stringWithFormat:@"%@",emvProgress.pan];
                            NSLog(@"==== IC卡卡号 ====%@",t2);
                            NSString *t3 = [NSString stringWithFormat:@"%@",emvProgress.cardExpired];
                            NSLog(@"==== IC卡有效期为 ====%@",t3);
                            NSString *t4 = [NSString stringWithFormat:@"%@",emvProgress.panSerialNO];
                            NSLog(@"==== IC卡序列号 ====%@",t4);
                            
                            
                            //读取卡信息(EMV继续交易)
                            LFC_GETPIN * inputPin = [[LFC_GETPIN alloc] init];
                            inputPin.panBlock = emvProgress.pan;
                            inputPin.moneyNum = @"13.99";
                            inputPin.timeout = 40;
                            [manager continuePBOC:inputPin successBlock:^(LFC_EMVResult *emvResult) {
                                NSLog(@"EMV继续交易");
                                NSString *t1 = [NSString stringWithFormat:@"%02x",emvResult.result];
                                NSLog(@"==== IC卡处理结果 ====%@",t1);
                                NSString *t2 = [NSString stringWithFormat:@"%@",emvResult.dol];
                                NSLog(@"==== IC卡55域数据 ====%@",t2);
                                NSString *t3 = [NSString stringWithFormat:@"%@",emvResult.password];
                                NSLog(@"==== IC卡PIN密文 ====%@",t3);
                            }failedBlock:^(NSString *errCode, NSString *errInfo) {
                                NSLog(@"EMV继续交易errInfo%@",errInfo);
                            }];
                            
                            
                        } failedBlock:^(NSString *errCode, NSString *errInfo) {
                            NSLog(@"EMV开始交易errInfo:%@",errInfo);
                        }];
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                } failedBlock:^(NSString *errCode, NSString *errInfo) {
                    NSLog(@"%@",errCode);
                }];
                
                
                
                
                
                
                
            } failedBlock:^(NSString *errCode, NSString *errInfo) {
                NSLog(@"设备开启失败.失败码：%@,失败描述:%@",errCode,errInfo);
            }];
            
            
            
            
            
        }
    } completeBlock:^(NSMutableArray *deviceArray) {
        NSLog(@"searchCompleteBloc");
        
    }];
}
- (void)resultCardInfoModel{
    [self.delegate posResponseDataWithCardInfoModelWithLianDi:self.CardInfo];
}

- (void)stopSearchAction{
    NSLog(@"stopSearch");
    [manager stopSearchDev];
}
- (void)closeDevice{
    [manager closeDevice];
}
@end
