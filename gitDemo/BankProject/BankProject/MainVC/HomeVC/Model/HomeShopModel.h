//
//  HomeShopModel.h
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeShopModel : NSObject

@property (nonatomic, copy)   NSString *shopID;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy)   NSString *detials;
@property (nonatomic, copy)   NSString *shopImg;
@property (nonatomic, copy)   NSString *shopcode;
@property (nonatomic, strong) NSNumber *sellPrice;
@property (nonatomic, strong) NSNumber *isShuffling;
@property (nonatomic, strong) NSNumber *isHome;
@property (nonatomic, copy)   NSString *detialsImg;
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, copy)   NSString *shopName;
@property (nonatomic, copy)   NSString *imgs;
@property (nonatomic, strong) NSNumber *shopStock;
@property (nonatomic, copy)   NSString *homeImg;



@end

NS_ASSUME_NONNULL_END