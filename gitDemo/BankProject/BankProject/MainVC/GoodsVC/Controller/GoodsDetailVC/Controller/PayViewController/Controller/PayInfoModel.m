//
//  PayInfoModel.m
//  BankProject
//
//  Created by mc on 2019/7/26.
//  Copyright © 2019 mc. All rights reserved.
//

#import "PayInfoModel.h"

@implementation PayInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"addressId":@"id",
             @"isdefault":@"address.isdefault",
             @"area":@"address.area", // 声明sex字段在sexDic下的sex
             @"city":@"address.city",
             @"ctime":@"address.ctime",
             @"isdelete":@"address.isdelete",
             @"addressDetail":@"address.addressDetail",
             @"userid":@"address.userid",
             @"username":@"address.username",
             @"userphone":@"address.userphone",
             @"province":@"address.province",
             };
}

@end
