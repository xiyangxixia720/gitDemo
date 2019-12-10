//
//  BusinessSchoolViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BusinessSchoolViewController.h"
#import "BusinessTableViewCell.h"
#import "BusTitleView.h"
#import "BusSelectView.h"
#import "BusinessVideoModel.h"
#import "BusinessContentModel.h"
#import "WebViewController.h"
#import "WLCircleProgressView.h"




@interface BusinessSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,BusSelectViewDelegate>

{
    int loadPage;
    BOOL isCompletion;
    int nowLoad;
    
    int selectedType;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imgArr;

@property (nonatomic, strong) BusinessVideoModel *bVideoM;
@property (nonatomic, strong) NSMutableArray *videoArr;
@property (nonatomic, strong) BusinessContentModel *bContentM;
@property (nonatomic, strong) NSMutableArray *contentArr;

@property(nonatomic,strong)LXAVPlayView *playerview;
@property(nonatomic,strong)UIView *playFatherView;
@property (nonatomic, strong) WLCircleProgressView *progressView1;


@property (nonatomic, strong) UIView *scrollBView;

@property (nonatomic, strong) NSMutableArray *videoTitleArr;

@property (nonatomic, strong) UILabel *videoInfoLabel;

@property (nonatomic, strong) UIButton *closeVideoBtn;
@property (nonatomic, strong) UIButton *downLoadVideoBtn;
@end

@implementation BusinessSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"商学院";
    self.videoArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.contentArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.imgArr = @[@"http://www.t-chs.com/tuhsJDEwLmFsaWNkbi5jb20vaTIvNjc4MDAyOTAvVDJPS3g1WGZoYiQ2JDZfISE2NzgwMDI5MCQ5.jpg",
                    @"http://img005.hc360.cn/y1/M05/F7/AC/wKhQc1StX7CEZ8yjAAAAALhYqIA302.jpg",
                    @"http://img2.99114.com/group1/M00/85/CB/wKgGTFlB_8SADFRMAAV8RTxRB6A099.png",
                    @"http://www.t-biao.com/tubiaoJDEwLmFsaWNkbi5jb20vdGZzY29tL2k0LzI5ODUyNTc2NTYvVEIyeW5EZmJrR2oxMUpqU1pGTVhYWG5SVlhhXyEhMjk4NTI1NzY1NiQ5.jpg",
                    @"http://img5.imgtn.bdimg.com/it/u=1373639754,603726077&fm=26&gp=0.jpg",
                    @"http://bpic.588ku.com/element_origin_min_pic/17/08/16/33327d0b15cedeba21707b1314a8dd00.jpg",
                    @"http://img3.99114.com/group10/M00/67/98/rBADs1n-uICAaXGIAAJK9Jsnyso827.jpg",
                    @"http://www.t-chs.com/tuhsJDEwLmFsaWNkbi5jb20vaTIvNjc4MDAyOTAvVDJPS3g1WGZoYiQ2JDZfISE2NzgwMDI5MCQ5.jpg",
                    @"http://img005.hc360.cn/y1/M05/F7/AC/wKhQc1StX7CEZ8yjAAAAALhYqIA302.jpg",
                    @"http://img2.99114.com/group1/M00/85/CB/wKgGTFlB_8SADFRMAAV8RTxRB6A099.png",
                    @"http://www.t-biao.com/tubiaoJDEwLmFsaWNkbi5jb20vdGZzY29tL2k0LzI5ODUyNTc2NTYvVEIyeW5EZmJrR2oxMUpqU1pGTVhYWG5SVlhhXyEhMjk4NTI1NzY1NiQ5.jpg",
                    @"http://img5.imgtn.bdimg.com/it/u=1373639754,603726077&fm=26&gp=0.jpg",
                    @"http://bpic.588ku.com/element_origin_min_pic/17/08/16/33327d0b15cedeba21707b1314a8dd00.jpg",
                    @"http://img3.99114.com/group10/M00/67/98/rBADs1n-uICAaXGIAAJK9Jsnyso827.jpg"];
    
