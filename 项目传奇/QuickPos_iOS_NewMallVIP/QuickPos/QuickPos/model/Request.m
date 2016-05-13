//
//  Request.m
//  QuickPos
//
//  Created by 糊涂 on 15/3/18.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "Request.h"
#import "XML.h"
#import "QuickPos.h"
#import "Common.h"
#import "QuickPosTabBarController.h"
#import "SystemPrivacySDK.h"
#import "JSONKit.h"
#import "GTMBase66.h"



#define SHOP_BASE_URL @"http://101.231.98.131:8080/hdcctp/"

#define MANGE_BASW_URL @"http://112.65.206.146:8000/api/lc/" //理财基础URL  生产

//#define MANGE_BASW_URL @"http://192.168.1.184:8888/api/lc/"  //测试


#define kURL_TN_Normal                @"http://202.101.25.178:8080/sim/gettn" //银联在线支付提供的模拟TN接口


#define TimeOut 60
@interface Request(){
    
}
@property(nonatomic, strong)NSObject<ResponseData>* delegate;
@end

@implementation Request
// 请求标识定义

- (instancetype)initWithDelegate:(NSObject<ResponseData>*)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

// 用户登录请求
- (void)userLoginWithAccount:(NSString*)account password:(NSString*)password{
    if ([password length] != 256) {
        // 没有加密时将数据加密
        password = [[[QuickPos alloc] init] enCodeWithData:password enCodeType:NO account:account];
    }
    NSDictionary *dict = @{@"application": MONILEMAC_LOGIN,
                           @"mobileNo": account,
                           @"password": password,
                           @"token": @"0000",
                           @"encodetype":@"userpassword",
                           };
    [self requestWithDict:dict requestType:REQUEST_USERLOGIN];
}
// 获取验证码
- (void)getMobileMacWithAccount:(NSString*)account appType:(NSString*)type{
    NSDictionary *dic = @{@"application": MONILEMAC_MOBILEMAC,
                          @"mobileNo": account,
                          @"phone": account,
                          @"token": @"0002",
                          @"appType": type};
    [self requestWithDict:dic requestType:REQUEST_GETMOBILEMAC];
    
}
//版本更新
-(void)ClientUpdateInstrVersion:(NSString *)instrVersion dateType:(NSString *)dateType
{
    NSDictionary *dic = @{@"application":MOBILEMAC_CLIENTUPDATE,
                          @"instrVersion":instrVersion,
                          @"dateType":dateType,
                          @"token":@"0000"
                          };
    [self requestWithDict:dic requestType:REQUEST_CLIENTUPDATE];
}

//注册
- (void)userSignWithAccount:(NSString *)account password:(NSString *)password mobileMac:(NSString *)mobileMac
{
    if ([password length] != 256) {
    // 没有加密时将数据加密
        password = [[[QuickPos alloc] init] enCodeWithData:password enCodeType:NO account:account];
    }

    NSDictionary *dict = @{@"application": MOBILEMAC_REGISTER,
                           @"userName":account,
                           @"mobileNo": account,
                           @"password": password,
                           @"mobileMac":mobileMac,
                           @"token": @"0001",
                           @"encodeType":@"userpassword"};
    
    [self requestWithDict:dict requestType:REQUEST_USERREGISTER];
        
}

//找回密码
- (void)backPasswordWithMobileNo:(NSString *)mobileNo newPassword:(NSString *)newPassword cardID:(NSString *)cardID mobileMac:(NSString *)mobileMac realNmae:(NSString *)realNmae{
    if ([newPassword length] != 256) {
        // 没有加密时将数据加密
        newPassword = [[[QuickPos alloc] init] enCodeWithData:newPassword enCodeType:NO account:mobileNo];
    }
   
    
 
    NSDictionary *dict = @{@"application": MOBILEMAC_RETPWD,
                           @"certType":@"01",
                           @"mobileNo": mobileNo,
                           @"newPassword": newPassword,
                           @"mobileMac":mobileMac,
                           @"certPid":cardID,
                           @"realName":realNmae,
                           @"token": @"0000",
                           };
    
    [self requestWithDict:dict requestType:REQUEST_BACKPASSWORD];

}

//修改密码
- (void)changePasswordWithMobileNo:(NSString *)mobileNo newPassword:(NSString *)newPassword olePassword:(NSString *)olePassword mobileMac:(NSString *)mobileMac{
    if ([newPassword length] != 256) {
        // 没有加密时将数据加密
        newPassword = [[[QuickPos alloc] init] enCodeWithData:newPassword enCodeType:NO account:mobileNo];
    }
    if ([olePassword length] != 256) {
        // 没有加密时将数据加密
        olePassword = [[[QuickPos alloc] init] enCodeWithData:olePassword enCodeType:NO account:mobileNo];
    }

    
    
    
    
    NSDictionary *dict = @{@"application": MOBILEMAC_CHANGEPASSWORD,
                           @"password":olePassword,
                           @"mobileNo": mobileNo,
                           @"newPassword": newPassword,
                           @"mobileMac":mobileMac,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"encodetype":@"userpassword",
                           };
    
    [self requestWithDict:dict requestType:REQUEST_CHANGEPASSWORD];
    
}






//查询用户信息接口字段
- (void)userInfo:(NSString*)mobileNo{
    NSDictionary *dict = @{@"application": MONILEMAC_USERINFO,
                           @"mobileNo": mobileNo,
                           @"token": @"0000",
                           };
    [self requestWithDict:dict requestType:REQUSET_USERINFOQUERY];
    
}
//虚拟账户余额查询接口
- (void)getVirtualAccountBalance:(NSString*)accType token:(NSString*)token{
    NSDictionary *dic = @{@"application": MOBILEMAC_ACCTENQUIRY,
                          @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                          @"acctType": accType,
                          @"token":[AppDelegate getUserBaseData].token,
                          };
    [self requestWithDict:dic requestType:REQUEST_ACCTENQUIRY];

}


