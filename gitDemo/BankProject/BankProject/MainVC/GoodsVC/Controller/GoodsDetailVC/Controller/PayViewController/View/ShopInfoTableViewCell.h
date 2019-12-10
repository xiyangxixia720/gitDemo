//
//  ShopInfoTableViewCell.h
//  ShoppingMall
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayInfoModel;

@protocol ShopInfoTableViewCellDelegate <NSObject>

@required

- (void)addClickWithIndex:(int)index withCell:(UITableViewCell *_Nullable)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ShopInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) id <ShopInfoTableViewCellDelegate>delegate;

@property (nonatomic, strong) PayInfoModel *orderM;

@end

NS_ASSUME_NONNULL_END
