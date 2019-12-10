//
//  NSDictionary+Category.m
//  Healthy
//
//  Created by mc on 2019/5/10.
//  Copyright © 2019 mc. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (id)safeStringObjectForKey:(NSString*)key {
    id object = [self objectForKey:key];
    // 字典中没key时value为<nil>
    if (![[self allKeys] containsObject:key]) {
        object = nil;
    }
    if ([[object class] isSubclassOfClass:[NSNull class]]) {
        object = nil;
    } else if ([[object class] isSubclassOfClass:[NSNumber class]]) {
        // 判断NSNumber是不是小数
        if (([object doubleValue] - floor([object doubleValue]) < 0.01)) {
            object = [NSString stringWithFormat:@"%ld",(long)[object integerValue]];
        } else {
            object = [NSString stringWithFormat:@"%.2f",[object doubleValue]];
        }
    }
    return object;
}

- (NSDictionary *)deleteAllNullValue
{    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr]isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }else{
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}



@end
