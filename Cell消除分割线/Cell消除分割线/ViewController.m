//
//  ViewController.m
//  Cell消除分割线
//
//  Created by Aotu on 16/1/18.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UITableView *tableview1;
    
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    
    tableview1 = [[UITableView alloc] init];
    tableview1.frame = [UIScreen mainScreen].bounds;
    tableview1.delegate = self;
    tableview1.dataSource = self;
    
    for (int i = 0; i<10; i++) {
        NSString *str = [NSString stringWithFormat:@"日了🐶%d",i];
        [_dataArray addObject:str];
    }
    [tableview1 reloadData];
    
    ////////////////////////////////////////////////////////////
    
    
    //1.
//    tableview1.separatorStyle = YES; //消除分割线
    

    
    //2.
//    解决tableView分割线左边不到边的情况 分割线不到边解决方法
        if ([tableview1 respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview1 setSeparatorInset:UIEdgeInsetsZero];
        }
    
    
    
    //3.
//    iOS8行高新特性 (动态计算行高)
    tableview1.estimatedRowHeight = 150.0f;  //estimated(预估)
    tableview1.rowHeight = UITableViewAutomaticDimension;   //Dimension(尺寸)
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    [self.view addSubview:tableview1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"id";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    }
    

    return cell;
    
    
}



//可以在这个方法里 对cell进行绑定数据 !!!!! 这个更为效率
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.textLabel.text = _dataArray[indexPath.row];
}


//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataArray removeObjectAtIndex:indexPath.row];//
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationLeft];
}

/*此时删除按钮为Delete，如果想显示为“删除” 中文的话，则需要实现
 UITableViewDelegate 中的- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath方法*/

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}




@end
