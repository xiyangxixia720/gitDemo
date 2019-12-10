//
//  PersonInfoViewController.m
//  BankProject
//
//  Created by mc on 2019/7/19.
//  Copyright © 2019 mc. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MyAdressViewController.h"
#import "ChangePhoneViewController.h"
#import "ChangePWViewController.h"

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人资料";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self.view addSubview:self.tableView];
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"手机号",@"修改密码",@"我的地址"];
    }
    return _titleArr;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.titleArr[indexPath.section];
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = [fUserDefaults objectForKey:@"userphone"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//
//    }else if (indexPath.row == 1){
//        ChangePhoneViewController *changePhoneVC = [[ChangePhoneViewController alloc] init];
//        [self.navigationController pushViewController:changePhoneVC animated:YES];
//    }
    MyAdressViewController *addressVC = [[MyAdressViewController alloc] init];
    ChangePhoneViewController *changePhoneVC = [[ChangePhoneViewController alloc] init];
    ChangePWViewController *changePwVC = [[ChangePWViewController alloc] init];

    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:changePhoneVC animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:changePwVC animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:addressVC animated:YES];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
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
