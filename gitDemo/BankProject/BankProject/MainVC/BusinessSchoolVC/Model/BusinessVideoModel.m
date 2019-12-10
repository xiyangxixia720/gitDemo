//
//  BusinessVideoModel.m
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BusinessVideoModel.h"

@implementation BusinessVideoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"videoID":@"id",
             };
}

@end