//申请交易订单
- (void)applyOrderMobileNo:(NSString *)mobileNo MerchanId:(NSString*)merchantId productId:(NSString*)productId orderAmt:(NSString *)orderAmt orderDesc:(NSString*)orderDesc orderRemark:(NSString*)orderRemark commodityIDs:(NSString *)commodityIDs payTool:(NSString*)payTool{
    
    NSDictionary *dic = @{@"application": MOBILEMAC_ORDER,
                          @"mobileNo": mobileNo,
                          @"merchantId": merchantId,
                          @"productId": productId,
                          @"orderAmt": orderAmt,
                          @"orderDesc": orderDesc,
                          @"orderRemark": orderRemark,
                          @"commodityIDs":commodityIDs,
                          @"payTool": payTool,
                          @"token":[AppDelegate getUserBaseData].token,
                          };
    [self requestWithDict:dic requestType:REQUSET_ORDER];
    
}
//实名认证资料（无界传organization，上传头像的前一步骤）
- (void)realNameAuthentication:(NSString *)realName ID:(NSString *)ID{
        NSDictionary *dic = @{@"application": @"UserUpdateInfo",
                              @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                              @"realName": realName,
                              @"certPid": ID,
                              @"certType": @"01",
                              @"token":[AppDelegate getUserBaseData].token,
                              };
        [self requestWithDict:dic requestType:REQUEST_REALNAMEAUTHENTICATION];
    
}

//获取商城列表
- (void)getMallListmobile:(NSString *)mobileNo firstData:(NSString *)firstData lastData:(NSString *)lastData dataSize:(NSString *)dataSize requestType:(NSString *)requestType
{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dict = @{@"application":MOBILEMAC_COMMODITYLIST,
                           @"mobileNo":mobileNo,
                           @"firstDataID":firstData,
                           @"lastDataID":lastData,
                           @"dataSize":dataSize,
                           @"requestType":requestType,
                           @"token":@"0000"
                           };
    [self requestWithDict:dict requestType:REQUEST_COMMODITYLIST];
    
}

//上传头像
-(void)upPhotoImage:(NSData*)imageStr{
    
//    NSLog(@"res %@", imageStr);
//    NSLog(@"base encode %@", [Utils base64Encode:imageStr]);
//    NSLog(@"base decode %@", [Utils base64Decode:[Utils base64Encode:imageStr]]);
    
    NSDictionary *dic = @{@"application": MONILEMAC_USERIDENTITYPICUPLOAD,
                        @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                        @"img":[Utils base64Encode:imageStr],
                        @"imgApplyType":@"01",
                        @"imgSign":[Utils md5WithData:imageStr],
                        @"token":[AppDelegate getUserBaseData].token,
                        };
    [self requestWithDict:dic requestType:REQUEST_UPHEADIMAGE];
}

//添加商城数据
- (void)addMallDataMobileNo:(NSString *)mobileNo icon:(NSString *)icon title:(NSString *)title price:(NSString *)price amount:(NSString *)amount
{
    NSDictionary*dic=@{@"application": MOBILEMAC_ADDCOMMODITY,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"icon":icon,
                       @"title":title,
                       @"price":price,
                       @"amount":amount,
                       @"token":@"0000",
                       };
    [self requestWithDict:dic requestType:REQUEST_ADDCOMMODITY];
}
//删除商品数据
- (void)DeleteMallDataMobileNo:(NSString *)mobileNo commodityID:(NSString *)commodityID
{
    NSDictionary*dic=@{@"application": MOBILEMAC_DELETECOMMODITY,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"commodityID":commodityID,
                       @"token":@"0000",
                       };
    [self requestWithDict:dic requestType:REQUEST_DELETECOMMODITY];
}
- (void)changeMallDataMobileNo:(NSString *)mobileNo commodityID:(NSString *)commodityID icon:(NSString *)icon title:(NSString *)title price:(NSString *)price amount:(NSString *)amount
{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:      MOBILEMAC_EDITCOMMODITY,@"application",
       [AppDelegate getUserBaseData].mobileNo,@"mobileNo",commodityID,@"commodityID",
                        amount,@"amount",
    [AppDelegate getUserBaseData].mobileNo,@"token", nil];
    
    if (icon) {
        [dic setObject:icon forKey:@"icon"];
    }
    if (title) {
        [dic setObject:title forKey:@"title"];
    }
    if (price) {
        [dic setObject:price forKey:@"price"];
    }
    
    
    
    
    [self requestWithDict:dic requestType:REQUEST_EDITCOMMODITY];
}
//上传身份证正面
-(void)upIDcardPositive:(NSData*)imageStr{
    
    
    
    NSDictionary*dic=@{@"application": MONILEMAC_USERIDENTITYPICUPLOAD,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"img" :[Utils base64Encode:imageStr],
                       @"imgApplyType":@"02",
                       @"imgSign":[Utils md5WithData:imageStr],
                       @"token":[AppDelegate getUserBaseData].token,
                       };
    [self requestWithDict:dic requestType:REQUSET_IDCARDPOSITIVE];


}

//上传身份证反面
-(void)upIDcardReverse:(NSData*)imageStr{
   
    
    NSDictionary*dic=@{@"application": MONILEMAC_USERIDENTITYPICUPLOAD,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"img":[Utils base64Encode:imageStr],
                       @"imgApplyType":@"03",
                       @"imgSign":[Utils md5WithData:imageStr],
                       @"token":[AppDelegate getUserBaseData].token,
                       };
    [self requestWithDict:dic requestType:REQUSET_IDCARDREVERSE];
    
}

