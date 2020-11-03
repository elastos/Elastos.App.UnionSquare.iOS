//
//  HWMDIDInfoViewController.m
//  elastos wallet
//
//  Created by  on 2019/10/30.
//

#import "HWMDIDInfoViewController.h"
#import "HWMDIDInfoTableViewCell.h"
#import "HWMTheEditorDIDInfoViewController.h"
#import "HWMConfidentialInformationViewController.h"
#import "HMWFMDBManager.h"
#import "HMWToDeleteTheWalletPopView.h"
#import "HWMDIDManager.h"
#import "ELWalletManager.h"
#import "WYDIDUtils.h"
#import "HWMDIDInfoShowTableViewCell.h"
#import "HWMshowIntroductionInfoViewController.h"
#import "WYShowCustomContentViewController.h"

static NSString *cellString=@"HWMDIDInfoTableViewCell";
static NSString *customCellString = @"HWMDIDInfoShowTableViewCell";

@interface HWMDIDInfoViewController ()<UITableViewDataSource,UITableViewDelegate,HMWToDeleteTheWalletPopViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DIDInfoTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *theEditorButton;
@property (weak, nonatomic) IBOutlet UIButton *ConfidentialInformationButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(copy,nonatomic)NSString *PubKeyString;

@property(copy,nonatomic)NSArray *dataArray;
@property(strong,nonatomic)HMWToDeleteTheWalletPopView *deleteDIDPopView;

@property (strong, nonatomic) NSDictionary *fullInfo;
@property (strong, nonatomic) NSDictionary *extraInfo;
@property (copy, nonatomic) NSArray *allExtraInfoList;
@property (strong, nonatomic) NSMutableArray *displayList;

@end

@implementation HWMDIDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title=@"DID";
    [self getDIDInfo];
    [self prepareDisplayList];
    self.DIDInfoTextLabel.text=NSLocalizedString(@"DID基本信息", nil);
    [[HMWCommView share]makeBordersWithView:self.theEditorButton];
    [[HMWCommView share]makeBordersWithView:self.ConfidentialInformationButton];
    [self.theEditorButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [self.ConfidentialInformationButton setTitle:NSLocalizedString(@"凭证信息", nil) forState:UIControlStateNormal];
    [self makeUI];
}

-(void)getDIDInfo{
    [[HWMDIDManager shareDIDManager]hasDIDWithPWD:@"" withDIDString:self.currentWallet.didString WithPrivatekeyString:@"" WithmastWalletID:self.currentWallet.masterWalletID needCreatDIDString:NO];
    NSDictionary *didInfoDic=[[HWMDIDManager shareDIDManager]getDIDInfo];
    if (self.model==nil) {
        self.model=[[HWMDIDInfoModel alloc]init];
    }
    self.model.did=didInfoDic[@"DIDString"];
    self.model.didName=didInfoDic[@"nickName"];
    self.model.endString=didInfoDic[@"endTime"];
    if (self.model.didName.length==0) {
        self.model.didName=@"unknown";
    }
    
    invokedUrlCommand *cmommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,@"IDChain",@"0",@"100"] callbackId:self.currentWallet.masterWalletID className:@"wallet" methodName:@"createMasterWallet"];
    PluginResult * resultBasePublicKeysList =[[ELWalletManager share]getAllPublicKeys:cmommand];
    NSString *status=[NSString stringWithFormat:@"%@",resultBasePublicKeysList.status];
    if ([status isEqualToString:@"1"]) {
        
        NSArray *PublicKeysListArray=resultBasePublicKeysList.message[@"success"][@"PublicKeys"];
        
        self.PubKeyString=PublicKeysListArray.firstObject;
        
        
    }
    
    NSDictionary *didInfoExtended = [WYDIDUtils getDIDInfoFromString:self.model.did];
    WYLog(@"=== dev temp === DID Info Dic: %@", didInfoExtended);
    self.fullInfo = didInfoExtended[@"fullInfo"];
    self.extraInfo = didInfoExtended[@"extraInfo"];
    
    self.model = [HWMDIDInfoModel modelWithDictionary:self.fullInfo];
    
}

