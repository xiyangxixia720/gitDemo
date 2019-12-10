//
//  CheckItemTableViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckItemTableViewCellDelegate <NSObject>

- (void)selectSkuWithID:(NSString *_Nullable)skuIDStr withMoney:(NSString *_Nullable)selectedMoney;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CheckItemTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *titleArr;

@property (weak, nonatomic) id <CheckItemTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
