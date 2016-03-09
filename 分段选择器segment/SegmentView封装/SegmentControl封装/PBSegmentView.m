//
//  PBSegmentView.m
//  SegmentControl封装
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 彭彬. All rights reserved.
//

#import "PBSegmentView.h"

#define kScreenW   [UIScreen mainScreen].bounds.size.width

#define kScreenH   [UIScreen mainScreen].bounds.size.height

@implementation PBSegmentView
{
    float width;//每个按钮的宽度
    
    UIImageView *_selectImage;
}


-(id)initWithFrame:(CGRect)frame withTitleArr:(NSArray*)TitleArr
{
    if (self = [super initWithFrame:frame]) {
        
        [self creatSegmentView:TitleArr];
    }
    return self;
}

//创建底部滑块
- (void)setSelectImageName:(NSString *)selectImageName {
    
    _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -3, width, 3)];
    
    _selectImage.image = [UIImage imageNamed:selectImageName];
    
    [self addSubview:_selectImage];
    
}


//循环创建button用于覆盖在view上用作itemsegment
-(void)creatSegmentView:(NSArray*)arr
{
//    if (arr.count <= 4) {
    
        width = self.frame.size.width/arr.count;
        
        for (int i = 0; i < arr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i*width, 0, width,self.frame.size.height);
            
            [button setTitle:arr[i] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
            
            //        选中的按钮调用方法
            [button addTarget:self action:@selector(segButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTag:10000 +i];
            
            
            //    设置初始button 的颜色与字体大小
            if (i == 0) {
                button.selected = YES;
                button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            }else
            {
                button.selected = NO;
            }
            
            [self addSubview:button];
        }
//    }else
//    {
//        width = self.frame.size.width/4;
//    }
    
    

    
}

- (void)segButtonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 10000;
    
    [UIView animateWithDuration:.35 animations:^{
        _selectImage.frame = CGRectMake(index * width, self.frame.size.height -3, width, 3);
    }];
    
//    调用block方法，进行传值给viewController，用与进行判断
    _segmentBlock(sender.tag -10000 , sender);
    
    
//    遍历视图数组，取出所有button，并将selected属性改为NO
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)view;
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    }
//    被选中的button
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:20];
}
@end

