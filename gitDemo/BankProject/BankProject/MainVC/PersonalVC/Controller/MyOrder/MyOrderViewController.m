//
//  MyOrderViewController.m
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderView.h"
#import "OrderTableViewCell.h"
#import "MyOrderModel.h"

@interface MyOrderViewController ()<MyOrderViewDelegate,UITableViewDelegate,UITableViewDataSource>

{
    NSString *nowLoadStr;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nowMonthArr;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (nonatomic, strong) MyOrderModel *myOrderModel;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的订单";
    self.nowMonthArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.historyArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getDataWithType:[NSString stringWithFormat:@"%d",self.clickType]];
    [self.view addSubview:self.tableView];
}

- (void)getDataWithType:(NSString *)typeStr
{
    if ([typeStr intValue] == 3) {
        typeStr = @"";
    }
    NSDictionary *send_d = @{@"userid":[FLTools getUserID],
                             @"type":typeStr,
                             @"page":@"0",
                             @"rows":@"1000",
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectOrderList",MYURL] headStr:[FLTools getUserID] parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *allDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"allData"];
            NSArray *monthDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"monthData"];
            for (int i = 0; i < allDataArr.count; i ++) {
                self.myOrderModel = [MyOrderModel modelWithDictionary:allDataArr[i]];
                [self.nowMonthArr addObject:self.myOrderModel];
            }
            for (int j = 0; j < monthDataArr.count; j ++) {
                self.myOrderModel = [MyOrderModel modelWithDictionary:monthDataArr[j]];
                [self.historyArr addObject:self.myOrderModel];
            }
            [self.tableView reloadData];
        }
    } failure:^(id failure) {
        
    }];
}

- (void)initUI
{
    MyOrderView *orderHead = [[MyOrderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 45) withType:self.clickType - 1];
    orderHead.backgroundColor = [UIColor whiteColor];
    orderHead.delegate = self;
    [self.view addSubview:orderHead];
    
    [self.view addSubview:self.tableView];
}

#pragma mark --- customDelegate ---
- (void)headClickIndex:(int)index
{
    DLog(@"----%d",index);
    [self.historyArr removeAllObjects];
    [self.nowMonthArr removeAllObjects];
    [self getDataWithType:[NSString stringWithFormat:@"%d",index + 1]];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_W, SCREEN_H - Nav_Height - 45 - HomeIndicator) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 160;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.nowMonthArr.count;
    }else{
        return self.historyArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] lastObject];
    }
    if (indexPath.section == 0) {
        self.myOrderModel = self.nowMonthArr[indexPath.row];
        cell.label1.text = self.myOrderModel.ordercode;
        NSString *statusStr;
        if ([self.myOrderModel.status intValue] == 1) {
            statusStr = @"未发货";
        }else{
            statusStr = @"已发货";
        }
        cell.label2.text = statusStr;
        cell.label3.text = self.myOrderModel.shop_name;
        cell.label4.text = [NSString stringWithFormat:@"￥%@",self.myOrderModel.shop_money];
        cell.label5.text = [NSString stringWithFormat:@"x%@",self.myOrderModel.number];
        cell.label6.text = self.myOrderModel.ctime;
        cell.label7.text = [NSString stringWithFormat:@"合计：￥%@", self.myOrderModel.pay_money];
    }else{
        self.myOrderModel = self.historyArr[indexPath.row];
        cell.label1.text = self.myOrderModel.ordercode;
        NSString *statusStr;
        if ([self.myOrderModel.status intValue] == 1) {
            statusStr = @"未发货";
        }else{
            statusStr = @"已发货";
        }
        cell.label2.text = statusStr;
        cell.label3.text = self.myOrderModel.shop_name;
        cell.label4.text = [NSString stringWithFormat:@"￥%@",self.myOrderModel.shop_money];
        cell.label5.text = [NSString stringWithFormat:@"x%@",self.myOrderModel.number];
        cell.label6.text = self.myOrderModel.ctime;
        cell.label7.text = [NSString stringWithFormat:@"合计：￥%@", self.myOrderModel.pay_money];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    footV.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor grayColor];
    if (section == 0) {
        titleLabel.text = @"本月订单";
    }else{
        titleLabel.text = @"历史订单";
    }
    [footV addSubview:titleLabel];
    return footV;
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
