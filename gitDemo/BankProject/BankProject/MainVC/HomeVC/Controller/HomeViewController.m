//
//  HomeViewController.m
//  BankProject
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "ZFJRollView.h"
#import "HomeShopModel.h"
#import "HomeBrandModel.h"
#import "HomeCompanyModel.h"
#import "HomeVideoModel.h"
#import "HomeShufflingModel.h"
#import "HomeTView.h"
#import "BoutiqueV.h"
#import "WebViewController.h"
#import "GoodsDetailViewController.h"
#import "DCCycleScrollView.h"
#import "NewListVC.h"
#import "WLCircleProgressView.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,ZFJRollViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,DCCycleScrollViewDelegate>


{
    BOOL isShowAll;
    BOOL  ISHorizontalScreen;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *shopArr;
@property (nonatomic, strong) HomeShopModel *shopModel;

@property (nonatomic, strong) NSMutableArray *brandArr;
@property (nonatomic, strong) HomeBrandModel *brandModel;

@property (nonatomic, strong) HomeCompanyModel *companyModel;
@property (nonatomic, strong) HomeVideoModel *videoModel;

@property (nonatomic, strong) NSMutableArray *shuffArr;
@property (nonatomic, strong) HomeShufflingModel *shufModel;
@property(nonatomic,strong)LXAVPlayView *playerview;
@property(nonatomic,strong)UIView *playFatherView;

@property (nonatomic, strong) UIView *scrollBView;
@property (nonatomic, strong) UIImageView *videoImg;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *downLoadVBtn;

@property (nonatomic, strong) UILabel *downLoadVideoTipLabel;

@property (nonatomic, strong) WLCircleProgressView *hprogressView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"可优云商";
    [self initData];
    [self getScrollViewData];

    
    [self.view addSubview:self.tableView];
    
}

- (void)initBackImg
{
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyebg"]];
    backImg.frame = CGRectMake(0, 0, SCREEN_W, 132);
    [self.view addSubview:backImg];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (_playFatherView) {
        [self.playFatherView removeFromSuperview];
        self.playFatherView = nil;
        [self.playerview destroyPlayer];
        self.playBtn.alpha = 1;
        ISHorizontalScreen = NO;
    }
}

