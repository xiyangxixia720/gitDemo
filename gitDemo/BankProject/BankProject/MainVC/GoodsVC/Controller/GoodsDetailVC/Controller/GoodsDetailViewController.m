//
//  GoodsDetailViewController.m
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "DetailFirstTableViewCell.h"
#import "DetailSecondTableViewCell.h"
#import "SectionHeadView.h"
#import "AddShopTableViewCell.h"
#import "CheckItemTableViewCell.h"
#import <WebKit/WebKit.h>
#import "BuyNowViewController.h"
#import "GoodInfoModel.h"
#import "AddressModel.h"
#import "SkuModel.h"
#import "SelectedAddressViewController.h"
#import "FaHuoAdressTableViewCell.h"
#import "PWLoginViewController.h"

static NSString *reuseWebCell = @"WebCell";



@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,SectionHeadViewDelegate,WKUIDelegate, WKNavigationDelegate,CheckItemTableViewCellDelegate,AddShopTableViewCellDelegate>

{
    BOOL isShowInfo;
    BOOL isShowShopInfo;
    
    int selectedAddressInt;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SectionHeadView *sectionH;
@property (nonatomic, strong) SectionHeadView *sectionHThird;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollV;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webViewHeight;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) GoodInfoModel *goodModel;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) SkuModel *skuModel;

@property (nonatomic, strong) NSMutableArray *skuArr;
@property (nonatomic, strong) NSMutableArray *addressArr;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isShowShopInfo = YES;
    
    selectedAddressInt = 0;
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(getNoti:) name:@"selectAddressNoti" object:nil];
}


-(void)getNoti:(NSNotification*)noti
{
    NSDictionary *dic = noti.userInfo;
    selectedAddressInt = [[dic objectForKey:@"addressIndex"] intValue];
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:4];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)getDetailData
{
    NSString *userIDStr;
    if (![FLTools isLogin]) {
        userIDStr = @"";
    }else{
        userIDStr = [FLTools getUserID];
    }
    NSDictionary *sendD = @{@"userid":userIDStr,
                            @"shopid":self.goodDetailIDStr,
                            };
    WEAK_SELF;
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectShopById",MYURL] headStr:nil parameters:sendD success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            
            weakSelf.goodModel = [GoodInfoModel modelWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"shop"]];
            NSArray *skuArr = [[responseObject objectForKey:@"data"] objectForKey:@"skuList"];
            for (int i = 0; i < skuArr.count; i ++) {
                weakSelf.skuModel = [SkuModel modelWithDictionary:skuArr[i]];
                [weakSelf.skuArr addObject:weakSelf.skuModel];
                if (i == 0) {
                    weakSelf.goodModel.selectedSkuIDStr = weakSelf.skuModel.skuIDStr;
                    weakSelf.goodModel.selectedSkuMoneyStr = [NSString stringWithFormat:@"%@", weakSelf.skuModel.real_price];
                }
            }
            weakSelf.goodModel.goodCount = 1;
            NSArray *addArr = [[responseObject objectForKey:@"data"] objectForKey:@"addressList"];
            for (int j = 0; j < addArr.count; j ++) {
                weakSelf.addressModel = [AddressModel modelWithDictionary:addArr[j]];
                [weakSelf.addressArr addObject:weakSelf.addressModel];
            }
            [self.tableView reloadData];
            [self creatWebView];
        }
    } failure:^(id failure) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.webViewHeight = 0.0;
    self.skuArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.addressArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    [self initUI];
    [self getDetailData];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.webView.UIDelegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)initUI
{
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    commitBtn.frame = CGRectMake(0, SCREEN_H - 50 - HomeIndicator, SCREEN_W, 50);
    [commitBtn setBackgroundColor:MainTonal];
    [self.view addSubview:commitBtn];
    
    [self.view addSubview:self.tableView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"-s-reture"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(8, 30, 50, 50);
    [backBtn addTarget:self action:@selector(backBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.masksToBounds = YES;
    [self.view addSubview:backBtn];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -Status_Height, SCREEN_W, SCREEN_H - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseWebCell];
    }
    _tableView.tableFooterView = [self getFootV];
    _tableView.tableHeaderView = [self getHead];
    return _tableView;
}

- (UIView *)getFootV
{
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 600)];
    UIImageView *detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 600)];
    [detailImg sd_setImageWithURL:[NSURL URLWithString:self.goodModel.shopImg] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    [footV addSubview:detailImg];
    return footV;
}

