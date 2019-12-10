//
//  FindHeadView.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "FindHeadView.h"

@interface FindHeadView()

@property (nonatomic, strong) UITextField *inputTF;

@end

@implementation FindHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        float self_w = self.frame.size.width;
        
        FLButton *leftBtn = [FLButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"授权查询" forState:UIControlStateNormal];
        leftBtn.imageRect = CGRectMake(10, 0, 60, 60);
        leftBtn.titleRect = CGRectMake(0, 70, 80, 20);
        leftBtn.frame = CGRectMake(60, 0, 80, 100);
        leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        leftBtn.tag = 1;
        [leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"shouquan1"] forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        
        FLButton *rightBtn = [FLButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"防伪查询" forState:UIControlStateNormal];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        rightBtn.tag = 2;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.imageRect = CGRectMake(10, 0, 60, 60);
        rightBtn.titleRect = CGRectMake(0, 70, 80, 20);
        rightBtn.frame = CGRectMake(self_w - 140, 0, 80, 100);
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"fangweichaxun"] forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        
        UITextField *inputTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, self_w - 120, 36)];
        self.inputTF = inputTF;
        inputTF.placeholder = @"请输入代理商推荐码";
        inputTF.font = [UIFont systemFontOfSize:15];
        inputTF.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:inputTF];
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake(self_w - 95, 120, 90, 36);
        [checkBtn setTitle:@"查询" forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.layer.masksToBounds = YES;
        checkBtn.layer.cornerRadius = 5;
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkBtn setBackgroundColor:MainTonal];
        [self addSubview:checkBtn];
    }
    return self;
}

- (void)BtnClick:(UIButton *)btn
{
    int indexInt = (int)btn.tag;
    self.returnIndex(indexInt);
}

- (void)checkBtnClick
{
    if (self.inputTF.text.length == 0) {
        return;
    }
    NSDictionary *sendD = @{@"shopCode":self.inputTF.text};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/home/selectContentByType",MYURL] headStr:nil parameters:sendD success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            self.alertStrBlock([responseObject objectForKey:@"msg"]);
        }else{
            self.alertStrBlock([responseObject objectForKey:@"msg"]);
        }
    } failure:^(id failure) {
        
    }];
}

@end
