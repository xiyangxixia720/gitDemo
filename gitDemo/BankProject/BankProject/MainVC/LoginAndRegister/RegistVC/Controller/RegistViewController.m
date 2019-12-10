//
//  RegistViewController.m
//  BankProject
//
//  Created by mc on 2019/7/12.
//  Copyright © 2019 mc. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistTableViewCell.h"
#import "RegistFootV.h"
#import "RegistModel.h"
#import "RegLevelModel.h"
#import "UploadParam.h"


@interface RegistViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    NSTimer *timer;
    NSString *idcard_front;
    NSString *idcard_reverse;
    BOOL isVisable;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeHArr;
@property (nonatomic, strong) RegistModel *registM;
@property (nonatomic, strong) RegLevelModel *levelM;
@property (nonatomic, strong) UIImageView *zhenImg;
@property (nonatomic, strong) UIImageView *fanImg;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) NSMutableArray *levelArr;

@end

@implementation RegistViewController

static int downCount = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.levelArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self getLevel];
    [self initData];
    [self initUI];
}

- (void)initData
{
    self.registM = [[RegistModel alloc] init];
    self.titleArr = @[@"姓名",@"手机号",@"验证码",@"密码",@"微信号",@"上级编号",@"申请级别",@"现居地址",@"身份证号"];
    self.placeHArr = @[@"请填写姓名",
                       @"请填写手机号",
                       @"请输入验证码",
                       @"请输入6-16位密码",
                       @"请填写微信号",
                       @"请填写你的上级编号",
                       @"请填写申请级别",
                       @"例：陕西西安",
                       @"请填写你的身份证号"];
}

- (void)initUI
{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - Nav_Height - HomeIndicator) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    _tableView.tableFooterView = [self getFootV];
    return _tableView;
}

