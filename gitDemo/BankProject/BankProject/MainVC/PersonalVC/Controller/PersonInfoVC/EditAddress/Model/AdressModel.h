//
//  AdressModel.h
//  ShoppingMall
//
//  Created by mc on 2019/7/2.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdressModel : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userphone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *addressDetail;

@end

NS_ASSUME_NONNULL_END
