//
//  SectionHeadView.m
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import "SectionHeadView.h"

@interface SectionHeadView()

//@property (nonatomic, strong) UILabel *titleLabe;
//@property (nonatomic, strong) UILabel *contentLabel;
//@property (nonatomic, strong) UIButton *choiceBtn;

@end

@implementation SectionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = BACKCOLOR;
        lineView.frame = CGRectMake(0, 0, SCREEN_W, 10);
        [self addSubview:lineView];

        self.titleLabe = [[UILabel alloc] init];
//        self.titleLabe.text = @"属性";
        self.titleLabe.textColor = [UIColor grayColor];
        self.titleLabe.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.titleLabe];
        
        self.contentLabel = [[UILabel alloc] init];
//        self.contentLabel.text = @"查看详情";
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.contentLabel];
        
        
        [self addSubview:self.choiceBtn];
    }
    return self;
}

- (UIButton *)choiceBtn
{
    if (!_choiceBtn) {
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choiceBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_choiceBtn addTarget:self action:@selector(choiceBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [_choiceBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    }
    return _choiceBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).valueOffset(@(20));
        make.left.equalTo(self).valueOffset(@(15));
        make.height.valueOffset(@(20));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabe);
        make.left.equalTo(self.titleLabe.mas_right).valueOffset(@(10));
        make.height.valueOffset(@(20));
    }];
    
    [self.choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabe);
        make.right.equalTo(self).valueOffset(@(-15));
        make.height.width.valueOffset(@(35));
    }];
}

- (void)choiceBtnCLick:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
    }else{
        button.selected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(isShowInfoClick:withView:)]) {
        [self.delegate isShowInfoClick:button.selected withView:self];
    }
}

@end
