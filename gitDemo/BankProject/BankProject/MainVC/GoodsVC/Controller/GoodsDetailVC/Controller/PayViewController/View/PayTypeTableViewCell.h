//
//  PayTypeTableViewCell.h
//  ShoppingMall
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payImg;
@property (weak, nonatomic) IBOutlet UILabel *paytitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seletedImg;

@end

NS_ASSUME_NONNULL_END
