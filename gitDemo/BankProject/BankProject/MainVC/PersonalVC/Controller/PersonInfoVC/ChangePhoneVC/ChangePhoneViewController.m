//
//  ChangePhoneViewController.m
//  BankProject
//
//  Created by mc on 2019/7/19.
//  Copyright © 2019 mc. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()

{
    NSTimer *timer;
}
    
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
@property (weak, nonatomic) IBOutlet UIButton *CodeBtn;

@end

@implementation ChangePhoneViewController

static int changePhoneCount = 60;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.CodeBtn addTarget:self action:@selector(CodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)CodeBtnClick
{
    if (timer) {
        return;
    }
    if (self.phoneTF.text.length != 11) {
        return;
    }
    [self loadCode];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)timerStart
{
    if (changePhoneCount == 0) {
        [timer invalidate];
        timer = nil;
        [self.CodeBtn setTitle:@" 发送验证码 " forState:UIControlStateNormal];
        [self.CodeBtn setTitleColor:MainTonal forState:UIControlStateNormal];
        [self.CodeBtn setBackgroundColor:[UIColor whiteColor]];
        self.CodeBtn.layer.borderColor = MainTonal.CGColor;
        self.CodeBtn.layer.borderWidth = 1;
        self.CodeBtn.layer.masksToBounds = YES;
        self.CodeBtn.layer.cornerRadius = 5;
        changePhoneCount = 60;
        return;
    }
    changePhoneCount --;
    [self.CodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.CodeBtn setBackgroundColor:MainTonal];
    [self.CodeBtn setTitle:[NSString stringWithFormat:@" (%d)秒后重发 ",changePhoneCount] forState:UIControlStateNormal];
}

- (IBAction)commitBtnClick:(id)sender
{
    if (self.phoneTF.text.length != 11) {
        [self showErrorWithStr:@"请输入正确的手机号"];
        return;
    }
    if (self.CodeTF.text.length != 6) {
        [self showErrorWithStr:@"请输入6位验证码"];
        return;
    }
    NSDictionary *sendD = @{@"loginName":[fUserDefaults objectForKey:@"userphone"],
                            @"phone":self.phoneTF.text,
                            @"smsCode":self.CodeTF.text,
                            };
    [self.view endEditing:YES];
    WEAK_SELF;
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/updatePhone",MYURL] headStr:[FLTools getUserID] parameters:sendD success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [weakSelf showSucessWihtStr:@"修改成功"];
            [fUserDefaults setObject:weakSelf.phoneTF.text forKey:@"userphone"];
        }else{
            [weakSelf showSucessWihtStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(id failure) {
        
    }];
}

#pragma mark ---  Network Request ---
- (void)loadCode
{
    [self.view endEditing:YES];
    if (self.phoneTF.text.length != 11) {
        [self showSucessWihtStr:@"手机号输入错误"];
        return;
    }
    NSDictionary *send_d = @{@"loginName":self.phoneTF.text};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@/app/login/sendSms",MYURL] headStr:nil  parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"发送成功"];
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
