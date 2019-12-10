//
//  PersonHeadV.h
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonHeadV : UIView
@property (weak, nonatomic) IBOutlet UIImageView *peronImg;
@property (weak, nonatomic) IBOutlet UILabel *personTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *EditBtn;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *OrderView;
@property (weak, nonatomic) IBOutlet UIView *OrderView1;
@property (weak, nonatomic) IBOutlet UIView *OrderView2;

@end

NS_ASSUME_NONNULL_END