- (void)initData
{
    self.shopArr  = [[NSMutableArray alloc] initWithCapacity:0];
    self.brandArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.shuffArr = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)getScrollViewData
{
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectHomeData",MYURL] headStr:nil parameters:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSDictionary *infoDict = [responseObject objectForKey:@"data"];
            NSArray *shopArr = [infoDict objectForKey:@"shoplist"];
            for (int i = 0; i < shopArr.count; i ++) {
                self.shopModel = [HomeShopModel modelWithDictionary:shopArr[i]];
                [self.shopArr addObject:self.shopModel];
            }
            
            NSArray *brandArr = [infoDict objectForKey:@"brand"];
            for (int j = 0; j < brandArr.count; j ++) {
                self.brandModel = [HomeBrandModel modelWithDictionary:brandArr[j]];
                [self.brandArr addObject:self.brandModel];
            }
            
            self.companyModel = [HomeCompanyModel modelWithDictionary:[infoDict objectForKey:@"company"]];
            self.videoModel = [HomeVideoModel modelWithDictionary:[infoDict objectForKey:@"video"]];
            
            NSArray *shufArr = [infoDict objectForKey:@"shuffling"];
            for (int m = 0; m < shufArr.count; m ++) {
                self.shufModel = [HomeShufflingModel modelWithDictionary:shufArr[m]];
                [self.shuffArr addObject:self.shufModel];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(id failure) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - Nav_Height - kTabBarHeight - HomeIndicator) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headLoad)];
    }
    _tableView.tableHeaderView = [self getHead];
    if (!isShowAll) {
//        _tableView.tableFooterView = [self getFoot];
    }else{
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

//- (ZQPlayerMaskView *)playerMaskView
//{
//    if (!_playerMaskView) {
//        _playerMaskView = [[ZQPlayerMaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 170)];
//        _playerMaskView.delegate = self;
//        _playerMaskView.isWiFi = YES; // 是否允许自动加载，
//        // 网络视频
//        NSString *videoUrl = @"http://183.60.197.29/17/q/t/v/w/qtvwspkejwgqjqeywjfowzdjcjvjzs/hc.yinyuetai.com/A0780162B98038FBED45554E85720E53.mp4?sc=e9bad1bb86f52b6f&br=781&vid=3192743&aid=38959&area=KR&vst=2&ptp=mv&rd=yinyuetai.com";
//        [_playerMaskView playWithVideoUrl:videoUrl];
//        _playerMaskView.backgroundImage.image = [self thumbnailImageForVideo:[NSURL URLWithString:videoUrl] atTime:5];
//        //    _playerMaskView.backgroundImage.image = [UIImage imageNamed:@"img222"];
//        _playerMaskView.backgroundImage.frame = CGRectMake(0, 0, SCREEN_W - 20, 170);
//    }
//    _playerMaskView.bottomView.alpha = 0;
//    _playerMaskView.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 170);
//    return _playerMaskView;
//}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        _playBtn.frame = CGRectMake(SCREEN_W - 80, 155, 30, 30);
        [_playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)getFoot
{
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    FLButton *flBtn = [FLButton buttonWithType:UIButtonTypeCustom];
    flBtn.frame = CGRectMake(0, 0, SCREEN_W, 50);
    [flBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [flBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    flBtn.titleLabel.font = [UIFont systemFontOfSize:14];;
    [flBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    flBtn.titleRect = CGRectMake(SCREEN_W/2 - 35, 15, 70, 20);
    flBtn.imageRect = CGRectMake(SCREEN_W/2 + 35, 22, 10, 6);
    [flBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:flBtn];
    return footV;
}

- (UIView *)getHead
{
    if (self.shopArr.count == 0) {
        return [[UIView alloc] init];
    }
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1040)];
    
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyebg"]];
    backImg.frame = CGRectMake(0, 0, SCREEN_W, 132);
    [headV addSubview:backImg];
    
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.shuffArr.count; i ++) {
        self.shufModel = self.shuffArr[i];
        [imgArr addObject:self.shufModel.img];
    }
//    NSArray *imgArr = @[@"http://img3.imgtn.bdimg.com/it/u=3742824195,1198412488&fm=26&gp=0.jpg",@"http://img0.imgtn.bdimg.com/it/u=3614016355,114048003&fm=214&gp=0.jpg",@"http://img5.imgtn.bdimg.com/it/u=2655160983,321524852&fm=26&gp=0.jpg"];
    SDCycleScrollView *cycleScrollV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 10,  SCREEN_W - 20, 160)  delegate:self placeholderImage:[UIImage imageNamed:@"img222"]];
    cycleScrollV.autoScrollTimeInterval = 5;
    cycleScrollV.layer.masksToBounds = YES;
    cycleScrollV.layer.cornerRadius = 2;
    cycleScrollV.showPageControl = YES;
    cycleScrollV.titleLabelTextAlignment = NSTextAlignmentRight;
    cycleScrollV.titleLabelBackgroundColor = [UIColor clearColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollV.imageURLStringsGroup = imgArr;
    });
    [headV addSubview:cycleScrollV];
    
    HomeTView *homeTitleV = [[[NSBundle mainBundle] loadNibNamed:@"HomeTView" owner:self options:nil] lastObject];
    homeTitleV.titleLabel.text = @"甄选优品";
    [homeTitleV.moreBtn addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapfirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstBtnClick)];
    [homeTitleV.jianTouImg addGestureRecognizer:tapfirst];
    [homeTitleV.jianTouImg setUserInteractionEnabled:YES];
    homeTitleV.frame =CGRectMake(0, 170, SCREEN_W, 60);
    [headV addSubview:homeTitleV];
    
    BoutiqueV *boutiqueV = [[[NSBundle mainBundle] loadNibNamed:@"BoutiqueV" owner:self options:nil] lastObject];
    boutiqueV.frame = CGRectMake(10, 220, SCREEN_W - 20, 230);
    for (int y = 0; y < self.shopArr.count; y ++) {
        self.shopModel = self.shopArr[y];
        if (y == 0) {
            [boutiqueV.img1 sd_setImageWithURL:[NSURL URLWithString:self.shopModel.homeImg] placeholderImage:[UIImage imageNamed:@"img222"]];
        }else if (y == 1){
            [boutiqueV.img2 sd_setImageWithURL:[NSURL URLWithString:self.shopModel.homeImg] placeholderImage:[UIImage imageNamed:@"img222"]];
        }else{
            [boutiqueV.img3 sd_setImageWithURL:[NSURL URLWithString:self.shopModel.homeImg] placeholderImage:[UIImage imageNamed:@"img222"]];
        }
    }
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Click)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Click)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Click)];

    [boutiqueV.backFirst addGestureRecognizer:tap1];
    [boutiqueV.backSecond addGestureRecognizer:tap2];
    [boutiqueV.backThird addGestureRecognizer:tap3];

    [headV addSubview:boutiqueV];
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 450, SCREEN_W, 10)];
    lineV1.backgroundColor = BACKCOLOR;
    [headV addSubview:lineV1];
    
    HomeTView *homeTitleV1 = [[[NSBundle mainBundle] loadNibNamed:@"HomeTView" owner:self options:nil] lastObject];
    homeTitleV1.titleLabel.text = @"精彩视频";
    [homeTitleV1.moreBtn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapsecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondBtnClick)];
    [homeTitleV1.jianTouImg addGestureRecognizer:tapsecond];
    [homeTitleV1.jianTouImg setUserInteractionEnabled:YES];
    homeTitleV1.frame =CGRectMake(0, 460, SCREEN_W, 60);
    [headV addSubview:homeTitleV1];
    
    UIView *scrollBView = [[UIView alloc] initWithFrame:CGRectMake(10, 520, SCREEN_W - 20, 230)];
    scrollBView.layer.shadowOffset = CGSizeMake(1, 1);
    scrollBView.layer.shadowRadius = 5.0;
    scrollBView.layer.shadowColor = MainTonal.CGColor;
    scrollBView.layer.shadowOpacity = 0.5;
    scrollBView.backgroundColor = [UIColor whiteColor];
    self.scrollBView = scrollBView;
    [headV addSubview:scrollBView];
    
    UIImageView *videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W - 20, 170)];
    [videoImg sd_setImageWithURL:[NSURL URLWithString:self.videoModel.videoImg] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    self.videoImg = videoImg;
    videoImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBtnClick)];
    [videoImg addGestureRecognizer:tapp];
    [scrollBView addSubview:videoImg];
    
