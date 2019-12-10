//
//  AddressModel.m
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"addressIDStr":@"id",
             };
}

@end