// 贴牌资源
- (void)userAgreement{
    NSDictionary *dic = @{@"application": MOBILEMAC_USERAGREEMENT,
                          @"token": @"0000"};
    [self requestWithDict:dic requestType:REQUEST_USERAGREEMENT];
}

// 获取频道
- (void)getChannel{
}

//银行卡列表
-(void)bankListAndbindType:(NSString*)bindType{
    
    
    NSDictionary*dic=@{@"application": MOBILEMAC_GETBANKLIST,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"bindType":bindType,
                       @"cardIdx":@"0",
                       @"cardNum":@"10",
                       @"token":[AppDelegate getUserBaseData].token,
                       };
    [self requestWithDict:dic requestType:REQUSET_BANKLIST];
    
    
}

//银行所在省份
-(void)BankofProvinces{

    NSDictionary*dic=@{@"application" : MOBILEMAC_CITIESCODE,
                       @"token" :[AppDelegate getUserBaseData].token,
                       
                       };
 [self requestWithDict:dic requestType:REQUSET_PROVINCES];
}
//银行所在城市
-(void)BankofCity:(NSString *)provinceCode{
    
    NSDictionary*dic=@{@"application": MOBILEMAC_CITIESCODE,
                       @"token" :[AppDelegate getUserBaseData].token,
                       @"provinceCode":provinceCode,
                       };
    [self requestWithDict:dic requestType:REQUSET_CITY];
}
//上传签名图片
- (void)UserSignatureUploadMobile:(NSString *)mobile longitude:(NSString *)logitude latitude:(NSString *)latitude merchantId:(NSString *)merchantId orderId:(NSString *)orderId signPicAscii:(NSString *)signPicAscii picSign:(NSString *)picSign
{
    NSDictionary *dic = @{@"application":MOBILEMAC_USERSIGNATUREUPLOAD,
                          @"mobile":mobile,
                          @"longitude":logitude,
                          @"latitude":latitude,
                          @"merchantId":merchantId,
                          @"orderId":orderId,
                          @"signPicAscii":signPicAscii,
                          @"picSign":picSign,
                          @"token":[AppDelegate getUserBaseData].token,
                          };
    [self requestWithDict:dic requestType:REQUEST_USERSIGNATUREUPLOAD];
}

//总行
-(void)GetBankHeadQuarter{
    
    NSDictionary*dic=@{@"application": MOBILEMAC_BANK,
                       @"token": @"0000"
                       };
    [self requestWithDict:dic requestType:REQUSET_BANK];
}
//支行
-(void)GetBranch{
    NSUserDefaults*userDefaults=[NSUserDefaults standardUserDefaults];
    NSString*bankProvinceId=[userDefaults objectForKey:KFprovincesID];
    NSString*bankCityId=[userDefaults objectForKey:KFcityID];
    NSString*bankID=[userDefaults objectForKey:BankID];
    
    NSDictionary*dic=@{@"application": MOBILEMAC_BANKOFBRANCH,
                       @"bankProvinceId":bankProvinceId,
                       @"bankCityId":bankCityId,
                       @"condition":@"",
                       @"offset":@"0",
                       @"token":[AppDelegate getUserBaseData].token,
                       @"bankId":bankID,
                       };
    [self requestWithDict:dic requestType:REQUSET_Branch];
    
    
}
//绑定银行卡
-(void)BankCardBind:(NSString*)accountNumber andBandType:(NSString*)bandType{
    NSUserDefaults*userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString*bankID=[userDefaults objectForKey:branchID];
    
    NSDictionary*dic=@{@"application": MOBILEMAC_BANKCARDBIND,
                       
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"bankId":bankID,
                       //@"offset":@"0",
                       @"accountNo":accountNumber,
                       //@"cardIdx":@"00",
                       @"token":[AppDelegate getUserBaseData].token,
                       @"bandType":bandType,
                       
                       };
    [self requestWithDict:dic requestType:REQUSET_BankCardBind];
    
}

//解除银行卡绑定
-(void)BankCardUnBind:(NSString *)cardldx{

    NSDictionary*dic=@{@"application": MOBILEMAC_BANKCARDUNBIND,
                       
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       
                       @"cardIdx":cardldx,
                       @"token":[AppDelegate getUserBaseData].token,
                       
                       
                       };
    [self requestWithDict:dic requestType:REQUSET_BankCardUnBind];


}








//消息列表
-(void)msgList:(NSString *)firstMsgID andLastMsgID:(NSString *)lastMsgID andRequestType:(NSString *)requestType{


    NSDictionary*dic=@{@"application": MOBILEMAC_MESGLIST,
                       
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"firstMsgID":firstMsgID,
                       @"lastMsgID":lastMsgID,
                       @"msgSize":@"20",
                       @"requestType":requestType,
                       
                       @"token":[AppDelegate getUserBaseData].token,
                       };
    [self requestWithDict:dic requestType:REQUSET_MESGLIST];



}







//交易记录列表
-(void)recordList:(NSString *)filter andFirstMsgID:(NSString *)firstMsgID andLastMsgID:(NSString *)lastMsgID andRequestType:(NSString *)requestType{
    
    
    NSDictionary*dic=@{@"application": MOBILEMAC_RECORDLIST,
                       
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"firstMsgID":firstMsgID,
                       @"lastMsgID":lastMsgID,
                       @"msgSize":@"20",
                       @"requestType":requestType,
                       @"filter":filter,
                       @"token":[AppDelegate getUserBaseData].token,
                       };
    [self requestWithDict:dic requestType:REQUSET_RECORDLIST];
    
    
    
}

