//
//  BoutiqueView.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "BoutiqueView.h"

@interface BoutiqueView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *aniView;

@end

@implementation BoutiqueView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        float self_w = self.frame.size.width;
        float self_H = self.frame.size.height - 15;
        UIScrollView *infoScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self_w, self_H)];
        infoScrollV.contentSize = CGSizeMake(self_w * 2, self_H);
        infoScrollV.showsHorizontalScrollIndicator = NO;
        infoScrollV.delegate = self;
        infoScrollV.pagingEnabled = YES;
        [self addSubview:infoScrollV];
        
        float b_w = (self_w - 15 * 4)/3;
        for (int i = 0; i < 6; i ++) {
            
            UIView *bView = [[UIView alloc] init];
            if (i >= 3) {
                bView.frame = CGRectMake(10 + (b_w + 15) * i + 20, 0, b_w, self_H);
            }else{
                bView.frame = CGRectMake(15 + (b_w + 15) * i, 0, b_w, self_H);
            }
            
            UIImageView *topImg = [[UIImageView alloc] init];
            topImg.image = [UIImage imageNamed:@"img222"];
            topImg.frame = CGRectMake(0, 0, b_w, self_H - 40);
            [bView addSubview:topImg];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.text = @"商品名称商品名称 商品名称";
            nameLabel.font = [UIFont systemFontOfSize:13];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.numberOfLines = 2;
            nameLabel.frame = CGRectMake(0, self_H - 40, b_w, 36);
            [bView addSubview:nameLabel];
            
            [infoScrollV addSubview:bView];
        }
        
        UIView *tipV = [[UIView alloc] init];
        tipV.backgroundColor = [UIColor colorWithHexString:@"#FFD9C38C"];
        tipV.layer.masksToBounds = YES;
        tipV.layer.cornerRadius = 3;
        [self addSubview:tipV];
        [tipV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoScrollV.mas_bottom).valueOffset(@(8));
            make.centerX.mas_equalTo(self);
            make.width.valueOffset(@(50));
            make.height.valueOffset(@(6));
        }];
        
        UIView *aniView = [[UIView alloc] init];
        aniView.frame = CGRectMake(0, 0, 25, 6);
        aniView.backgroundColor = [UIColor colorWithHexString:@"#87481f"];
        aniView.layer.masksToBounds = YES;
        aniView.layer.cornerRadius = 2;
        self.aniView = aniView;
        [tipV addSubview:aniView];
    }
    return self;
}

#pragma mark --- scrollViewDelegate ---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.aniView.frame = CGRectMake(page * 25, 0, 25, 6);
    } completion:nil];
}

@end
