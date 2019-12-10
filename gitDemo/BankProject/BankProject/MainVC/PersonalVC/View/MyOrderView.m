//
//  MyOrderView.m
//  ShoppingMall
//
//  Created by mc on 2019/7/11.
//  Copyright © 2019 mc. All rights reserved.
//

#import "MyOrderView.h"

@interface MyOrderView()

{
    int selectedIndex;
}

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIView *redView;

@end

@implementation MyOrderView

- (instancetype)initWithFrame:(CGRect)frame withType:(int)type
{
    if (self = [super initWithFrame:frame]) {
        selectedIndex = 0;
        NSArray *titleArr = @[@"未发货",@"已发货",@"全部订单"];
        float btn_w = SCREEN_W/3;
        for (int i = 0; i < 3; i ++) {
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            titleBtn.tag = i;
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn.frame = CGRectMake(btn_w * i, 0, btn_w, 45);
            if (i == type) {
                titleBtn.selected = YES;
                self.selectedBtn = titleBtn;
                [titleBtn setTitleColor:MainTonal forState:UIControlStateSelected];
            }
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:titleBtn];
        }
        
        UIView *redView = [[UIView alloc] init];
        redView.backgroundColor = MainTonal;
        redView.frame = CGRectMake(btn_w * type, self.frame.size.height - 2, btn_w, 1);
        self.redView = redView;
        [self addSubview:redView];
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        lineV.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
        [self addSubview:lineV];
    }
    return self;
}

- (void)titleBtnClick:(UIButton *)btnButton
{
    float btn_X = btnButton.center.x;
    float btn_Y = self.frame.size.height - 1;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.redView.center = CGPointMake(btn_X, btn_Y);
    [UIView commitAnimations];
    
    int index = (int)btnButton.tag;
    if ([self.delegate respondsToSelector:@selector(headClickIndex:)]) {
        [self.delegate headClickIndex:index];
    }
    if (btnButton!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        btnButton.selected = YES;
        self.selectedBtn = btnButton;
        [btnButton setTitleColor:MainTonal forState:UIControlStateSelected];
    }else{
        self.selectedBtn.selected = YES;
    }
}

@end