//交易记录详情
-(void)recordDetail:(NSString *)recordID andTime:(NSString *)time{
    
    NSDictionary*dic=@{@"application": MOBILEMAC_RECORDDETAIL,
                       
                       @"mobile":[AppDelegate getUserBaseData].mobileNo,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"recordID":recordID,
                       @"time":time,
                       @"token":[AppDelegate getUserBaseData].token,
                       };
    [self requestWithDict:dic requestType:REQUSET_RECORDDETAIL];



}



//我的刷卡器
-(void)myCreditCardMachine{
    
    NSDictionary*dic=@{
                       @"application": MOBILEMAC_MYPOS,
                       @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                       @"token":[AppDelegate getUserBaseData].token,
                       
                       };
    [self requestWithDict:dic requestType:REQUSET_MYPOS];
    
}


//查询卡余额
- (void)checkMyCardBalance:(NSString*)cardInfo cardPassWord:(NSString*)cardPassWord iccardInfo:(NSString*)ICCardInfo ICCardSerial:(NSString*)ICCardSerial ICCardValidDate:(NSString*)ICCardValidDate merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId encodeType:(NSString*)encodeType{
    
    QuickPos *quickPos = [[QuickPos alloc]init];
    NSString *c = [quickPos enCodeWithData:cardPassWord enCodeType:YES account:orderId];
    NSDictionary*dic=@{@"application": MOBILEMAC_CARDBALANCE ,
                       @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                       @"cardInfo": cardInfo,
                       @"cardPassword": c,
                       @"ICCardInfo": ICCardInfo,
                       @"ICCardSerial": ICCardSerial,
                       @"ICCardValidDate": ICCardValidDate,
                       @"merchantId": merchantId,
                       @"encodeType": @"bankpassword",
                       @"orderId": orderId,
                       @"token":[AppDelegate getUserBaseData].token
                       };
    [self requestWithDict:dic requestType:REQUSET_CARDBALANCE];
    
    
}
//商城支付接口
- (void)mallCardPay:(NSString *)cardInfo cardPassWord:(NSString *)cardPassword iccardInfo:(NSString *)ICCardInfo ICCardSerial:(NSString *)ICCardSerial ICCardValidDate:(NSString *)ICCardValidDate merchantId:(NSString *)merchantId productId:(NSString *)productId orderId:(NSString *)orderId encodeType:(NSString *)encodeType orderAmt:(NSString *)orderAmt payType:(NSString*)payType{
    
    QuickPos *quickPos = [[QuickPos alloc]init];
    NSString *c = [quickPos enCodeWithData:cardPassword enCodeType:YES account:orderId];
    NSDictionary*dic=@{@"application":MOBILEMAC_JFPALCARDPAYFORSTORE ,
                       @"cardInfo": cardInfo,
                       @"cardPassword": c,
                       @"ICCardInfo": ICCardInfo,
                       @"ICCardSerial": ICCardSerial,
                       @"ICCardValidDate":ICCardValidDate,
                       @"merchantId": merchantId,
                       @"productId": productId,
                       @"orderId": orderId,
                       @"encodeType": encodeType,
                       @"token": [AppDelegate getUserBaseData].token,
                       @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                       @"orderAmt": orderAmt,
                       @"payType":payType,
                       };
    [self requestWithDict:dic requestType:REQUSET_JFPALCARDPAYFORSTORE];
}

//支付接口
- (void)cardPay:(NSString*)cardInfo cardPassWord:(NSString*)cardPassword iccardInfo:(NSString*)ICCardInfo ICCardSerial:(NSString*)ICCardSerial ICCardValidDate:(NSString*)ICCardValidDate merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId  encodeType:(NSString*)encodeType orderAmt:(NSString*)orderAmt payType:(NSString*)payType{
    
    QuickPos *quickPos = [[QuickPos alloc]init];
    NSString *c = [quickPos enCodeWithData:cardPassword enCodeType:YES account:orderId];
    NSDictionary*dic=@{@"application":MOBILEMAC_JFPALCARDPAY ,
                       @"cardInfo": cardInfo,
                       @"cardPassword": c,
                       @"ICCardInfo": ICCardInfo,
                       @"ICCardSerial": ICCardSerial,
                       @"ICCardValidDate":ICCardValidDate,
                       @"merchantId": merchantId,
                       @"productId": productId,
                       @"orderId": orderId,
                       @"encodeType": encodeType,
                       @"token": [AppDelegate getUserBaseData].token,
                       @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                       @"orderAmt": orderAmt,
                       @"payType":payType,
                       };
    [self requestWithDict:dic requestType:REQUSET_JFPALCARDPAY];

}

//账户支付

- (void)acctPay:(NSString*)mobileNo encodetype:(NSString*)encodetype password:(NSString*)password mobileMac:(NSString*)mobileMac acctType:(NSString*)acctType merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId orderAmt:(NSString*)orderAmt encodeType:(NSString*)encodeType payType:(NSString*)payType{
    QuickPos *quickPos = [[QuickPos alloc]init];
    NSString *passwordEncode = [quickPos enCodeWithData:password enCodeType:NO account:orderId];
//    NSString *mobileMacEncode = [quickPos enCodeWithData:mobileMac enCodeType:YES account:orderId];
    
    NSDictionary*dic=@{@"application":MOBILEMAC_JFPALACCTPAY,
                       @"mobileNo": mobileNo,
                       @"encodetype": @"userpassword",
                       @"password": passwordEncode,
                       @"mobileMac": mobileMac,
                       @"acctType": acctType,
                       @"merchantId": merchantId,
                       @"productId": productId,
                       @"orderId": orderId,
                       @"orderAmt": orderAmt,
                       @"encodeType": @"bankpassword",
                       @"token":[AppDelegate getUserBaseData].token,
                       @"payType":payType,
                       };
    [self requestWithDict:dic requestType:REQUSET_JFPALACCTPAY];
    
}

