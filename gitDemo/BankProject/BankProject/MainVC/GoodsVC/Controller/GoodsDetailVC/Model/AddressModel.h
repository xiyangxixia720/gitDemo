//
//  AddressModel.h
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject

@property (nonatomic, strong) NSNumber *isdefault;
@property (nonatomic, copy)   NSString *area;
@property (nonatomic, copy)   NSString *city;
@property (nonatomic, copy)   NSString *ctime;
@property (nonatomic, copy)   NSString *addressIDStr;
@property (nonatomic, strong) NSNumber *isdelete;
@property (nonatomic, copy)   NSString *addressDetail;
@property (nonatomic, copy)   NSString *userid;
@property (nonatomic, copy)   NSString *username;
@property (nonatomic, copy)   NSString *userphone;
@property (nonatomic, copy)   NSString *province;

@end

NS_ASSUME_NONNULL_END
