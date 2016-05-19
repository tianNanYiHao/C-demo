//
//  ViewController.h
//  BluetoothTest
//
//  Created by gui hua on 15/3/18.
//  Copyright (c) 2015年 szjhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITextViewDelegate, UITableViewDelegate>
{

   }
 
@property (retain, nonatomic) IBOutlet UITableView *devicesTableView;
- (IBAction)BtnFoundDevice:(id)sender;
- (IBAction)BtndisConnect:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *LabTip;
@property (retain, nonatomic) IBOutlet UITextView *TextViewTip;
- (IBAction)BtnAmountPass:(id)sender;
- (IBAction)BtnAmountNopass:(id)sender;
- (IBAction)BtnNoAmountpass:(id)sender;
- (IBAction)BtnNoAmountNopass:(id)sender;
- (IBAction)BtnMainkey:(id)sender;
- (IBAction)BtnWorkKey:(id)sender;
- (IBAction)BtnMac:(id)sender;
- (IBAction)BtnReadBattery:(id)sender;
- (IBAction)BtnTerid:(id)sender;
- (IBAction)BtnCancel:(id)sender;

@end

