//
//  AddShopTableViewCell.m
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import "AddShopTableViewCell.h"

@interface AddShopTableViewCell ()

{
    int count;
}

@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;



@end

@implementation AddShopTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    count = 1;
    [self.jianBtn addTarget:self action:@selector(jianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.jiaBtn addTarget:self action:@selector(jiaBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"addCell";
    //1.判断是否存在可重用cell
    AddShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"AddShopTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setShopCount:(int)shopCount
{
    _shopCount = shopCount;
    self.countLabel.text = [NSString stringWithFormat:@"%d",shopCount];
}

- (void)jianBtnClick
{
    if (count == 1) {
        return;
    }
    count --;
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    if ([self.delegate respondsToSelector:@selector(addGoodNum:)]) {
        [self.delegate addGoodNum:count];
    }
}

- (void)jiaBtnClick
{
    count ++;
    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
    if ([self.delegate respondsToSelector:@selector(addGoodNum:)]) {
        [self.delegate addGoodNum:count];
    }
}

@end
