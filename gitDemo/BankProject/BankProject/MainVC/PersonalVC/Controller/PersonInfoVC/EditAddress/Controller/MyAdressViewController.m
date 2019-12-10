//
//  MyAdressViewController.m
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import "MyAdressViewController.h"
#import "AddressTableViewCell.h"
#import "EditAddressViewController.h"
#import "MyAddressModel.h"


@interface MyAdressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyAddressModel *myAddressM;
@property (nonatomic, strong) NSMutableArray *myDataArr;

@end

@implementation MyAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的地址";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.myDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:self.tableView];
    
    [self getData];
}

- (void)getData
{
    WEAK_SELF;
    [self showLoadProgressWithStr:@"正在加载"];
    NSDictionary *sendD = @{@"userid":[FLTools getUserID]};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/selectAddress",MYURL] headStr:[FLTools getUserID] parameters:sendD success:^(id responseObject) {
        [weakSelf hideMyProgress];
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            for (int i = 0; i < dataArr.count; i ++) {
                self.myAddressM = [MyAddressModel modelWithDictionary:dataArr[i]];
                [self.myDataArr addObject:self.myAddressM];
            }
            [self.tableView reloadData];
        }else{
            [self.tableView reloadData];
        }
    } failure:^(id failure) {
        [weakSelf hideMyProgress];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACKCOLOR;
        _tableView.tableFooterView = [self getFootV];
    }
    return _tableView;
}

- (UIView *)getFootV
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    bView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    titleLabel.text = @"添加收货地址";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [bView addSubview:titleLabel];
    
    UIImageView *jianTouImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 50, 25, 10, 13)];
    [jianTouImg setImage:[UIImage imageNamed:@"jiantou"]];
    [bView addSubview:jianTouImg];
    
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewClick)];
    [bView addGestureRecognizer:tapClick];
    return bView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.myDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AddressTableViewCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.myAddressM = self.myDataArr[indexPath.section];
    cell.nameLabel.text = self.myAddressM.username;
    cell.phoneLabel.text = self.myAddressM.userphone;
    cell.contentLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.myAddressM.province,self.myAddressM.city,self.myAddressM.area,self.myAddressM.addressDetail];
    [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = 123 + indexPath.section;
    cell.deleteBtn.tag = 1999 + indexPath.section;
    return cell;
}

- (void)tapViewClick
{
    EditAddressViewController *editVC = [[EditAddressViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)editBtnClick:(UIButton *)button
{
    DLog(@"--- %ld",(long)button.tag);
    int selectedTag = (int)button.tag - 123;
    self.myAddressM = self.myDataArr[selectedTag];
    EditAddressViewController *editVC = [[EditAddressViewController alloc] init];
    editVC.editIDStr = self.myAddressM.addressID;
    editVC.infoDict = @{@"name":self.myAddressM.username,
                        @"phone":self.myAddressM.userphone,
                        @"province":self.myAddressM.province,
                        @"city":self.myAddressM.city,
                        @"area":self.myAddressM.area,
                        @"addressDetail":self.myAddressM.addressDetail,
                        };
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)deleteBtnClick:(UIButton *)button
{
    WEAK_SELF;
    [self showAlertVCWithTitle:@"提示" withMessage:@"确定删除此地址" withConfirm:^{
        int selectedTag = (int)button.tag - 1999;
        weakSelf.myAddressM = weakSelf.myDataArr[selectedTag];
        NSDictionary *send_d = @{@"id":weakSelf.myAddressM.addressID,
                                 };
        [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/deleteAddress",MYURL] headStr:[FLTools getUserID] parameters:send_d success:^(id responseObject) {
            if ([[responseObject objectForKey:@"status"] intValue] == 200) {
                [weakSelf showSucessWihtStr:@"删除成功"];
                [weakSelf.myDataArr removeAllObjects];
                [weakSelf getData];
            }else{
                
            }
        } failure:^(id failure) {
            
        }];
    } withCancel:^{
        
    } withViewController:self];
    
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


@end
