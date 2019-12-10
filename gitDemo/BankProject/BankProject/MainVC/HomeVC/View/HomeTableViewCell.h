//
//  HomeTableViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *HomeNewImg;
@property (weak, nonatomic) IBOutlet UILabel *HomeNewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *HomeNewTimeLabel;

@end

NS_ASSUME_NONNULL_END
