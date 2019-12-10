//
//  AddShopTableViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddShopTableViewCellDelegate <NSObject>

- (void)addGoodNum:(int)goodNum;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AddShopTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) int shopCount;
@property (nonatomic, weak) id<AddShopTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
