//
//  MyOrderModel.h
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderModel : NSObject

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, copy)   NSString *ordercode;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy)   NSString *shop_img;
@property (nonatomic, copy)   NSString *shop_name;
@property (nonatomic, strong) NSNumber *pay_money;
@property (nonatomic, strong) NSNumber *shop_money;
@property (nonatomic, copy)   NSString *sku_name;


@end

NS_ASSUME_NONNULL_END
