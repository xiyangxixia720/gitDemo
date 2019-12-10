//
//  MyOrderView.h
//  ShoppingMall
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyOrderViewDelegate <NSObject>

- (void)headClickIndex:(int)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderView : UIView

- (instancetype)initWithFrame:(CGRect)frame withType:(int)type;

@property (nonatomic, weak) id<MyOrderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
