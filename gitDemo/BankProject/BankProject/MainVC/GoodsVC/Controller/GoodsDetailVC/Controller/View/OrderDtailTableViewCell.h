//
//  OrderDtailTableViewCell.h
//  ShoppingMall
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDtailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailPlaceLabel;

@end

NS_ASSUME_NONNULL_END
