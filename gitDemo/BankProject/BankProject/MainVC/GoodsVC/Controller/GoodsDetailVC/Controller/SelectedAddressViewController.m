//
//  SelectedAddressViewController.m
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import "SelectedAddressViewController.h"
#import "SeletAddressTableViewCell.h"
#import "AddressModel.h"
#import "EditAddressViewController.h"

@interface SelectedAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AddressModel *addModel;

@end

@implementation SelectedAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 360) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self getHeadV];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


- (UIView *)getHeadV
{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(0, 10, 35, 35);
    [headV addSubview:closeBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2 - 100, 15, 200, 20)];
    titleLabel.text = @"配送至";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headV addSubview:titleLabel];
    
    return headV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    SeletAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SeletAddressTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if (indexPath.row == 0) {
//        cell.addressLabel.text = @"添加新地址";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.addressImg.image = [UIImage imageNamed:@""];
//    }else{
        self.addModel = self.addressArr[indexPath.row];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.addModel.province,self.addModel.city,self.addModel.area,self.addModel.addressDetail];
        cell.addressImg.image = [UIImage imageNamed:@"address(1)"];
//    }
    return cell;
}

- (void)closeBtnClick
{
    [self.popupController dismiss];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.row == 0) {
//        EditAddressViewController *editVC = [[EditAddressViewController alloc] init];
//        [self.navigationController pushViewController:editVC animated:YES];
//    }else{
        [self.popupController dismiss];
        self.addModel = self.addressArr[indexPath.row];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter postNotificationName:@"selectAddressNoti" object:nil userInfo:@{@"addressIndex":[NSString stringWithFormat:@"%ld",indexPath.row]}];
//    }
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