//    UIButton *boFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];bofang
//    [scrollBView addSubview:self.playBtn];
    [scrollBView addSubview:self.playBtn];
    
    UILabel *videoInfoLabel = [[UILabel alloc] init];
    videoInfoLabel.font = [UIFont systemFontOfSize:15];
    videoInfoLabel.text = self.videoModel.title;
    videoInfoLabel.frame = CGRectMake(6, 176, SCREEN_W - 32, 40);
    videoInfoLabel.numberOfLines = 2;
    [scrollBView addSubview:videoInfoLabel];
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 770, SCREEN_W, 10)];
    lineV2.backgroundColor = BACKCOLOR;
    [headV addSubview:lineV2];
    
    HomeTView *homeTitleV2 = [[[NSBundle mainBundle] loadNibNamed:@"HomeTView" owner:self options:nil] lastObject];
    homeTitleV2.frame = CGRectMake(0, 780, SCREEN_W, 60);
    homeTitleV2.titleLabel.text = @"企业实力";
    homeTitleV2.jianTouImg.alpha = 0;
    homeTitleV2.moreBtn.alpha = 0;
    [headV addSubview:homeTitleV2];
    
    
//    ZFJRollView *rollView = [[ZFJRollView alloc] initWithFrame:CGRectMake(0, 840, SCREEN_W, 150) withDistanceForScroll:30 withGap:0];
//    rollView.delegate = self;
//    NSArray *companyArr = [self.companyModel.shuffling componentsSeparatedByString:@","];
//    [rollView rollView:@[@"gerenbg",@"gerenbg"]];
//    [headV addSubview:rollView];
    
