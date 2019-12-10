//
//  EditAddressViewController.m
//  BankProject
//
//  Created by mc on 2019/7/25.
//  Copyright © 2019 mc. All rights reserved.
//

#import "EditAddressViewController.h"
#import "AddressTableViewCell.h"
#import "EditATableViewCell.h"
#import "DetailATableViewCell.h"
#import "AdressModel.h"
#import "AdressTableViewCell.h"


@interface EditAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *detailTV;
@property (nonatomic, strong) AdressModel *aModel;


@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加地址";
    [self setIsShowRightBtn:YES];
    [self setRightBtnWithTitleStr:@"保存" withTitleColor:MainTonal action:@selector(rightBtnClick)];
    self.aModel = [[AdressModel alloc] init];
    
    if (!fStringIsEmpty(self.editIDStr)) {
        self.aModel.username = [self.infoDict objectForKey:@"name"];
        self.aModel.userphone = [self.infoDict objectForKey:@"phone"];
        self.aModel.province = [self.infoDict objectForKey:@"province"];
        self.aModel.city = [self.infoDict objectForKey:@"city"];
        self.aModel.area = [self.infoDict objectForKey:@"area"];
        self.aModel.addressDetail = [self.infoDict objectForKey:@"addressDetail"];
    }
    
    
    [self.view addSubview:self.tableView];
    
    [self getData];
}

- (void)getData
{

}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        static NSString *cellID = @"EditATableViewCell";
        EditATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EditATableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.EditTF.delegate = self;
        if (indexPath.section == 0) {
            if (fStringIsEmpty(self.aModel.username)) {
                cell.EditTF.placeholder = @"请输入收件人姓名";
            }else{
                cell.EditTF.text = self.aModel.username;
            }
            cell.EdtiTitleLabel.text = @"收件人";
            [cell.EditTF addTarget:self action:@selector(NameTFDidChange:) forControlEvents:UIControlEventEditingChanged];
        }else{
            if (fStringIsEmpty(self.aModel.userphone)) {
                cell.EditTF.placeholder = @"请输入收件人电话号码";
            }else{
                cell.EditTF.text = self.aModel.userphone;
            }
            cell.EdtiTitleLabel.text = @"联系方式";
            [cell.EditTF addTarget:self action:@selector(PhoneTFDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellID = @"AdressTableViewCell";
        AdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AdressTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (fStringIsEmpty(self.aModel.province)) {
            cell.detailLabel.text = @"";
        }else{
            cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@-%@",self.aModel.province,self.aModel.city,self.aModel.area];
        }
        return cell;
    }else{
        static NSString *cellID = @"DetailATableViewCell";
        DetailATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailATableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (fStringIsEmpty(self.aModel.addressDetail)) {
            cell.DetailTV.text = @"详细地址：如街道、门牌号、小区、单元室等...";
            cell.DetailTV.textColor = [UIColor grayColor];
        }else{
            cell.DetailTV.text = self.aModel.addressDetail;
            cell.DetailTV.textColor = [UIColor blackColor];
        }
        cell.DetailTV.delegate = self;
        self.detailTV = cell.DetailTV;
        return cell;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        self.detailTV.text = @"详细地址：如街道、门牌号、小区、单元室等...";
        self.detailTV.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"详细地址：如街道、门牌号、小区、单元室等..."]){
        self.detailTV.text = @"";
        self.detailTV.textColor = [UIColor blackColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.detailTV resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        self.aModel.addressDetail = textView.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 2) {
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:MainTonal resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            self.aModel.province = province.name;
            self.aModel.city = city.name;
            self.aModel.area = area.name;
            [self.tableView reloadData];
        } cancelBlock:^{
            
        }];
    }
}

- (void)NameTFDidChange:(UITextField *)theTextField
{
    self.aModel.username = theTextField.text;
}

- (void)PhoneTFDidChange:(UITextField *)theTextField
{
    self.aModel.userphone = theTextField.text;
}

- (void)rightBtnClick
{
    NSString *IDStr = [FLTools getUserID];
    NSString *usernameStr = self.aModel.username;
    NSString *phoneStr = self.aModel.userphone;
    NSString *province = self.aModel.province;
    NSString *cityStr = self.aModel.city;
    NSString *areaStr = self.aModel.area;
    NSString *detailStr = self.aModel.addressDetail;
    
    if (fStringIsEmpty(usernameStr)) {
        [self showErrorWithStr:@"收件人姓名不能为空"];
        return;
    }
    if (fStringIsEmpty(phoneStr)) {
        [self showErrorWithStr:@"收件人电话不能为空"];
        return;
    }
    if (fStringIsEmpty(detailStr)) {
        [self showErrorWithStr:@"详细地址不能为空"];
        return;
    }
    [self.view endEditing:YES];
    [self showLoadProgressWithStr:@"正在保存"];

    if (fStringIsEmpty(self.editIDStr)) {
        NSDictionary *sendD = @{@"userid":IDStr,
                                @"username":usernameStr,
                                @"userphone":phoneStr,
                                @"province":province,
                                @"city":cityStr,
                                @"area":areaStr,
                                @"addressDetail":detailStr,
                                };
        WEAK_SELF;
        [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/addAddress",MYURL] headStr:[FLTools getUserID] parameters:sendD success:^(id responseObject) {
            if ([[responseObject objectForKey:@"status"] intValue] == 200) {
                [weakSelf showSucessWihtStr:@"保存成功"];
                [weakSelf performSelector:@selector(afterLoadPopVC) withObject:nil afterDelay:1];
            }else{
                [weakSelf showErrorWithStr:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(id failure) {
            [weakSelf hideMyProgress];
        }];
    }else{
        NSDictionary *sendD = @{@"username":usernameStr,
                                @"userphone":phoneStr,
                                @"province":province,
                                @"city":cityStr,
                                @"area":areaStr,
                                @"addressDetail":detailStr,
                                @"id":self.editIDStr
                                };
        [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/updateAddress",MYURL] headStr:[FLTools getUserID] parameters:sendD success:^(id responseObject) {
            if ([[responseObject objectForKey:@"status"] intValue] == 200) {
                [self showSucessWihtStr:@"编辑成功"];
            }else{
                [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(id failure) {
            [self hideMyProgress];
        }];
    }
}

- (void)afterLoadPopVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 50;
    }else if (indexPath.section == 2){
        return 60;
    }else{
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
