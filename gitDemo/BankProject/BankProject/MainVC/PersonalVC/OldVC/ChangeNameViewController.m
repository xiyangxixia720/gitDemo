//
//  ChangeNameViewController.m
//  BankProject
//
//  Created by mc on 2019/7/19.
//  Copyright © 2019 mc. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改昵称";
    [self initUI];
}

- (void)initUI
{
    UITextField *inputNameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, Nav_Height + 10, SCREEN_W, 45)];
    [inputNameTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [inputNameTF setValue:[NSNumber numberWithInt:28] forKey:@"paddingLeft"];
    inputNameTF.placeholder = @"  请输入昵称";
    inputNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputNameTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputNameTF];
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
