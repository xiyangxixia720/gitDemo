//
//  GoodsCollectionViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GoodImg;
@property (weak, nonatomic) IBOutlet UILabel *GoodTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodOldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodCountLabel;

@end

NS_ASSUME_NONNULL_END
