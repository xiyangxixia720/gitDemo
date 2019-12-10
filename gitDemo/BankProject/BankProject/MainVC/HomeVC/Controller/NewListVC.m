//
//  NewListVC.m
//  BankProject
//
//  Created by mc on 2019/8/16.
//  Copyright © 2019 mc. All rights reserved.
//

#import "NewListVC.h"
#import "HomeTableViewCell.h"
#import "HomeBrandModel.h"
#import "WebViewController.h"

@interface NewListVC ()<UITableViewDelegate,UITableViewDataSource>

{
    int loadPage;
    BOOL isCompletion;
    int nowLoad;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeBrandModel *brandModel;
@property (nonatomic, strong) NSMutableArray *brandArr;

@end

@implementation NewListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"品牌动态";
    
    self.brandArr = [[NSMutableArray alloc] initWithCapacity:0];
    nowLoad = -1;
    loadPage = 0;

    [self getDataDate:0];
}

- (void)getDataDate:(int)pageCount
{
    if (nowLoad == pageCount) {
        return;
    }
    nowLoad = pageCount;
    int pageNum = LOADNUM;
    NSDictionary *send_d = @{@"page":[NSString stringWithFormat:@"%d",pageCount],
                             @"rows":[NSString stringWithFormat:@"%d",pageNum],
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@/app/home/selectContentByBand",MYURL] headStr:[FLTools getUserID] parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            if (dataArr.count == 0) {
                return;
            }
            if (self->isCompletion == YES && dataArr.count < pageNum) {
                [self.tableView reloadData];
                return;
            }
            if (dataArr.count < pageNum) {
                self->isCompletion = YES;
            }else{
                self->loadPage ++;
            }
            for (int i = 0; i < dataArr.count; i ++) {
                self.brandModel = [HomeBrandModel modelWithDictionary:dataArr[i]];
                [self.brandArr addObject:self.brandModel];
            }
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
        }
    } failure:^(id failure) {
        
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headLoad)];
        typeof(self) weakSelf = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf getDataDate:self->loadPage];
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.brandArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.brandModel = self.brandArr[indexPath.row];
    [cell.HomeNewImg sd_setImageWithURL:[NSURL URLWithString:self.brandModel.contentImg] placeholderImage:[UIImage imageNamed:@"img222"]];
    cell.HomeNewTitleLabel.text = self.brandModel.title;
    cell.HomeNewTimeLabel.text = self.brandModel.ctime;;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webVC = [[WebViewController alloc] init];
    //    webVC.webUrlStr = @"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9596532797121279138%22%7D&n_type=0&p_from=1";
    webVC.titleStr = @"品牌动态";
    
    self.brandModel = self.brandArr[indexPath.row];
    webVC.detailIDStr = self.brandModel.brandID;
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)headLoad
{
    [self.brandArr removeAllObjects];
    nowLoad = -1;
    loadPage = 0;
    isCompletion = NO;
    [self getDataDate:0];
    [self.tableView.mj_header endRefreshing];
}

- (void)footLoad
{
    [self.tableView.mj_footer endRefreshing];
    [self getDataDate:loadPage];
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
