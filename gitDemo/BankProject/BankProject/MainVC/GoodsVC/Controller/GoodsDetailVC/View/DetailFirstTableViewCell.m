//
//  DetailFirstTableViewCell.m
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import "DetailFirstTableViewCell.h"
#import "GoodInfoModel.h"

@interface DetailFirstTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation DetailFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"firstCell";
    //1.判断是否存在可重用cell
    DetailFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"DetailFirstTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setGoodInfoModel:(GoodInfoModel *)goodInfoModel
{
    _goodInfoModel = goodInfoModel;
    self.titleLabel.text = goodInfoModel.shopName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",goodInfoModel.selectedSkuMoneyStr];
    self.countLabel.text = [NSString stringWithFormat:@"库存%@",goodInfoModel.shopStock];
}

@end
