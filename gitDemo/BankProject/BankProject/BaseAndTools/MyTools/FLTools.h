//
//  FLTools.h
//  ShoppingMall
//
//  Created by mc on 2019/6/27.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTools : NSObject

/**
 判断是否登录
 @return YES：登录   NO：为登录
 */
+ (BOOL)isLogin;

/**
 获取userID
 *
 */
+ (NSString *)getUserID;

/**
 退出登录
 *
 */
+ (void)Logout;

/**
 数组转json字符串
 *
 */
+ (NSString *)arrToJosonStrWithArr:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
