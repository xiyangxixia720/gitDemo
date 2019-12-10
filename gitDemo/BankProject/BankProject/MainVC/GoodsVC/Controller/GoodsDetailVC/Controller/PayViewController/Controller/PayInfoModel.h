//
//  PayInfoModel.h
//  BankProject
//
//  Created by mc on 2019/7/26.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayInfoModel : NSObject

@property (nonatomic, strong) NSString *ordercode;
@property (nonatomic, strong) NSNumber *number;
@property (strong, nonatomic) NSDictionary *address;
@property (nonatomic, strong) NSNumber *totalMoney;
@property (nonatomic, strong) NSString *shopimg;
@property (nonatomic, strong) NSString *skuname;
@property (nonatomic, strong) NSString *shop_money;
@property (nonatomic, strong) NSString *shopname;

@end

NS_ASSUME_NONNULL_END
