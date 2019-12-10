//
//  WebModel.h
//  BankProject
//
//  Created by mc on 2019/7/28.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebModel : NSObject

@property (nonatomic, strong) NSNumber *isHome;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *contentImg;
@property (nonatomic, strong) NSString *webIDStr;
@property (nonatomic, strong) NSNumber *isShuffling;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *detials;
@property (nonatomic, strong) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