#pragma mark -------创建webView-------
- (void)creatWebView {
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    wkWebConfig.userContentController = wkUController;
    //自适应屏幕的宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    //添加js调用
    [wkUController addUserScript:wkUserScript];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) configuration:wkWebConfig];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView sizeToFit];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    NSURL *url = [NSURL URLWithString:self.sdModel.shopDescribe];
//    DLog(@"--- %@",self.sdModel.shopDescribe);
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/e1833f898329"]];
    [_webView loadHTMLString:self.goodModel.detials baseURL:nil];

//    [self.webView loadRequest:request];
    //    [self.webView loadHTMLString:self.sdModel.shopDescribe baseURL:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.scrollView addSubview:self.webView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        //方法一
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        /*
         //方法二
         [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
         CGFloat height = [result doubleValue] + 20;
         self.webViewHeight = height;
         self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil]  withRowAnimation:UITableViewRowAnimationNone];
         }];
         */
    }
}

- (SectionHeadView *)sectionH
{
    if (!_sectionH) {
        _sectionH = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
        _sectionH.titleLabe.text = @"规格";
        _sectionH.contentLabel.text = @"请选择商品规格";
        _sectionH.delegate = self;
    }
    return _sectionH;
}

- (SectionHeadView *)sectionHThird
{
    if (!_sectionHThird) {
        _sectionHThird = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
        _sectionHThird.delegate = self;
        _sectionHThird.titleLabe.text = @"属性";
        _sectionHThird.contentLabel.text = @"查看详情";
    }
    return _sectionHThird;
}

- (UIView *)getHead
{
    NSMutableArray *imgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [imgArr addObjectsFromArray:[self.goodModel.imgs componentsSeparatedByString:@","]];
    if (imgArr.count != 0) {
        [imgArr removeLastObject];
    }
    if (imgArr.count == 0) {
        return [[UIView alloc] init];
    }
//    NSArray *imgArr = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563424442785&di=5e898616e715792000a0f779bbac0f8a&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201410%2F05%2F20141005093448_TmHx4.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563424456842&di=3fdab06db852c24fd41e33dea1d714f3&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170508%2F532815e992b34cd096411fe128af3703_th.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563424470039&di=8ad85a4899e29dc75be1182cde816bfb&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fhousephotolib%2F1403%2F11%2Fc0%2F31980059_1394517771823.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563424489330&di=08643f776adba07d38f3701734abdbca&imgtype=0&src=http%3A%2F%2Fimg1.soufunimg.com%2Fviewimage%2Fzxb%2F2014_11%2F24%2F41%2F21%2Fpic%2F001401819900%2F640x1500.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563424499743&di=9db79ee552960111581d21ad8e27ceb7&imgtype=0&src=http%3A%2F%2Fpic30.nipic.com%2F20130614%2F4828981_103411051383_2.jpg"];
    if (_cycleScrollV) {
        return _cycleScrollV;
    }
    _cycleScrollV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,  SCREEN_W, 375)  delegate:self placeholderImage:[UIImage imageNamed:@"placeImg"]];
    
    
