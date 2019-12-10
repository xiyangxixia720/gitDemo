//
//  PersonalViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonInfoCell.h"
#import "PersonInfoSecondCell.h"
#import "PersonNewHead.h"
#import "MyTeamViewController.h"
#import "UploadParam.h"
#import "PersonInfoViewController.h"
#import "MyOrderViewController.h"
#import "AboutUSViewController.h"
#import "PWLoginViewController.h"
#import "PersonModel.h"

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)   NSArray *titlelArr;
@property (nonatomic, copy)   NSArray *imgArr;

@property (nonatomic, strong) UIImageView *PersonImg;

@property (nonatomic, strong) PersonModel *pModel;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getData];
    [self.view addSubview:self.tableView];

}

- (void)getData
{
    if (![FLTools isLogin]) {
        return;
    }
    NSDictionary *sendD = @{@"userid":[FLTools getUserID]};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/selectAppUserById",MYURL] headStr:[FLTools getUserID] parameters:sendD success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            self.pModel = [PersonModel modelWithDictionary:[responseObject objectForKey:@"data"]];
            [self.tableView reloadData];
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(id failure) {
        [self showErrorWithStr:@"请检查网络连接"];
    }];
}

- (void)initData
{
    self.titlelArr = @[@[@"yifahuo",@"weifahuo",@"quanbu"],@[@"wodetuandui",@"guanyuwomen",@"tuichu"]];
    self.imgArr    = @[@[@"已发货",@"未发货",@"全部"],@[@"我的团队",@"关于我们",@"退出登录"]];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -Status_Height, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 150;
    }
    _tableView.tableHeaderView = [self getHeadView];
    return _tableView;
}

- (UIView *)getHeadView
{
    PersonNewHead *pH = [[[NSBundle mainBundle] loadNibNamed:@"PersonNewHead" owner:self options:nil] lastObject];
    NSString *userNameStr;
    NSString *userID;
    NSString *levelNameStr = @"未登录";
    NSString *buyResultsStr = @"未登录";
    NSString *rewardStr = @"未登录";
    NSString *headImgStr;

    if ([FLTools isLogin]) {
        userNameStr = [fUserDefaults objectForKey:@"realname"];
        userID = [fUserDefaults objectForKey:@"code"];
        levelNameStr = self.pModel.levelName;
        buyResultsStr = [NSString stringWithFormat:@"%@",self.pModel.buyResults];
        rewardStr = [NSString stringWithFormat:@"%@",self.pModel.reward];
        headImgStr = [fUserDefaults objectForKey:@"headImg"];
    }
    pH.frame = CGRectMake(0, 0, SCREEN_W, 270);
    pH.PersonNameLabel.text = userNameStr;
    pH.PersonImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapCLick)];
    [pH.PersonImg addGestureRecognizer:imgTap];
    self.PersonImg = pH.PersonImg;
    [pH.PersonImg sd_setImageWithURL:[NSURL URLWithString:headImgStr] placeholderImage:[UIImage imageNamed:@"moren"]];
    pH.IDLabel.text = userID;
    pH.LevelLabel.text = levelNameStr;
    pH.AllPriceLabel.text = buyResultsStr;
    pH.HasMoneyLabel.text = rewardStr;
    [pH.EditBtn addTarget:self action:@selector(EditBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return pH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"cell";
        PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonInfoCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFirstClick)];
        [cell.infoFirstB addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecondClick)];
        [cell.infoSecondB addGestureRecognizer:tap2];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThirdClick)];
        [cell.infoThirdB addGestureRecognizer:tap3];
        return cell;
    }else{
        static NSString *cellIDS = @"secondCell";
        PersonInfoSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:cellIDS];
        if (!secondCell) {
            secondCell = [[[NSBundle mainBundle] loadNibNamed:@"PersonInfoSecondCell" owner:self options:nil] lastObject];
            secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4Click)];
        [secondCell.SInfoFView addGestureRecognizer:tap4];
        
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap5Click)];
        [secondCell.SInfoSView addGestureRecognizer:tap5];
        UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap6Click)];
        [secondCell.SInfoTView addGestureRecognizer:tap6];
        if ([FLTools isLogin]) {
            secondCell.outLoginLabel.text = @"退出登录";
        }else{
            secondCell.outLoginLabel.text = @"登录";
        }
        return secondCell;
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


#pragma mark --- btnClickMethed ---
- (void)tapFirstClick
{
    DLog(@"11111111");
    if ([FLTools isLogin]) {
        MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
        myOrderVC.clickType = 1;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }else{
        PWLoginViewController *pwLoginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:pwLoginVC animated:YES];
    }
}

- (void)tapSecondClick
{
    DLog(@"22222");
    if ([FLTools isLogin]) {
        MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
        myOrderVC.clickType = 2;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }else{
        PWLoginViewController *pwLoginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:pwLoginVC animated:YES];
    }
}

- (void)tapThirdClick
{
    DLog(@"333333");
    if ([FLTools isLogin]) {
        MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
        myOrderVC.clickType = 3;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }else{
        PWLoginViewController *pwLoginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:pwLoginVC animated:YES];
    }
}


- (void)tap4Click
{
    DLog(@"444444");
    
    if ([FLTools isLogin]) {
        MyTeamViewController *teamVC = [[MyTeamViewController alloc] init];
        [self.navigationController pushViewController:teamVC animated:YES];
    }else{
        PWLoginViewController *codeLoginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:codeLoginVC animated:YES];
    }
}

