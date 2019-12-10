//
//  FLBaseViewController.h
//  Answer
//
//  Created by mc on 2019/6/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isShowRightBtn;

/**
 *  设置导航右侧文字
 *
 *  @param rightTitle  标题
 *  @param btnColor    颜色
 *  @param action      点击事件
 */
- (void)setRightBtnWithTitleStr:(NSString *)rightTitle withTitleColor:(UIColor *)btnColor action:(SEL)action;

/**
 *  设置导航右侧图片按钮
 *
 *  @param titleImg    图片
 *  @param action      点击事件
 */
- (void)setNavRightWithImg:(UIImage *)titleImg action:(SEL)action;


/**
 *  设置导航左按钮label
 *
 *  @param titleStr  标题
 */
- (void)setNavLeftTileWithTitle:(NSString *)titleStr;


/*********************** 加载提示 *******************/
- (void)showErrorWIthStr:(NSString *)errorStr withErrorImage:(UIImage *)showImg;

- (void)showErrorWithStr:(NSString *)showStr;

- (void)showSucessWihtStr:(NSString *)infoStr withSucImg:(UIImage *)img;

- (void)showSucessWihtStr:(NSString *)sucessStr;

- (void)showLoadProgressWithStr:(NSString *)showStr;

- (void)hideMyProgress;

/**
  系统alert封装
 *
 */
- (void)showAlertVCWithTitle:(NSString *)title withMessage:(NSString *)message withConfirm:(void(^)(void))confirmBlock withCancel:(void(^)(void))cancelBlock withViewController:(UIViewController *)vc;

/**
 只显示确定
 *
 */
- (void)onlyShowConfirmVCWithTitle:(NSString *)title withMessage:(NSString *)message withConfirm:(void(^)(void))confirmBlock withViewController:(UIViewController *)vc;

/**
  系统sheet封装
 *
 */
- (void)showSheetVCWithTitle:(NSString *)title withMessage:(NSString *)message withItemArr:(NSArray *)itemArr withConfimItem:(void(^)(int index))indexBlock withViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