    nowLoad = -1;
    selectedType = 2;
    [self getDataWithType:selectedType withPage:1];
    [self.view addSubview:self.tableView];
    [self initHeadV];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)getDataWithType:(int)typeInt withPage:(int)pageCount
{
    if (nowLoad == pageCount) {
        return;
    }
    nowLoad = pageCount;
    int pageNum = LOADNUM;
    NSDictionary *send_d = @{@"page":[NSString stringWithFormat:@"%d",pageCount],
                             @"rows":[NSString stringWithFormat:@"%d",pageNum],
                             @"type":[NSString stringWithFormat:@"%d",typeInt],
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectSchoolBussiness",MYURL] headStr:nil parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200){
            NSArray *videoArr = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
            NSArray *contentArr = [[responseObject objectForKey:@"data"] objectForKey:@"content"];
            if (contentArr.count == 0) {
                return;
            }
            if (self->isCompletion == YES && contentArr.count < pageNum) {
                [self.tableView reloadData];
                return;
            }
            if (contentArr.count < pageNum) {
                self->isCompletion = YES;
            }else{
                self->loadPage ++;
            }
            for (int i = 0; i < videoArr.count; i ++) {
                self.bVideoM = [BusinessVideoModel modelWithDictionary:videoArr[i]];
                [self.videoArr addObject:self.bVideoM];
            }
            for (int j = 0; j < contentArr.count; j ++) {
                self.bContentM = [BusinessContentModel modelWithDictionary:contentArr[j]];
                [self.contentArr addObject:self.bContentM];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        }else{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(id failure) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)initHeadV
{
    BusSelectView *busV = [[BusSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    busV.delegate = self;
    [self.view addSubview:busV];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_W, SCREEN_H - Nav_Height - HomeIndicator - kTabBarHeight - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 115;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headLoad)];
        __weak typeof(self) weakSelf = self;
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf getDataWithType:self->selectedType withPage:self->loadPage];
        }];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    _tableView.tableHeaderView = [self getHeadV];
    return _tableView;
}

- (UIView *)getHeadV
{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 370)];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    lineV.backgroundColor = BACKCOLOR;
    [headV addSubview:lineV];
    
    BusTitleView *busV = [[[NSBundle mainBundle] loadNibNamed:@"BusTitleView" owner:self options:nil] lastObject];
    busV.frame = CGRectMake(0, 1, SCREEN_W, 50);
    [headV addSubview:busV];
    
    UIView *scrollBView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, SCREEN_W - 20, 230)];
    scrollBView.layer.shadowOffset = CGSizeMake(1, 1);
    scrollBView.layer.shadowRadius = 5.0;
    scrollBView.layer.shadowColor = MainTonal.CGColor;
    scrollBView.layer.shadowOpacity = 0.5;
    scrollBView.backgroundColor = [UIColor whiteColor];
    [headV addSubview:scrollBView];
    self.scrollBView = scrollBView;
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.videoTitleArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.videoArr.count; i ++) {
        self.bVideoM = self.videoArr[i];
        [imgArr addObject:self.bVideoM.videoImg];
        [self.videoTitleArr addObject:self.bVideoM.title];
    }
//    NSArray *imgArr =
//        NSArray *imgArr = @[@"https://gd1.alicdn.com/imgextra/i4/0/TB1pcR3fnlYBeNjSszcXXbwhFXa_!!0-item_pic.jpg_400x400.jpg",
//                            @"https://gd2.alicdn.com/imgextra/i1/0/TB1EBRax1GSBuNjSspbXXciipXa_!!0-item_pic.jpg_400x400.jpg",@"https://gd4.alicdn.com/imgextra/i1/17996653/O1CN011z17UbdueISJxH2_!!17996653.jpg_400x400.jpg"];
    SDCycleScrollView *cycleScrollV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_W - 20, 170)  delegate:self placeholderImage:[UIImage imageNamed:@"placeImg"]];
    cycleScrollV.autoScroll = NO;
//    cycleScrollV.autoScrollTimeInterval = 5;
    cycleScrollV.layer.masksToBounds = YES;
    cycleScrollV.layer.cornerRadius = 2;
    cycleScrollV.showPageControl = YES;
    cycleScrollV.titleLabelTextAlignment = NSTextAlignmentCenter;
