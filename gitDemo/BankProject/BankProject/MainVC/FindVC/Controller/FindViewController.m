//
//  FindViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "FindViewController.h"
#import "WebViewController.h"
#import "FindHeadView.h"
#import "SelectTypeView.h"
#import "FindModel.h"

@interface FindViewController ()

@property (nonatomic, strong) FindHeadView *findV;
@property (nonatomic, strong) FindModel *findM;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self getData];
}

- (void)getData
{
    WEAK_SELF;
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectCategory",MYURL] headStr:[FLTools getUserID] parameters:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            for (int i = 0; i < dataArr.count; i ++) {
                weakSelf.findM = [FindModel modelWithDictionary:dataArr[i]];
                [self.dataArr addObject:weakSelf.findM];
            }
        }
    } failure:^(id failure) {
        
    }];
}

- (void)initUI
{
    [self.view addSubview:self.findV];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + 180, SCREEN_W, 10)];
    lineV.backgroundColor = BACKCOLOR;
    [self.view addSubview:lineV];

    SelectTypeView *selectV = [[[NSBundle mainBundle] loadNibNamed:@"SelectTypeView" owner:self options:nil] lastObject];
    float seletH;
    float selevY;
    if (IS_IPHONEX) {
        seletH = SCREEN_H * 0.3;
        selevY = 80 + 190;
    }else{
        seletH = SCREEN_H * 0.45;
        selevY = 50 + 190;
    }
    selectV.frame = CGRectMake(0, selevY, self.view.frame.size.width, seletH);
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Click)];
    [selectV.bImgFirst addGestureRecognizer:tap1];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Click)];
    [selectV.bImgSecond addGestureRecognizer:tap2];

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Click)];
    [selectV.bImgThird addGestureRecognizer:tap3];

    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4Click)];
    [selectV.bImgFour addGestureRecognizer:tap4];
    [self.view addSubview:selectV];
}

- (FindHeadView *)findV
{
    if (!_findV) {
        _findV = [[FindHeadView alloc] initWithFrame:CGRectMake(10, 30, SCREEN_W - 20, 180)];
        __weak typeof(self) weakSelf = self;
        _findV.returnIndex = ^(int index) {
            DLog(@"--- %d",index);
            if (index == 2) {
//                WebViewController *webV = [[WebViewController alloc] init];
//                webV.webUrlStr = @"https://weibo.com/2677270411/E3bcCx5kb?type=comment#_rnd1563859422459";
//                webV.titleStr = @"企业实力";
//                [weakSelf.navigationController pushViewController:webV animated:YES];
            }
        };
        _findV.alertStrBlock = ^(NSString * _Nullable alertStr) {
            [weakSelf.view endEditing:YES];
            [weakSelf onlyShowConfirmVCWithTitle:@"查询结果" withMessage:alertStr withConfirm:^{
                
            } withViewController:weakSelf];
        };
        _findV.backgroundColor = [UIColor whiteColor];
    }
    return _findV;
}


- (void)tap1Click
{
    WebViewController *webV = [[WebViewController alloc] init];
//    webV.webUrlStr = @"https://weibo.com/2677270411/E3bcCx5kb?type=comment#_rnd1563859422459";
    webV.titleStr = @"质量保障";
    self.findM = self.dataArr[0];
    webV.detailIDStr = @"5";
    [self.navigationController pushViewController:webV animated:YES];
}

- (void)tap2Click
{
    WebViewController *webV = [[WebViewController alloc] init];
//    webV.webUrlStr = @"https://weibo.com/2677270411/E3bcCx5kb?type=comment#_rnd1563859422459";
    webV.titleStr = @"实体招商";
//    self.findM = self.dataArr[1];
    webV.detailIDStr = @"6";
    [self.navigationController pushViewController:webV animated:YES];
}

- (void)tap3Click
{
    WebViewController *webV = [[WebViewController alloc] init];
//    webV.webUrlStr = @"https://weibo.com/2677270411/E3bcCx5kb?type=comment#_rnd1563859422459";
    webV.titleStr = @"代理加盟";
//    self.findM = self.dataArr[2];
    webV.detailIDStr = @"7";
    [self.navigationController pushViewController:webV animated:YES];
}

- (void)tap4Click
{
    WebViewController *webV = [[WebViewController alloc] init];
//    webV.webUrlStr = @"https://weibo.com/2677270411/E3bcCx5kb?type=comment#_rnd1563859422459";
//    self.findM = self.dataArr[3];
    webV.detailIDStr = @"8";
    webV.titleStr = @"企业文化";
    [self.navigationController pushViewController:webV animated:YES];
}







//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 180 + Nav_Height + 30, SCREEN_W - 20, 270) style:UITableViewStylePlain];
//        _tableView.rowHeight = 90;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.layer.masksToBounds = YES;
//        _tableView.layer.cornerRadius = 5;
//        _tableView.layer.borderWidth = 0.5;
//        _tableView.layer.borderColor = [UIColor grayColor].CGColor;
//    }
//    return _tableView;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"cell";
//    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"FindTableViewCell" owner:self options:nil] lastObject];
//    }
//    return cell;
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