//提现
-(void)takeCash:(NSString *)cashAmt andPassword:(NSString *)password andMobileMac:(NSString *)mobileMac andCashType:(NSString *)cashType andCardTag:(NSString *)cardTag andCardIdx:(NSString *)cardIdx{

    if ([password length] != 256) {
        // 没有加密时将数据加密
        password = [[[QuickPos alloc] init] enCodeWithData:password enCodeType:NO account:[AppDelegate getUserBaseData].mobileNo];
    }
    
    NSDictionary *dict = @{@"application": MOBILEMAC_JFPALCASH,
                           @"cashAmt": cashAmt,
                           @"password": password,
                           @"cardIdx": cardIdx,
                           @"mobileNo":[AppDelegate getUserBaseData].mobileNo,
                           @"cardTag": cardTag,
                           @"mobileMac":mobileMac,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"encodeType":@"userpassword",
                           @"cashType":cashType,
                           
                           };
    
    [self requestWithDict:dict requestType:REQUSET_JFPalCash];
}


//流量充值-查询手机号信息
- (void)getPhoneNumber:(NSString *)mobileNo
{
    NSDictionary *dict = @{@"application":MOBILEMAC_GETTRADEFLOW,
                           @"mobileNo":mobileNo,
                           @"token": @"0000",
                           };
    [self requestWithDict:dict requestType:REQUEST_GETPHONENUMBER];
}



#pragma mark - 无卡支付
//获取无卡支付绑定银行卡列表
- (void)getQuickPayMyCardList{
    NSDictionary *dict = @{@"application": MOBILEMAC_GETQUICKBANKCARD,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_GETQUICKBANKCARD];


}
//解绑无卡支付银行卡
- (void)quickPayBankCardUnbind:(NSString*)bindId{
    NSDictionary *dict = @{@"application": MOBILEMAC_UNBINDQUICKBANKCARD,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"bindID": bindId,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_UNBINDQUICKBANKCARD];


}
//查询银行卡信息
- (void)checkBankCardInfo:(NSString*)cardNo{
    NSDictionary *dict = @{@"application": MOBILEMAC_QUICKBANKCARDQUERY,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"cardNo": cardNo,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_QUICKBANKCARDQUERY];

}
//无卡支付申请
- (void)applyForQuickPay:(NSString*)name IDCard:(NSString*)IDCard cardNo:(NSString*)cardNo vaild:(NSString*)vaild cvv2:(NSString*)cvv2 phone:(NSString*)phone orderID:(NSString*)orderID bindID:(NSString*)bindID orderAmt:(NSString*)orderAmt productId:(NSString*)productId merchantId:(NSString*)merchantId{
    QuickPos *quickPos = [[QuickPos alloc]init];
    NSString *payInfoEncode = [quickPos enCodeWithName:name IDCard:IDCard cardNo:cardNo vaild:vaild cvv2:cvv2 phone:phone];
    NSDictionary *dict = @{@"application": MOBILEMAC_QUICKBANKCARDAPPLY,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"payInfo": payInfoEncode,
                           @"encodeType": @"quickPayment",
                           @"orderId": orderID,
                           @"bindID": bindID,
                           @"orderAmt":orderAmt,
                           @"merchantId":merchantId,
                           @"productId": productId,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_QUICKBANKCARDAPPLY];
}
//确认无卡支付
- (void)enSureQuickPay:(NSString*)validateCode orderID:(NSString*)orderID{
    NSDictionary *dict = @{@"application": MOBILEMAC_QUICKBANKCARDCONFIRM,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"validateCode": validateCode,
                           @"orderId": orderID,
//                           @"merchantId":@"0004000001",
//                           @"productId":@"0000000000",
                           };
    
    [self requestWithDict:dict requestType:REQUEST_QUICKBANKCARDCONFIRM];
}
//发送无卡支付验证短信
- (void)getQuickPayCode:(NSString*)orderID{
    NSDictionary *dict = @{@"application": MOBILEMAC_QUICKBANKCARDMSG,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"orderId": orderID,
//                           @"merchantId":@"0004000001",
//                           @"productId":@"0000000000",
                           };
    
    [self requestWithDict:dict requestType:REQUEST_QUICKBANKCARDMSG];

}



//功能频道开关
- (void)getChannelApplication{
    NSDictionary *dict = @{@"application": MOBILEMAC_GETCHANNELAPPLICATION,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_GETCHANNELAPPLICATION];

}




//信用卡信息查询
- (void)checkCreditCardInfo:(NSString*)realName cardNum:(NSString*)accountNo{
    NSDictionary *dict = @{@"application": MOBILEMAC_QUERYCREDITINFO,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"realName": realName,
                           @"accountNo": accountNo,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_QUERYCREDITINFO];
    
}

//绑定快捷⽀支付认证码
-(void)quickPayCode:(NSString*)organization{

    NSDictionary *dict = @{@"application": MOBILEMAC_BINDQUICKPAYPSAM,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           @"organization": organization,
                          
                           };
    
    [self requestWithDict:dict requestType:REQUEST_ORGANIZATION];




}

// 查询快捷⽀支付认证码绑定状态
-(void)quickPayCodeState{
    
    NSDictionary *dict = @{@"application": MOBILEMAC_GETQUICKPAYPSAM,
                           @"mobileNo": [AppDelegate getUserBaseData].mobileNo,
                           @"token": [AppDelegate getUserBaseData].token,
                           };
    
    [self requestWithDict:dict requestType:REQUEST_QUICKPAYSTATE];
}










