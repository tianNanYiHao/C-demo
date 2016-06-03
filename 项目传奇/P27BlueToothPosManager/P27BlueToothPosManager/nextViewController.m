//
//  nextViewController.m
//  P27BlueToothPosManager
//
//  Created by Aotu on 16/5/26.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "nextViewController.h"
#import "DCBlueToothManager.h"

@interface nextViewController ()
@property (nonatomic,strong) DCBlueToothManager *dcBlueToothManager;

@end

@implementation nextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"DCBlueToothManagerTestView";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
 
    
    
    
    
    
    
}
- (IBAction)getDCBluetoothManger:(id)sender {
    
    _dcBlueToothManager = [DCBlueToothManager getDCBlueToothManager];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
