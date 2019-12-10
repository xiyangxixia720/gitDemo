//
//  GoodsViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsCollectionViewCell.h"
#import "GoodsDetailViewController.h"
#import "GoodsModel.h"

static NSString * const GoodsID = @"GoodsID";

@interface GoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

{
    int loadPage;
    BOOL isCompletion;
    int nowLoad;
}

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *myLayout;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) GoodsModel *goodM;


@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品";
    
//    }else{
//        PWLoginViewController *loginVC = [[PWLoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
}

- (void)getGoodsDate:(int)pageCount
{
    if (nowLoad == pageCount) {
        return;
    }
    nowLoad = pageCount;
    int pageNum = LOADNUM;
    NSString *userIDStr = @"";
    if ([FLTools isLogin]) {
        userIDStr = [FLTools getUserID];
    }
    NSDictionary *send_d = @{@"userid":userIDStr,
                             @"page":[NSString stringWithFormat:@"%d",pageCount],
                             @"rows":[NSString stringWithFormat:@"%d",pageNum],
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectShops",MYURL] headStr:nil parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            if (dataArr.count == 0) {
                return;
            }
            if (self->isCompletion == YES && dataArr.count < pageNum) {
                [self.myCollectionView reloadData];
                return;
            }
            if (dataArr.count < pageNum) {
                self->isCompletion = YES;
            }else{
                self->loadPage ++;
            }
            for (int i = 0; i < dataArr.count; i ++) {
                self.goodM = [GoodsModel modelWithDictionary:dataArr[i]];
                [self.goodsArr addObject:self.goodM];
            }
            [self.myCollectionView reloadData];
        }
    } failure:^(id failure) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.goodsArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:self.myCollectionView];
    nowLoad = -1;
    loadPage = 1;
    isCompletion = NO;
    [self getGoodsDate:1];
}

#pragma mark --- uicollectionView ---
- (UICollectionView *)myCollectionView
{
    if (!_myCollectionView) {
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - Nav_Height) collectionViewLayout:self.myLayout];
        _myCollectionView.backgroundColor = BACKCOLOR;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.emptyDataSetSource = self;
        _myCollectionView.emptyDataSetDelegate = self;
        [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:GoodsID];
        _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headLoad)];
//        _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footLoad)];
        __weak typeof(self) weakSelf = self;

        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.myCollectionView.mj_footer endRefreshing];
            [weakSelf getGoodsDate:self->loadPage];
        }];
    }
    return _myCollectionView;
}

- (UICollectionViewFlowLayout *)myLayout
{
    if (!_myLayout) {
        _myLayout = [[UICollectionViewFlowLayout alloc] init];
        _myLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        float itemH = IS_IPHONEX ? SCREEN_H/3:SCREEN_H/2.5;
        _myLayout.itemSize = CGSizeMake((SCREEN_W - 35)/2, itemH);
        // 设置列的最小间距
        _myLayout.minimumInteritemSpacing = 10;
        // 设置最小行间距
        _myLayout.minimumLineSpacing = 15;
    }
    return _myLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsID forIndexPath:indexPath];
    self.goodM = self.goodsArr[indexPath.item];
    [cell.GoodImg sd_setImageWithURL:[NSURL URLWithString:self.goodM.shop_img] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    cell.GoodPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.goodM.real_price];
    
    
    NSString *oldStr = [NSString stringWithFormat:@"￥%@",self.goodM.sell_price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
    
    
    cell.GoodOldPriceLabel.attributedText = attribtStr;
    cell.GoodTitleLabel.text = self.goodM.shop_name;
    cell.GoodCountLabel.text = [NSString stringWithFormat:@"%@件",self.goodM.shop_stock];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.goodM = self.goodsArr[indexPath.item];
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] init];
    goodsDetailVC.goodDetailIDStr = self.goodM.goodsID;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark --- clickMethed ---
- (void)headLoad
{
    [self.goodsArr removeAllObjects];
    nowLoad = -1;
    loadPage = 1;
    isCompletion = NO;
    [self getGoodsDate:1];
    [self.myCollectionView.mj_header endRefreshing];
}

- (void)footLoad
{
    [self.myCollectionView.mj_footer endRefreshing];
}

#pragma mark --- noData ---
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"noData"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
//    if ([FLTools isLogin]) {
        [self getGoodsDate:1];
//    }else{
//        PWLoginViewController *loginVC = [[PWLoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
}


- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"网络不给力，请点击重试哦~";
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置所有字体大小为 #15
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:15.0]
                   range:NSMakeRange(0, text.length)];
    // 设置所有字体颜色为浅灰色
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor lightGrayColor]
                   range:NSMakeRange(0, text.length)];
    // 设置指定4个字体为蓝色//007EE5
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor colorWithHexString:@"#007EE5"]
                   range:NSMakeRange(7, 4)];
    return attStr;
}

@end
