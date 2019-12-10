//
//  BusinessVideoModel.h
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessVideoModel : NSObject

@property (nonatomic, strong) NSNumber *isHome;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy)   NSString *videoID;
@property (nonatomic, copy)   NSString *videoImg;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy)   NSString *video;


@end

NS_ASSUME_NONNULL_END
