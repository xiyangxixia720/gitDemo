//
//  BusSelectView.m
//  BankProject
//
//  Created by mc on 2019/7/17.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BusSelectView.h"

@interface BusSelectView()

{
    int selectedIndex;
}

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIImageView *redView;

@end

@implementation BusSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        selectedIndex = 0;
        NSArray *titleArr = @[@"营销课程",@"朋友圈打造",@"素材中心"];
        float btn_w = SCREEN_W/3;
        for (int i = 0; i < 3; i ++) {
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            titleBtn.tag = i + 2;
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            titleBtn.frame = CGRectMake(btn_w * i, 5, btn_w, 40);
            if (i == 0) {
                titleBtn.selected = YES;
                self.selectedBtn = titleBtn;
                [titleBtn setTitleColor:MainTonal forState:UIControlStateSelected];
            }
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:titleBtn];
        }
        
        UIImageView *redView = [[UIImageView alloc] init];
        redView.image = [UIImage imageNamed:@"bg1"];
        redView.frame = CGRectMake(0, 5, btn_w, 40);
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
    float btn_Y = btnButton.center.y;
    self.redView.center = CGPointMake(btn_X, btn_Y);
    
    int index = (int)btnButton.tag;
    if ([self.delegate respondsToSelector:@selector(clickIndex:)]) {
        [self.delegate clickIndex:index];
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
