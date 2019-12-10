//
//  BusinessContentModel.m
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BusinessContentModel.h"

@implementation BusinessContentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"contentID":@"id",
             };
}

@end
