//
//  Request.h
//  QuickPos
//
//  Created by 糊涂 on 15/3/18.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseData <NSObject>

- (void)responseWithDict:(NSDictionary*)dict requestType:(NSInteger)type;

@end

// 请求标识定义
enum{
    REQUEST_USERLOGIN,
    REQUEST_USERREGISTER,
    REQUEST_GETMOBILEMAC,
    REQUEST_USERAGREEMENT,
    REQUEST_BACKPASSWORD,
    REQUEST_CHANGEPASSWORD,
    REQUSET_USERINFOQUERY,//用户信息
    REQUSET_ORDER,//申请订单
    REQUEST_COMMODITYLIST,//商城列表
    REQUEST_ADDCOMMODITY,//添加商品
    REQUEST_DELETECOMMODITY,//删除商品
    REQUEST_EDITCOMMODITY,//修改商品
    REQUEST_ACCTENQUIRY,
    REQUEST_UPHEADIMAGE,
    REQUEST_UPHEADIMAGEHEAD,
    REQUEST_GETUPHEADIMAGEHEAD,
    REQUEST_REALNAMEAUTHENTICATION,
    REQUEST_GETCHANNEL,//频道
    REQUSET_UPHEADIMAGE,//头像
    REQUSET_REALNAMEAUTHENTICATION, //真实姓名
    REQUSET_IDCARDPOSITIVE,//身份证正面
    REQUSET_IDCARDREVERSE,//身份证反面
    REQUSET_MESGLIST,//消息
    REQUSET_BANKLIST,//银行卡列表
    REQUSET_PROVINCES,//省份
    REQUSET_CITY,
    REQUSET_BANK,//银行总行
    REQUSET_Branch,//银行支行
    REQUSET_BankCardBind,//绑定卡
    REQUSET_BankCardUnBind,//解除绑定
    REQUSET_RECORDLIST,//列表
    REQUSET_RECORDDETAIL, //详情
    REQUSET_MYPOS,//我的刷卡器
    REQUSET_CARDBALANCE, //查询银行卡余额
    REQUSET_JFPALCARDPAY, //支付
    REQUSET_JFPALCARDPAYFORSTORE,//商品支付
    REQUSET_JFPALACCTPAY,//账户支付,
    REQUSET_CodePay,     //扫码支付
    REQUSET_CodeOrderPic,//付款码支付请求 根据用户请求生成付款二维码。
    REQUSET_JFPalCash,//提现
    REQUEST_CLIENTUPDATE,//版本更新
    REQUEST_GETQUICKBANKCARD,//获取无卡支付绑定银行卡
    REQUEST_UNBINDQUICKBANKCARD,//解绑无卡支付银行卡
    REQUEST_QUICKBANKCARDQUERY,//查询银行卡信息
    REQUEST_QUICKBANKCARDAPPLY,//无卡支付申请
    REQUEST_QUICKBANKCARDCONFIRM,//确认无卡支付
    REQUEST_QUICKBANKCARDMSG,//发送无卡支付验证短信
    REQUEST_USERSIGNATUREUPLOAD, //上传签名图片
    REQUEST_GETCHANNELAPPLICATION, //功能频道开关
    REQUEST_QUERYCREDITINFO, //信用卡信息查询
    REQUEST_SEARCHALREADY, //查询已经认证的卡
    REQUEST_CARDSTATU, //查询卡的状态
    REQUEST_FOURINFO, //四要素检查
    REQUEST_ORGANIZATION,//绑定快捷⽀支付认证码
    REQUEST_QUICKPAYSTATE,//查询快捷⽀支付认证码绑定状态
    REQUEST_GETPHONENUMBER,//手机号信息(流量充值)
    REQUEST_GETBULETOOHTHNUMBER, //绑定蓝牙识别码
    REQUEST_GETFEERATE,          //手续费接口
    
    
    
