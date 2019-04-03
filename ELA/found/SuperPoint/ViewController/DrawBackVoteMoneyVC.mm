//
//  DrawBackVoteMoneyVC.m
//  elastos wallet
//
//  Created by 樊晓乐 on 2019/2/15.
//

#import "DrawBackVoteMoneyVC.h"
#import "HMWSecurityVerificationPopView.h"
#import "ELWalletManager.h"
#import "assetDetailsModel.h"
@interface DrawBackVoteMoneyVC ()<HMWSecurityVerificationPopViewDelegate>
@property(strong,nonatomic)HMWSecurityVerificationPopView *securityVerificationPopV;

@property (weak, nonatomic) IBOutlet UILabel *tagNodeNameLab;

@property (weak, nonatomic) IBOutlet UILabel *tagNote;

@property (weak, nonatomic) IBOutlet UIButton *drawBtn;

@property(nonatomic,strong) assetDetailsModel *model;

@end

@implementation DrawBackVoteMoneyVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self defultWhite];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iconInfoUpdate:) name:progressBarcallBackInfo object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImg:@"tab_bg"];
    self.title= NSLocalizedString(@"选举管理", nil);
    self.tagNote.text = NSLocalizedString(@"注销报名72小时后，方可提取质押金", nil);
    self.tagNodeNameLab.text = NSLocalizedString(@"节点名称", nil);
    self.drawBtn.enabled = NO;
    [self.drawBtn setTitle:NSLocalizedString(@"取回质押金", nil) forState:UIControlStateNormal];
    
    
    ELWalletManager *manager   =  [ELWalletManager share];
    
    IMainchainSubWallet *mainchainSubWallet = [manager getWalletELASubWallet:manager.currentWallet.masterWalletID];
    
    nlohmann::json info = mainchainSubWallet->GetRegisteredProducerInfo();
    NSString *dataStr = [NSString stringWithUTF8String:info.dump().c_str()];
    
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:[dataStr  dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
//    ELWalletManager *manager   =  [ELWalletManager share];
//
//    IMainchainSubWallet *mainchainSubWallet = [manager getWalletELASubWallet:manager.currentWallet.masterWalletID];
    
//    Json result = mainchainSubWallet->GetAllTransaction(0, 500,"");
//    NSString *dataStr = [NSString stringWithUTF8String:result.dump().c_str()];
//
//    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:[dataStr  dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//    NSArray *tranList=[NSArray modelArrayWithClass:assetDetailsModel.class json:param[@"Transactions"]];
    
    //取 注销记录
//    for (int i=0; i < tranList.count; i++) {
//        assetDetailsModel *model1 = tranList[i];
//        if (model1.Type.integerValue==10 && model1.ConfirmStatus.integerValue>=1) {
//            self.model = model1;
//            break;
//        }
//    }
//    if (self.model==nil) {
//        self.drawBtn.enabled = NO;
//        return;
//    }
    if ([param[@"Info"][@"Confirms"] integerValue]>2160) {
        self.drawBtn.enabled=YES;
    }else{
        self.drawBtn.enabled=NO;
    }
}
-(void)iconInfoUpdate:(NSNotification*)notice{
    
    NSDictionary *dic  = notice.object;
    
    
  
    NSArray *infoArray=[[FLTools share]stringToArray:dic[@"callBackInfo"]];
    
    NSString *walletID=infoArray.firstObject;
    NSString *chainID=infoArray[1];
    NSInteger index = [infoArray[2] integerValue];
  
    NSString * currentBlockHeight=dic[@"currentBlockHeight"];
    
    
   
  
    
    
    ELWalletManager *manager   =  [ELWalletManager share];
    
    if (![manager.currentWallet.masterWalletID isEqualToString:walletID]&& [chainID isEqualToString:@"ELA"]) {
        return;
    }
    IMainchainSubWallet *mainchainSubWallet = [manager getWalletELASubWallet:manager.currentWallet.masterWalletID];
    
    Json result = mainchainSubWallet->GetAllTransaction(0, 500,"");
    NSString *dataStr = [NSString stringWithUTF8String:result.dump().c_str()];
    
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:[dataStr  dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSArray *tranList=[NSArray modelArrayWithClass:assetDetailsModel.class json:param[@"Transactions"]];
    
    //取 注销记录
    for (int i=0; i < tranList.count; i++) {
        assetDetailsModel *model1 = tranList[i];
        if (model1.Type.integerValue==10 && model1.ConfirmStatus.integerValue>=1) {
            self.model = model1;
            break;
        }
    }
    if (self.model==nil) {
        self.drawBtn.enabled = NO;
        return;
    }
        self.drawBtn.enabled = ([currentBlockHeight integerValue]-self.model.Height.integerValue>=2160);
}
- (IBAction)drawBackAction:(id)sender {
    [self.view addSubview:self.securityVerificationPopV];
    [self.securityVerificationPopV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
}
-(HMWSecurityVerificationPopView *)securityVerificationPopV{
    if (!_securityVerificationPopV) {
        _securityVerificationPopV =[[HMWSecurityVerificationPopView alloc]init];
        _securityVerificationPopV.backgroundColor=[UIColor clearColor];
        _securityVerificationPopV.delegate=self;
    }
    
    return _securityVerificationPopV;
}

-(void)takeOutOrShutDown{
    [self.securityVerificationPopV removeFromSuperview];
    self.securityVerificationPopV=nil;
}
-(void)makeSureWithPWD:(NSString*)pwdString{
    
    [self.view endEditing:YES];

    ELWalletManager *manager = [ELWalletManager share];
    
    NSString *walletId =  manager.currentWallet.masterWalletID;
    IMainchainSubWallet *wallet = [manager getWalletELASubWallet:walletId];
    NSString *ownerpublickey  =[NSString stringWithCString:wallet->GetPublicKeyForVote().c_str() encoding:NSUTF8StringEncoding];
    
    [HttpUrl NetPOSTHost:Http_IP url:@"/api/dposnoderpc/check/getdepositcoin" header:@{} body:@{@"ownerpublickey":ownerpublickey} showHUD:YES WithSuccessBlock:^(id data) {
        CGFloat available = [data[@"data"][@"result"][@"available"] doubleValue];
        BOOL ret = [manager RetrieveDeposit:walletId acount:available-0.0001  Pwd:pwdString];
        [self takeOutOrShutDown];
        if (ret) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } WithFailBlock:^(id data) {
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end