- (UIView *)getFootV
{
    RegistFootV *registF = [[[NSBundle mainBundle] loadNibNamed:@"RegistFootV" owner:self options:nil] lastObject];
    registF.frame = CGRectMake(0, 0, SCREEN_W, 260);
    [registF.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    registF.zhengImg.userInteractionEnabled = YES;
    registF.fanImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *zhenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhenTapClick)];
    [registF.zhengImg addGestureRecognizer:zhenTap];
    self.zhenImg = registF.zhengImg;
    
    UITapGestureRecognizer *fanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fanTapClick)];
    [registF.fanImg addGestureRecognizer:fanTap];
    self.fanImg = registF.fanImg;
    
    return registF;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    RegistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RegistTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 1) {
        self.phoneTF = cell.ContenTF;
    }
    if (indexPath.row == 2) {
        UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn setBackgroundColor:[UIColor whiteColor]];
        [codeBtn setTitleColor:MainTonal forState:UIControlStateNormal];
        codeBtn.frame = CGRectMake(SCREEN_W - 120, 8, 100, 35);
        codeBtn.layer.masksToBounds = YES;
        codeBtn.layer.cornerRadius  = 5;
        codeBtn.layer.borderWidth = 1;
        codeBtn.layer.borderColor = MainTonal.CGColor;
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.codeBtn = codeBtn;
        [cell.contentView addSubview:codeBtn];
    }
    cell.TitleLabel.text = self.titleArr[indexPath.row];
    cell.ContenTF.placeholder = self.placeHArr[indexPath.row];
    cell.ContenTF.text = [self getContentStrWithIndexRow:indexPath.row];
    cell.ContenTF.tag = indexPath.item;
    cell.ContenTF.delegate = self;
    [cell.ContenTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (NSString *)getContentStrWithIndexRow:(NSInteger)row
{
    if (row == 0) {
        if (!fStringIsEmpty(self.registM.nameStr)) {
            return self.registM.nameStr;
        }else{
            return nil;
        }
    }else if (row == 1){
        if (!fStringIsEmpty(self.registM.phoneStr)) {
            return self.registM.phoneStr;
        }else{
            return nil;
        }
    }else if (row == 2){
        if (!fStringIsEmpty(self.registM.codeStr)) {
            return self.registM.codeStr;
        }else{
            return nil;
        }
    }else if (row == 3){
        if (!fStringIsEmpty(self.registM.pwStr)) {
            return self.registM.pwStr;
        }else{
            return nil;
        }
    }else if (row == 4){
        if (!fStringIsEmpty(self.registM.weiXinStr)) {
            return self.registM.weiXinStr;
        }else{
            return nil;
        }
    }else if (row == 5){
        if (!fStringIsEmpty(self.registM.bossNameStr)) {
            return self.registM.bossNameStr;
        }else{
            return nil;
        }
    }else if (row == 6){
        if (!fStringIsEmpty(self.registM.levelStr)) {
            return self.registM.levelStr;
        }else{
            return nil;
        }
    }else if (row == 7){
        if (!fStringIsEmpty(self.registM.placeStr)) {
            return self.registM.placeStr;
        }else{
            return nil;
        }
    }else{
        if (!fStringIsEmpty(self.registM.IDStr)) {
            return self.registM.IDStr;
        }else{
            return nil;
        }
    }
}

#pragma mark --- textFieldDelegate ---
- (void)changedTextField:(UITextField *)textField
{
    int tfTag = (int)textField.tag;
    if (tfTag == 0) {
        self.registM.nameStr = textField.text;
    }else if (tfTag == 1){
        self.registM.phoneStr = textField.text;
    }else if (tfTag == 2){
        self.registM.codeStr = textField.text;
    }else if (tfTag == 3){
        self.registM.pwStr = textField.text;
    }else if (tfTag == 4){
        self.registM.weiXinStr = textField.text;
    }
    else if (tfTag == 5){
        self.registM.bossNameStr = textField.text;
    }else if (tfTag == 6){
        self.registM.levelStr = textField.text;
    }else if (tfTag == 7){
        self.registM.placeStr = textField.text;
    }else{
        self.registM.IDStr = textField.text;
    }
}



- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - Nav_Height - HomeIndicator);
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int tfTag = (int)textField.tag;
    if (tfTag >= 3) {
        self.tableView.frame = CGRectMake(0, -80, SCREEN_W, SCREEN_H - Nav_Height - HomeIndicator);
    }
    if (tfTag == 6) {
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;

        NSMutableArray *leveTitleArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < self.levelArr.count; i ++) {
            self.levelM = self.levelArr[i];
            [leveTitleArr addObject:self.levelM.levelName];
        }
        [BRStringPickerView showStringPickerWithTitle:@"申请级别" dataSource:leveTitleArr defaultSelValue:@"" resultBlock:^(id selectValue) {
            weakSelf.registM.levelStr = selectValue;
            NSUInteger index = [leveTitleArr indexOfObject:selectValue];
            weakSelf.levelM = weakSelf.levelArr[index];
            weakSelf.registM.levelId = weakSelf.levelM.levelID;
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark --- btnClick ---
- (void)commitBtnClick
{
    [self.view endEditing:YES];
    DLog(@"name-%@,phone-%@,weixin-%@,boss-%@,level-%@,place-%@,idStr=%@",self.registM.nameStr,self.registM.phoneStr,self.registM.weiXinStr,self.registM.bossNameStr,self.registM.levelStr,self.registM.placeStr,self.registM.IDStr);
    if (fStringIsEmpty(self.registM.nameStr)) {
        [self showErrorWithStr:@"姓名不能为空"];
        return;
    }
    if (self.registM.phoneStr.length != 11) {
        [self showErrorWithStr:@"电话输入有误"];
        return;
    }
    if (fStringIsEmpty(self.registM.codeStr)) {
        [self showErrorWithStr:@"验证码不能为空"];
        return;
    }
    if (self.registM.pwStr.length < 6 || self.registM.pwStr.length > 16) {
        [self showErrorWithStr:@"请输入6-16密码"];
        return;
    }
    
    if (fStringIsEmpty(self.registM.weiXinStr)) {
        [self showErrorWithStr:@"微信不能为空"];
        return;
    }
    if (fStringIsEmpty(self.registM.bossNameStr)) {
        [self showErrorWithStr:@"等级名称不能为空"];
        return;
    }
    if (fStringIsEmpty(self.registM.levelStr)) {
        [self showErrorWithStr:@"申请级别不能为空"];
        return;
    }
    if (fStringIsEmpty(self.registM.placeStr)) {
        [self showErrorWithStr:@"地址不能为空"];
        return;
    }
    if (fStringIsEmpty(self.registM.IDStr)) {
        [self showErrorWithStr:@"身份证号不能为空"];
        return;
    }
    if (fStringIsEmpty(idcard_front)) {
        [self showErrorWithStr:@"请上传身份证正面照片"];
        return;
    }
    if (fStringIsEmpty(idcard_reverse)) {
        [self showErrorWithStr:@"请上传身份证反面照片"];
        return;
    }
    [self.view endEditing:YES];
    NSDictionary *send_d = @{@"realname":self.registM.nameStr,
                             @"userphone":self.registM.phoneStr,
                             @"smsCode":self.registM.codeStr,
                             @"wechatno":self.registM.weiXinStr,
                             @"code":self.registM.bossNameStr,
                             @"levelId":self.registM.levelId,
                             @"levelName":self.registM.levelStr,
                             @"address":self.registM.placeStr,
                             @"idcard":self.registM.IDStr,
                             @"idcard_front":idcard_front,
                             @"idcard_reverse":idcard_reverse,
                             @"password":self.registM.pwStr
                             };
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@/app/user/register",MYURL] headStr:nil parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"注册成功"];
            
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)zhenTapClick
{
    __weak typeof(self) weakSelf = self;
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        weakSelf.zhenImg.image = (UIImage *)data;
        [weakSelf uploadPicture:(UIImage *)data withLoadName:@"idcard_front"];
    }];
}