- (void)prepareDisplayList {
    self.displayList = [[NSMutableArray alloc] init];
    for (NSDictionary *item in self.allExtraInfoList) {
        NSString *key = item[@"key"];
        NSString *value = self.extraInfo[key];
        if (value.length > 0) {
            NSString *content = value;
            if ([key isEqualToString:@"phone"]) {
                NSString *phoneCode = self.extraInfo[@"phoneCode"];
                if (phoneCode.length > 0) {
                    content = [NSString stringWithFormat:@"%@ %@", phoneCode, content];
                }
            }
            
            if ([key isEqualToString:@"gender"]) {
                content = [[FLTools share]genderStringWithType:content];
            }
            
            if ([key isEqualToString:@"birthday"]) {
                content = [[FLTools share]TimeFormatConversionBirthday:content];
            }
            
            if ([key isEqualToString:@"nation"]) {
                content = [[FLTools share]contryNameTransLateByCode:[content integerValue]];
            }
            
            if ([key isEqualToString:@"customInfos"]) {
                NSDictionary *customInfosDic = [WYUtils dicFromJSONString:content];
                for (NSDictionary *customInfoItem in customInfosDic) {
                    NSDictionary *displayItem = @{
                        @"title": customInfoItem[@"title"],
                        @"content": customInfoItem[@"content"],
                        @"type": customInfoItem[@"type"],
                        @"key": key
                    };
                    [self.displayList addObject:displayItem];
                }
            } else {
                NSDictionary *displayItem = @{
                    @"title": item[@"text"],
                    @"content": content,
                    @"type": item[@"type"],
                    @"key": key
                };
                [self.displayList addObject:displayItem];
            }
        }
    }
    
    WYLog(@"=== dev temp === displayList prepared: %@", self.displayList);
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[NSArray arrayWithObjects:NSLocalizedString(@"姓名", nil),NSLocalizedString(@"主管理公钥", nil),NSLocalizedString(@"DID", nil),NSLocalizedString(@"有效期", nil), nil];
    }
    return _dataArray;
}

- (NSArray *)allExtraInfoList {
    if (!_allExtraInfoList) {
        _allExtraInfoList = @[
            @{@"text":NSLocalizedString(@"昵称", nil),
              @"index":@"0",@"type":@"1",
              @"key":@"nickname"},
            @{@"text":NSLocalizedString(@"性别",nil),
              @"index":@"1",@"type":@"2",
              @"key":@"gender"},
            @{@"text":NSLocalizedString(@"出生日期",nil),
              @"index":@"2",@"type":@"2",
              @"key":@"birthday"},
            @{@"text":NSLocalizedString(@"头像地址1",nil),
              @"index":@"3",@"type":@"1",
              @"key":@"avatar"},
            @{@"text":NSLocalizedString(@"邮箱",nil),
              @"index":@"4",@"type":@"1",
              @"key":@"email"},
            @{@"text":NSLocalizedString(@"手机号", nil),
              @"index":@"5",@"type":@"3",
              @"key":@"phone"},
            @{@"text":NSLocalizedString(@"国家/地区", nil),
              @"index":@"6",@"type":@"2",
              @"key":@"nation"},
            @{@"text":NSLocalizedString(@"个人简介qe",nil),
              @"index":@"7",@"type":@"4",
              @"key":@"introduction"},
            @{@"text":NSLocalizedString(@"个人主页网址",nil),
              @"index":@"8",@"type":@"1",
              @"key":@"homePage"},
            @{@"text":NSLocalizedString(@"Facebook账号",nil),
              @"index":@"9",@"type":@"1",
              @"key":@"facebook"},
            @{@"text":NSLocalizedString(@"Twitter账号",nil),
              @"index":@"10",@"type":@"1",
              @"key":@"twitter"},
            @{@"text":NSLocalizedString(@"微博账号",nul),
              @"index":@"11",@"type":@"1",
              @"key":@"weibo"},
            @{@"text":NSLocalizedString(@"微信账号",null),
              @"index":@"12",@"type":@"1",
              @"key":@"wechat"},
            @{@"text":NSLocalizedString(@"谷歌账号1",null),
              @"index":@"13",@"type":@"1",
              @"key":@"googleAccount"},
            @{@"text":NSLocalizedString(@"自定义信息",null),
              @"index":@"14",@"type":@"666",
              @"key":@"customInfos"}
        ];
    }
    return _allExtraInfoList;
}

-(void)deleteDIDEvent{
    
    UIView * mainView=[self mainWindow];
    [mainView addSubview:self.deleteDIDPopView];
    [self.deleteDIDPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(mainView);
    }];
    
}
-(HMWToDeleteTheWalletPopView *)deleteDIDPopView{
    if (!_deleteDIDPopView) {
        _deleteDIDPopView =[[HMWToDeleteTheWalletPopView alloc]init];
        _deleteDIDPopView.delegate=self;
        _deleteDIDPopView.deleteType=deleteDIDInfoType;
    }
    return _deleteDIDPopView;
}