//    cycleScrollV.titlesGroup = @[@"老师的今飞凯达附加费",@"九分裤健康的方式",@"的解放路上咖啡机"];
    cycleScrollV.titleLabelBackgroundColor = [UIColor clearColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollV.imageURLStringsGroup = imgArr;
    });
    [scrollBView addSubview:cycleScrollV];
    
    
    UIImageView *bofangImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 60, 130, 30, 30)];
    bofangImg.image = [UIImage imageNamed:@"bofang"];
    [scrollBView addSubview:bofangImg];

    UILabel *videoInfoLabel = [[UILabel alloc] init];
    videoInfoLabel.font = [UIFont systemFontOfSize:15];
    if (self.videoTitleArr.count != 0) {
        videoInfoLabel.text = self.videoTitleArr[0];
    }
    videoInfoLabel.frame = CGRectMake(6, 176, SCREEN_W - 32, 40);
    self.videoInfoLabel = videoInfoLabel;
    videoInfoLabel.numberOfLines = 2;
    [scrollBView addSubview:videoInfoLabel];
    
   
    BusTitleView *busV1 = [[[NSBundle mainBundle] loadNibNamed:@"BusTitleView" owner:self options:nil] lastObject];
    busV1.headTitleLabel.text = @"精品文章";
    busV1.frame = CGRectMake(0, 310, SCREEN_W, 50);
    [headV addSubview:busV1];
   
    
    UIView *linFView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, SCREEN_W, 10)];
    linFView.backgroundColor = BACKCOLOR;
    [headV addSubview:linFView];
    
    return headV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessTableViewCell *cell = [BusinessTableViewCell cellWithTableView:tableView];
    self.bContentM = self.contentArr[indexPath.row];
    cell.contentMedel = self.bContentM;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.bContentM = self.contentArr[indexPath.row];
    WebViewController *webV = [[WebViewController alloc] init];
//        webV.webUrlStr = @"https://weibo.com/2677270411/E3bcCx5kb?type=comment#_rnd1563859422459";
    webV.detailIDStr = self.bContentM.contentID;
    webV.titleStr = @"精彩文章";
    [self.navigationController pushViewController:webV animated:YES];
}

