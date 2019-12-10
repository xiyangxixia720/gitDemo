//
//  ViewController.m
//  BankProject
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import "ViewController.h"
#import "FLTabBarcontroller.h"
#import "PWLoginViewController.h"
#import "FLNavBaseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FLTabBarcontroller *mainVC = [[FLTabBarcontroller alloc] init];
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    window.rootViewController = mainVC;
    
//    PWLoginViewController *loginVC = [[PWLoginViewController alloc] init];
//
//    FLNavBaseViewController *nav = [[FLNavBaseViewController alloc] initWithRootViewController:loginVC];
//    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
//
//    window.rootViewController = nav;

}


@end