-(void)sureToDeleteViewWithPWD:(NSString*)pwd{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self toCancelOrCloseDelegate];
}
-(void)toCancelOrCloseDelegate{
    [self.deleteDIDPopView removeFromSuperview];
    self.deleteDIDPopView=nil;
    
}
- (IBAction)theEditorEvent:(id)sender {
    HWMTheEditorDIDInfoViewController *TheEditorDIDInfoVC=[[HWMTheEditorDIDInfoViewController alloc]init];
    TheEditorDIDInfoVC.model=self.model;
    TheEditorDIDInfoVC.extraInfo = self.extraInfo;
    TheEditorDIDInfoVC.currentWallet=self.currentWallet;
    TheEditorDIDInfoVC.PubKeyString=self.PubKeyString;
    [self.navigationController pushViewController:TheEditorDIDInfoVC animated:YES];
}
- (IBAction)ConfidentialInformationEvent:(id)sender {
    HWMConfidentialInformationViewController *ConfidentialInformationVC=[[HWMConfidentialInformationViewController alloc]init];
    ConfidentialInformationVC.model=self.model;
    ConfidentialInformationVC.currentWallet=self.currentWallet;
    [self.navigationController pushViewController:ConfidentialInformationVC animated:YES];
}
-(void)makeUI{
    [self.table registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:cellString];
    [self.table registerNib:[UINib nibWithNibName:customCellString bundle:nil] forCellReuseIdentifier:customCellString];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.table.rowHeight = 55.f;
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.backgroundColor=[UIColor clearColor];
    [self.table reloadData];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HWMDIDInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.leftTextLabel.text=self.dataArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.arrImageView.alpha=0.f;
                cell.infoLabel.text=self.model.didName;
                break;
            case 1:
                cell.infoLabel.text=self.PubKeyString;
                break;
            case 2:
                cell.infoLabel.text=self.model.did;
                
                break;
            case 3:
                cell.arrImageView.alpha=0.f;
                if (self.model.endString.length>0) {
                    cell.infoLabel.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"至", nil),[[FLTools share]YMDCommunityTimeConversionTimeFromTimesTamp:self.model.endString]];
                }
                
                break;
                
            default:
                
                break;
        }
        return cell;
    } else if (indexPath.section == 1) {
        HWMDIDInfoShowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:customCellString];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSDictionary *item = self.displayList[indexPath.row];
        NSString *title = item[@"title"];
        NSString *content = item[@"content"];
        cell.leftLabel.text = title;
        cell.rightLabel.text = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        if ([item[@"key"] isEqualToString:@"avatar"]) {
            
            cell.headIocnImageView.alpha=1.f;
            if (content.length>4) {
               
                NSString *typeString=[content substringFromIndex:content.length-4];
                if ([typeString isEqualToString:@".svg"]) {
                    cell.headIocnImageView.contentMode=UIViewContentModeScaleAspectFit;
                }else{
                    cell.headIocnImageView.contentMode=UIViewContentModeScaleAspectFill;
                }
                [[FLTools share]loadUrlSVGAndPNG:content WithSuccessBlock:^(id data) {
                    if (data) {
                        cell.headIocnImageView.image=data;
                    }else{
                        cell.headIocnImageView.image=[UIImage imageNamed:@"mine_did_default_avator"];
                    }
                }];
            }else{
                cell.headIocnImageView.image=[UIImage imageNamed:@"mine_did_default_avator"];
            }
            cell.rightLabel.alpha=0.f;
            
        }
        
        return cell;
    }
    
    HWMDIDInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary *item = self.displayList[indexPath.row];
        if ([item[@"key"] isEqualToString:@"avatar"]) {
            return 85.f;
        }
    }
    return 55.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.extraInfo.count > 0) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    } else if (section == 1) {
        return self.displayList.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"DID基本信息", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"上链信息", nil);
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
    header.textLabel.font = [UIFont systemFontOfSize:16.f];
    header.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary *infoSelected = self.displayList[indexPath.row];
        WYLog(@"=== dev temp === infoSelected: %@", infoSelected);
        if ([infoSelected[@"key"] isEqualToString:@"introduction"]) {
            HWMshowIntroductionInfoViewController *AddPersonalProfileVC=[[HWMshowIntroductionInfoViewController alloc]init];
            AddPersonalProfileVC.model=self.model;
            [self.navigationController pushViewController:AddPersonalProfileVC animated:YES];
        } else if ([infoSelected[@"key"] isEqualToString:@"customInfos"] && [infoSelected[@"type"] isEqualToString:@"-2"]) {
            WYShowCustomContentViewController *contentVC = [[WYShowCustomContentViewController alloc] init];
            contentVC.title = infoSelected[@"title"];
            contentVC.contentText = infoSelected[@"content"];
            [contentVC refreshData];
            [self.navigationController pushViewController:contentVC animated:YES];
        }
    }
}
-(void)setModel:(HWMDIDInfoModel *)model{
    _model=model;
}

-(void)setCurrentWallet:(FLWallet *)currentWallet{
    _currentWallet=currentWallet;
}

@end