    REQUSET_AD,
    REQUSET_PRODUCTLIST,
    REQUSET_ORDER_INQUIRY,
    REQUSET_FIRST,
    REQUSET_PRODUCTDETAIL,
    REQUSET_GETMONEY,
    REQUSET_GETORDER,
};

#define MOBILEMAC_CLIENTUPDATE                  @"ClientUpdate2"
#define MOBILEMAC_RETPWD                        @"RetrievePassword"
#define MOBILEMAC_CARDPAY                       @"JFPalCardPay"
#define MOBILEMAC_ACCTPAY                       @"JFPalAcctPay"
#define MOBILEMAC_UPPWD                         @"UserUpdatePwd"
#define MOBILEMAC_REGISTER                      @"UserRegister"
#define MONILEMAC_USERINFO                      @"UserInfoQuery"
#define MONILEMAC_ORDERINFO                     @"REQUSET_ORDER"
#define MONILEMAC_MOBILEMAC                     @"GetMobileMac"
#define MONILEMAC_LOGIN                         @"UserLogin"
#define MONILEMAC_USERUPDATAINFO                @"UserUpdateInfo"
#define MONILEMAC_USERIDENTITYPICUPLOAD         @"UserIdentityPicUpload2"
#define MOBILEMAC_USERINFOQUERY                 @"UserInfoQuery"
#define MOBILEMAC_ORDER                         @"RequestOrder"
#define MOBILEMAC_ACCTENQUIRY                   @"JFPalAcctEnquiry"
#define MOBILEMAC_COMMODITYLIST                 @"CommodityList"
#define MOBILEMAC_GETBANKLIST                   @"GetBankCardList2"
#define MOBILEMAC_USERAGREEMENT                 @"UserAgreement"
#define MOBILEMAC_RETPWD                        @"RetrievePassword"
#define MOBILEMAC_CHANGEPASSWORD                @"UserUpdatePwd"
#define MOBILEMAC_CARDPAY       @"JFPalCardPay"
#define MOBILEMAC_ACCTPAY       @"JFPalAcctPay"
#define MOBILEMAC_UPPWD         @"UserUpdatePwd"
#define MOBILEMAC_REGISTER      @"UserRegister"
#define MONILEMAC_USERINFO      @"UserInfoQuery"
#define MONILEMAC_ORDERINFO     @"REQUSET_ORDER"
#define MONILEMAC_MOBILEMAC     @"GetMobileMac"
#define MONILEMAC_LOGIN         @"UserLogin"
#define MONILEMAC_USERUPDATAINFO               @"UserUpdateInfo"
#define MONILEMAC_USERIDENTITYPICUPLOAD        @"UserIdentityPicUpload2"
#define MONILEMAC_UPLOADHEAD        @"UserHeadPicUpload"
#define MONILEMAC_GETUPLOADHEAD        @"GetUserHeadPic"
#define MOBILEMAC_USERINFOQUERY @"UserInfoQuery"
#define MOBILEMAC_ORDER         @"RequestOrder"
#define MOBILEMAC_ACCTENQUIRY   @"JFPalAcctEnquiry"
#define MOBILEMAC_COMMODITYLIST    @"CommodityList"
#define MOBILEMAC_ADDCOMMODITY  @"AddCommodity"
#define MOBILEMAC_DELETECOMMODITY @"DeleteCommodity"
#define MOBILEMAC_EDITCOMMODITY @"EditCommodity"
#define MOBILEMAC_GETBANKLIST      @"GetBankCardList2"
#define MOBILEMAC_MESGLIST         @"MsgList"
#define MOBILEMAC_CITIESCODE       @"CitiesCode"
#define MOBILEMAC_BANK             @"GetBankHeadQuarter"
#define MOBILEMAC_BANKOFBRANCH     @"GetBankBranch"
#define MOBILEMAC_BANKCARDBIND     @"BankCardBind"
#define MOBILEMAC_BANKCARDUNBIND     @"BankCardUnBind"

