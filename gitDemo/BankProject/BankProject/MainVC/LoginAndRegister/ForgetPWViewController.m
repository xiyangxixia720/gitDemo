//
//  ForgetPWViewController.m
//  BankProject
//
//  Created by mc on 2019/7/22.
//  Copyright © 2019 mc. All rights reserved.
//

#import "ForgetPWViewController.h"

@interface ForgetPWViewController ()

{
    NSTimer *timer;
}

@end

@implementation ForgetPWViewController

static int forgetCount = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.phoneTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTF setValue:[NSNumber numberWithInt:35] forKey:@"paddingLeft"];
    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)codeBtnClick
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
    if (forgetCount == 0) {
        [timer invalidate];
        timer = nil;
        [self.codeBtn setTitle:@" 发送验证码 " forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:MainTonal forState:UIControlStateNormal];
        [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
        self.codeBtn.layer.borderColor = MainTonal.CGColor;
        self.codeBtn.layer.borderWidth = 1;
        self.codeBtn.layer.masksToBounds = YES;
        self.codeBtn.layer.cornerRadius = 5;
        forgetCount = 60;
        return;
    }
    forgetCount --;
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundColor:MainTonal];
    [self.codeBtn setTitle:[NSString stringWithFormat:@" (%d)秒后重发 ",forgetCount] forState:UIControlStateNormal];
}

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

- (IBAction)commitBtn:(id)sender
{
    if (self.phoneTF.text.length != 11) {
        [self showSucessWihtStr:@"手机号输入错误"];
        return;
    }
    if (self.codeTF.text.length != 6) {
        [self showSucessWihtStr:@"验证码输入错误"];
        return;
    }
    if (self.pwTF.text.length < 6 || self.pwTF.text.length > 16) {
        [self showSucessWihtStr:@"请输入6-16位密码"];
        return;
    }
    NSDictionary *infoDict = @{@"loginName":self.phoneTF.text,
                               @"pwd":self.pwTF.text,
                               @"smsCode":self.codeTF.text,
                               };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/findPwd",MYURL] headStr:nil parameters:infoDict success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"修改成功"];
        }
    } failure:^(id failure) {
        
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
