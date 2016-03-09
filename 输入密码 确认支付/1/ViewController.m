//
//  ViewController.m
//  1
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)dd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
            [alert setTitle:@"SecurityVerification"];
    [alert setMessage:@"ForYourTransactionSecurityPleaseEnterTheVerificationCode"];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"MessageAuthenticationCode";
                    textField.secureTextEntry = YES;
        
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *pwd = [(UITextField*)[alert.textFields objectAtIndex:0] text];
        if (pwd.length == 0) {
           
            [self presentViewController:alert animated:YES completion:nil];
        }else{
          
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