#define MOBILEMAC_RECORDLIST       @"RecordList"
#define MOBILEMAC_RECORDDETAIL     @"RecordDetail"
#define MOBILEMAC_MYPOS            @"MyPos"
#define MOBILEMAC_CARDBALANCE      @"BankCardBalance"
#define MOBILEMAC_JFPALCARDPAY     @"JFPalCardPay"
#define MOBILEMAC_JFPALCARDPAYFORSTORE @"JFPalCardPayforStore"
#define MOBILEMAC_JFPALACCTPAY     @"JFPalAcctPay"
#define MOBILEMAC_CodePay     @"CodePay"
#define MOBILEMAC_CodeOrderPic     @"CodeOrderPic"
#define MOBILEMAC_JFPALCASH        @"JFPalCash"
#define MOBILEMAC_USERSIGNATUREUPLOAD     @"UserSignatureUpload"
#define MOBILEMAC_GETQUICKBANKCARD        @"GetQuickBankCard"
#define MOBILEMAC_UNBINDQUICKBANKCARD        @"UnbindQuickBankCard"
#define MOBILEMAC_QUICKBANKCARDQUERY        @"QuickBankCardQuery"
#define MOBILEMAC_QUICKBANKCARDAPPLY        @"QuickBankCardApply"
#define MOBILEMAC_QUICKBANKCARDCONFIRM        @"QuickBankCardConfirm"
#define MOBILEMAC_QUICKBANKCARDMSG        @"QuickBankCardMsg"
#define MOBILEMAC_GETCHANNELAPPLICATION   @"Channel"
#define MOBILEMAC_QUERYCREDITINFO           @"QueryCreditInfo"
#define MOBILEMAC_BankCardInfoValid           @"BankCardInfoValid"
#define MOBILEMAC_GetBankCardInfoValid           @"GetBankCardInfoValid"
#define MOBILEMAC_GetBankCardInfoValidState           @"GetBankCardInfoValidState"
#define MOBILEMAC_BINDQUICKPAYPSAM           @"BindQuickPayPSAM"
#define MOBILEMAC_GETQUICKPAYPSAM           @"GetQuickPayPSAM"
#define MOBILEMAC_GETTRADEFLOW              @"TradeFlow"
#define MOBILEMAC_GETBULETOOHTHNUMBER       @"BindTerminal"
#define MOBILEMAC_GETFEERATE                @"GetFeerate"

@interface Request : NSObject

- (instancetype)initWithDelegate:(NSObject<ResponseData>*)delegate;

// 用户登录请求
- (void)userLoginWithAccount:(NSString*)account password:(NSString*)password;
// 获取验证码
- (void)getMobileMacWithAccount:(NSString*)account appType:(NSString*)type;
//版本更新
-(void)ClientUpdateInstrVersion:(NSString *)instrVersion dateType:(NSString *)dateType;
//注册
- (void)userSignWithAccount:(NSString *)account password:(NSString *)password mobileMac:(NSString *)mobileMac;
//用户协议
-(void)userAgreement;


//找回密码
- (void)backPasswordWithMobileNo:(NSString *)mobileNo newPassword:(NSString *)newPassword cardID:(NSString *)cardID mobileMac:(NSString *)mobileMac realNmae:(NSString *)realNmae;
//查询用户信息接口字段
- (void)userInfo:(NSString*)mobileNo;

//虚拟账户余额查询接口
- (void)getVirtualAccountBalance:(NSString*)accType token:(NSString*)token;

