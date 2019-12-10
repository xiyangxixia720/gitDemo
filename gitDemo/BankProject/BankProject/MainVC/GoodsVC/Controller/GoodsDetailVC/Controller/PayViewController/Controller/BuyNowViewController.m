//
//  BuyNowViewController.m
//  ShoppingMall
//
//  Created by mc on 2019/7/15.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BuyNowViewController.h"
#import "OrderDtailTableViewCell.h"
#import "PayInfoModel.h"
#import "PriceTableViewCell.h"
#import "PayTypeTableViewCell.h"
#import "ShopInfoTableViewCell.h"
#import "PayCommitView.h"
#import "WXApi.h"
#import "AlipaySDK/AlipaySDK.h"


@interface BuyNowViewController ()<UITableViewDelegate,UITableViewDataSource,ShopInfoTableViewCellDelegate>

{
    int shopCount;
    int seletedPay;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PayInfoModel *payModel;
//@property (nonatomic, strong) OrderArrModel *oAModel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation BuyNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"PaySucType" object:nil];
    [self getPayData];
    
//    [self initFoot];

}

- (void)commitPayV
{
    UIView *footV = [[[NSBundle mainBundle] loadNibNamed:@"PayCommitView" owner:self options:nil] lastObject];
    footV.frame = CGRectMake(0, SCREEN_H - HomeIndicator - 50, SCREEN_W, 50);
    [self.view addSubview:footV];
}

- (void)getPayData
{
//    NSDictionary *sendD = @{@"":@""};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/buyShop",MYURL] headStr:[FLTools getUserID] parameters:self.infoDict success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            self.payModel = [PayInfoModel modelWithJSON:[responseObject objectForKey:@"data"]];
            [self.view addSubview:self.tableView];

            [self.tableView reloadData];
            [self initFoot];
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(id failure) {
        [self showErrorWithStr:@"请检查网络连接"];
    }];
}

- (void)paySuccess:(NSNotification*)noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *type = [dic objectForKey:@"name"];
    [self showSucessWihtStr:type withSucImg:[UIImage imageNamed:@""]];
//    if ([type isEqualToString:@"1"]) {
//        [self showSucessWihtStr:@"" withSucImg:[UIImage imageNamed:@""]];
//    }else if ([type isEqualToString:@"2"]){
//        [self showSucessWihtStr:@"" withSucImg:[UIImage imageNamed:@""]];
//
//    }else if ([type isEqualToString:@"3"]){
//        [self showSucessWihtStr:@"" withSucImg:[UIImage imageNamed:@""]];
//
//    }else if ([type isEqualToString:@"4"]){
//        [self showSucessWihtStr:@"" withSucImg:[UIImage imageNamed:@""]];
//
//    }else if ([type isEqualToString:@"5"]){
//        [self showSucessWihtStr:@"" withSucImg:[UIImage imageNamed:@""]];
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    seletedPay = 0;
//    [self getData];
}

- (void)getData
{
    /*
     {
     "id" : null,
     "storename" : "",
     "isdelete" : null,
     "totalprice" : "0.41",
     "userid" : null,
     "province" : "内蒙古自治区",
     "realprice" : "0",
     "area" : "新城区",
     "addressDetail" : "鱼化寨与兜路交汇处",
     "ordercode" : "5120781563177796247402603",
     "userphone" : "1110",
     "city" : "呼和浩特市",
     "username" : "张三",
     "ctime" : null,
     "preferprice" : "0.09",
     "shopList" : [
     {
     "stock" : 100,
     "number" : 1,
     "shopname" : "辣条",
     "retail_price" : "0.41",
     "sku_name" : "20g",
     "sku_pic" : "http:\/\/localhost:8099\/upload\/981a04116eb24d7e8d2906a16ceda9dc_back.png"
     }
     ],
     "isdefault" : null
     }
     */
//    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@shop/buyNow",MYURL] headStr:[FLTools getUserID] parameters:self.infoDict success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
////            self.oModel = [OrderModel modelWithDictionary:[responseObject objectForKey:@"data"]];
//        }
//        [self.tableView reloadData];
//    } failure:^(id failure) {
//
//    }];
}

