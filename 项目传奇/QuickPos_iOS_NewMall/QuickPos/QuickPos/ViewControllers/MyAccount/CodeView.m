//
//  CodeView.m
//  QuickPos
//
//  Created by 张倡榕 on 15/6/10.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "CodeView.h"
@interface CodeView ()<ResponseData,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UIButton *binding;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (nonatomic,assign)BOOL textType;

//@property (nonatomic,strong)UIViewController *parentCtrl;
@end

@implementation CodeView
@synthesize codeLbl;
@synthesize backview;
@synthesize codeTextF;
@synthesize textType;
- (instancetype)init{
    self = [super init];
    if (self) {
//        Request *request = [[Request alloc]initWithDelegate:self];
//        [request quickPayCodeState];
//        if (![codeLbl.text isEqualToString:L(@"NoRecord")]) {
//            self.binding.userInteractionEnabled = YES;
//        }
//        [self.binding addTarget:self action:@selector(bindingQuickPosCode:) forControlEvents:UIControlEventTouchUpInside];
        self  = [[[NSBundle mainBundle] loadNibNamed:@"CodeView" owner:self options:nil] objectAtIndex:0];
        self.backview.center = self.center;
        self.backview.layer.masksToBounds = YES;
        self.backview.layer.cornerRadius = 8;
        self.codeTextF.userInteractionEnabled = NO;
//        self.codeTextF.layer.masksToBounds = YES;
//        self.codeTextF.layer.borderWidth = 1.0;
//        self.codeTextF.layer.cornerRadius = 8;
//        self.codeTextF.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        textType = YES;
        self.frame = CGRectMake(0, -27, SCREEN_WIDTH, SCREEN_HEIGHT);
        if (!self.parentCtrl) {
            self.parentCtrl = [[UIViewController alloc]init];
        }
        
        
    }
    return self;
    
    
}
- (IBAction)closeCodeView:(id)sender {
    NSLog(@"closeCodeView");
    [self removeFromSuperview];
}

-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        
        if (type == REQUEST_ORGANIZATION) {
            [self.delegate getRespDesc:L(@"BindingSuccess")];
        }
    }
    else
    {
        [self.delegate getRespDesc:[dict objectForKey:@"respDesc"]];
    }

}





//绑定快捷支付认证码
- (IBAction)bindingQuickPosCode:(UIButton *)sender {
    
     NSLog(@"bindingQuickPosCode");
    if (textType == NO) {
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"PleaseInputQuickCode") message:L(@"InputSixteenCode") delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"sure"), nil];
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
//        [alert show];
        
        NSString *code = codeTextF.text;
        if (code.length != 16 || ![self matchStringFormat:code withRegex:@"^[0-9]*$"])
        {
            [self.delegate getRespDesc:L(@"InputRightCode")];
            [self removeFromSuperview];
            
        }
        else
        {
            Request *request = [[Request alloc]initWithDelegate:self];
            [request quickPayCode:code];
            [self removeFromSuperview];
        }
        
    }
    else
    {
        [self removeFromSuperview];
    }
    
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        NSString *code = [(UITextField*)[alertView textFieldAtIndex:0] text];
//        
//        if (code.length != 16 || ![self matchStringFormat:code withRegex:@"^[0-9]*$"])
//        {
////            [MBProgressHUD showHUDAddedTo:self animated:YES WithString:L(@"PleaseEnterCorrectInformation")];
//            [self removeFromSuperview];
//            [self.delegate getRespDesc:L(@"InputRightCode")];
//        }
//        else
//        {
//            Request *request = [[Request alloc]initWithDelegate:self];
//            [request quickPayCode:code];
//            [self removeFromSuperview];
//        }
//    }
//    else{
//        
//    }
//}

#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:matchedStr];
}


+ (void)showVersionView:(UIViewController *)ctrl lab:(NSString *)lab{
    CodeView * v = [[CodeView alloc]init];
    v.delegate = (NSObject<getRespDesc>*)ctrl;
    [ctrl.view addSubview:v];

    if ([lab isEqualToString:L(@"NoRecord")]) {
        v.textType = NO;
        v.codeTextF.userInteractionEnabled = YES;
        v.codeTextF.placeholder = L(@"InputSixteenCode");
    }
    else
    {
        v.codeTextF.placeholder = lab;
    }
    v.originFrame = v.superCtrl.view.frame;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
