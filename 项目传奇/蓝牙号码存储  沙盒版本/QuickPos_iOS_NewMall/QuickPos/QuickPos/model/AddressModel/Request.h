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
    REQUEST_ORGANIZATION,//绑定快捷⽀支付认证码
    REQUEST_QUICKPAYSTATE,//查询快捷⽀支付认证码绑定状态
    REQUEST_GETPHONENUMBER,//手机号信息(流量充值)

    
    REQUSET_AD,
    REQUSET_PRODUCTLIST,
    REQUSET_ORDER_INQUIRY,
    REQUSET_FIRST,
    REQUSET_PRODUCTDETAIL,
    REQUSET_GETMONEY,
    REQUSET_GETORDER,
    
    
    
    
    REQUSET_Lccplist, //理财产品列表 55
    REQUSET_MyMangeZiChanList, //查询我的理财资产列表// 56
    REQUSET_HoldingList, //持有中.... 57
    REQUSET_ZHUCEMANGE, //开通理财账户 58
    REQUSET_showHadRedeem,//已赎回列表 59
    REQUSET_GETPRODUCTDITAIL, //获取产品详情列表 60
    REQUSET_getManageProductOrder, //生成理财产品订单接口 61
    


    
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
#define MOBILEMAC_BINDQUICKPAYPSAM           @"BindQuickPayPSAM"
#define MOBILEMAC_GETQUICKPAYPSAM           @"GetQuickPayPSAM"
#define MOBILEMAC_GETTRADEFLOW              @"TradeFlow"


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

//绑定快捷⽀支付认证码
-(void)quickPayCode:(NSString*)organization;

// 查询快捷⽀支付认证码绑定状态
-(void)quickPayCodeState;







/////
//获取理财产品列表
-(void)getManageListWithBranchname:(NSString*)appuser userid:(NSString*)telephontNum;
//查询我的理财资产接口
-(void)getMyMangeZiChanList;
//5、查看持有产品列表(持有中)
-(void)getHoldingList;
//8、开通理财账户
-(void)getZhuce;
//9、查看赎回产品列表 (已赎回)
-(void)showHadRedeem;
//2.产品详情
-(void)getProductDitailWithID:(NSString*)productID;
//3、申购产品 生成订单接口
-(void)getManageProductOrderWithProductID:(NSString*)ProductID Number:(NSNumber*)number amt:(NSNumber*)amt tranType:(NSString *)type;









- (void)getPhoneNumber:(NSString *)mobileNo;//流量充值
- (void)sendInfo;
- (void)getAD;
- (void)getProductWithCardId:(NSString*)cardId;
- (void)getInfoWithMobile:(NSString*)mobile;
- (void)getDetailInfoWithProductId:(NSString*)productId withTraceabilityId:(NSString*)traceabilityId;
- (void)getMoneyInfoWithProductId:(NSString*)productId productList:(id)productlist;
- (void)gettotalMoneyWithProductLists:(NSArray*)productlists withMobile:(NSString *)mobile withTotal:(NSString*)total;
@end
