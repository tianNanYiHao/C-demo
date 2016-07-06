//
//  FeedBackView.m
//  QuickPos
//
//  Created by Aotu on 16/6/20.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "FeedBackView.h"
#import "Common.h"
#import "JYZTextView.h"


@interface FeedBackView()<UITextFieldDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIButton *commedUP;
@property (weak, nonatomic) IBOutlet UITextField *textieldByFeed;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (nonatomic,strong) UILabel  *numLabel;
@property (nonatomic,strong) JYZTextView *jyzT;
@property (nonatomic,strong) NSString   *safeString; //安全字段



@end


@implementation FeedBackView
- (instancetype)init{
    self = [super init];
    if (self) {
        self  = [[[NSBundle mainBundle] loadNibNamed:@"FeedBackView" owner:self options:nil] objectAtIndex:0];
        self.viewBack.center = self.center;
        self.viewBack.layer.masksToBounds = YES;
        self.viewBack.layer.cornerRadius = 8;
        
        //textfiledADD
        _jyzT = [[JYZTextView alloc] initWithFrame:CGRectMake(5, 30, _viewBack.frame.size.width-10, _viewBack.frame.size.height/2)];
        _jyzT.backgroundColor = [UIColor whiteColor];
        _jyzT.delegate = self;
        _jyzT.font = [UIFont systemFontOfSize:14.f];
        _jyzT.textColor = [UIColor blackColor];
        _jyzT.textAlignment = NSTextAlignmentLeft;
        _jyzT.placeholder = @"请输入大于10少于300百字的评价";
        [_viewBack addSubview:_jyzT];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_jyzT.frame)-90, CGRectGetMaxY(_jyzT.frame)+6, 80, 21)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.text = @"300";
        _numLabel.backgroundColor = [UIColor whiteColor];
        [_viewBack addSubview:_numLabel];

        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        if (!self.parentCtrl) {
            self.parentCtrl = [[UIViewController alloc]init];
        }
        
    }
    return self;
}
#pragma mark textField的字数限制

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.numLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
    [self wordLimit:textView];
}

#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 300) {
        NSLog(@"%d",text.text.length);
        _jyzT.editable = YES;
    }
    else{
        _jyzT.editable = NO;
        _safeString = [_jyzT.text substringFromIndex:300]; //  提供后台使用
        
    }
    return nil;
}






- (IBAction)commedUPSure:(id)sender {
    
    [self.superCtrl dismissViewControllerAnimated:NO completion:^{
    }];
}


+(void)showVersionView:(id)ctrl{

    FeedBackView *v = [[FeedBackView alloc]init];
    [v.parentCtrl.view addSubview:v];
    v.superCtrl = (UIViewController*)ctrl;
    v.originFrame = v.superCtrl.view.frame;
    v.parentCtrl.view.window.windowLevel = UIWindowLevelAlert;
    [(UIViewController*)ctrl presentViewController:v.parentCtrl animated:NO completion:nil];
}





@end
