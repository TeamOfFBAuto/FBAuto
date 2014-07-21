//
//  GmarkViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//个人中心 我的收藏界面
#import <UIKit/UIKit.h>



@class LoadingIndicatorView;
@class GmarkTableViewCell;


@interface GmarkViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>
{
    UITableView *_tableview;
    UIView *_dview;//下面删除view
    
    
    GmarkTableViewCell *_tmpCell;//用于计算高度
    
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    int _currentPage;//当前页
    
    //上提加载
    LoadingIndicatorView *_upMoreView;//上提加载更多
    BOOL _isUpMoreSuccess;//上提加载成功
    BOOL _isupMore;//是否为上提加载更多

    
    
}

@property(nonatomic,assign)BOOL delClicked;//点击删除按钮
@property(nonatomic,assign)int delType;//是否为删除 2是正常 3为删除

@property(nonatomic,strong)UILabel *numLabel;//记录删除时选中了多少个


@property(nonatomic,strong)NSMutableArray *netDataArray;//网络数据数组
@property(nonatomic,strong)NSMutableArray *dataSourceArray;//数据源

//记录点击要删除的收藏的数组
@property(nonatomic,strong)NSMutableArray *indexes;

@end