//    NSArray *imageArr = @[@"http://photocdn.sohu.com/20120808/Img350129585.jpg",
//                          @"http://photocdn.sohu.com/20120808/Img350129585.jpg",
//                          @"http://photocdn.sohu.com/20120808/Img350129585.jpg",
//                          @"http://photocdn.sohu.com/20120808/Img350129585.jpg",
//                          ];
    NSMutableArray *imageArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (imageArr.count == 0) {
        [imageArr addObjectsFromArray:[self.companyModel.shuffling componentsSeparatedByString:@","]];
        [imageArr removeLastObject];
    }
    DCCycleScrollView *banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 840, SCREEN_W, 130) shouldInfiniteLoop:YES imageGroups:imageArr];
    banner.autoScrollTimeInterval = 5;
    banner.autoScroll = YES;
    banner.isZoom = YES;
    banner.itemSpace = 0;
    banner.imgCornerRadius = 10;
    banner.itemWidth = self.view.frame.size.width - 100;
    banner.delegate = self;
    [headV addSubview:banner];

    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0, 980, SCREEN_W, 10)];
    lineV3.backgroundColor = BACKCOLOR;
    [headV addSubview:lineV3];
    
    HomeTView *homeTitleV3 = [[[NSBundle mainBundle] loadNibNamed:@"HomeTView" owner:self options:nil] lastObject];
    homeTitleV3.frame = CGRectMake(0, 990, SCREEN_W, 60);
    homeTitleV3.titleLabel.text = @"品牌动态";
    [homeTitleV3.moreBtn addTarget:self action:@selector(jianTitleBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    homeTitleV3.jianTouImg.alpha = 0;
//    homeTitleV3.moreBtn.alpha = 0;
    UITapGestureRecognizer *tapthird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jianTitleBtnClick)];
    [homeTitleV3.jianTouImg addGestureRecognizer:tapthird];
    [homeTitleV3.jianTouImg setUserInteractionEnabled:YES];
    [headV addSubview:homeTitleV3];
    
    UIView *lineV4 = [[UIView alloc] initWithFrame:CGRectMake(0, 1049, SCREEN_W, 0.5)];
    lineV4.backgroundColor = BACKCOLOR;
    [headV addSubview:lineV4];
    
    return headV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (isShowAll) {
//        return self.brandArr.count;
//    }else{
//        if (self.brandArr.count < 5) {
//            return self.brandArr.count;
//        }else{
//            return 5;
//        }
//    }
    if (self.brandArr.count < 5) {
        return self.brandArr.count;
    }else{
        return 5;
    }
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

#pragma mark --- customDelegate ---


- (void)didSelectPicWithIndexPath:(NSInteger)index
{
    WebViewController *webV = [[WebViewController alloc] init];
    webV.detailIDStr = self.companyModel.companyID;
    [self.navigationController pushViewController:webV animated:YES];
}

#pragma mark --- btnClickMethed ---
- (void)firstBtnClick
{
    self.tabBarController.selectedIndex = 3;
}

- (void)secondBtnClick
{
    self.tabBarController.selectedIndex = 2;
}

- (void)tap1Click
{
    if (self.shopArr.count == 0) {
        return;
    }
    self.shopModel = self.shopArr[0];
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] init];
    goodsDetailVC.goodDetailIDStr = self.shopModel.shopID;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    DLog(@"---%@",self.shopModel.shopID);
}

- (void)tap2Click
{
    if (self.shopArr.count <2) {
        return;
    }
    self.shopModel = self.shopArr[1];
    DLog(@"---%@",self.shopModel.shopID);
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] init];
    goodsDetailVC.goodDetailIDStr = self.shopModel.shopID;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (void)tap3Click
{
    if (self.shopArr.count < 3) {
        return;
    }
    self.shopModel = self.shopArr[2];
    DLog(@"---%@",self.shopModel.shopID);
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] init];
    goodsDetailVC.goodDetailIDStr = self.shopModel.shopID;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (void)moreBtnClick
{
//    isShowAll = YES;
//    [self.tableView reloadData];
}

