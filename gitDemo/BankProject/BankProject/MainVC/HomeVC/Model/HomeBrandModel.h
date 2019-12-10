//
//  HomeBrandModel.h
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBrandModel : NSObject

@property (nonatomic, strong) NSNumber *isHome;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, copy)   NSString *contentImg;
@property (nonatomic, copy)   NSString *brandID;
@property (nonatomic, strong) NSNumber *isShuffling;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *detials;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
