//
//  WebViewController.h
//  MyFoundationProject
//
//  Created by mc on 2019/5/15.
//  Copyright © 2019 mc. All rights reserved.
//

#import "FLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : FLBaseViewController

@property (nonatomic, copy) NSString *webUrlStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *detailIDStr;

@end

NS_ASSUME_NONNULL_END
