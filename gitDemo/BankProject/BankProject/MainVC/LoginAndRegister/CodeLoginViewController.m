//
//  CodeLoginViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "CodeLoginViewController.h"
#import "RegistViewController.h"
#import "FLTabBarcontroller.h"
#import "ForgetPWViewController.h"

@interface CodeLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;

@end

@implementation CodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    [self.phoneTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTF setValue:[NSNumber numberWithInt:35] forKey:@"paddingLeft"];
}

- (IBAction)forgetBtnClick:(id)sender
{
    ForgetPWViewController *forgetVC = [[ForgetPWViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (IBAction)LoginBtnClick:(id)sender
{
    if (self.phoneTF.text.length != 11) {
        [self showErrorWithStr:@"请输入正确的手机号"];
        return;
    }
    if (self.pwTF.text.length < 6 || self.pwTF.text.length > 16) {
        [self showErrorWithStr:@"输入6-16密码"];
        return;
    }
    NSDictionary *sendD = @{@"password":self.pwTF.text,
                            @"userphone":self.phoneTF.text,
                            @"type":@"2",
                            };
    [self.view endEditing:YES];
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@/app/login/login",MYURL] headStr:nil parameters:sendD success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"登录成功"];
            [self performSelector:@selector(afterLoad) withObject:nil afterDelay:1];
            NSDictionary *infoDict = [responseObject safeStringObjectForKey:@"data"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"id"] forKey:@"userID"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"realname"] forKey:@"realname"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"levelName"] forKey:@"levelName"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"userphone"] forKey:@"userphone"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"address"] forKey:@"address"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"idcardFront"] forKey:@"idcardFront"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"idcardReverse"] forKey:@"idcardReverse"];
            
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"code"] forKey:@"code"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"buyResults"] forKey:@"buyResults"];
            [fUserDefaults setObject:[infoDict safeStringObjectForKey:@"reward"] forKey:@"reward"];
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

- (IBAction)codeLoginBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)regitstBtnClick:(id)sender
{
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
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
