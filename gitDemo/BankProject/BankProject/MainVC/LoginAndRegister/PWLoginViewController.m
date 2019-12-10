//
//  PWLoginViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "PWLoginViewController.h"
#import "RegistViewController.h"
#import "CodeLoginViewController.h"
#import "FLTabBarcontroller.h"

@interface PWLoginViewController ()

{
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;

@end

@implementation PWLoginViewController

static int loginCount = 60;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden = YES;
    self.title = @"登录";
    self.navigationController.navigationBarHidden = NO;

    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.PhoneTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.PhoneTF setValue:[NSNumber numberWithInt:35] forKey:@"paddingLeft"];
}

- (void)codeBtnClick
{
    if (timer) {
        return;
    }
    if (self.PhoneTF.text.length != 11) {
        return;
    }
    [self loadCode];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)timerStart
{
    if (loginCount == 0) {
        [timer invalidate];
        timer = nil;
        [self.codeBtn setTitle:@" 发送验证码 " forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:MainTonal forState:UIControlStateNormal];
        [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
        self.codeBtn.layer.borderColor = MainTonal.CGColor;
        self.codeBtn.layer.borderWidth = 1;
        self.codeBtn.layer.masksToBounds = YES;
        self.codeBtn.layer.cornerRadius = 5;
        loginCount = 60;
        return;
    }
    loginCount --;
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundColor:MainTonal];
    [self.codeBtn setTitle:[NSString stringWithFormat:@" (%d)秒后重发 ",loginCount] forState:UIControlStateNormal];
}

- (IBAction)pwLoginBtnClick:(id)sender
{
    CodeLoginViewController *codeVC = [[CodeLoginViewController alloc] init];
    [self.navigationController pushViewController:codeVC animated:YES];
}

- (IBAction)registBtnClick:(id)sender
{
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}


#pragma mark ---  Network Request ---
- (void)loadCode
{
    [self.view endEditing:YES];
    if (self.PhoneTF.text.length != 11) {
        [self showSucessWihtStr:@"手机号输入错误"];
        return;
    }
    NSDictionary *send_d = @{@"loginName":self.PhoneTF.text};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@/app/login/sendSms",MYURL] headStr:nil  parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"发送成功"];
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)commitBtnClick:(id)sender
{
    if (self.PhoneTF.text.length != 11) {
        [self showErrorWithStr:@"请输入正确的手机号"];
        return;
    }
    if (self.CodeTF.text.length != 6) {
        [self showErrorWithStr:@"输入正确的验证码"];
        return;
    }
    NSDictionary *sendD = @{@"smscode":self.CodeTF.text,
                            @"userphone":self.PhoneTF.text,
                            @"type":@"1",
                            };
    [self.view endEditing:YES];
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@/app/login/login",MYURL] headStr:nil parameters:sendD success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"登录成功"];
            [self performSelector:@selector(afterLoad) withObject:nil afterDelay:1];
            NSDictionary *infoDict = [responseObject objectForKey:@"data"];
            [fUserDefaults setObject:[infoDict objectForKey:@"id"] forKey:@"userID"];
            [fUserDefaults setObject:[infoDict objectForKey:@"realname"] forKey:@"realname"];
            [fUserDefaults setObject:[infoDict objectForKey:@"levelName"] forKey:@"levelName"];
            [fUserDefaults setObject:[infoDict objectForKey:@"userphone"] forKey:@"userphone"];
            [fUserDefaults setObject:[infoDict objectForKey:@"address"] forKey:@"address"];
            [fUserDefaults setObject:[infoDict objectForKey:@"idcardFront"] forKey:@"idcardFront"];
            [fUserDefaults setObject:[infoDict objectForKey:@"idcardReverse"] forKey:@"idcardReverse"];
            
            [fUserDefaults setObject:[infoDict objectForKey:@"code"] forKey:@"code"];
            [fUserDefaults setObject:[infoDict objectForKey:@"buyResults"] forKey:@"buyResults"];
            [fUserDefaults setObject:[infoDict objectForKey:@"reward"] forKey:@"reward"];


        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(id failure) {
        
    }];
}

- (void)afterLoad
{
    FLTabBarcontroller *mainVC = [[FLTabBarcontroller alloc] init];
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    window.rootViewController = mainVC;
}

@end
