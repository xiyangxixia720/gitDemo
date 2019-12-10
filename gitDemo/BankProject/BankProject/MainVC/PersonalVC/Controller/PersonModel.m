//
//  PersonModel.m
//  BankProject
//
//  Created by mc on 2019/8/19.
//  Copyright © 2019 mc. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"personID":@"id",
             };
}

@end
