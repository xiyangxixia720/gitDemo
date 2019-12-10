//
//  HomeBrandModel.m
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import "HomeBrandModel.h"

@implementation HomeBrandModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"brandID":@"id",
             };
}

@end
