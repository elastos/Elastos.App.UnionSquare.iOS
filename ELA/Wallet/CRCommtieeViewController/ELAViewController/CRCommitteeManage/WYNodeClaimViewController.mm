//
/*
 * Copyright (c) 2022 Gelaxy Team
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


#import "WYNodeClaimViewController.h"
#import "HWMTransactionDetailsView.h"
#import "HMWSendSuccessPopuView.h"
#import "ELWalletManager.h"
#import "YYKit.h"
#import "ELAVotingProcessUtil.h"

@interface WYNodeClaimViewController () <HWMTransactionDetailsViewDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *DPoSTextField;

@property (strong, nonatomic) HWMTransactionDetailsView *ShowPoPWDView;
@property (strong, nonatomic) HMWSendSuccessPopuView *sendSuccessPopuV;
@property (strong, nonatomic) ELAVotingProcessUtil *votingProcessUtil;

@end

@implementation WYNodeClaimViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
    [self.view addSubview:containerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [containerView.topAnchor constraintEqualToAnchor:margin.topAnchor constant:15.f],
        [containerView.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor constant:15.f],
        [containerView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor constant:-15.f],
        [containerView.heightAnchor constraintEqualToConstant:130.f]
    ]];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [containerView addSubview:self.titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:15.f],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-15.f],
        [self.titleLabel.heightAnchor constraintEqualToConstant:55.f]
    ]];
    
    UIView *sepView1 = [[UIView alloc] init];
    sepView1.translatesAutoresizingMaskIntoConstraints = NO;
    sepView1.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.5f);
    [containerView addSubview:sepView1];
    
    [NSLayoutConstraint activateConstraints:@[
        [sepView1.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:15.f],
        [sepView1.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-15.f],
        [sepView1.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
        [sepView1.heightAnchor constraintEqualToConstant:1.f]
    ]];
    
    self.DPoSTextField = [[UITextField alloc] init];
    self.DPoSTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.DPoSTextField.backgroundColor = [UIColor clearColor];
    self.DPoSTextField.textColor = [UIColor whiteColor];
    self.DPoSTextField.font = [UIFont systemFontOfSize:14.f];
    self.DPoSTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.DPoSTextField withTxt:NSLocalizedString(@"请输入运营公钥（必填）", nil)];
    [containerView addSubview:self.DPoSTextField];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.DPoSTextField.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:15.f],
        [self.DPoSTextField.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-15.f],
        [self.DPoSTextField.topAnchor constraintEqualToAnchor:sepView1.bottomAnchor],
        [self.DPoSTextField.heightAnchor constraintEqualToConstant:55.f]
    ]];
    
    UIView *sepView2 = [[UIView alloc] init];
    sepView2.translatesAutoresizingMaskIntoConstraints = NO;
    sepView2.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.5f);
    [containerView addSubview:sepView2];
    
    [NSLayoutConstraint activateConstraints:@[
        [sepView2.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:15.f],
        [sepView2.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-15.f],
        [sepView2.topAnchor constraintEqualToAnchor:self.DPoSTextField.bottomAnchor],
        [sepView2.heightAnchor constraintEqualToConstant:1.f]
    ]];
    
    UIButton *nextButton = [[UIButton alloc] init];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    nextButton.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
    [self makeBordersWithView:nextButton];
    [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [nextButton.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [nextButton.widthAnchor constraintEqualToConstant:250.f],
        [nextButton.heightAnchor constraintEqualToConstant:40.f],
        [nextButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-120.f]
    ]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    
    WYLog(@"=== dev temp ===: infoModel dpospublickey: %@", self.infoModel.dpospublickey);
    
    if (self.infoModel.dpospublickey && ![self.infoModel.dpospublickey isEqualToString:@""]) {
        self.title = NSLocalizedString(@"管理CR节点", nil);
        self.DPoSTextField.text = self.infoModel.dpospublickey;
    } else {
        self.title = NSLocalizedString(@"领取CR节点", nil);
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Node", nil), self.infoModel.didName];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
    selector:@selector(onTxPublish:) name:OnTxPublishedResult object:nil];
}

- (void)nextButtonPressed:(id)sender {
    NSString *nodekey = self.DPoSTextField.text;
    if (!nodekey || [nodekey isEqualToString:@""] || [nodekey isEqualToString:self.infoModel.dpospublickey]) {
        [[FLTools share] showErrorInfo:NSLocalizedString(@"请输入运营公钥（必填）", nil)];
        return;
    }
    
    UIView *mainView =[self mainWindow];
    [mainView addSubview:self.ShowPoPWDView];
    [self.ShowPoPWDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(mainView);
    }];
}

-(HWMTransactionDetailsView *)ShowPoPWDView{
    if (!_ShowPoPWDView) {
        _ShowPoPWDView=[[HWMTransactionDetailsView alloc]init];
        _ShowPoPWDView.delegate=self;
        _ShowPoPWDView.DetailsType=didInfoType;
        [_ShowPoPWDView  TransactionDetailsWithFee:@"0.0001" withTransactionDetailsAumont:nil];
    }
    return _ShowPoPWDView;
}

- (void)pwdAndInfoWithPWD:(NSString*)pwd {
    [self claimNode:pwd];
}

- (void)closeTransactionDetailsView {
    [self.ShowPoPWDView removeFromSuperview];
    self.ShowPoPWDView = nil;
}

- (void)onTxPublish:(NSNotification*)notice{

    _votingProcessUtil = [ELAVotingProcessUtil shareVotingProcess];
    NSMutableDictionary *resultDic = _votingProcessUtil.resultDic;
    
    NSDictionary *param =notice.object;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        WYLog(@"TxPublish Code = %@",param[@"Code"]);
        
        WYLog(@"TxPublish SignTransaction = %@",resultDic[@"SignTransaction"]);
        WYLog(@"TxPublish result = %@",resultDic[@"result"]);
        
        if(resultDic != nil
           && [[resultDic allKeys] containsObject:@"result"]
           && resultDic[@"result"] != nil){
            [self showSendSuccessOrFial:sendDealType];
        } else {
            [self showSendSuccessOrFial:SignatureFailureType];
        }
    
    });

    
}

- (void)showSendSuccessOrFial:(SendSuccessType)type{
    [self closeTransactionDetailsView];
    [SVProgressHUD dismiss];
    self.sendSuccessPopuV.type=type;
    [self.view addSubview:self.sendSuccessPopuV];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sendSuccessPopuV removeAllSubviews];
        self.sendSuccessPopuV=nil;
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (HMWSendSuccessPopuView *)sendSuccessPopuV{
    if (!_sendSuccessPopuV) {
        _sendSuccessPopuV=[[HMWSendSuccessPopuView alloc]init];
    }
    return _sendSuccessPopuV;
}

- (void)claimNode:(NSString *)pwd {
    [[FLTools share] showLoadingView];
    invokedUrlCommand *mommand = [[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID, pwd] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"exportWalletWithMnemonic"];
    PluginResult *result = [[ELWalletManager share]VerifyPayPassword:mommand];
    NSNumber *number = result.status;
    
    if( [number intValue] != 1)
    {
        NSString *errCode=[NSString stringWithFormat:@"%@", result.message[@"error"][@"message"]];
        [[FLTools share]showErrorInfo:NSLocalizedString(errCode, nil)];
        return;
    }

    NSDictionary *payloadDic = @{
        @"NodePublicKey": self.DPoSTextField.text,
        @"CRCouncilMemberDID": [self.infoModel.did stringByReplacingOccurrencesOfString:@"did:elastos:" withString:@""]
    };
    
    WYLog(@"=== dev temp === Node Claim Transaction payload: %@", payloadDic);
    
    mommand = [[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID, payloadDic, pwd] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"nodeClaimTransaction"];
    
    _votingProcessUtil = [ELAVotingProcessUtil shareVotingProcess];
    PluginResult *pluginResult = [[ELWalletManager share] nodeClaimTransaction:mommand];
    _votingProcessUtil.resultDic = pluginResult.message[@"success"];
    
    WYLog(@"=== dev temp === nodeClaimTransaction: %@",_votingProcessUtil.resultDic);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