//申请交易订单
- (void)applyOrderMobileNo:(NSString *)mobileNo MerchanId:(NSString*)merchantId productId:(NSString*)productId orderAmt:(NSString *)orderAmt orderDesc:(NSString*)orderDesc orderRemark:(NSString*)orderRemark commodityIDs:(NSString *)commodityIDs payTool:(NSString*)payTool;
//实名认证资料（上传头像的前一步骤）
- (void)realNameAuthentication:(NSString *)realName ID:(NSString *)ID;
//上传头像
-(void)upPhotoImage:(NSData*)imageStr;
//上传侧边头像
-(void)upPhotoHeadImage:(NSData*)imageStr;
//获取侧边头像
-(void)getPhotoHeadImage;
- (void)getMallListmobile:(NSString *)mobileNo firstData:(NSString *)firstData lastData:(NSString *)lastData dataSize:(NSString *)dataSize requestType:(NSString *)requestType;
//添加商城列表数据
- (void)addMallDataMobileNo:(NSString *)mobileNo icon:(NSString *)icon title:(NSString *)title price:(NSString *)price amount:(NSString *)amount;
//删除商品数据
- (void)DeleteMallDataMobileNo:(NSString *)mobileNo commodityID:(NSString *)commodityID;
//修改商品数据
- (void)changeMallDataMobileNo:(NSString *)mobileNo commodityID:(NSString *)commodityID icon:(NSString *)icon title:(NSString *)title price:(NSString *)price amount:(NSString *)amount;
// 获取频道信息
- (void)getChannel;

//上传身份证正面
-(void)upIDcardPositive:(NSData*)imageStr;

//上传身份证反面
-(void)upIDcardReverse:(NSData*)imageStr;

//银行卡列表
-(void)bankListAndbindType:(NSString*)bindType;
//银行所在城市
-(void)BankofCity:(NSString *)provinceCode;

//银行所在省份
-(void)BankofProvinces;

//总行
-(void)GetBankHeadQuarter;

//支行
-(void)GetBranch;

//绑定卡
-(void)BankCardBind:(NSString*)accountNumber andBandType:(NSString*)bandType;

//交易记录列表
-(void)recordList:(NSString *)filter andFirstMsgID:(NSString *)firstMsgID andLastMsgID:(NSString *)lastMsgID andRequestType:(NSString *)requestType;

//交易详情
-(void)recordDetail:(NSString *)recordID andTime:(NSString *)time;

//我的刷卡器
-(void)myCreditCardMachine;

//查询卡余额
- (void)checkMyCardBalance:(NSString*)cardInfo cardPassWord:(NSString*)cardPassWord iccardInfo:(NSString*)ICCardInfo ICCardSerial:(NSString*)ICCardSerial ICCardValidDate:(NSString*)ICCardValidDate merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId encodeType:(NSString*)encodeType;
//商城刷卡支付
- (void)mallCardPay:(NSString *)cardInfo cardPassWord:(NSString *)cardPassword iccardInfo:(NSString *)ICCardInfo ICCardSerial:(NSString *)ICCardSerial ICCardValidDate:(NSString *)ICCardValidDate merchantId:(NSString *)merchantId productId:(NSString *)productId orderId:(NSString *)orderId encodeType:(NSString *)encodeType orderAmt:(NSString *)orderAmt payType:(NSString*)payType;
//支付接口
- (void)cardPay:(NSString*)cardInfo cardPassWord:(NSString*)cardPassword iccardInfo:(NSString*)ICCardInfo ICCardSerial:(NSString*)ICCardSerial ICCardValidDate:(NSString*)ICCardValidDate merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId  encodeType:(NSString*)encodeType orderAmt:(NSString*)orderAmt payType:(NSString*)payType;
//账户支付
- (void)acctPay:(NSString*)mobileNo encodetype:(NSString*)encodetype password:(NSString*)password mobileMac:(NSString*)mobileMac acctType:(NSString*)acctType merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId orderAmt:(NSString*)orderAmt encodeType:(NSString*)encodeType payType:(NSString*)payType;
//提现
-(void)takeCash:(NSString *)cashAmt andPassword:(NSString *)password andMobileMac:(NSString *)mobileMac andCashType:(NSString *)cashType andCardTag:(NSString *)cardTag andCardIdx:(NSString *)cardIdx;

