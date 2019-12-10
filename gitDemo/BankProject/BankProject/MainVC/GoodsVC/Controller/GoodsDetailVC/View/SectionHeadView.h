//
//  SectionHeadView.h
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeadViewDelegate <NSObject>

- (void)isShowInfoClick:(BOOL)isShow withView:(UIView *_Nullable)sView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SectionHeadView : UIView

@property (nonatomic, strong) UILabel *titleLabe;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *choiceBtn;


@property (nonatomic, weak) id<SectionHeadViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
