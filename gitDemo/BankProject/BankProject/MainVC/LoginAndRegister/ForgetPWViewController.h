//
//  ForgetPWViewController.h
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import "FLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPWViewController : FLBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@end

NS_ASSUME_NONNULL_END
