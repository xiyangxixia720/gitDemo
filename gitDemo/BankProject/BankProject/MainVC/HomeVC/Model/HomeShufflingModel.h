//
//  HomeShufflingModel.h
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeShufflingModel : NSObject

@property (nonatomic, copy)   NSString *shufflingID;
@property (nonatomic, copy)   NSString *img;
@property (nonatomic, strong) NSNumber *status;

@end

NS_ASSUME_NONNULL_END
