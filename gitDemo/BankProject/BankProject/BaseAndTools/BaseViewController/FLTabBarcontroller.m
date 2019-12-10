//
//  FLTabBarcontroller.m
//  ShoppingMall
//
//  Created by mc on 2019/6/27.
//  Copyright © 2019 mc. All rights reserved.
//

#define nameFont 13
#define selectedColor [UIColor colorWithRed:86/255.0 green:193/255.0 blue:56/255.0 alpha:1]
#define normalColor [UIColor blackColor]

#import "FLTabBarcontroller.h"
#import "FLNavBaseViewController.h"

@interface FLTabBarcontroller ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation FLTabBarcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addRootVC];
}

- (void)addRootVC
{
    NSArray* controllerArr = @[@"HomeViewController", @"FindViewController",@"BusinessSchoolViewController",@"GoodsViewController",@"PersonalViewController"];
    //图片数组
    NSArray* imageArr = @[@"home", @"faxian", @"shangxueyuan",@"sahngpin",@"wode"];
    
    //高亮图片数组
    NSArray* selImageArr = @[@"home1", @"faxian1", @"shangxueyuan1",@"sahngpin1",@"wode1"];
    
    //标题数组
    NSArray *titleArr = @[@"首页",
                          @"发现",
                          @"商学院",
                          @"商品",
                          @"个人中心"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < controllerArr.count; i ++) {
        Class controller = NSClassFromString(controllerArr[i]);
        UIViewController *vc = [[controller alloc] init];
        //        vc.title = titleArr[i];
        FLNavBaseViewController *nav = [[FLNavBaseViewController alloc] initWithRootViewController:vc];
        nav.navigationBar.barTintColor = [UIColor whiteColor];
        nav.tabBarItem.image = [[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
        
        
        //字体大小，颜色（未被选中时）
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#aaaaaa"],NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica"size:nameFont],NSFontAttributeName,nil]forState:UIControlStateNormal];
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

        //字体大小，颜色（被选中时）
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MainTonal,NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica"size:nameFont],NSFontAttributeName,nil]forState:UIControlStateSelected];
        nav.tabBarItem.title = titleArr[i];
        [array addObject:nav];
    }
    self.viewControllers = array;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0)
{
    return YES;
}

@end
