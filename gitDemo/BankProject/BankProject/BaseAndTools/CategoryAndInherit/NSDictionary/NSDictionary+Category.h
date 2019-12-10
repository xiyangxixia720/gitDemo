//
//  NSDictionary+Category.h
//  Healthy
//
//  Created by mc on 2019/5/10.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Category)

- (id)safeStringObjectForKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