#pragma mark - 无卡支付
//获取无卡支付绑定银行卡列表
- (void)getQuickPayMyCardList;
//解绑无卡支付银行卡
- (void)quickPayBankCardUnbind:(NSString*)bindId;
//查询银行卡信息
- (void)checkBankCardInfo:(NSString*)cardNo;
//无卡支付申请
- (void)applyForQuickPay:(NSString*)name IDCard:(NSString*)IDCard cardNo:(NSString*)cardNo vaild:(NSString*)vaild cvv2:(NSString*)cvv2 phone:(NSString*)phone orderID:(NSString*)orderID bindID:(NSString*)bindID orderAmt:(NSString*)orderAmt productId:(NSString*)productId merchantId:(NSString*)merchantId;
//确认无卡支付
- (void)enSureQuickPay:(NSString*)validateCode orderID:(NSString*)orderID;
//发送无卡支付验证短信
- (void)getQuickPayCode:(NSString*)orderID;

//上传签名图片
- (void)UserSignatureUploadMobile:(NSString *)mobile longitude:(NSString *)logitude latitude:(NSString *)latitude merchantId:(NSString *)merchantId orderId:(NSString *)orderId signPicAscii:(NSString *)signPicAscii picSign:(NSString *)picSign;

//消息
-(void)msgList:(NSString *)firstMsgID andLastMsgID:(NSString *)lastMsgID andRequestType:(NSString *)requestType;

//修改密码
- (void)changePasswordWithMobileNo:(NSString *)mobileNo newPassword:(NSString *)newPassword olePassword:(NSString *)olePassword mobileMac:(NSString *)mobileMac;
//解除银行卡绑定
-(void)BankCardUnBind:(NSString *)cardldx;

//功能频道开关
- (void)getChannelApplication;
//信用卡信息查询
- (void)checkCreditCardInfo:(NSString*)realName cardNum:(NSString*)accountNo;
//查询已经认证的银行卡
- (void)searchAlreadyCarNumStatu:(NSString *)str;
//查询已经认证的银行卡
- (void)searchAlreadyCarNum:(NSString *)str;
//四要素接口
- (void)carCheckName:(NSString*)realName cardNum:(NSString*)accountNo phone:(NSString*)phone idCard:(NSString*)iddcard;

//绑定快捷⽀支付认证码
-(void)quickPayCode:(NSString*)organization;

// 查询快捷⽀支付认证码绑定状态
-(void)quickPayCodeState;
//绑定蓝牙识别码 (查  增  删)
-(void)getBuleToothDeviceNumberWithInteger:(NSString*)integer deviceId:(NSString*)deviceId psamId:(NSString*)psamId PhoneNumber:(NSString *)mobileNo;

//versionStatus 0代表普通版 1代表vip  tradeDelay 提现类型  money  金额（单位为分）
-(void)getFeerateWithVersionStatus:(NSString*)versionStatus tradeDelay:(NSString*)tradeDelay money:(NSString*)money;

//扫码支付 0008000001  0000000000
-(void)scanToPayWalletType:(NSString*)walletType merchantId:(NSString*)merchantId productId:(NSString*)productId orderId:(NSString*)orderId orderAmt:(NSString*)orderAmt payAcc:(NSString*)payAcc;


//付款码订单请求  0008000002  0000000000
-(void)scanCodeOrderRequestWalletType:(NSString*)walletType merchantId:(NSString*)merchantId productId:(NSString*)productId orderAmt:(NSString*)orderAmt  orderId:(NSString*)orderId orderDesc:(NSString*)orderDesc orderRemark:(NSString*)orderRemark;



- (void)sendInfo;
- (void)getAD;
- (void)getProductWithCardId:(NSString*)cardId;
- (void)getInfoWithMobile:(NSString*)mobile;
- (void)getDetailInfoWithProductId:(NSString*)productId withTraceabilityId:(NSString*)traceabilityId;
- (void)getMoneyInfoWithProductId:(NSString*)productId productList:(id)productlist;
- (void)gettotalMoneyWithProductLists:(NSArray*)productlists withMobile:(NSString *)mobile withTotal:(NSString*)total;

//流量充值接口
- (void)getPhoneNumber:(NSString *)mobileNo;

@end
