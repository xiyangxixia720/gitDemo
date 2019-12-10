//
//  RegLevelModel.h
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegLevelModel : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy)   NSString *levelID;
@property (nonatomic, copy)   NSString *levelName;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, strong) NSNumber *shopNumber;
@property (nonatomic, strong) NSNumber *rewardNumber;

@end

NS_ASSUME_NONNULL_END
