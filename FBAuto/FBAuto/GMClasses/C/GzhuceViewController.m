//
//  GzhuceViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GzhuceViewController.h"
#import "GzhuceTableViewCell.h"

@interface GzhuceViewController ()

@end

@implementation GzhuceViewController




- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //分配内存
    self.contenTfArray = [[NSMutableArray alloc]init];
    
    //自定义navigation
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui_24_42.png"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 12, 21);
    [leftBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 21)];
    [leftV addSubview:leftBtn];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:leftV];
    self.navigationItem.leftBarButtonItem = leftitem;
    
    
    self.navigationItem.title = @"经纪人注册";
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.alpha = 1;
    
    //个人注册
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"个人注册" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    btn1.frame = CGRectMake(0, 64, 160, 50);
    [btn1 addTarget:self action:@selector(gerenzhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    //商家注册
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"商家注册" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    btn2.frame = CGRectMake(160, 64, 160, 50);
    [btn2 addTarget:self action:@selector(shagnjiazhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    //个人注册
    _gerenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 124, 320, 568-124) style:UITableViewStylePlain];
    _gerenTableView.delegate = self;
    _gerenTableView.dataSource = self;
    _gerenTableView.tag = 5;
    [self.view addSubview:_gerenTableView];
    
    //商家注册
    _shangjiaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 124, 320, 568-124) style:UITableViewStylePlain];
    _shangjiaTableView.delegate = self;
    _shangjiaTableView.dataSource = self;
    _shangjiaTableView.tag = 6;
    [self.view addSubview:_shangjiaTableView];
    _shangjiaTableView.hidden = YES;
    
    
    
    //地区pickview
    _pickeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    _pickeView.delegate = self;
    _pickeView.dataSource = self;
    [self.view addSubview:_pickeView];
    _isChooseArea = NO;
    
    //地区选择
    UIView *backPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 568, 320, 216)];
    backPickView.backgroundColor = [UIColor whiteColor];
    
    [backPickView addSubview:_pickeView];
    self.backPickView = backPickView;
    [self.view addSubview:self.backPickView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    
    
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}



//个人注册
-(void)gerenzhuce{
    _gerenTableView.hidden = NO;
    _shangjiaTableView.hidden = YES;
    self.navigationItem.title = @"经纪人注册";
}

//商家注册
-(void)shagnjiazhuce{
    _shangjiaTableView.hidden = NO;
    _gerenTableView.hidden = YES;
    self.navigationItem.title = @"商家注册";
}





//#pragma mark - 提交
//-(void)tijiaoBtnClicked{
//    NSLog(@"%s",__FUNCTION__);
//}




#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        if (tableView.tag == 5) {//个人注册
            height = 395;
        }else if(tableView.tag ==6){//商家注册
            height = 505;
        }
    }else if (indexPath.row ==1){
        height = 80;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str1 = @"geren";
    static NSString *str2 = @"shangjia";
    
    GzhuceTableViewCell *Gcell = nil;
    if (tableView.tag == 5) {//个人
        GzhuceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[GzhuceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1];
        }
        Gcell = cell;
        [Gcell areaFuzhi];
        
    }else if (tableView.tag == 6){//商家
        GzhuceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str2];
        if (!cell) {
            cell = [[GzhuceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2];
        }
        Gcell = cell;
        
        [Gcell areaFuzhi];
        
    }
    
   
    
    
    if (indexPath.row == 1) {
        for (UIView *view in Gcell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 32)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 36, 300, 32)];
        
        label1.font = [UIFont systemFontOfSize:12];
        label2.font = [UIFont systemFontOfSize:12];
        
        
        label1.text = @"1.请输入一个您常用的";
        [Gcell.contentView addSubview:label1];
        [Gcell.contentView addSubview:label2];
        
        
    }
    
    
    Gcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    __weak typeof (_gerenTableView)bgerenTableView = _gerenTableView;
    __weak typeof (_shangjiaTableView)bshangjiaTableView = _shangjiaTableView;
    __weak typeof (self)bself = self;
    
    //上移tableview
    [Gcell setTfBlock:^(long tt) {
        
        if (tt == 13|| tt == 14 || tt == 15 ) {
            [UIView animateWithDuration:0.3 animations:^{
                bgerenTableView.frame = CGRectMake(0, -50, 320, 444);
            } completion:^(BOOL finished) {
                
            }];
        }else if (tt == 23 || tt == 24 || tt == 25 || tt == 26 ) {
            [UIView animateWithDuration:0.3 animations:^{
                bshangjiaTableView.frame = CGRectMake(0, -90, 320, 444);
            } completion:^(BOOL finished) {
                
            }];
            
            
        }else if (tt == 27) {
            [UIView animateWithDuration:0.3 animations:^{
                bshangjiaTableView.frame = CGRectMake(0, -150, 320, 500);
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }];
    
    //收键盘时下移tableview
    [Gcell setShouTablevBlock:^{
        _isChooseArea = NO;
        [UIView animateWithDuration:0.3 animations:^{
            bgerenTableView.frame = CGRectMake(0, 124, 320, 444);
            bshangjiaTableView.frame = CGRectMake(0, 124, 320, 444);
            [bself areaHidden];
        } completion:^(BOOL finished) {
            
        }];
        
        
    }];
    
    
    //设置弹出datePickView block
    __weak typeof (Gcell)bGcell = Gcell;
    
    [Gcell setChooseAreaBlock:^{
        [bGcell allShou];
        if (_isChooseArea == NO) {
            [bself areaShow];
        }else{
            [bself areaHidden];
        }
        _isChooseArea = !_isChooseArea;
    }];
    
    
    
    
    Gcell.delegate = self;
    
    return Gcell;
}




#pragma mark - 地区选择弹出
-(void)areaShow{//地区出现
    NSLog(@"_backPickView");
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0, 352, 320, 216);
    }];
    
    
}

-(void)areaHidden{//地区隐藏
    __weak typeof (self)bself = self;
    //NSLog(@"sss ssss ssss %@ %@",self.province,self.city);
    if (_gerenTableView.hidden == NO) {
        [_gerenTableView reloadData];
    }
    if (_shangjiaTableView.hidden == NO) {
        [_shangjiaTableView reloadData];
    }
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0, 568, 320, 216);
        
    }];
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _data.count;
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        return cities.count;
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return _data[row][@"State"];
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        return cities[row][@"city"];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _flagRow = row;
        _str1 = _data[row][@"State"];
        NSLog(@"%@",_str1);
        //给控件赋值str1
        if ([_str1 isEqualToString:@"省份"]) {
            _str1 = @"";
        }
        //self.diqu = _str1;
        if (_gerenTableView.hidden == NO) {
            self.province = _str1;//上传
        }
        if ((_shangjiaTableView.hidden == NO)) {
            self.province1 = _str1;
        }
        
        _isChooseArea = YES;
        
        
    } else if (component == 1) {
        _str2 = _data[_flagRow][@"Cities"][row][@"city"];
        if ([_str2 isEqualToString:@"市区县"]) {
            _str2 = @"";
        }
        _str3 = [_str1 stringByAppendingString:_str2];
        NSLog(@"%@",_str3);
        //给控件赋值str3;
        //self.diqu = _str3;
        self.city = _str2;//上传
        if (_gerenTableView.hidden == NO) {
            self.province1 = _str2;
        }
        if (_shangjiaTableView.hidden == NO) {
            self.city1 = _str2;
        }
        _isChooseArea = YES;
        
        
    }
    [pickerView reloadAllComponents];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
