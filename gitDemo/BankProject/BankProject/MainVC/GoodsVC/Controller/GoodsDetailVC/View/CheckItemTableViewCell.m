//
//  CheckItemTableViewCell.m
//  BankProject
//
//  Created by mc on 2019/7/18.
//  Copyright © 2019 mc. All rights reserved.
//

#import "CheckItemTableViewCell.h"
#import "CBGroupAndStreamView.h"
#import "SkuModel.h"


@interface CheckItemTableViewCell ()<CBGroupAndStreamDelegate>

@property (strong, nonatomic) CBGroupAndStreamView * checkV;
@property (strong, nonatomic) NSMutableArray *skuIDArr;
@property (strong, nonatomic) SkuModel *skuModel;
@property (strong, nonatomic) NSMutableArray *moneyArr;

@end

@implementation CheckItemTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.contentView.backgroundColor = [UIColor greenColor];

        
    }
    return self;
}

- (CBGroupAndStreamView *)checkV
{
    if (!_checkV) {
        _checkV = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
        _checkV.delegate = self;
        _checkV.isDefaultSel = NO;
        _checkV.radius = 10;
        _checkV.isDefaultSel = YES;
        _checkV.font = [UIFont systemFontOfSize:12];
        _checkV.titleTextFont = [UIFont systemFontOfSize:18];
        NSArray * tArr = @[@"规格"];
        [_checkV setContentView:@[self.titleArr] titleArr:tArr];
    }
    _checkV.isSingle = YES;
    return _checkV;
}

- (void)setTitleArr:(NSArray *)titleArr
{
    _titleArr = titleArr;

    self.skuIDArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.moneyArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *nowtitleArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < titleArr.count; i ++) {
        self.skuModel = titleArr[i];
        [self.skuIDArr addObject:self.skuModel.skuIDStr];
        [nowtitleArr addObject:self.skuModel.sku_name];
        [self.moneyArr addObject:self.skuModel.real_price];
    }
    _titleArr = nowtitleArr;
    [self addSubview:self.checkV];
    [self.checkV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];

}

#pragma mark---delegate
- (void)cb_confirmReturnValue:(NSArray *)valueArr groupId:(NSArray *)groupIdArr
{
    NSLog(@"valueArr = %@ \ngroupIdArr = %@",valueArr,groupIdArr);
}

- (void)cb_selectCurrentValueWith:(NSString *)value index:(NSInteger)index groupId:(NSInteger)groupId
{
    NSLog(@"value = %@----index = %ld------groupId = %ld",value,index,groupId);
    NSString *idStr = self.skuIDArr[index];
    NSString *moneyStr = self.moneyArr[index];
    if ([self.delegate respondsToSelector:@selector(selectSkuWithID:withMoney:)]) {
        [self.delegate selectSkuWithID:idStr withMoney:moneyStr];
    }
//    currentData = (int)index;
//    [self initUI];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"checkCell";
//    //1.判断是否存在可重用cell
//    CheckItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell){
//        [tableView registerNib:[UINib nibWithNibName:@"CheckItemTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
//        cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return cell;
//}

@end