// 网络请求 dict:请求参数,type:请求唯一标识
- (void)requestWithDict:(NSDictionary*)dict requestType:(NSInteger)type {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    XML *Xml = [[XML alloc] init];
    NSString *str = [Xml xmlDataWithDict:dict];
    
//    str = [Utils urlDecode:str];
    NSString *sing = [Utils urlEncode:str];
    str = sing;
    sing = [Utils md5WithString:sing];
    str = [str stringByReplacingOccurrencesOfString:SIGN withString:sing];
    str = [NSString stringWithFormat:@"requestXml=%@", str];
    NSLog(@"request %@",[Utils urlDecode:str]);
    NSURL *url = [NSURL URLWithString:BASE_URL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setTimeoutInterval:TimeOut];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:policy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *operaction = [manager HTTPRequestOperationWithRequest:req success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL achieve = [self.delegate respondsToSelector:@selector(responseWithDict:requestType:)];
        NSDictionary *d = [Xml deXMLWithData:operation.responseData];
        
        if (operation.responseData && achieve) {
            if ([[d objectForKey:@"respCode"] isEqualToString:@"0001"] || [[d objectForKey:@"respCode"] isEqualToString:@"0002"]) {
                
                [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication].keyWindow rootViewController] view] WithString:d[@"respDesc"]];
                [[QuickPosTabBarController getQuickPosTabBarController] gotoLoginViewCtrl];
            }else{
                [self.delegate responseWithDict:d requestType:type];
            }
            
        }
        NSLog(@"resp %@", d);
        NSString *respDesc = [NSString stringWithString:[d[@"respDesc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"respDesc返回-%@",respDesc);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == -1001){
            NSLog(@"请求超时");
            NSDictionary *dic = @{@"respCode": @"1001", @"respDesc": @"请求超时,请稍后重试"};
            [self.delegate responseWithDict:dic requestType:type];
        }else if (error.code == -1016) {
            BOOL achieve = [self.delegate respondsToSelector:@selector(responseWithDict:requestType:)];
            
            NSDictionary *d = [Xml deXMLWithData:operation.responseData];
            
            
            if (operation.responseData && achieve) {
                if ([[d objectForKey:@"respCode"] isEqualToString:@"0001"] || [[d objectForKey:@"respCode"] isEqualToString:@"0002"]) {

                    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication].keyWindow rootViewController] view] WithString:d[@"respDesc"]];
                    [[QuickPosTabBarController getQuickPosTabBarController] gotoLoginViewCtrl];
                }else{
                    [self.delegate responseWithDict:d requestType:type];
                }
                
            }
            NSString *desc = [d objectForKey:@"respDesc"];
            NSLog(@"resp %@", d);
            NSLog(@"respDesc返回-%@",desc);
        }
        
    }];
    
    [[manager operationQueue] addOperation:operaction];
}


- (void)sendInfo{
    //    NSDictionary*dic=@{@"act":@"welcome" ,
    //                       @"ver":@"1.1" ,
    //                       @"app":@"other"
    //                       };
    //    NSDictionary*dic=@{
    //                       @"termId":@"99999900" ,
    //                       @"orgId":@"000000039" ,
    //                       @"busType":@"100061",
    //                       @"cateId":@"" ,
    //                       @"series":@"1" ,
    //                       @"totalSeries":@"3"
    //                       };
    
    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999903" ,
                                     @"orgId":@"000000001" ,
                                     @"busType":@"100061",
                                     @"cateId":@"" ,
                                     @"series":@"1" ,
                                     @"totalSeries":@"3"}
                       
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_FIRST withUrl:@"MALL0001.json?"];
}

- (void)getProductWithCardId:(NSString*)cardId{
    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999903" ,
                                     @"orgId":@"000000001" ,
                                     @"busType":@"100061",
                                     @"cateId":cardId ,
                                     }
                       
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_PRODUCTLIST withUrl:@"MALL0002.json?"];
}

- (void)getAD{
    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999900" ,
                                     @"orgId":@"000000039" ,
                                     @"busType":@"100061"}
                       
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_AD withUrl:@"MALL0004.json?"];
}

- (void)getInfoWithMobile:(NSString*)mobile{
    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999900" ,
                                     @"orgId":@"000000039" ,
                                     @"busType":@"100061",
                                     @"mobile":mobile
                                     }
                       
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_ORDER_INQUIRY withUrl:@"MALL0006.json?"];
}

- (void)getDetailInfoWithProductId:(NSString*)productId withTraceabilityId:(NSString*)traceabilityId{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HHmmss"];
    NSString *currenttime = [dateFormatter1 stringFromDate:[NSDate date]];
    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999900" ,
                                     @"orgId":@"000000039" ,
                                     @"busType":@"100061",
                                     @"TransDate":currentDate,
                                     @"TransTime":currenttime,
                                     @"productId":productId,
                                     @"isTerm":@"0",
                                     @"traceabilityId":traceabilityId,
                                     }
                       
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_PRODUCTDETAIL withUrl:@"MALL0003.json?"];
}

- (void)getMoneyInfoWithProductId:(NSString*)productId productList:(id)productlist{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]]; //获取系统时间0
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HHmmss"];
    
    NSString *currenttime = [dateFormatter1 stringFromDate:[NSDate date]];  //获取系统时间1
    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999900" ,
                                     @"orgId":@"000000039" ,
                                     @"busType":@"100061",
                                     @"TransDate":currentDate,
                                     @"TransTime":currenttime,
                                     @"isTerm":@"0",
                                     @"products":productlist,
                                     }
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_GETMONEY withUrl:@"MALL0007.json?"]; //发送网络请求
}

