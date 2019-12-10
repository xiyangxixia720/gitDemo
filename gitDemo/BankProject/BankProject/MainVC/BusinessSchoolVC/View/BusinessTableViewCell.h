//
//  BusinessTableViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BusinessContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface BusinessTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BusinessContentModel *contentMedel;

@end

NS_ASSUME_NONNULL_END
