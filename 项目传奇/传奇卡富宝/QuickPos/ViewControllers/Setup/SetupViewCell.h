//
//  SetupViewCell.h
//  QuickPos
//
//  Created by kuailefu on 16/6/2.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetupViewCellDelegate <NSObject>

-(void)getIndex:(NSIndexPath*)indexPath;


@end

@interface SetupViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (nonatomic,assign)id<SetupViewCellDelegate> delegate;
@property (nonatomic,assign) NSIndexPath *indexPath;


@end
