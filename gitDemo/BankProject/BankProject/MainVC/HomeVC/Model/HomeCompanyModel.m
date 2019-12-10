//
//  HomeCompanyModel.m
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import "HomeCompanyModel.h"

@implementation HomeCompanyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"companyID":@"id",
             };
}

@end
