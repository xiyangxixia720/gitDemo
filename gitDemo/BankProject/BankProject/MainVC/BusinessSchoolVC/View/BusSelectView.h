//
//  BusSelectView.h
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BusSelectViewDelegate <NSObject>

- (void)clickIndex:(int)indexInt;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BusSelectView : UIView

@property (nonatomic, weak) id<BusSelectViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
