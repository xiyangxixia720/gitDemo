//
//  MyAddressModel.m
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"addressID":@"id",
             };
}

@end
