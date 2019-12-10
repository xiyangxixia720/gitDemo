//
//  DetailSecondTableViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface DetailSecondTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) GoodInfoModel *goodModel;

@end

NS_ASSUME_NONNULL_END