- (void)jianTitleBtnClick
{
    NewListVC *moreVC = [[NewListVC alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)playVideo
{
    CGRect rect = CGRectMake(0, 0,  SCREEN_W - 20, 170);
    self.playFatherView = [[UIView alloc] initWithFrame:rect];
    [self.scrollBView addSubview:self.playFatherView];
    
    
    LXPlayModel *model =[[LXPlayModel alloc]init];
    model.playUrl = self.videoModel.video;
//    model.playUrl = @"http://183.60.197.29/17/q/t/v/w/qtvwspkejwgqjqeywjfowzdjcjvjzs/hc.yinyuetai.com/A0780162B98038FBED45554E85720E53.mp4?sc=e9bad1bb86f52b6f&br=781&vid=3192743&aid=38959&area=KR&vst=2&ptp=mv&rd=yinyuetai.com";
    model.videoTitle = @"";
    model.fatherView = self.playFatherView;
    self.playerview =[[LXAVPlayView alloc]init];
    self.playerview.isLandScape = NO;
    self.playerview.isAutoReplay = YES;
    self.playerview.currentModel = model;
    
    LXWS(weakSelf);
    self.playerview.backBlock = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    UIButton *closeVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeVideoBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    self.closeBtn = closeVideoBtn;
    [closeVideoBtn addTarget:self action:@selector(closeVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeVideoBtn.frame = CGRectMake(SCREEN_W - 70, 0, 35, 35);
    [self.playerview addSubview:closeVideoBtn];
    
    UIButton *downLoadVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downLoadVideoBtn setImage:[UIImage imageNamed:@"downlode"] forState:UIControlStateNormal];
    self.downLoadVBtn = downLoadVideoBtn;
    [downLoadVideoBtn addTarget:self action:@selector(downLoadVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    downLoadVideoBtn.frame = CGRectMake(10, 70, 50, 50);
    downLoadVideoBtn.alpha = 0;
    [self.playerview addSubview:downLoadVideoBtn];
    
    [self.scrollBView addSubview:self.playBtn];
    
}

-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld",index);
    WebViewController *webV = [[WebViewController alloc] init];
    webV.title = @"企业实力";
    webV.detailIDStr = self.companyModel.companyID;
    [self.navigationController pushViewController:webV animated:YES];
}

#pragma mark - 屏幕旋转
-(BOOL)shouldAutorotate
{
    DLog(@"---- %d",ISHorizontalScreen);
    if (self.closeBtn == nil) {
        return NO;
    }
    if (ISHorizontalScreen == NO) {
        self.closeBtn.alpha = 0;
        self.downLoadVBtn.alpha = 1;
        self.downLoadVBtn.frame = CGRectMake(SCREEN_H - 60, SCREEN_W / 2, 35, 35);
        ISHorizontalScreen = YES;
    }else{
        self.downLoadVBtn.frame = CGRectMake(SCREEN_W - 160, 10, 35, 35);
        [self.hprogressView removeFromSuperview];
        self.hprogressView = nil;
        self.closeBtn.alpha = 1;
        ISHorizontalScreen = NO;
    }
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault; // your own style
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"UIViewController will rotate to Orientation: %ld", toInterfaceOrientation);
    
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)){//横屏
        NSLog(@"横屏");
        self.closeBtn.alpha = 0;
        self.downLoadVBtn.alpha = 1;
        self.downLoadVBtn.frame = CGRectMake(SCREEN_H - 60, SCREEN_W / 2, 35, 35);
    }else{//竖屏
        NSLog(@"竖屏");
        self.closeBtn.alpha = 1;
    }
}

- (void)closeVideoBtnClick
{
    ISHorizontalScreen = YES;
    self.playBtn.alpha = 1;
    [self.playFatherView removeFromSuperview];
    self.playFatherView = nil;
    [self.playerview destroyPlayer];
}

- (void)headLoad
{
    [self.brandArr removeAllObjects];
    [self.shopArr removeAllObjects];
    [self.shuffArr removeAllObjects];

    [self getScrollViewData];
    
    if (_playFatherView) {
        [self.playFatherView removeFromSuperview];
        self.playFatherView = nil;
        [self.playerview destroyPlayer];
//        self.playBtn.alpha = 1;
//        ISHorizontalScreen = NO;
        
        self.playBtn.alpha = 1;
        ISHorizontalScreen = NO;
    }
}

- (void)playBtnClick
{
    self.playBtn.alpha = 0;
    [self playVideo];
}

#pragma mark --- noData ---
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"noData"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    // button clicked...
//    nowLoad = -1;
    [self getScrollViewData];
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

- (void)downLoadVideoBtnClick
{
    
    [self.playerview addSubview:self.downLoadVideoTipLabel];
    
    [self performSelector:@selector(afterLoadDellocMethod) withObject:nil afterDelay:1];
    
    WLCircleProgressView *circleProgress1 = [WLCircleProgressView viewWithFrame:CGRectMake(SCREEN_W/2 - 25, SCREEN_H/2 - 25, 50, 50) circlesSize:CGRectMake(20, 5, 20, 5)];
    circleProgress1.layer.cornerRadius = 10;
    circleProgress1.progressValue = 0;
    self.hprogressView = circleProgress1;
    [self.playerview addSubview:circleProgress1];
    
    LXPlayModel *model =[[LXPlayModel alloc]init];
//    model.playUrl = self.bVideoM.video;
    NSString *url = model.playUrl;
//    NSString *url = @"http://183.60.197.29/17/q/t/v/w/qtvwspkejwgqjqeywjfowzdjcjvjzs/hc.yinyuetai.com/A0780162B98038FBED45554E85720E53.mp4?sc=e9bad1bb86f52b6f&br=781&vid=3192743&aid=38959&area=KR&vst=2&ptp=mv&rd=yinyuetai.com";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"jaibaili.mp4"];
    
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    WEAK_SELF;
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                float count = 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
                                [weakSelf downloadProgress:count];
                            } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                                
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       NSLog(@"%@",response);
                       
                       [weakSelf saveVideo:fullPath];
                   }];
    [task resume];
    
}

