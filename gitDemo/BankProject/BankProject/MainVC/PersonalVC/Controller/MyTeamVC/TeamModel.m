//
//  TeamModel.m
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import "TeamModel.h"

@implementation TeamModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"teamID":@"id",
             };
}
@end
