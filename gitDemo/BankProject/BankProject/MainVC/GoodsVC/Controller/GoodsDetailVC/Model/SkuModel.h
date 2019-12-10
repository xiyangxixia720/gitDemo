//
//  SkuModel.h
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkuModel : NSObject

@property (nonatomic, strong) NSNumber *sku_stock;
@property (nonatomic, copy)   NSString *skuIDStr;
@property (nonatomic, strong) NSNumber *real_price;
@property (nonatomic, copy)   NSString *sku_name;

@end

NS_ASSUME_NONNULL_END
