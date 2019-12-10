//
//  FLTools.m
//  ShoppingMall
//
//  Created by mc on 2019/6/27.
//  Copyright © 2019 mc. All rights reserved.
//

#import "FLTools.h"

@implementation FLTools

+ (BOOL)isLogin
{
    NSString *uid = [fUserDefaults objectForKey:@"userID"];
    if (fStringIsEmpty(uid)) {
        return NO;
    }
    return YES;
}

+ (NSString *)getUserID
{
    NSString *uid = [fUserDefaults objectForKey:@"userID"];
    return uid;
}

+ (void)Logout
{
    [fUserDefaults setObject:@"" forKey:@"userID"];
}

+ (NSString *)arrToJosonStrWithArr:(NSArray *)arr
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