- (void)gettotalMoneyWithProductLists:(NSArray*)productlists withMobile:(NSString *)mobile withTotal:(NSString*)total{

    NSDictionary*dic=@{@"REQ_HEAD":@{@"TRAN_SCUESSS":@"1"},
                       @"REQ_BODY":@{@"termId":@"99999900" ,
                                     @"orgId":@"000000039" ,
                                     @"busType":@"100061",
                                     @"mobile":mobile,
                                     @"totalAmount":total,  //总金额
                                     @"products":productlists, //产品列表
                                     }
                       
                       };
    NSDictionary *dict = @{@"REQ_MESSAGE":[self DataTOjsonString:dic]};
    [self requestWithDict:dict requestType:REQUSET_GETORDER withUrl:@"MALL0008.json?"];
}


//json解析  得到jsonData
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (id)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:theData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    
    if ([jsonData count] > 0 && error == nil && [jsonData isKindOfClass:[NSDictionary class]]){
        return jsonData;
    }else{
        return nil;
    }
}


// 网络请求 dict:请求参数,type:请求唯一标识
- (void)requestWithDict:(NSDictionary*)dict requestType:(NSInteger)type  withUrl:(NSString *)url{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    [manager POST:[NSString stringWithFormat:@"%@%@",SHOP_BASE_URL,url]
       parameters:dict
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //              NSLog(@"suceess is:   \n>>>>response data:\n %@",responseObject);
              //               NSLog(@"suceess is:   \n>>>>response data:\n %@",operation.responseString);
              NSLog(@"suceess is:   \n>>>>response data:\n %@",operation.responseData);
              NSLog(@"suceess is:   \n>>>>response data:\n %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
              BOOL achieve = [self.delegate respondsToSelector:@selector(responseWithDict:requestType:)];
              if (operation.responseData && achieve) {
                  if ([self toJSONData:operation.responseData]) {
                      [self.delegate responseWithDict:[self toJSONData:operation.responseData] requestType:type];
                  }

              }
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (error.code == -1001){
                  NSLog(@"请求超时");
                  NSDictionary *dic = @{@"respCode": @"1001", @"respDesc": @"请求超时,请稍后重试"};
                  [self.delegate responseWithDict:dic requestType:type];
              }else if (error.code == -1016) {
                  BOOL achieve = [self.delegate respondsToSelector:@selector(responseWithDict:requestType:)];
                  
                  NSDictionary *d = [self toJSONData:operation.responseData];

                  
                  if (operation.responseData && achieve) {
                      if ([[d objectForKey:@"respCode"] isEqualToString:@"0001"] || [[d objectForKey:@"respCode"] isEqualToString:@"0002"]) {
                          
                      }else{
                          [self.delegate responseWithDict:d requestType:type];
                      }
                      
                  }
                  NSString *desc = [d objectForKey:@"respDesc"];
                  NSLog(@"resp %@", d);
                  NSLog(@"respDesc返回-%@",desc);
              }
              
          }];
    

}




-(void)getTN{
    
    //GCD 异步操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        //异步现场 请求网络数据 耗时操作
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        __block NSString * t =[[NSString alloc] init];
        [manager GET:kURL_TN_Normal parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Bloct >> tn ====  %@" , operation.responseString);
            t = operation.responseString;
            
            //返回主线程 拿到数据
            dispatch_async(dispatch_get_main_queue(), ^{
                t = operation.responseString;
                
                NSLog(@"t ===== %@",t);

                if ([_delegate respondsToSelector:@selector(getTNWithString:)]) {
                    [_delegate getTNWithString:t];

                }
            });
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
    });
    

}





//获取理财产品列表
-(void)getManageListWithBranchname:(NSString*)appuser userid:(NSString*)telephontNum{
    
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo
                           };
    
    NSString *jsontDataKit = [dict JSONString];
    NSLog(@"****************%@",jsontDataKit);
    
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"*******oo***********%@",data);
    
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    NSLog(@"`````````````````````   %@",jsonString);
    
    [self requestMangeWithString:jsonString requestType:REQUSET_Lccplist withuRl:@"lccplist"];
    
    
}

//查询我的理财资产接口
-(void)getMyMangeZiChanList{
    
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_MyMangeZiChanList withuRl:@"chaxun/chxzichan"];  //56

}

//5、查看持有产品列表(持有中)
-(void)getHoldingList{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo
                           };
    NSString *jsontDataKit = [dict JSONString];
    
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    
    [self requestMangeWithString:jsonString requestType:REQUSET_HoldingList withuRl:@"chy/chylccp"];//57
}

//8、开通理财账户
-(void)getZhuce{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo
                           };
    NSString *jsontDataKit = [dict JSONString];
    
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    
    [self requestMangeWithString:jsonString requestType:REQUSET_ZHUCEMANGE withuRl:@"zhuc/lccpzhh"]; //58
}

//9、查看赎回产品列表 (已赎回)
-(void)showHadRedeem
{
    
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo
                           };
    NSString *jsontDataKit = [dict JSONString];
    
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    
    [self requestMangeWithString:jsonString requestType:REQUSET_showHadRedeem withuRl:@"shh/yshhlccp"]; //59

}


//2、获取产品详情
-(void)getProductDitailWithID:(NSString*)productID{
    
    NSDictionary *dict = @{
                           @"lccp_id":productID
                           };
    
    NSString *jsontDataKit = [dict JSONString];
    
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    
    [self requestMangeWithString:jsonString requestType:REQUSET_GETPRODUCTDITAIL withuRl:@"lccpinfo"]; //60
    
    
}