- (void)fanTapClick
{
    __weak typeof(self) weakSelf = self;
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        weakSelf.fanImg.image = (UIImage *)data;
        [weakSelf uploadPicture:(UIImage *)data withLoadName:@"idcard_reverse"];
    }];
}

- (void)codeBtnClick
{
    if (timer) {
        return;
    }
    
    if (self.phoneTF.text.length != 11) {
        return;
    }
    
    [self loadCode];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)timerStart
{
    if (downCount == 0) {
        [timer invalidate];
        timer = nil;
        [self.codeBtn setTitle:@" 发送验证码 " forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:MainTonal forState:UIControlStateNormal];
        [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
        self.codeBtn.layer.borderColor = MainTonal.CGColor;
        self.codeBtn.layer.borderWidth = 1;
        self.codeBtn.layer.masksToBounds = YES;
        self.codeBtn.layer.cornerRadius = 5;
        downCount = 60;
        return;
    }
    downCount --;
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundColor:MainTonal];
    [self.codeBtn setTitle:[NSString stringWithFormat:@" (%d)秒后重发 ",downCount] forState:UIControlStateNormal];
}

#pragma mark ---  Network Request ---
- (void)getLevel
{
    
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/user/selectAllLevel",MYURL] headStr:nil parameters:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSArray *dataA = [responseObject objectForKey:@"data"];
            for (int i = 0; i < dataA.count; i ++) {
                self.levelM = [RegLevelModel modelWithDictionary:dataA[i]];
                [self.levelArr addObject:self.levelM];
            }
        }else{
            [self showErrorWithStr:@"msg"];
        }
    } failure:^(id failure) {
        
    }];
}

- (void)loadCode
{
    [self.view endEditing:YES];
    if (self.phoneTF.text.length != 11) {
        [self showSucessWihtStr:@"手机号输入错误"];
        return;
    }
    NSDictionary *send_d = @{@"loginName":self.phoneTF.text};
    [[HttpRequest sharedInstance] postWithURLString:[NSString stringWithFormat:@"%@app/login/sendSms",MYURL] headStr:nil  parameters:send_d success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"发送成功"];
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)uploadPicture:(UIImage *)image withLoadName:(NSString *)nameStr
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    UploadParam *uploadP = [[UploadParam alloc] init];
    uploadP.data = imageData;
    uploadP.name = @"file";
    uploadP.filename = fileName;
    uploadP.mimeType = @"image/jpeg";
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArr addObject:uploadP];
    
    [[HttpRequest sharedInstance] uploadWithURLString:[NSString stringWithFormat:@"%@/app/user/upload",MYURL] parameters:nil uploadParam:dataArr success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            [self showSucessWihtStr:@"上传成功"];
//            [self.tableView reloadData];
            if ([nameStr isEqualToString:@"idcard_front"]) {
                idcard_front = [responseObject objectForKey:@"data"];
            }else{
                idcard_reverse = [responseObject objectForKey:@"data"];
            }
        }else{
            [self showErrorWithStr:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [self showErrorWithStr:@"请检查网络连接"];
    }];
}

#pragma mark --- tableviewDelegate ---
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    if (!isVisable) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - Nav_Height - HomeIndicator);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardDidShow
{
    isVisable = YES;
}

-(void)keyboardDidHide
{
    isVisable = NO;
}

@end
