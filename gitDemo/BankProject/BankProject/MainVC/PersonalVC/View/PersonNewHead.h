//
//  PersonNewHead.h
//  BankProject
//
//  Created by mc on 2019/7/24.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonNewHead : UIView
@property (weak, nonatomic) IBOutlet UIImageView *PersonImg;
@property (weak, nonatomic) IBOutlet UILabel *PersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIButton *EditBtn;
@property (weak, nonatomic) IBOutlet UILabel *LevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *AllPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *HasMoneyLabel;

@end

NS_ASSUME_NONNULL_END
