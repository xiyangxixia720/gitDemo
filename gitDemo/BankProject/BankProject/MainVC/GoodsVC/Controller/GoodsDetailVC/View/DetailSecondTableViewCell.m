//
//  DetailSecondTableViewCell.m
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import "DetailSecondTableViewCell.h"
#import "GoodInfoModel.h"

@interface DetailSecondTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation DetailSecondTableViewCell

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
    static NSString *ID = @"secondCell";
    //1.判断是否存在可重用cell
    DetailSecondTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"DetailSecondTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setGoodModel:(GoodInfoModel *)goodModel
{
    _goodModel = goodModel;
    self.titleLabel.text = @"发货";
    self.contentLabel.text = goodModel.address;
}

@end
