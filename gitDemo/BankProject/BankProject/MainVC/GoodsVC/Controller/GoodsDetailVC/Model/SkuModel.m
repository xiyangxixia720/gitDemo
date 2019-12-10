//
//  SkuModel.m
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import "SkuModel.h"

@implementation SkuModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"skuIDStr":@"id",
             };
}

@end