- (void)tap5Click
{
    DLog(@"555555");
    AboutUSViewController *aboutUS = [[AboutUSViewController alloc] init];
    [self.navigationController pushViewController:aboutUS animated:YES];
}

- (void)tap6Click
{
    DLog(@"6666666");
    PWLoginViewController *pwLoginVC = [[PWLoginViewController alloc] init];
    if ([FLTools isLogin]) {
        WEAK_SELF;
        [self showAlertVCWithTitle:@"提示" withMessage:@"确定退出登录" withConfirm:^{
            [FLTools Logout];
            [weakSelf.navigationController pushViewController:pwLoginVC animated:YES];
        } withCancel:^{
            
        } withViewController:self];
    }else{
        [self.navigationController pushViewController:pwLoginVC animated:YES];
    }
    
}

- (void)EditBtnClick
{
    if ([FLTools isLogin]) {
        PersonInfoViewController *personInfoVC = [[PersonInfoViewController alloc] init];
        [self.navigationController pushViewController:personInfoVC animated:YES];
    }else{
        PWLoginViewController *codeLoginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:codeLoginVC animated:YES];
    }
}

- (void)imgTapCLick
{
    
    if ([FLTools isLogin]) {
        WEAK_SELF
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
            [weakSelf uploadPicture:(UIImage *)data];
        }];
    }else{
        PWLoginViewController *codeLoginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:codeLoginVC animated:YES];
    }
}


- (void)uploadPicture:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    UploadParam *uploadP = [[UploadParam alloc] init];
    uploadP.data = imageData;
    uploadP.name = @"file";
    uploadP.filename = fileName;
    uploadP.mimeType = @"image/jpeg";
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArr addObject:uploadP];
    
    WEAK_SELF;
    [[HttpRequest sharedInstance] uploadWithURLString:[NSString stringWithFormat:@"%@app/user/upload",MYURL] parameters:nil uploadParam:dataArr success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {

            [fUserDefaults setObject:[responseObject objectForKey:@"data"] forKey:@"headImg"];
                                     

            [weakSelf loadPersonImgWithImg:[responseObject objectForKey:@"data"]];
        }else{
            [weakSelf showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf showErrorWithStr:@"请检查网络连接"];
    }];
}

- (void)loadPersonImgWithImg:(NSString *)imgStr
{
    WEAK_SELF;
    NSDictionary *send_d = @{@"head_img":[fUserDefaults objectForKey:@"headImg"],
                             @"loginName":[fUserDefaults objectForKey:@"userphone"],
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/updateHeadImg",MYURL] headStr:[FLTools getUserID] parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [weakSelf showSucessWihtStr:@"上传成功"];
            [fUserDefaults setObject:imgStr forKey:@"headImg"];
            [weakSelf.tableView reloadData];
        }
    } failure:^(id failure) {
        
    }];
}







//- (void)initData
//{
//    self.imgArr = @[@"youhuiquan",@"形状 13",@"jiangli",@"guanyu",@"tuandui"];
//    self.titleArr = @[@"优惠券",@"全部业绩",@"销售奖励",@"我的团队",@"关于我们"];
//}
//
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.tableFooterView = [self getFootView];
//        _tableView.tableHeaderView = [self getHeadView];
//    }
//    return _tableView;
//}
//
//- (UIView *)getFootView
//{
//    PersonalFootV *foot = [[[NSBundle mainBundle] loadNibNamed:@"PersonalFootV" owner:self options:nil] lastObject];
//    [foot.logOutBtn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    foot.frame = CGRectMake(0, 0, SCREEN_W, 60);
//    
//    return foot;
//}
//
//- (UIView *)getHeadView
//{
//    PersonHeadV *personH = [[[NSBundle mainBundle] loadNibNamed:@"PersonHeadV" owner:self options:nil] lastObject];
//    personH.frame = CGRectMake(0, 0, SCREEN_W, 160);
//    
//    personH.peronImg.userInteractionEnabled = YES;
//    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapCLick)];
//    [personH.peronImg addGestureRecognizer:imgTap];
//    self.personImg = personH.peronImg;
//    
//    [personH.EditBtn addTarget:self action:@selector(EditBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UITapGestureRecognizer *orderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap1)];
//    [personH.OrderView addGestureRecognizer:orderTap];
//    
//    UITapGestureRecognizer *orderTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap2)];
//    [personH.OrderView1 addGestureRecognizer:orderTap2];
//    
//    UITapGestureRecognizer *orderTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap3)];
//    [personH.OrderView2 addGestureRecognizer:orderTap3];
//    
//    return personH;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 5;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    cell.imageView.image = [UIImage imageNamed:self.imgArr[indexPath.section]];
//    cell.textLabel.text = self.titleArr[indexPath.section];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
//

//
//- (void)EditBtnClick
//{
//    DLog(@"000");
//    PersonInfoViewController *personInfoVC = [[PersonInfoViewController alloc] init];
//    [self.navigationController pushViewController:personInfoVC animated:YES];
//}
//
//- (void)orderTap1
//{
//    DLog(@"1111");
//}
//
//- (void)orderTap2
//{
//    DLog(@"2222");
//}
//
//- (void)orderTap3
//{
//    DLog(@"3333");
//}
//
//- (void)logOutBtnClick
//{
//    PWLoginViewController *pwLoginVC = [[PWLoginViewController alloc] init];
//    [self showAlertVCWithTitle:@"提示" withMessage:@"确定退出登录" withConfirm:^{
//        [self.navigationController pushViewController:pwLoginVC animated:YES];
//    } withCancel:^{
//        
//    } withViewController:self];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