#pragma mark --- customDelegate ---
- (void)clickIndex:(int)indexInt
{
    DLog(@"--- %d",indexInt);
    selectedType = indexInt;
    [self.contentArr removeAllObjects];
    [self.videoArr removeAllObjects];
    nowLoad = -1;
    isCompletion = NO;
    [self getDataWithType:selectedType withPage:1];
    if (_playFatherView) {
        [self.playFatherView removeFromSuperview];
        self.playFatherView = nil;
        [self.playerview destroyPlayer];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DLog(@"index == %ld",(long)index);
    [self videoPlayWithIndex:(int)index];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.videoInfoLabel.text = self.videoTitleArr[index];
}

#pragma mark --- btnClickMethed ---
- (void)headLoad
{
    [self.contentArr removeAllObjects];
    [self.videoArr removeAllObjects];
    nowLoad = -1;
    loadPage = 0;
    isCompletion = NO;
    [self getDataWithType:selectedType withPage:1];
};


- (void)videoPlayWithIndex:(int)index
{
//    _playerMaskView = [[ZQPlayerMaskView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_W - 20, 170)];
//    _playerMaskView.delegate = self;
//    _playerMaskView.isWiFi = YES; // 是否允许自动加载，
//    [self.scrollBView addSubview:_playerMaskView];
//

//
//    NSString *videoUrl = @"http://183.60.197.29/17/q/t/v/w/qtvwspkejwgqjqeywjfowzdjcjvjzs/hc.yinyuetai.com/A0780162B98038FBED45554E85720E53.mp4?sc=e9bad1bb86f52b6f&br=781&vid=3192743&aid=38959&area=KR&vst=2&ptp=mv&rd=yinyuetai.com";
//    [_playerMaskView playWithVideoUrl:videoUrl];
//    [_playerMaskView.player play];
    
    self.bVideoM = self.videoArr[index];
    CGRect rect = CGRectMake(0, 0,  SCREEN_W - 20, 170);
    self.playFatherView = [[UIView alloc] initWithFrame:rect];
    [self.scrollBView addSubview:self.playFatherView];
    
    LXPlayModel *model =[[LXPlayModel alloc]init];
    model.playUrl = self.bVideoM.video;
//    model.playUrl = @"http://183.60.197.29/17/q/t/v/w/qtvwspkejwgqjqeywjfowzdjcjvjzs/hc.yinyuetai.com/A0780162B98038FBED45554E85720E53.mp4?sc=e9bad1bb86f52b6f&br=781&vid=3192743&aid=38959&area=KR&vst=2&ptp=mv&rd=yinyuetai.com";

    model.videoTitle = self.bVideoM.title;
    model.fatherView = self.playFatherView;
    self.playerview = [[LXAVPlayView alloc]init];
    self.playerview.isLandScape = YES;
    self.playerview.isAutoReplay = NO;
    self.playerview.currentModel = model;
    
    LXWS(weakSelf);
    self.playerview.backBlock = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    UIButton *closeVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeVideoBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    self.closeVideoBtn = closeVideoBtn;
    [closeVideoBtn addTarget:self action:@selector(closeVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeVideoBtn.frame = CGRectMake(SCREEN_W - 70, 0, 35, 35);
    [self.playerview addSubview:closeVideoBtn];

    
    
    UIButton *downLoadVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downLoadVideoBtn setImage:[UIImage imageNamed:@"downlode"] forState:UIControlStateNormal];
    self.downLoadVideoBtn = downLoadVideoBtn;
    [downLoadVideoBtn addTarget:self action:@selector(downLoadVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    downLoadVideoBtn.frame = CGRectMake(10, 70, 50, 50);
    self.downLoadVideoBtn.alpha = 0;
    [self.playerview addSubview:downLoadVideoBtn];
}


#pragma mark - 屏幕旋转
-(BOOL)shouldAutorotate{
    return YES;
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
        self.closeVideoBtn.alpha = 0;
        self.downLoadVideoBtn.alpha = 1;
        self.downLoadVideoBtn.frame = CGRectMake(SCREEN_H - 60, SCREEN_W / 2, 35, 35);

    }else{//竖屏
        NSLog(@"竖屏");
        self.downLoadVideoBtn.frame = CGRectMake(SCREEN_W - 160, 10, 35, 35);
        [self.progressView1 removeFromSuperview];
        self.progressView1 = nil;
        self.closeVideoBtn.alpha = 1;
    }
}





- (void)closeVideoBtnClick
{
    [self.playFatherView removeFromSuperview];
    self.playFatherView = nil;
    [self.playerview destroyPlayer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_playFatherView) {
        [self.playFatherView removeFromSuperview];
        self.playFatherView = nil;
        [self.playerview destroyPlayer];
    }
}

- (void)downLoadVideoBtnClick
{
    [self showSucessWihtStr:@"正在下载视频"];
    
    
    WLCircleProgressView *circleProgress1 = [WLCircleProgressView viewWithFrame:CGRectMake(SCREEN_W/2 - 25, SCREEN_H/2 - 25, 50, 50) circlesSize:CGRectMake(20, 5, 20, 5)];
    circleProgress1.layer.cornerRadius = 10;
    circleProgress1.progressValue = 0;
    [self.playerview addSubview:circleProgress1];
    self.progressView1 = circleProgress1;
    
    LXPlayModel *model =[[LXPlayModel alloc]init];
    model.playUrl = self.bVideoM.video;
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
//                                NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
                                float count = 1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
                                [weakSelf downloadProgress:count];
                            } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                                
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       NSLog(@"%@",response);
                       
                       [self saveVideo:fullPath];
                   }];
    [task resume];
    
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

    self.progressView1.progressValue = newValue;
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
    if (self.progressView1) {
        [self.progressView1 removeFromSuperview];
        self.progressView1 = nil;
    }
    if (error) {
        
        NSLog(@"保存视频失败%@", error.localizedDescription);
        [self showErrorWithStr:@"视频保存失败"];
        
    }else {
        [self showSucessWihtStr:@"视频保存成功"];
    }
    
}


@end
