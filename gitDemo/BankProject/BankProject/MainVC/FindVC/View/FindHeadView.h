//
//  FindHeadView.h
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnIndexBlock)(int index);
typedef void (^returnAlertBlock)(NSString *alertStr);

NS_ASSUME_NONNULL_BEGIN

@interface FindHeadView : UIView

@property (nonatomic, copy) returnIndexBlock returnIndex;
@property (nonatomic, copy) returnAlertBlock alertStrBlock;
@end

NS_ASSUME_NONNULL_END