- (void)afterLoadDellocMethod
{
    [self.downLoadVideoTipLabel removeFromSuperview];
    self.downLoadVideoTipLabel = nil;
}

- (void)downloadProgress:(float)value
{
    DLog(@"----%f",value);
    float newValue;
    if (value > 0 && value < 0.1) {
        newValue = 0.1;
    }else if (value > 0.2 && value < 0.3){
        newValue = 0.3;
    }else if (value > 0.3 && value < 0.4){
        newValue = 0.3;
    }else if (value > 0.4 && value < 0.5){
        newValue = 0.3;
    }else if (value > 0.5 && value < 0.6){
        newValue = 0.6;
    }else if (value > 0.6 && value < 0.9){
        newValue = 0.8;
    }else{
        newValue = 1.0;
    }
    
    self.hprogressView.progressValue = newValue;
}

- (UILabel *)downLoadVideoTipLabel
{
    if (!_downLoadVideoTipLabel) {
        _downLoadVideoTipLabel = [[UILabel alloc] init];
        _downLoadVideoTipLabel.text = @"正在下载";
        _downLoadVideoTipLabel.frame = CGRectMake(SCREEN_W/2 - 100, SCREEN_H / 2, 200, 20);
        _downLoadVideoTipLabel.textColor = [UIColor whiteColor];
        _downLoadVideoTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _downLoadVideoTipLabel;
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        
        NSURL *url = [NSURL URLWithString:videoPath];
        
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        
        if (compatible)
        {
            
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (self.hprogressView) {
        [self.hprogressView removeFromSuperview];
        self.hprogressView = nil;
    }
    if (error) {
        
        NSLog(@"保存视频失败%@", error.localizedDescription);
        [self.playerview addSubview:self.downLoadVideoTipLabel];
        self.downLoadVideoTipLabel.text = @"视频保存失败";
        [self performSelector:@selector(afterLoadDellocMethod) withObject:nil afterDelay:1];
    }else {
        [self.playerview addSubview:self.downLoadVideoTipLabel];
        self.downLoadVideoTipLabel.text = @"视频保存成功";
        [self performSelector:@selector(afterLoadDellocMethod) withObject:nil afterDelay:1];
    }
}


@end
