//
//  GoodsModel.h
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsModel : NSObject

@property (nonatomic, copy)   NSString *goodsID;
@property (nonatomic, strong) NSNumber *sell_price;
@property (nonatomic, copy)   NSString *shop_img;
@property (nonatomic, strong) NSNumber *shop_stock;
@property (nonatomic, strong) NSNumber *real_price;
@property (nonatomic, copy)   NSString *shop_name;

@end

NS_ASSUME_NONNULL_END