//3、申购产品 生成订单接口
-(void)getManageProductOrderWithProductID:(NSString*)ProductID Number:(NSNumber*)number amt:(NSNumber*)amt tranType:(NSString *)type hongBaoID:(NSString *)hongBaoID hongbaoNum:(NSString*)num{
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    if (![num isEqualToString:@"0"]) {
                     dict = @{
                               @"branchname":@"bmqhchqvip",
                               @"userid":[AppDelegate getUserBaseData].mobileNo,
                               @"lccp_id":ProductID,
                               @"lccp_num":number,
                               @"lccp_amt":amt,
                               @"txntype":type,
                               @"lccp_hb_id":hongBaoID
                               };
    }else
    {
                     dict = @{
                               @"branchname":@"bmqhchqvip",
                               @"userid":[AppDelegate getUserBaseData].mobileNo,
                               @"lccp_id":ProductID,
                               @"lccp_num":number,
                               @"lccp_amt":amt,
                               @"txntype":type,
                               @"lccp_hb_id":@"0000"
                               };
    }
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getManageProductOrder withuRl:@"shengou/shglccp"]; //61

}

//6、请求赎回交易(请求赎回按钮接口)
-(void)getRedeemTranseWith:(NSString*)chyNumber
{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           @"lccp_chy_no":chyNumber
                           };
    
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getRedeemTranse withuRl:@"shqshh/shqshhlccp"]; //62
    
}

//15、获取可用理财红包
-(void)getHongBaoList{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getHongBaolist withuRl:@"lccp/lchb"]; //63
    
}


//7、查看持有详情
-(void)getHoldingDetailWithHoldingCode:(NSString*)holdingCode{
    
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           @"lccp_chy_no":holdingCode
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getHoldingCode withuRl:@"lccp/chx/chymx"];//64
}



//8、查询持有产品收益列表(每日盈亏)
-(void)getEveryDayPrifitWithHoldingCode:(NSString*)holdingCode{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           @"lccp_chy_no":holdingCode
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getEveryDayPrifit withuRl:@"lccp/chx/shylist"];//65
    
    
    
}



//12、获取账户概况
-(void)getMangeAccoutDetail{
    
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getMangeAccoutDetail withuRl:@"account/survey"];//66
}



//88、请求赎回交易 ID
-(void)getRedeemOrderIDWithChiyouNum:(NSString*)chiNum withCountNum:(NSNumber*)countNum{
    
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           @"lccp_chy_no":chiNum,
                           @"lccp_shh_fe":countNum
                           
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getRedeemOrderID withuRl:@"shqshh/shqshhlccp"];//67

}

//14、获取短信验证码
-(void)getRedeemCodeWithOrderId:(NSString*)orderID{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           @"orderid":orderID
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_getRedeemCode withuRl:@"lccp/ems/getems"];//68
    
    
}
//9、确认赎回交易
-(void)finalyRedeemWithOrderID:(NSString*)ID withRedeemCode:(NSString*)Code
{
    NSDictionary *dict = @{
                           @"branchname":@"bmqhchqvip",
                           @"userid":[AppDelegate getUserBaseData].mobileNo,
                           @"orderid":ID,
                           @"checkcode":Code
                           
                           };
    NSString *jsontDataKit = [dict JSONString];
    NSData *data = [jsontDataKit dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 encodeData:data] encoding:NSUTF8StringEncoding];
    [self requestMangeWithString:jsonString requestType:REQUSET_finalyRedeem withuRl:@"qr/qrshhlccp"];//69
}






//理财功能网络请求
-(void)requestMangeWithString:(NSString*)string requestType:(NSInteger)type withuRl:(NSString*)url{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL *urltt = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MANGE_BASW_URL,url]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:urltt];
    [req setTimeoutInterval:TimeOut];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:policy];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    AFHTTPRequestOperation *operaction = [manager HTTPRequestOperationWithRequest:req success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"operation1: %@", operation.responseString);
        NSString *jsonString = [[NSString alloc] initWithData:[GTMBase66 decodeString:operation.responseString] encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [jsonString objectFromJSONString];
        NSLog(@"%%%%%%%%%%%%%%%%%%%%%%%@",dict);
        NSLog(@"++%li",(long)type);
        
        
        
        BOOL achieve = [self.delegate respondsToSelector:@selector(responseWithDict:requestType:)];
        
        if (operation.responseString && achieve) {
            if (dict) {
              
                [self.delegate responseWithDict:dict requestType:type];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        NSLog(@"operation2 :%@",operation.responseString);
        
    }];
    
    [[manager operationQueue] addOperation:operaction];
    
    
}


//NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
//NSLog(@"array_%@",timeZoneNames);
//NSString *startTime = @"2015-07-11 12:30";
//NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
////转化为东八区的时间，即背景时间NSLog(@"北京时间 %@",[formatter stringFromDate:[NSDate date]]);
//
//可以通过timeZoneNames数组查询各个时区的名字，都是以各大洲划分的。
//某一时区时间转化为手机本地系统时间
//- (void)day{
//    NSString *startTime = @"2015-07-11 12:30";
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate *startDate = [dateformatter dateFromString:startTime];
//    NSDate *startTime = [self getNowDateFromatAnDate:startDate];
//    NSString *startDateStr = [dateformatter stringFromDate:startTime];    NSLog(@"%@",startDateStr);
//    //这是最终转好的时间}- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{    //设置源日期时区    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//或GMT    //设置转换后的目标日期时区    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];    //得到源日期与世界标准时间的偏移量    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];    //目标日期与本地时区的偏移量    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];    //得到时间偏移量的差值    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;    //转为现在时间    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];    return destinationDateNow;
//}



@end
