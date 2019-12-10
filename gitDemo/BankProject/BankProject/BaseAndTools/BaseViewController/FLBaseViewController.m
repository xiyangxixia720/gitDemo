//
//  FLBaseViewController.m
//  Answer
//
//  Created by mc on 2019/6/17.
//  Copyright © 2019 mc. All rights reserved.
//

typedef void (^confirmClick) (void);

#import "FLBaseViewController.h"

@interface FLBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation FLBaseViewController

static BOOL isTap;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(receiveTap:) name:@"notiIsTap" object:nil];
    
    
    self.view.backgroundColor = BACKCOLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];


    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainTonal] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

//绑定的方法 带参数 是将通知本身给传过来
-(void)receiveTap:(NSNotification*)noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *ss = [dic objectForKey:@"name"];
    if ([ss isEqualToString:@"hideIsYes"]) {
        isTap = YES;
    }else{
        isTap = NO;
    }
    NSLog(@"dic == %@",dic);
}

// 什么时候调用，每次触发手势之前都会询问下代理方法，是否触发
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    if (isTap == YES) {
        return NO;
    }
    return YES;
}

/**
 * 导航右侧按钮
 */
- (void)setRightBtnWithTitleStr:(NSString *)rightTitle withTitleColor:(UIColor *)btnColor action:(SEL)action
{
    if (self.isShowRightBtn) {
        UIButton *rightBtn = rightBtn;
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:btnColor forState:UIControlStateNormal];
        rightBtn.bounds = CGRectMake(0,0,30,50);
        [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
}

- (void)setNavRightWithImg:(UIImage *)titleImg action:(SEL)action
{
    UIButton *rightBtn = rightBtn;
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:titleImg forState:UIControlStateNormal];
    rightBtn.bounds = CGRectMake(0,0,30,50);
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)setNavLeftTileWithTitle:(NSString *)titleStr
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = MainTonal;
    titleLabel.bounds = CGRectMake(0, 0, 30, 50);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/**
 * 提示和加载
 */
- (void)showErrorWIthStr:(NSString *)errorStr withErrorImage:(UIImage *)showImg
{
    [ProgressHUD showError:errorStr];
    [ProgressHUD imageError:showImg];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
}

- (void)showErrorWithStr:(NSString *)showStr
{
    [ProgressHUD showError:showStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
}

- (void)showSucessWihtStr:(NSString *)infoStr withSucImg:(UIImage *)img
{
    [ProgressHUD show:infoStr Interaction:YES];
    [ProgressHUD imageSuccess:img];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
}

- (void)showSucessWihtStr:(NSString *)sucessStr
{
    [ProgressHUD showSuccess:sucessStr];
}

- (void)showLoadProgressWithStr:(NSString *)showStr
{
    [ProgressHUD show:showStr Interaction:NO];
}

- (void)hideMyProgress
{
    [ProgressHUD dismiss];
}

- (void)showAlertVCWithTitle:(NSString *)title withMessage:(NSString *)message withConfirm:(void(^)(void))confirmBlock withCancel:(void(^)(void))cancelBlock withViewController:(UIViewController *)vc
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confirmBlock();
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }];
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)onlyShowConfirmVCWithTitle:(NSString *)title withMessage:(NSString *)message withConfirm:(void(^)(void))confirmBlock withViewController:(UIViewController *)vc
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confirmBlock();
    }];
    [alertVC addAction:confirm];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)showSheetVCWithTitle:(NSString *)title withMessage:(NSString *)message withItemArr:(NSArray *)itemArr withConfimItem:(void(^)(int index))indexBlock withViewController:(UIViewController *)vc
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < itemArr.count; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:itemArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            indexBlock(i);
        }];
        [alertVC addAction:action];
    }
    [vc presentViewController:alertVC animated:YES completion:nil];
}

@end
