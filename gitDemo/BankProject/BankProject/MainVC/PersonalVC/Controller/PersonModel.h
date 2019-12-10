//
//  PersonModel.h
//  BankProject
//
//  Created by mc on 2019/8/19.
//  Copyright © 2019 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : NSObject

@property (nonatomic, copy) NSString *personID;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userphone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *idcardFront;
@property (nonatomic, copy) NSString *wechatno;
@property (nonatomic, copy) NSString *idcardReverse;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) NSNumber *reward;
@property (nonatomic, strong) NSNumber *buyResults;
@property (nonatomic, copy) NSString *headImg;

@end

NS_ASSUME_NONNULL_END