//    cycleScrollV.autoScrollTimeInterval = 5;
//    cycleScrollV.infiniteLoop = NO;
//    cycleScrollV.showPageControl = NO;
//    cycleScrollV.autoScroll = YES;
    _cycleScrollV.titleLabelTextAlignment = NSTextAlignmentRight;
    _cycleScrollV.titleLabelBackgroundColor = [UIColor clearColor];
    NSMutableArray *indexArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *indexStr;
    for (int i = 0; i < imgArr.count; i ++) {
        indexStr = [NSString stringWithFormat:@"%d/%lu",i + 1,(unsigned long)imgArr.count];
        [indexArr addObject:indexStr];
    }
    _cycleScrollV.titlesGroup = indexArr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollV.imageURLStringsGroup = imgArr;
    });
    
    return _cycleScrollV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if (isShowInfo) {
            return 2;
        }else{
            return 1;
        }
    }else if (section == 3){
        if (isShowShopInfo) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DetailFirstTableViewCell *cell = [DetailFirstTableViewCell cellWithTableView:tableView];
        cell.goodInfoModel = self.goodModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if(indexPath.section == 1){
        DetailSecondTableViewCell *Scell = [DetailSecondTableViewCell cellWithTableView:tableView];
        Scell.goodModel = self.goodModel;
        Scell.selectionStyle = UITableViewCellSelectionStyleNone;

        return Scell;
    }else if (indexPath.section == 2){
        if (isShowInfo) {
            if (indexPath.row == 0) {
                static NSString *cellID = @"checkcell";
                CheckItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[CheckItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                cell.delegate = self;
                cell.titleArr = self.skuArr;
                return cell;
            }else{
                AddShopTableViewCell *Scell = [AddShopTableViewCell cellWithTableView:tableView];
                Scell.shopCount = self.goodModel.goodCount;
                Scell.selectionStyle = UITableViewCellSelectionStyleNone;

                return Scell;
            }
        }else{
            AddShopTableViewCell *Scell = [AddShopTableViewCell cellWithTableView:tableView];
            Scell.shopCount = self.goodModel.goodCount;
            Scell.delegate = self;
            Scell.selectionStyle = UITableViewCellSelectionStyleNone;

            return Scell;
        }
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseWebCell];
        [cell.contentView addSubview:self.scrollView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.section == 5){
        static NSString *reuseWebCell = @"webcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseWebCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseWebCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView addSubview:self.scrollView];
        return cell;
    }else{
        static NSString *addressID = @"dressID";
        FaHuoAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FaHuoAdressTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.addressArr.count != 0) {
            self.addressModel = self.addressArr[selectedAddressInt];
            
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.addressModel.province,self.addressModel.city,self.addressModel.area,self.addressModel.addressDetail];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([FLTools isLogin]) {
        
        if (indexPath.section == 4) {
            if (self.addressArr.count == 0) {
                [self showErrorWithStr:@"请先添加收货地址"];
                return;
            }
            SelectedAddressViewController *selectedVC = [[SelectedAddressViewController alloc] init];
            selectedVC.addressArr = self.addressArr;
            selectedVC.contentSizeInPopup = CGSizeMake(SCREEN_W, 360);
            
            STPopupController *popVC = [[STPopupController alloc] initWithRootViewController:selectedVC];
            popVC.navigationBarHidden = YES;
            popVC.style = STPopupStyleBottomSheet;
            [popVC presentInViewController:self];
        }
    }else{
        [self showErrorWithStr:@"请先登录"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (isShowInfo) {
            if (indexPath.row == 0) {
                return 160;
            }else{
                return 50;
            }
        }else{
            return 50;
        }
    }else if (indexPath.section == 0){
        return 110;
    }else if (indexPath.section == 5){
        return 100;
    }else if (indexPath.section == 3){
        return _webViewHeight;
    }
    else{
        return 80;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 50;
    }else if (section == 3){
        return 50;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
//        SectionHeadView *_sectionH = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
//        _sectionH.titleLabe.text = @"规格";
//        _sectionH.contentLabel.text = @"请选择商品规格";
//        _sectionH.delegate = self;
        return self.sectionH;
    }else if (section == 3){
//        _sectionHThird = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
//        _sectionHThird.delegate = self;
//        _sectionH.titleLabe.text = @"属性";
//        _sectionH.contentLabel.text = @"查看详情";
        return self.sectionHThird;
    }else{
        return nil;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark --- customDelegate ---
- (void)isShowInfoClick:(BOOL)isShow withView:(UIView * _Nullable)sView
{
    if (sView == self.sectionH) {
        isShowInfo = isShow;
        [self.tableView reloadData];
    }else{
        isShowShopInfo = isShow;
        [self.tableView reloadData];
    }
    
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)selectSkuWithID:(NSString *)skuIDStr withMoney:(NSString *)selectedMoney
{
    DLog(@"--- %@",skuIDStr);
    self.goodModel.selectedSkuIDStr = skuIDStr;
    self.goodModel.selectedSkuMoneyStr = selectedMoney;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addGoodNum:(int)goodNum
{
    self.goodModel.goodCount = goodNum;
}

#pragma mark --- btnClickMethed ---
- (void)commitBtnClick
{
    if ([FLTools isLogin]) {
        if (self.addressArr.count == 0) {
            [self showErrorWithStr:@"请先添加收货地址"];
            return;
        }
        DLog(@"立即购买");
        BuyNowViewController *payVC = [[BuyNowViewController alloc] init];
        self.addressModel = self.addressArr[selectedAddressInt];
        payVC.infoDict = @{@"skuid":self.goodModel.selectedSkuIDStr,
                           @"addressid":self.addressModel.addressIDStr,
                           @"number":[NSString stringWithFormat:@"%d",self.goodModel.goodCount],
                           @"shop_money":self.goodModel.selectedSkuMoneyStr,
                           @"userid":[FLTools getUserID],
                           };
        [self.navigationController pushViewController:payVC animated:YES];
    }else{
        PWLoginViewController *loginVC = [[PWLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)backBtnCLick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
