//
//  FLNavBaseViewController.m
//  Answer
//
//  Created by mc on 2019/6/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import "FLNavBaseViewController.h"

@interface FLNavBaseViewController ()

@end

@implementation FLNavBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBar.backgroundColor = [UIColor redColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0) {
        viewController.navigationController.navigationBar.hidden = NO;
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"reture(7)"]forState:UIControlStateNormal];//设置返回按钮图片
        backButton.bounds = CGRectMake(0, 0, 30, 60);
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)backAction
{
    [self popViewControllerAnimated:YES];
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
