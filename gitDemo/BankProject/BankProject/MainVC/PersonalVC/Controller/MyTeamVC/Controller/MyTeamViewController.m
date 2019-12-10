//
//  MyTeamViewController.m
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import "MyTeamViewController.h"
#import "MyTeamTableViewCell.h"
#import "TeamModel.h"

@interface MyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TeamModel   *tModel;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的团队";

    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:self.tableView];
    [self getData];
}

- (void)getData
{
    NSDictionary *send_d = @{@"code":[fUserDefaults objectForKey:@"code"],
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/selectUsersByPid",MYURL] headStr:nil parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *dataA = [responseObject objectForKey:@"data"];
            for (int i = 0; i < dataA.count; i ++) {
                self.tModel = [TeamModel modelWithDictionary:dataA[i]];
                [self.dataArr addObject:self.tModel];
            }
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
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    MyTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTeamTableViewCell" owner:self options:nil] lastObject];
    }
    self.tModel = self.dataArr[indexPath.row];
    [cell.titleImg sd_setImageWithURL:[NSURL URLWithString:self.tModel.headImg] placeholderImage:[UIImage imageNamed:@"tuanduitouxiang"]];
    cell.nameLabel.text = self.tModel.realname;
    cell.IDLabel.text = self.tModel.code;
    cell.timeLabel.text = self.tModel.ctime;
    return cell;
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
