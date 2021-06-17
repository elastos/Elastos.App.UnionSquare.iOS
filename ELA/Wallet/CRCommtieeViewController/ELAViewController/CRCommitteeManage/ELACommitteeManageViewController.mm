//
/*
 * Copyright (c) 2020 Elastos Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "ELACommitteeManageViewController.h"
#import "ELAUtils.h"
#import "Masonry.h"
#import "UIView+Ext.h"
#import "ELAPledgeView.h"
#import "HWMCRRegisteredViewController.h"
#import "ELWalletManager.h"
#import "HMWFMDBManager.h"
#import "ELANetworkManager.h"
#import "FLManageSelectPointNodeInformationVC.h"
#import "HWMDIDManager.h"
#import "HWMDIDAuthorizationViewController.h"
#import "ELAVotingProcessUtil.h"
#import "HWMCRRegisteredViewController.h"
#import "HWMCRListModel.h"
#import "HMWCRCommitteeMemberListViewController.h"
#import "ELANetwork.h"
#import "ELAImpeachView.h"
#import "ELAPasswdView.h"
#import "HMWToDeleteTheWalletPopView.h"
#import "HWMTransactionDetailsView.h"
#import "HMWAddTheCurrencyListViewController.h"
#import "WYNodeClaimViewController.h"

@interface ELACommitteeManageViewController ()<HWMDIDAuthorizationViewControllerDelegate, HMWToDeleteTheWalletPopViewDelegate, HMWAddTheCurrencyListViewControllerDelegate, HWMTransactionDetailsViewDelegate>

@property (nonatomic, strong) ELAPledgeView *pledgeView;

@property (nonatomic, strong) ELAImpeachView *impeachView;
@property (nonatomic, strong) ELAPasswdView *passwdView;

@property (nonatomic, strong) NSString *passwdValue;
@property (nonatomic, strong) NSString *impeachValue;

@property(strong,nonatomic)HMWToDeleteTheWalletPopView *openIDChainView;
@property(strong,nonatomic)HWMTransactionDetailsView *ShowPoPWDView;

@end

@implementation ELACommitteeManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self getNetwork];
    WYLog(@"=== dev temp === type at load: %d", _type);
    WYLog(@"=== dev temp === infoModel depositAmount at load: %@", _infoModel.depositAmount);

    [self creatView];
}

//- (void)getNetwork
//{
//    ELAWeakSelf;
//    [ELANetwork listcrcandidates:@"all" block:^(id  _Nonnull data, NSError * _Nonnull error){
//
//        if(error)
//        {
//            if(error.code == -999)
//            {
//                //已取消
//            }
//            else
//            {
//            }
//        }
//        else
//        {
//
//            NSDictionary *result = data[@"data"][@"result"];
//            if(result)
//            {
//                NSArray *array = result[@"crcandidatesinfo"];
//              //  [self CRC:CRC crcArray:array];
//            }
//        }
//
//
//    }];
//}
- (void)setBg:(UIColor*)fclolr withToColor:(UIColor*)tcolor withView:(UIView*)view{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, view.width, view.height);
    gl.colors = @[(__bridge id)fclolr.CGColor,(__bridge id)tcolor.CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    [view.layer addSublayer:gl];
    
}
#pragma mark - Action

- (void)updateDIDButtonAction:(id)sender
{
    ////    HWMCRListModel *crModel = [[HWMCRListModel alloc] init];
    ////    crModel.did = _infoModel.did;
    ////    crModel.location = _infoModel.location;
    ////    crModel.nickname = _infoModel.didName;
    ////    crModel.url =
    //     FLWallet *wallet = [ELWalletManager share].currentWallet;
    //            HWMCRRegisteredViewController *vc=[[ HWMCRRegisteredViewController alloc]init];
    //    //        vc.CRmodel = self.CRModel;
    //            vc.isUpdate=YES;
    //            vc.currentWallet = wallet;
    //
    //    ELAWeakSelf;
    if(_type == 2)
    {
        [self updataDIDInfoEvent:sender];
    }
    else if(_type == 1)
    {
        [self toRetrieveCRDepositTransactionFee];
        
    }
    else if(_type == 4)//4 任期已满
    {
        [self toRetrieveCRDepositTransactionFee];
        
    }
    else if(_type == 5)//5 弹劾去职
    {
        [self toRetrieveCRDepositTransactionFee];
        
    }
}

- (void)updateInfoButtonAction:(id)sender
{
    
    //    if(_type == 1)
    //    {
    FLWallet *wallet = [ELWalletManager share].currentWallet;
    HWMCRRegisteredViewController *vc=[[ HWMCRRegisteredViewController alloc]init];
    vc.isUpdate=YES;
    vc.currentWallet = wallet;
    
    HWMCRListModel *crModel = [[HWMCRListModel alloc] init];
    crModel.did = _infoModel.did;
    crModel.location = [NSString stringWithFormat:@"%ld", _infoModel.location];
    crModel.nickname = _infoModel.didName;
    crModel.url = _infoModel.address;
    vc.CRmodel = crModel;
    
    [self.navigationController pushViewController:vc animated:YES];
    //    }
}

- (void)nodeButtonAction:(id)sender {
    FLWallet *wallet = [ELWalletManager share].currentWallet;
    WYNodeClaimViewController *vc = [[WYNodeClaimViewController alloc] init];
    vc.currentWallet = wallet;
    vc.infoModel = self.infoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updataDIDInfoEvent:(id)sender
{
    FLWallet *wallet = [ELWalletManager share].currentWallet;
    [self showLoading];
    [[HWMDIDManager shareDIDManager]hasDIDWithPWD:@"" withDIDString:wallet.didString WithPrivatekeyString:@"" WithmastWalletID:wallet.masterWalletID needCreatDIDString:NO];
    [self hiddLoading];
    if (![[HWMDIDManager shareDIDManager]HasBeenOnTheChain]) {
        
        [[FLTools share]showErrorInfo:NSLocalizedString(@"当前钱包未创建DID", nil)];
        return;
    }
    
    HWMDIDInfoModel  *readModel=[[HWMDIDManager shareDIDManager]readDIDCredential];
    NSDictionary *dic =[[HWMDIDManager shareDIDManager]getDIDInfo];
    NSString *endTime=dic[@"endTime"];
    if ([endTime intValue]<[[[FLTools share]getNowTimeTimestampS] intValue])  {
        
        [[FLTools share]showErrorInfo:NSLocalizedString(@"DID已失效", nil)];
        return ;
    }
    readModel.endString=endTime;
    readModel.did=dic[@"DIDString"];
    readModel.didName=dic[@"nickName"];
    HWMDIDAuthorizationViewController *DIDAuthorizationVC=[[HWMDIDAuthorizationViewController alloc]init];
    DIDAuthorizationVC.readModel=readModel;
    DIDAuthorizationVC.DIDString=wallet.didString;
    DIDAuthorizationVC.mastWalletID=wallet.masterWalletID;
    DIDAuthorizationVC.delegate=self;
    DIDAuthorizationVC.MemberOfTheUpdate=YES;
    DIDAuthorizationVC.nickNameString = readModel.didName;
    [self.navigationController pushViewController:DIDAuthorizationVC animated:DIDAuthorizationVC];
}

-(void)needUploadJWTInfo
{
    [[FLTools share]showErrorInfo:@"更新成功"];
}

#pragma mark -


- (void)showImpeachView:(NSString *)fee json:(NSString *)jsonString
{
    ELAWeakSelf;
    //    FLWallet *wallet = [ELWalletManager share].currentWallet;
    NSString *balance = _infoModel.depositAmount; //[[ELWalletManager share] getVoteBalance:wallet.masterWalletID];
    NSString *str = @"";
    if(balance && ![balance isEqualToString:@""])
    {
        double amount = [balance doubleValue];
        str = [NSString stringWithFormat:@"%0.4f", amount];
    }
    _impeachView = [[ELAImpeachView alloc] init];
    _impeachView.amount = str;
    [_impeachView showAlertView:self.view];
    
    [_impeachView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
        make.top.bottom.equalTo(@(0));
    }];
    _impeachView.fee = fee;
    _impeachView.type = 1;
    //    _impeachView.buttonTitle = @"下一步";
    _impeachView.valueBlock = ^(NSString *value){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            double douValue = [value doubleValue];
            //            if(douValue <= 0)
            //            {
            //                //                    [weakSelf showErrorInfo:ELALocalizedString(@"请正确输入数字")];
            //                [weakSelf showErrorInfo:ELALocalizedString(@"err20001")];
            //                return;
            //            }
            weakSelf.impeachValue = value;
            [weakSelf showPasswdView:jsonString];
            
        });
        
    };
}
- (void)showSendSuccessPopuV
{
    ELAWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        HMWSendSuccessPopuView *_sendSuccessPopuV =[[HMWSendSuccessPopuView alloc]init];
        UIView *manView = [weakSelf mainWindow];
        [manView addSubview:_sendSuccessPopuV];
        [_sendSuccessPopuV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(manView);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_sendSuccessPopuV removeFromSuperview];
            [weakSelf goBack];
        });
    });
}

- (void)toRetrieveCRDepositTransactionFee
{
    BOOL res = [self isOpenIDChain];
    if(!res)
    {
        
        //        [[FLTools share]showErrorInfo:NSLocalizedString(@"该钱包尚未开启ID侧链", nil)];
        UIView *mainView =[self view];
        self.openIDChainView.deleteType=openIDChainType;
        [mainView addSubview:self.openIDChainView];
        [self.openIDChainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(mainView);
        }];
        
        return;
    }
    ELWalletManager *manager = [ELWalletManager share];
    NSString *walletId =  manager.currentWallet.masterWalletID;
    NSDictionary *dic = [manager RetrieveCRDepositTransactionFee:walletId acount:_infoModel.depositAmount Pwd:@""];
    NSString *fee = [[FLTools share]elaScaleConversionWith:[NSString stringWithFormat:@"%@", dic[@"fee"]]];
    if ([dic[@"fee"] doubleValue] > -1)
    {
        NSString *jsonString = dic[@"JSON"];
        
        [self showImpeachView:fee json:jsonString];
        
    }
    
}
#pragma mark -
- (void)showPasswdView:(NSString *)jsonString
{
    
    ELAWeakSelf;
    _passwdView = [[ELAPasswdView alloc] init];
    [_passwdView showAlertView:self.view];
    //    _passwdView.buttonTitle = @"下一步";
    [_passwdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
        make.top.bottom.equalTo(@(0));
    }];
    _passwdView.valueBlock = ^(NSString *value){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.passwdValue = value;
            BOOL result = [weakSelf toVerifyPayPassword:value];
            if(result)
            {
                double amountVa = [weakSelf.impeachValue doubleValue] * ELAUnitConversion;
                [weakSelf showLoading];
                ELWalletManager *manager = [ELWalletManager share];
                NSString *walletId =  manager.currentWallet.masterWalletID;
                BOOL ret = [manager  RetrieveCRDepositTransaction:walletId acount:amountVa  Pwd:weakSelf.passwdValue withJSONString:jsonString];
                [weakSelf hiddLoading];
                [weakSelf.impeachView hideAlertView];
                [weakSelf.passwdView hideAlertView];
                if (ret)
                {
                    [weakSelf showSendSuccessPopuV];
                }
                
            }
            
        });
        
    };
    
}
- (BOOL)toVerifyPayPassword:(NSString *)passwd
{
    FLWallet *wallet = [ELWalletManager share].currentWallet;
    invokedUrlCommand *mommand = [[invokedUrlCommand alloc]initWithArguments:@[wallet.masterWalletID, passwd] callbackId:wallet.walletID className:@"Wallet" methodName:@"exportWalletWithMnemonic"];
    PluginResult *result = [[ELWalletManager share]VerifyPayPassword:mommand];
    NSNumber *number = result.status;
    
    if( [number intValue] != CommandStatus_OK)
    {
        NSString *errCode=[NSString stringWithFormat:@"%@", result.message[@"error"][@"message"]];
        [[FLTools share]showErrorInfo:NSLocalizedString(errCode, nil)];
        return NO;
    }
    return YES;
}

- (BOOL)isOpenIDChain
{
    FLWallet *wallet = [ELWalletManager share].currentWallet;
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[wallet.masterWalletID] callbackId:wallet.masterWalletID className:@"Wallet" methodName:@"getAllSubWallets"];
    
    PluginResult * result =[[ELWalletManager share]getAllSubWallets:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]) {
        NSArray  *array = [[FLTools share]stringToArray:result.message[@"success"]];
        for (NSString *str in array) {
            if([str isEqualToString:@"IDChain"])
            {
                return YES;
            }
        }
        
    }
    return NO;
    
}


#pragma mark -
-(HMWToDeleteTheWalletPopView *)openIDChainView{
    if (!_openIDChainView) {
        _openIDChainView =[[HMWToDeleteTheWalletPopView alloc]init];
        _openIDChainView.delegate=self;
    }
    return _openIDChainView;
}

-(void)openIDChainOfDIDAddWithWallet:(NSString*)walletID
{
    //    FLWallet *wallet = [ELWalletManager share].currentWallet;
    //    if (walletID.length > 0 && [walletID isEqualToString:wallet.masterWalletID])
    //    {
    ////        [self showPWDView];
    //    }
}

#pragma mark - --------HMWToDeleteTheWalletPopViewDelegate-----------
-(void)sureToDeleteViewWithPWD:(NSString*)pwd
{
    [self toCancelOrCloseDelegate];
    ELAWeakSelf;
    _passwdView = [[ELAPasswdView alloc] init];
    [_passwdView showAlertView:self.view];
    //    _passwdView.buttonTitle = @"下一步";
    [_passwdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
        make.top.bottom.equalTo(@(0));
    }];
    _passwdView.valueBlock = ^(NSString *value){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.passwdValue = value;
            BOOL result = [weakSelf toVerifyPayPassword:value];
            if(result)
            {
                [weakSelf.passwdView hideAlertView];
                FLWallet *wallet = [ELWalletManager share].currentWallet;
                
                HMWAddTheCurrencyListViewController *AddTheCurrencyListVC=[[HMWAddTheCurrencyListViewController alloc]init];
                AddTheCurrencyListVC.wallet=wallet;
                AddTheCurrencyListVC.didType=@"didType";
                AddTheCurrencyListVC.delegate = weakSelf;
                
                [weakSelf.navigationController pushViewController:AddTheCurrencyListVC animated:YES];
                
                
                
            }
            
        });
        
    };
    
}

-(void)toCancelOrCloseDelegate{
    [self.openIDChainView removeFromSuperview];
    self.openIDChainView=nil;
}

#pragma mark - view
- (void)creatView
{
    
    UIView *infoView = [[UIView alloc] init];
    infoView.layer.borderColor = [UIColor whiteColor].CGColor;
    infoView.layer.borderWidth = 1;
    infoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoView];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 360)];
    [self setBg:ELARGBA(28, 47, 47, 0.75) withToColor:ELARGBA(17, 32, 34, 0.75) withView:bgView];
    [infoView addSubview:bgView];
    
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_infoModel.avatar] placeholderImage:ImageNamed(@"point_information_img")];
    
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 40;
    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headImageView.layer.borderWidth = 0.5;
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:headImageView];
    //
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _infoModel.didName;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PingFangRegular(16);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    [infoView addSubview:titleLabel];
    
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"";
    subLabel.textColor = [UIColor whiteColor];
    subLabel.font = PingFangRegular(14);
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.numberOfLines = 0;
    [infoView addSubview:subLabel];
    
    UIButton *updateInfoButton = [[UIButton alloc] init];
    updateInfoButton.layer.masksToBounds = YES;
    //    button.layer.cornerRadius = 5;
    updateInfoButton.layer.borderColor = [UIColor whiteColor].CGColor;
    updateInfoButton.layer.borderWidth = 1;
    updateInfoButton.backgroundColor = ELARGB(45, 69, 76);
    updateInfoButton.titleLabel.textColor = [UIColor whiteColor];
    updateInfoButton.titleLabel.font = PingFangRegular(14);
    updateInfoButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    updateInfoButton.titleLabel.minimumScaleFactor = 0.5f;
    [updateInfoButton setTitle:ELALocalizedString(@"更新委员信息") forState:(UIControlStateNormal)];
    [updateInfoButton addTarget:self action:@selector(updateInfoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:updateInfoButton];
    
    UIButton *button = [[UIButton alloc] init];
    button.layer.masksToBounds = YES;
    //    button.layer.cornerRadius = 5;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    button.backgroundColor = ELARGB(45, 69, 76);
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = PingFangRegular(14);
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.5f;
    [button setTitle:ELALocalizedString(@"更新DID信息") forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(updateDIDButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    // [button addTarget:self action:@selector(manageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    UIButton *nodeButton = [[UIButton alloc] init];
    nodeButton.layer.masksToBounds = YES;
    //    button.layer.cornerRadius = 5;
    nodeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    nodeButton.layer.borderWidth = 1;
    nodeButton.backgroundColor = ELARGB(45, 69, 76);
    nodeButton.titleLabel.textColor = [UIColor whiteColor];
    nodeButton.titleLabel.font = PingFangRegular(14);
    nodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    nodeButton.titleLabel.minimumScaleFactor = 0.5f;
    [nodeButton setTitle:ELALocalizedString(@"领取CR节点") forState:(UIControlStateNormal)];
    [nodeButton addTarget:self action:@selector(nodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    // [button addTarget:self action:@selector(manageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nodeButton];
    
    //    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    //    updateInfoButton.hidden = YES;
    if(_type == 1)
    {
        NSString *des = @"本轮竞选已经结束，很遗憾您此次未能当选。感谢您的参与，祝您好运！";
        NSString *text = ELALocalizedString(des);
        subLabel.text = text;
        updateInfoButton.hidden = YES;
        nodeButton.hidden = YES;
        [button setTitle:ELALocalizedString(@"提取质押金") forState:(UIControlStateNormal)];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
    }
    else if(_type == 2)
    {
        NSString *des = @"每位CR委员须运行一个默认当选的DPoS超级节点，享有该节点产生的所有收益，并有义务保证节点正常运行。";
        NSString *text = ELALocalizedString(des);
        subLabel.text = text;
        
        WYLog(@"=== dev temp ===: infoModel dpospublickey: %@", self.infoModel.dpospublickey);
        
        if (self.infoModel.dpospublickey && ![self.infoModel.dpospublickey isEqualToString:@""]) {
            [nodeButton setTitle:ELALocalizedString(@"管理CR节点") forState:(UIControlStateNormal)];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.view.mas_trailing).offset(-40);
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading).offset(40);
            make.trailing.equalTo(button.mas_leading).offset(-20);
            make.width.equalTo(button.mas_width);
            make.height.equalTo(button.mas_height);
            make.bottom.equalTo(button.mas_bottom);
        }];
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(updateInfoButton.mas_leading);
            make.trailing.equalTo(button.mas_trailing);
            make.height.equalTo(button.mas_height);
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
    }
    else if(_type == 3)
    {
        double douValue = [_infoModel.depositAmount doubleValue];
        NSString *des = ELALocalizedString(@"上届CR委员会任期已满，所有委员自动卸任离职。根据您的世界履职情况及CRC委员节点的运行情况，您的竞选押金返还额度为");
        NSString *string = [NSString stringWithFormat:@"%@%0.4fELA", des, douValue];
        subLabel.text = string;
        updateInfoButton.hidden = YES;
        nodeButton.hidden = YES;
        [button setTitle:ELALocalizedString(@"提取质押金") forState:(UIControlStateNormal)];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
    }
    else if(_type == 4)
    {
        WYLog(@"=== dev temp === infoModel depositAmount: %@", _infoModel.depositAmount);
        double douValue = [_infoModel.depositAmount doubleValue];
        WYLog(@"=== dev temp === infoModel depositAmount Double: %f", douValue);
        NSString *des = ELALocalizedString(@"上届CR委员会任期已满，所有委员自动卸任离职。根据您的世界履职情况及CRC委员节点的运行情况，您的竞选押金返还额度为");
        NSString *string = [NSString stringWithFormat:@"%@%0.4fELA", des, douValue];
        subLabel.text = string;
        updateInfoButton.hidden = YES;
        nodeButton.hidden = YES;
        [button setTitle:ELALocalizedString(@"提取质押金") forState:(UIControlStateNormal)];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
    }
    else if(_type == 5)
    {
        double douValue = [_infoModel.depositAmount doubleValue];
        NSString *des = ELALocalizedString(@"由于对您的弹劾已通过。您的委员职务已被免职。根据您的世界履职情况及CRC委员节点的运行情况，您的竞选押金返还额度为");
        NSString *string = [NSString stringWithFormat:@"%@%0.4fELA", des, douValue];
        subLabel.text = string;
        updateInfoButton.hidden = YES;
        nodeButton.hidden = YES;
        [button setTitle:ELALocalizedString(@"提取质押金") forState:(UIControlStateNormal)];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
    }
    else if(_type == 6)
    {
        double douValue = [_infoModel.depositAmount doubleValue];
        NSString *des = ELALocalizedString(@"上届CR委员会因故解散，所有委员自动去职。根据您时机履职情况及CRC委员节点的运行情况，您的竞选押金返回金额为");
        NSString *string = [NSString stringWithFormat:@"%@%0.4fELA", des, douValue];
        subLabel.text = string;
        updateInfoButton.hidden = YES;
        nodeButton.hidden = YES;
        [button setTitle:ELALocalizedString(@"提取质押金") forState:(UIControlStateNormal)];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(button.mas_top).offset(-20);
        }];
    }
    else if(_type == 7)
    {
        NSString *des = [NSString stringWithFormat:@"%@\n%@", ELALocalizedString(@"由于您的委员节点处于未激活状态，您的委员职务将暂时停职。"), ELALocalizedString(@"请尽快处理节点问题，以免影响委员权限。")];
        NSString *text = ELALocalizedString(des);
        subLabel.text = text;
        if (self.infoModel.dpospublickey && ![self.infoModel.dpospublickey isEqualToString:@""]) {
            [nodeButton setTitle:ELALocalizedString(@"管理CR节点") forState:(UIControlStateNormal)];
        }
        button.hidden = YES;
        updateInfoButton.hidden = YES;
        
        [nodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-BottomHeight - 40);
        }];
        
        [updateInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(nodeButton.mas_top).offset(-20);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(250));
            make.height.equalTo(@(40));
            make.bottom.equalTo(nodeButton.mas_top).offset(-20);
        }];
    }
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(@(NavigitionBarHeight + 15));
        make.height.equalTo(@(360));
    }];
    //
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(infoView);
    }];
    //
    //
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(infoView);
        make.top.equalTo(infoView).offset(40);
        make.width.height.equalTo(@(80));
        
    }];
    //
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImageView);
        make.top.equalTo(headImageView.mas_bottom).offset(15);
    }];
    
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(85);
    }];
    
}

@end