- (void)initFoot
{
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - HomeIndicator - Nav_Height - 50, SCREEN_W, 50)];
    footV.backgroundColor = [UIColor whiteColor];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"付款" forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:[UIColor redColor]];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.frame = CGRectMake(SCREEN_W - 100, 0, 100, 50);
    [footV addSubview:commitBtn];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = [NSString stringWithFormat:@"合计：￥%@",self.payModel.totalMoney];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.frame = CGRectMake(20, 0, SCREEN_W - 150, 50);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [footV addSubview:priceLabel];
    
    [self.view addSubview:footV];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - HomeIndicator - 50 - Nav_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 3;
    }else if (section == 1){
        return 1;
//        return self.oModel.shopList.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"cell";
        ShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ShopInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.orderM = self.payModel;
        //self.oModel.shopList
        //        cell.orderM = self.oModel.shopList[indexPath.row];
        
//        [cell.shopImg sd_setImageWithURL:[NSURL URLWithString:self.PayInfoModel.shopimg] placeholderImage:[UIImage imageNamed:@"placeImg"]];
//        cell.shopNameLabel.text = self.oAModel.shopname;
//        cell.guiGeLabel.text = self.oAModel.sku_name;
//        [cell.jianBtn addTarget:self action:@selector(jianBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        cell.countLabel.text = [NSString stringWithFormat:@"%@",self.oAModel.number];
//        shopCount = [self.oAModel.number intValue];
//        self.countLabel = cell.countLabel;
//        [cell.jiaBtn addTarget:self action:@selector(jiaBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.oAModel.retail_price];

        return cell;
        
    }
    if (indexPath.section == 1) {
        static NSString *cellID = @"cell";
        PriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PriceTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.payModel.totalMoney];
        //        cell.ActualLabel.text = [NSString stringWithFormat:@"￥%@",self.oModel.realprice];
        //        cell.secondLabel.text = [NSString stringWithFormat:@"￥%@",self.oModel.totalprice];
        //        cell.thirdLabel.text = [NSString stringWithFormat:@"-￥%@",self.oModel.preferprice];
        return cell;
        
        
    }
    if (indexPath.section == 3) {
        static NSString *cellID = @"cell";
        PayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTypeTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            cell.payImg.image = [UIImage imageNamed:@"youhuiquan-1"];
            cell.paytitleLabel.text = @"提货券支付";
        }else if (indexPath.row == 1){
            cell.payImg.image = [UIImage imageNamed:@"weixinzhifu"];
            cell.paytitleLabel.text = @"微信支付";
        }else{
            cell.payImg.image = [UIImage imageNamed:@"zhifubao"];
            cell.paytitleLabel.text = @"支付宝支付";
        }
        if (seletedPay == indexPath.row) {
            cell.seletedImg.image = [UIImage imageNamed:@"xuanzhong"];
        }else{
            cell.seletedImg.image = [UIImage imageNamed:@"weixuanzhong"];
        }
        return cell;
    }else{
        static NSString *cellID = @"cell";
        OrderDtailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDtailTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameLabel.text = [self.payModel.address objectForKey:@"username"];
        cell.phoneLabel.text = [self.payModel.address objectForKey:@"userphone"];
        cell.placeLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[self.payModel.address objectForKey:@"province"],[self.payModel.address objectForKey:@"city"],[self.payModel.address objectForKey:@"area"],[self.payModel.address objectForKey:@"addressDetail"]];
        [cell.detailPlaceLabel addTarget:self action:@selector(placeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        seletedPay = (int)indexPath.row;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1){
        return 50;
    }else if (indexPath.section == 2){
        return 90;
    }else{
        return 50;
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

#pragma mark --- btnClick ---
- (void)placeBtnClick
{
    DLog(@"地址详情");
}

- (void)jianBtnClick
{
    if (shopCount == 1) {
        return;
    }
    shopCount --;
    self.countLabel.text = [NSString stringWithFormat:@"%d",shopCount];
}

- (void)jiaBtnClick
{
    shopCount ++;
    self.countLabel.text = [NSString stringWithFormat:@"%d",shopCount];
}

- (void)commitBtnClick
{
    NSString *typeStr;
    if (seletedPay == 0) {
        typeStr = @"3";
    }else if (seletedPay == 1){
        typeStr = @"2";
    }else{
        typeStr = @"1";
    }
    NSDictionary *send_D = @{@"userid":[FLTools getUserID],
                             @"type":typeStr,
                             @"ordercode":self.payModel.ordercode,
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@pay/infopay",MYURL] headStr:[FLTools getUserID] parameters:send_D success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue]  == 200) {

            if ([typeStr isEqualToString:@"2"]) {
                NSDictionary *infoDict = [responseObject objectForKey:@"data"];
                [self weiXinPayWithInfo:infoDict];
            }else if ([typeStr isEqualToString:@"1"]){
                NSString *dataStr = [responseObject objectForKey:@"data"];
                
                [self aLiPayWithInfo:dataStr];
            }else{
                [self showSucessWihtStr:[responseObject objectForKey:@"msg"]];
            }
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(id failure) {
        [self showErrorWithStr:@"请检查网络连接"];
    }];
}

- (void)weiXinPayWithInfo:(NSDictionary *)infoDict
{
    PayReq *req = [[PayReq alloc] init];
    UInt32 time_int = [[infoDict objectForKey:@"timestamp"] intValue];
    req.openID = @"wx70ba3f2751d05742";//微信开放平台审核通过的AppID
    req.partnerId = [infoDict objectForKey:@"partnerid"];//微信支付分配的商户ID
    req.prepayId = [infoDict objectForKey:@"prepayid"];// 预支付交易会话ID
    req.nonceStr = [infoDict objectForKey:@"noncestr"];//随机字符串
    req.timeStamp = time_int;//当前时间
    req.package = @"Sign=WXPay";//固定值
    req.sign = [infoDict objectForKey:@"sign"];//签名，除了sign，剩下6个组合的再次签名字符串
    if ([WXApi isWXAppInstalled] == YES) {
        //此处会调用微信支付界面
        BOOL sss =   [WXApi sendReq:req];
        if (!sss ) {
            [self showErrorWithStr:@"微信sdk错误"];
        }
    }else {
        //微信未安装
        [self showErrorWithStr:@"您没有安装微信"];
    }
}

- (void)aLiPayWithInfo:(NSString *)infoDict
{
    NSString *appScheme = @"bankScheme";
//    NSString *orderString = [infoDict objectForKey:@"sign"];
    NSString *appStr = @"app_id=2019042864355223&format=JSON&charset=utf-8&sign_type=RSA2&version=1.0&notify_url=http%3A%2F%2F39.98.84.90%2Fapi%2Fnotify%2Fali_notify&timestamp=2019-08-08+15%3A33%3A43&biz_content=%7B%22out_trade_no%22%3A%221496236524158922%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%22test+subject-%5Cu6d4b%5Cu8bd5%5Cu8ba2%5Cu5355%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&method=alipay.trade.app.pay&sign=gxffxUpEPv4GfMgflL3IhMpFXhzsZICY4EvYN0eQ8RIW6h0x765ZsSOW0beYbc9DeuXxrLqvSohp8yf9jZ3QajPCkbM8vR3E%2BFPmyU8dssCHVaNeeIMgK1SlINqurgiVTr6%2FBf%2FSrf2cglcWljtdtZdozI2anUvHCP%2BtzWBLnkHMwYGcuH27TLY85fjdTfJ4leLd8OPuBqKoSrwgoMojhteDKVjfnCi66JQhcUbsIgNvb4aBYb1YrUcinQ7Aluiri2HBcpQbxfxVTdbH%2BPMMnvzQdx9wr37eTkhwojXrB%2BtGrX1ZOg5ffnLhXnK3rwvB1dphHckUFWQItrSOtACKaQ%3D%3D";
    [[AlipaySDK defaultService] payOrder:infoDict fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

#pragma mark --- customDelegate ---
- (void)addClickWithIndex:(int)index withCell:(UITableViewCell *_Nullable)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"---%d---- %ld",index,(long)indexPath.row);
//    self.oAModel = self.oModel.shopList[indexPath.row];
//    self.oAModel.number = [NSNumber numberWithInt:index];
    //    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    //    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
