//
//  ShopInfoTableViewCell.m
//  ShoppingMall
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import "ShopInfoTableViewCell.h"
#import "PayInfoModel.h"

@interface ShopInfoTableViewCell()

{
    int count;
}

//@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *dShopImg;
@property (nonatomic, strong) UILabel *dTitleLabel;
@property (nonatomic, strong) UILabel *dGuiGeLabel;
@property (nonatomic, strong) UILabel *dPriceLabel;
@property (nonatomic, strong) UILabel *dCountLabel;
@property (nonatomic, strong) UIButton *dLeftBtn;
@property (nonatomic, strong) UIButton *dRightBtn;

@end

@implementation ShopInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        count = 1;
        [self createSubView];
    }
    return self;
}

- (void)createSubView
{
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.masksToBounds = YES;
    backV.layer.cornerRadius = 5;
    [self addSubview:backV];
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    _dShopImg = [[UIImageView alloc] init];
    _dShopImg.image = [UIImage imageNamed:@"timg"];
    [backV addSubview:_dShopImg];
    [_dShopImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backV);
        make.left.mas_equalTo(backV.mas_left).valueOffset(@(10));
        make.width.height.mas_equalTo(92);
    }];
    
    _dTitleLabel = [[UILabel alloc] init];
    _dTitleLabel.text = @"80-90后儿时美味零食大辣 片看着香吃着更香健康美";
    _dTitleLabel.font = [UIFont systemFontOfSize:15];
    _dTitleLabel.numberOfLines = 2;
    _dTitleLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    [backV addSubview:_dTitleLabel];
    [_dTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dShopImg);
        make.left.equalTo(self.dShopImg.mas_right).valueOffset(@(10));
        make.right.mas_equalTo(backV).valueOffset(@(-15));
        make.height.mas_equalTo(36);
    }];
    
    _dGuiGeLabel = [[UILabel alloc] init];
    _dGuiGeLabel.text = @"规格350g";
    _dGuiGeLabel.textColor = [UIColor grayColor];
    _dGuiGeLabel.font = [UIFont systemFontOfSize:14];
    [backV addSubview:_dGuiGeLabel];
    [_dGuiGeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dShopImg).valueOffset(@(8));
        make.left.equalTo(self.dTitleLabel);
        make.width.valueOffset(@(150));
    }];
    
//    _dLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_dLeftBtn setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
//    [_dLeftBtn addTarget:self action:@selector(leftBtnCLick) forControlEvents:UIControlEventTouchUpInside];
//    [backV addSubview:_dLeftBtn];
//    [_dLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.dTitleLabel);
//        make.bottom.equalTo(self.dShopImg.mas_bottom);
//        make.width.height.valueOffset(@(35));
//    }];
//
//    _dCountLabel = [[UILabel alloc] init];
//    _dCountLabel.text = @"1";
//    _dCountLabel.font = [UIFont systemFontOfSize:13];
//    _dCountLabel.textColor = [UIColor grayColor];
//    _dCountLabel.textAlignment = NSTextAlignmentCenter;
//    [backV addSubview:_dCountLabel];
//    [_dCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.dLeftBtn.mas_right);
//        make.centerY.equalTo(self.dLeftBtn);
//        make.height.valueOffset(@(20));
//    }];
//
//    _dRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_dRightBtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
//    [_dRightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [backV addSubview:_dRightBtn];
//    [_dRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.dCountLabel);
//        make.left.equalTo(self.dCountLabel.mas_right);
//        make.width.height.valueOffset(@(35));
//    }];
    
    _dPriceLabel = [[UILabel alloc] init];
    _dPriceLabel.textColor = MainTonal;
    _dPriceLabel.text = @"¥10000";
    _dPriceLabel.font = [UIFont systemFontOfSize:14];
    [backV addSubview:_dPriceLabel];
    [_dPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dShopImg.mas_right).valueOffset(@(10));
        make.bottom.equalTo(self.dShopImg.mas_bottom);
        make.height.valueOffset(@(20));
    }];
}


- (void)rightBtnClick
{
    count ++;
    self.dCountLabel.text = [NSString stringWithFormat:@"%d",count];
    UITableViewCell *cell = (UITableViewCell *)[[self.dCountLabel superview] superview];
    if ([self.delegate respondsToSelector:@selector(addClickWithIndex:withCell:)]) {
        [self.delegate addClickWithIndex:count withCell:cell];
    }
}

- (void)leftBtnCLick
{
    if (count == 1) {
        return;
    }
    count --;
    self.dCountLabel.text = [NSString stringWithFormat:@"%d",count];
    UITableViewCell *cell = (UITableViewCell *)[[self.dCountLabel superview] superview];
    if ([self.delegate respondsToSelector:@selector(addClickWithIndex:withCell:)]) {
        [self.delegate addClickWithIndex:count withCell:cell];
    }
}

- (void)setOrderM:(PayInfoModel *)orderM
{
    _orderM = orderM;
    [_dShopImg sd_setImageWithURL:[NSURL URLWithString:orderM.shopimg] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    _dTitleLabel.text = orderM.shopname;
    _dGuiGeLabel.text = [NSString stringWithFormat:@"规格 %@",orderM.skuname];
    _dPriceLabel.text = [NSString stringWithFormat:@"￥%@",orderM.shop_money];

}
//{
//    _orderM = orderM;
//    _dTitleLabel.text = orderM.shopname;
//    _dGuiGeLabel.text = [NSString stringWithFormat:@"规格 %@",orderM.sku_name];
//    _dCountLabel.text = [NSString stringWithFormat:@"%@",orderM.number];
//    _dPriceLabel.text = [NSString stringWithFormat:@"￥%@",orderM.retail_price];
    //        [cell.shopImg sd_setImageWithURL:[NSURL URLWithString:self.oAModel.sku_pic] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    //        cell.shopNameLabel.text = self.oAModel.shopname;
    //        cell.guiGeLabel.text = self.oAModel.sku_name;
    //        cell.jianBtn.tag = indexPath.row + 666;
    //        cell.jiaBtn.tag = indexPath.row + 8888;
    //        [cell.jianBtn addTarget:self action:@selector(jianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        cell.countLabel.text = [NSString stringWithFormat:@"%@",self.oAModel.number];
    //        shopCount = [self.oAModel.number intValue];
    //        self.countLabel = cell.countLabel;
    //        [cell.jiaBtn addTarget:self action:@selector(jiaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.oAModel.retail_price];
//}

@end
