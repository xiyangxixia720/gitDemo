//
//  BusinessTableViewCell.m
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BusinessTableViewCell.h"
#import "BusinessContentModel.h"

@interface BusinessTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation BusinessTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"businessCell";
    //1.判断是否存在可重用cell
    BusinessTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentMedel:(BusinessContentModel *)contentMedel
{
    _contentMedel = contentMedel;
    [self.titleImg sd_setImageWithURL:[NSURL URLWithString:contentMedel.contentImg] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    self.titleLabel.text = contentMedel.title;
    self.timeLabel.text  = contentMedel.ctime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
