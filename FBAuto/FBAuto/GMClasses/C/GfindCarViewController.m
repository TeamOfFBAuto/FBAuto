//
//  GfindCarViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindCarViewController.h"
#import "GfindCarTableViewCell.h"


#import "GmLoadData.h"

@interface GfindCarViewController ()

@end

@implementation GfindCarViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.flagHeight = 60;
    
    _tableiView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64)];
    _tableiView.delegate = self;
    _tableiView.dataSource = self;
    
    _tableiView.separatorColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableiView];
    
    
    if (self.gtype == 2) {//我的车源
        [self prepareCheyuan];
    }else if (self.gtype == 3){//我的寻车
        [self prepareXunche];
    }
    
    
    
}



#pragma mark - 请求网络数据
//我的车源
-(void)prepareCheyuan{
    //获取我的车源列表
    //http://fbautoapp.fblife.com/index.php?c=interface&a=getmycheyuan&authkey=VWMHKVFzUWYBdAAuAWdRJgdz
    GmLoadData *gmloadData = [[GmLoadData alloc]init];
    
    
    
}

//我的寻车
-(void)prepareXunche{
    
}



#pragma mark - UITableiViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__FUNCTION__);
    static NSString *identifier = @"identifier";
    GfindCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GfindCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadView:indexPath];
    
    __weak typeof (self)bself = self;
    __weak typeof (_tableiView)btableview = _tableiView;
    
    //设置上下箭头的点击
    [cell setAddviewBlock:^{
        
        //flag不为空的时候赋值给last
        if (bself.flagIndexPath) {
            bself.lastIndexPath = bself.flagIndexPath;
        }
        //当前点击的indexPath赋值给flag
        bself.flagIndexPath = indexPath;
        
        //把flag加到数组里
        NSArray *indexPathArray = @[bself.flagIndexPath];
        
        //如果last有值 并且和flag不同 就加到数组里
        if (bself.lastIndexPath && (bself.lastIndexPath.row!=bself.flagIndexPath.row || bself.lastIndexPath.section != bself.flagIndexPath.section)) {
            indexPathArray = @[bself.lastIndexPath,bself.flagIndexPath];
        }
        
        //单元格高度标示 
        if (bself.flagHeight == 120) {
            bself.flagHeight = 60;
        }else if (bself.flagHeight == 60){
            bself.flagHeight = 120;
        }
        
        
        
        
        
        [btableview reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        
        
        
        
        
    }];
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadView:indexPath];
    }else{
        _tmpCell = [[GfindCarTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadView:indexPath];
    }
    

    NSLog(@"%f",height);
    
    return height;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
