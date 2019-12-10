//
//  RegistTableViewCell.h
//  BankProject
//
//  Created by mc on 2019/7/15.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *ContenTF;

@end

NS_ASSUME_NONNULL_END
