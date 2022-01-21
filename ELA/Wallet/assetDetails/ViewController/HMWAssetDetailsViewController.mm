//
//  HMWAssetDetailsViewController.m
//  ELA
//
//  Created by  on 2018/12/26.
//  Copyright © 2018 HMW. All rights reserved.
//

#import "HMWAssetDetailsViewController.h"
#import "HMWAssetDetailsTableViewCell.h"
#import "HMWcollectionViewController.h"
#import "HMWtransferViewController.h"
#import "HMWChooseSideChainViewController.h"
#import "HMWtransferTransactionDetailsViewController.h"
#import "assetDetailsModel.h"
#import "HMWTop_upPageForDetailsViewController.h"
#import "ELWalletManager.h"
#import "showOwnerAddressTableViewCell.h"
#import "HMWToDeleteTheWalletPopView.h"
#import "HWMTransactionDetailsView.h"
//#import "HMWpwdPopupView.h"
#import "HMWSendSuccessPopuView.h"
#import "WYVoteUtils.h"
#import "WYVoteDetailsViewController.h"


static NSString *cellString=@"HMWAssetDetailsTableViewCell";
static NSString *showOwnerAddressCellString=@"showOwnerAddressTableViewCell";




@interface HMWAssetDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,HMWToDeleteTheWalletPopViewDelegate,HWMTransactionDetailsViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UIButton *topUpButton;

@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightOff;

@property (weak, nonatomic) IBOutlet UILabel *noDataSourceTextLabel;

/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger currentIndex;
/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger allTotal;
/*
 *<# #>
 */
@property(strong,nonatomic)NSMutableArray *allListArray;

/*
 *<# #>
 */
@property(assign,nonatomic)BOOL isUpdate;
/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger allTotalMAXCount;
/*
 *<# #>
 */
@property(strong,nonatomic)NSArray *allAddressAaary;
@property (weak, nonatomic) IBOutlet UILabel *transactionRecordsTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteBlanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *voteElaLabel;
@property (weak, nonatomic) IBOutlet UILabel *allBlanceTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteBlanceTextLabel;
/*
 *<# #>
 */
@property(strong,nonatomic)NSMutableArray * NodeReturnsMutableArray;
/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger NodeReturnsCurrentIndex;
/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger NodeReturnsAllTotal;


/*
 *<# #>
 */
@property(assign,nonatomic)BOOL NodeReturnsIsUpdate;
/*
 *<# #>
 */
@property(assign,nonatomic)NSInteger NodeReturnsAllTotalMAXCount;
@property (weak, nonatomic) IBOutlet UIButton *anyChangeInTheWholeButton;
@property (weak, nonatomic) IBOutlet UIButton *transactionRecordsBtton;
@property (weak, nonatomic) IBOutlet UIButton *EarningsRecordButton;

@property (weak, nonatomic) IBOutlet UIButton *voteStatusButton;
@property (weak, nonatomic) IBOutlet UIView *voteStatusView;

@property (weak, nonatomic) IBOutlet UIView *voteOverviewView;
@property (weak, nonatomic) IBOutlet UIView *voteSepView;
@property (weak, nonatomic) IBOutlet UIView *voteDPoSView;
@property (weak, nonatomic) IBOutlet UIView *voteCRCView;
@property (weak, nonatomic) IBOutlet UIView *voteImpeachView;
@property (weak, nonatomic) IBOutlet UIView *voteProposalView;

@property (weak, nonatomic) IBOutlet UIButton *DPoSInvalidButton;
@property (weak, nonatomic) IBOutlet UIButton *CRCInvalidButton;
@property (weak, nonatomic) IBOutlet UIButton *impeachInvalidButton;
@property (weak, nonatomic) IBOutlet UIButton *proposalInvalidButton;

@property (weak, nonatomic) IBOutlet UILabel *voteAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteDetailsButton;

@property (weak, nonatomic) IBOutlet UIImageView *DPoSIconImage;
@property (weak, nonatomic) IBOutlet UILabel *DPoSAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *DPoSTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CRCIconImage;
@property (weak, nonatomic) IBOutlet UILabel *CRCAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *CRCTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *impeachIconImage;
@property (weak, nonatomic) IBOutlet UILabel *impeachAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *impeachTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *proposalIconImage;
@property (weak, nonatomic) IBOutlet UILabel *proposalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalTitleLabel;

/*
 *<# #>
 */
@property(copy,nonatomic)NSString *leftOrRight;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *OwnerAddressString;
/*
 *<# #>
 */
@property(strong,nonatomic)HMWToDeleteTheWalletPopView *utxoTheWalletPopV;
@property(strong,nonatomic)HWMTransactionDetailsView *TransactionDetailsV;
/*
 *<# #>
 */
@property(strong,nonatomic)HMWSendSuccessPopuView *sendSuccessPopuV;
@property (weak, nonatomic) IBOutlet UIView *makeLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toButtonOffSet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enMoneyWidthOffSet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toUpMoneyButtonWidthdOff;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *JSONString;

@property (strong, nonatomic) NSDictionary *voteData;

@end

@implementation HMWAssetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    [self makeView];
    self.isUpdate=NO;
    self.balanceLabel.text=[NSString stringWithFormat:@"%@",[[FLTools share]elaScaleConversionWith: self.model.iconBlance]];
    self.currencyNameLabel.text=@"ELA";
    self.updateTimeLabel.text=self.model.updateTime;
    self.currentIndex=0;
    [self loadAllTransactionWithIndex:self.currentIndex];
    [self.transferButton setTitle:NSLocalizedString(@"转账", nil) forState:UIControlStateNormal];
    [self.collectionButton setTitle:NSLocalizedString(@"收款", nil) forState:UIControlStateNormal];
    [self.transactionRecordsBtton setTitle:NSLocalizedString(@"交易记录", nil) forState:UIControlStateNormal];
    [self.EarningsRecordButton setTitle:NSLocalizedString(@"收益记录", nil) forState:UIControlStateNormal];
    [self.voteStatusButton setTitle:NSLocalizedString(@"投票状态", nil) forState:UIControlStateNormal];
    
    self.DPoSInvalidButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.DPoSInvalidButton.titleLabel.minimumScaleFactor = 0.5f;
    [self.DPoSInvalidButton.titleLabel sizeToFit];
    self.DPoSInvalidButton.layer.masksToBounds = YES;
    self.DPoSInvalidButton.layer.cornerRadius = self.DPoSInvalidButton.bounds.size.height / 2;
    
    self.CRCInvalidButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.CRCInvalidButton.titleLabel.minimumScaleFactor = 0.5f;
    [self.CRCInvalidButton.titleLabel sizeToFit];
    self.CRCInvalidButton.layer.masksToBounds = YES;
    self.CRCInvalidButton.layer.cornerRadius = self.CRCInvalidButton.bounds.size.height / 2;
    
    self.impeachInvalidButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.impeachInvalidButton.titleLabel.minimumScaleFactor = 0.5f;
    [self.impeachInvalidButton.titleLabel sizeToFit];
    self.impeachInvalidButton.layer.masksToBounds = YES;
    self.impeachInvalidButton.layer.cornerRadius = self.impeachInvalidButton.bounds.size.height / 2;
    
    self.proposalInvalidButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.proposalInvalidButton.titleLabel.minimumScaleFactor = 0.5f;
    [self.proposalInvalidButton.titleLabel sizeToFit];
    self.proposalInvalidButton.layer.masksToBounds = YES;
    self.proposalInvalidButton.layer.cornerRadius = self.proposalInvalidButton.bounds.size.height / 2;
    
    self.voteDetailsButton.layer.borderWidth = 1.f;
    self.voteDetailsButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.voteDetailsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.voteDetailsButton.titleLabel.minimumScaleFactor = 0.5f;
    
    self.DPoSTitleLabel.text = NSLocalizedString(@"DPoS节点选举", nil);
    self.CRCTitleLabel.text = NSLocalizedString(@"CR委员选举", nil);
    self.impeachTitleLabel.text = NSLocalizedString(@"CR委员弹劾", nil);
    self.proposalTitleLabel.text = NSLocalizedString(@"社区提案反对票", nil);
    
    self.topUpButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.anyChangeInTheWholeButton setTitle:NSLocalizedString(@"零钱换整", nil) forState:UIControlStateNormal];
    [self transactionRecordsAction:nil];
    [self.baseTableView setBackgroundColor:RGB(107, 133, 135)];
    [self.voteStatusView setBackgroundColor:RGB(107, 133, 135)];
    self.leftOrRight=@"0";
    if ([self.model.iconName isEqualToString:@"ELA"]) {
        [self GetRegisteredProducerInfo];
        if (self.synchronousP==1) {
            [self DetectionOfTheBalance];
        }
        
    }else{
        self.anyChangeInTheWholeButton.alpha=0.f;
        self.EarningsRecordButton.alpha=0.f;
        self.makeLineView.alpha=0.f;
        self.toButtonOffSet.constant=-100;
        self.enMoneyWidthOffSet.constant=-AppWidth+30;
        self.toUpMoneyButtonWidthdOff.constant=250;
        //        self.topUpButton.backgroundColor=[UIColor redColor];
        [self.topUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        self.topUpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(currentWalletAccountBalanceChanges:) name: AccountBalanceChanges object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iconInfoUpdate:) name:progressBarcallBackInfo object:nil];
    
}

-(void)currentWalletAccountBalanceChanges:(NSNotification *)notification{
    
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:notification.object];
    NSArray *infoArray=[[FLTools share]stringToArray:dic[@"callBackInfo"]];
    
    NSString *walletID=infoArray.firstObject;
    NSString *chainID=infoArray[1];
    //    NSInteger index = [infoArray[2] integerValue];
    NSString *  balance=dic[@"balance"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.title isEqualToString:chainID]&&[self.currentWallet.masterWalletID isEqualToString:walletID]){
            self.balanceLabel.text=[NSString stringWithFormat:@"%@",[[FLTools share]elaScaleConversionWith: balance]];
            self.currencyNameLabel.text=@"ELA";
        }});
}

-(void)iconInfoUpdate:(NSNotification *)notification{
    
    
    NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
    [waitQueue addOperationWithBlock:^{
        NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:notification.object];
        NSArray *infoArray=[[FLTools share]stringToArray:dic[@"callBackInfo"]];
        NSString *walletID=infoArray.firstObject;
        NSString *chainID=infoArray[1];
        //    NSInteger index = [infoArray[2] integerValue];
        NSString *lastBlockTimeString=dic[@"lastBlockTimeString"];
        //    NSString * currentBlockHeight=dic[@"currentBlockHeight"];
        //    NSString *  progress=dic[@"progress"];
        if ([self.currentWallet.masterWalletID isEqualToString:walletID]){
            if ([self.model.iconBlance isEqualToString:chainID]) {
                
                
                NSString *YYMMSS =[[FLTools share]YMDHMSgetTimeFromTimesTamp:lastBlockTimeString];
                self.model.updateTime=[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"已同步区块时间", nil),YYMMSS];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.updateTimeLabel.text=self.model.updateTime;
                });
            }
        }}];
}

-(void)DetectionOfTheBalance{
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"GetAllUTXOs"];
    PluginResult * result =[[ELWalletManager share]GetAllUTXOs:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]){
        NSInteger  MaxCount=[result.message[@"success"][@"MaxCount"] integerValue];
        if (MaxCount>500) {
            [self AnyChangeInTheWholeWithUTXOs:[NSString stringWithFormat:@"%ld",MaxCount]];
        }
    }
}

-(void)AnyChangeInTheWholeWithUTXOs:(NSString*)UTXOs{
    UIView *mainView=[self mainWindow];
    [mainView addSubview:self.utxoTheWalletPopV];
    self.utxoTheWalletPopV.UtxosString=UTXOs;
    [self.utxoTheWalletPopV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(mainView);
    }];
    
}

-(HMWToDeleteTheWalletPopView *)utxoTheWalletPopV{
    if (!_utxoTheWalletPopV) {
        _utxoTheWalletPopV =[[HMWToDeleteTheWalletPopView alloc]init];
        _utxoTheWalletPopV.delegate=self;
        _utxoTheWalletPopV.deleteType=UtxoChangeWhole;
    }
    
    return _utxoTheWalletPopV;
}

-(void)GetRegisteredProducerInfo{
    ELWalletManager *manager   =  [ELWalletManager share];
    
    IMainchainSubWallet *mainchainSubWallet = [manager getWalletELASubWallet:manager.currentWallet.masterWalletID];
    nlohmann::json info;
    const String stringC;
    NSString *dataStr;
    NSDictionary *CRparam;
    try {
        info = mainchainSubWallet->GetRegisteredProducerInfo();
        const String stringC = info.dump();
        dataStr = [NSString stringWithCString:stringC.c_str() encoding:NSUTF8StringEncoding];
        nlohmann::json CRinfo = mainchainSubWallet->GetRegisteredCRInfo();
        NSString *CRdataStr = [NSString stringWithUTF8String:CRinfo.dump().c_str()];
        CRparam = [NSJSONSerialization JSONObjectWithData:[CRdataStr   dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    } catch (const std:: exception &e ){
    }
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:[dataStr  dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString *Status = param[@"Status"];
    
    //    if (self.EarningsRecordButton.alpha==0) {
    
    NSString *CRStatus = CRparam[@"Status"];
    
    //
    //        if ([Status isEqualToString:@"Registered"]){
    //             [self loadGetOwnerAddress];
    //
    //         }else if([Status isEqualToString:@"Canceled"]){
    //             [self loadGetOwnerAddress];
    //
    //         }else if([Status isEqualToString:@"Unregistered"]){
    //             self.EarningsRecordButton.alpha=0.f;
    //
    //             self.enMoneyWidthOffSet.constant=-AppWidth+30;
    //             //        self.toUpMoneyButtonWidthdOff.constant=200;
    //
    //         }else if ([Status isEqualToString:@"ReturnDeposit"]){
    //
    //             [self loadGetOwnerAddress];
    //
    //         }
    //    if ([CRStatus isEqualToString:@"Registered"]){
    //        [self loadGetOwnerAddress];
    //    }else if([CRStatus isEqualToString:@"Canceled"]){
    //        [self loadGetOwnerAddress];
    //
    //    }else
    if([CRStatus isEqualToString:@"Unregistered"]&&[Status isEqualToString:@"Unregistered"]){
        self.EarningsRecordButton.alpha=0.f;
        self.enMoneyWidthOffSet.constant=-AppWidth+30;
    }else{
        if (![CRStatus isEqualToString:@"Unregistered"]) {
            self.OwnerAddressString=self.allAddressAaary.firstObject;
        }else if (![Status isEqualToString:@"Unregistered"]){
            self.OwnerAddressString=[[ELWalletManager share]GetOwnerAddressWithID:self.currentWallet.masterWalletID];
        }
        [self loadGetOwnerAddress];
        
    }
    
    //    }
    
    
    
    
}
-(void)loadGetOwnerAddress{
    
    [self.NodeReturnsMutableArray addObject:self.OwnerAddressString];
    
    
}
-(NSMutableArray *)NodeReturnsMutableArray{
    if (!_NodeReturnsMutableArray) {
        _NodeReturnsMutableArray =[[NSMutableArray alloc]init];
    }
    return _NodeReturnsMutableArray;
}
-(void)lockVoiteLoadDataSource{
    
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,@0] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getBalance"];
    PluginResult * result =[[ELWalletManager share]getBalance:mommand];
    
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]){
        NSString *blanceString=[NSString stringWithFormat:@"%@",result.message[@"success"]];
        
        self.voteBlanceLabel.text=[NSString stringWithFormat:@"%@",[[FLTools share] elaScaleConversionWith:blanceString ]];
        
    }
    
}
-(NSMutableArray *)allListArray{
    if (!_allListArray) {
        _allListArray =[[NSMutableArray alloc]init];
    }
    return _allListArray;
}
-(void)loadGetAllCoinBaseTransactionWithIndex:(NSInteger)index{
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,@(index),@"20",@""] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllTransaction"];
    PluginResult * result =[[ELWalletManager share]GetAllCoinBaseTransaction:mommand];
    if (self.NodeReturnsIsUpdate) {
        [self.NodeReturnsMutableArray removeAllObjects];
        [self.NodeReturnsMutableArray addObject:self.OwnerAddressString];
    }
    NSInteger a=[result.message[@"success"][@"MaxCount"] integerValue];
    self.NodeReturnsAllTotal=a;
    NSArray *tranList=[NSArray modelArrayWithClass:assetDetailsModel.class json:result.message[@"success"][@"Transactions"]];
    [self.NodeReturnsMutableArray addObjectsFromArray:tranList];
    self.NodeReturnsCurrentIndex=self.NodeReturnsMutableArray.count-1;
    if (self.NodeReturnsMutableArray.count==1) {
        self.noDataSourceTextLabel.text=NSLocalizedString(@"暂无收益记录", nil);
        self.noDataSourceTextLabel.alpha=1.f;
    }else{
        self.noDataSourceTextLabel.alpha=0.f;
    }
    [self.baseTableView reloadData];
    [self  baseTableViewEndRF];
    
}
-(void)loadAllTransactionWithIndex:(NSInteger)index{
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,@(index),@"20",@""] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllTransaction"];
    
    PluginResult * result =[[ELWalletManager share]getAllTransaction:mommand];
    if (self.isUpdate) {
        [self.allListArray removeAllObjects];
    }
    //    self.allTotalMAXCount=[result.message[@"success"][@"MaxCount"] integerValue];
    NSInteger a=[result.message[@"success"][@"MaxCount"] integerValue];
    self.allTotal=a;
    NSArray *tranList=[NSArray modelArrayWithClass:assetDetailsModel.class json:result.message[@"success"][@"Transactions"]];
    
    [self.allListArray addObjectsFromArray:tranList];
    if (self.allListArray.count==0) {
        self.noDataSourceTextLabel.alpha=1.f;
        self.noDataSourceTextLabel.text=NSLocalizedString(@"暂无交易记录", nil);
    }else{
        self.noDataSourceTextLabel.alpha=0.f;
        
    }
    self.currentIndex=self.allListArray.count;
    [self.baseTableView reloadData];
    [self  baseTableViewEndRF];
    
}
-(void)loadAnyChangeInTheWhole{
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllTransaction"];
    PluginResult * result =[[ELWalletManager share]CreateCombineUTXOTransactionFeeAndJSONString:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]) {
        UIView *mainView=[self mainWindow];
        [mainView addSubview:self.TransactionDetailsV];
        NSString *fee=[[FLTools share]elaScaleConversionWith:[NSString stringWithFormat:@"%@",result.message[@"success"][@"fee"]]];
        [self.TransactionDetailsV TransactionDetailsWithFee:fee withTransactionDetailsAumont:nil];
        self.JSONString=result.message[@"success"][@"jsonString"];
        [self.TransactionDetailsV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(mainView);
        }];
    }
}
- (IBAction)anyChangeInTheWholeAction:(id)sender {
    // 零钱换整
    [ self loadAnyChangeInTheWhole];
    
}

- (IBAction)transactionRecordsAction:(id)sender {
    self.leftOrRight=@"0";
    [self selecttState:self.transactionRecordsBtton];
    [self theNormalState:self.EarningsRecordButton];
    [self theNormalState:self.voteStatusButton];
    
    self.baseTableView.alpha = 1.f;
    self.voteStatusView.alpha = 0.f;
    
    [self.baseTableView reloadData];
    if (self.allListArray.count==0) {
        self.noDataSourceTextLabel.alpha=1.f;
        self.noDataSourceTextLabel.text=NSLocalizedString(@"暂无交易记录", nil);
    }else{
        self.noDataSourceTextLabel.alpha=0.f;
        
    }
    
}

- (IBAction)EarningsRecordAction:(id)sender {
    self.leftOrRight=@"1";
    if (self.NodeReturnsMutableArray.count==1) {
        [self loadGetAllCoinBaseTransactionWithIndex:0];
    }
    [self selecttState:self.EarningsRecordButton];
    [self theNormalState:self.transactionRecordsBtton];
    [self theNormalState:self.voteStatusButton];
    
    self.baseTableView.alpha = 1.f;
    self.voteStatusView.alpha = 0.f;
    
    [self.baseTableView reloadData];
    if (self.NodeReturnsMutableArray.count==1) {
        self.noDataSourceTextLabel.text=NSLocalizedString(@"暂无收益记录", nil);
        self.noDataSourceTextLabel.alpha=1.f;
    }else{
        self.noDataSourceTextLabel.alpha=0.f;
    }
}

- (IBAction)voteStatusPressed:(id)sender {
    
    // 投票记录
    [self selecttState:self.voteStatusButton];
    [self theNormalState:self.transactionRecordsBtton];
    [self theNormalState:self.EarningsRecordButton];
    
    
    self.noDataSourceTextLabel.alpha = 0.f;
    self.baseTableView.alpha = 0.f;
    self.voteStatusView.alpha = 1.f;
    
    NSDictionary *voteInfo = [WYVoteUtils getVoteInfo:self.currentWallet.masterWalletID];
    NSDictionary *voteAmounts = [WYVoteUtils getVoteAmounts:voteInfo];
    NSInteger totalAmount = [WYVoteUtils getTotalAmount:voteAmounts];
    
    if (voteInfo.count < 1 || totalAmount < 1) {
        self.voteOverviewView.alpha = 0.f;
        self.voteSepView.alpha = 0.f;
        self.voteDPoSView.alpha = 0.f;
        self.voteCRCView.alpha = 0.f;
        self.voteImpeachView.alpha = 0.f;
        self.voteProposalView.alpha = 0.f;
        
        self.noDataSourceTextLabel.text=NSLocalizedString(@"暂无投票记录", nil);
        self.noDataSourceTextLabel.alpha = 1.f;
        return;
    }
    
    NSDictionary *voteTimestamps = [WYVoteUtils getVoteTimestamps:voteInfo];
    NSInteger lastTimestamp = [WYVoteUtils getLastTimestamp:voteTimestamps];
    
    NSString *amountStr = [[FLTools share] elaScaleConversionWith:[NSString stringWithFormat:@"%ld", totalAmount]];
    NSString *timeStr = [[FLTools share] YMDHMSgetTimeFromTimesTamp:[NSString stringWithFormat:@"%ld", lastTimestamp]];
    
    self.voteAmountLabel.text = [NSString stringWithFormat:@"%@%@ ELA", NSLocalizedString(@"金额总计：", nil), amountStr];
    self.voteTimeLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"最新投票时间：", nil), timeStr];
    
    NSDictionary *votePayloads = [WYVoteUtils getVotePayloads:voteInfo];
    NSDictionary *voteAddrs = [WYVoteUtils getVoteAddrs:votePayloads];
    
    self.voteDetailsButton.alpha = 0.5f;
    self.voteDetailsButton.userInteractionEnabled = NO;
    [[FLTools share] showLoadingView];
    
    dispatch_async([WYUtils getTaskQueue], ^{
        
        NSDictionary *invalidAddrs = [WYVoteUtils getInvalidAddrs:voteAddrs withVoteTimestamps:voteTimestamps];
        NSDictionary *validPayloads = [WYVoteUtils getValidPayloads:votePayloads withInvalidAddrs:invalidAddrs];
        
        self.voteData = @{
            @"voteInfo": voteInfo,
            @"votePayloads": votePayloads,
            @"voteAmounts": voteAmounts,
            @"totalAmount": amountStr,
            @"voteTimestamps": voteTimestamps,
            @"lastTimestamp": timeStr,
            @"voteAddrs": voteAddrs,
            @"invalidAddrs": invalidAddrs,
            @"validPayloads": validPayloads
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (voteAmounts[@"Delegate"]) {
                self.DPoSIconImage.image = [UIImage imageNamed:@"asset_vote_node"];
                NSString *DPoSAmount = [[FLTools share] elaScaleConversionWith:voteAmounts[@"Delegate"]];
                self.DPoSAmountLabel.text = [NSString stringWithFormat:@"%@ ELA", DPoSAmount];
                self.DPoSAmountLabel.alpha = 1.f;
                
                NSArray *invalidDPoS = invalidAddrs[@"Delegate"];
                NSDictionary *validDPoS = validPayloads[@"Delegate"];
                if (invalidDPoS.count > 0) {
                    self.DPoSInvalidButton.alpha = 1.f;
                    if (validDPoS.count > 0) {
                        self.DPoSInvalidButton.titleLabel.text = NSLocalizedString(@"部分失效", nil);
                    } else {
                        self.DPoSInvalidButton.titleLabel.text = NSLocalizedString(@"已失效", nil);
                    }
                } else {
                    self.DPoSInvalidButton.alpha = 0.f;
                }
            } else {
                self.DPoSIconImage.image = [UIImage imageNamed:@"asset_vote_node_unchecked"];
                self.DPoSAmountLabel.text = @"--";
                self.DPoSAmountLabel.alpha = 0.6f;
                self.DPoSInvalidButton.alpha = 0.f;
            }
            
            if (voteAmounts[@"CRC"]) {
                self.CRCIconImage.image = [UIImage imageNamed:@"asset_vote_cr"];
                NSString *CRCAmount = [[FLTools share] elaScaleConversionWith:voteAmounts[@"CRC"]];
                self.CRCAmountLabel.text = [NSString stringWithFormat:@"%@ ELA", CRCAmount];
                self.CRCAmountLabel.alpha = 1.f;
                
                NSArray *invalidCRC = invalidAddrs[@"CRC"];
                NSDictionary *validCRC = validPayloads[@"CRC"];
                if (invalidCRC.count > 0) {
                    self.CRCInvalidButton.alpha = 1.f;
                    if (validCRC.count > 0) {
                        self.CRCInvalidButton.titleLabel.text = NSLocalizedString(@"部分失效", nil);
                    } else {
                        self.CRCInvalidButton.titleLabel.text = NSLocalizedString(@"已失效", nil);
                    }
                } else {
                    self.CRCInvalidButton.alpha = 0.f;
                }
            } else {
                self.CRCIconImage.image = [UIImage imageNamed:@"asset_vote_cr_unchecked"];
                self.CRCAmountLabel.text = @"--";
                self.CRCAmountLabel.alpha = 0.6f;
                self.CRCInvalidButton.alpha = 0.f;
            }
            
            if (voteAmounts[@"CRCImpeachment"]) {
                self.impeachIconImage.image = [UIImage imageNamed:@"asset_vote_judgement"];
                NSString *impeachAmount = [[FLTools share] elaScaleConversionWith:voteAmounts[@"CRCImpeachment"]];
                self.impeachAmountLabel.text = [NSString stringWithFormat:@"%@ ELA", impeachAmount];
                self.impeachAmountLabel.alpha = 1.f;
                
                NSArray *invalidImpeach = invalidAddrs[@"CRCImpeachment"];
                NSDictionary *validImpeach = validPayloads[@"CRCImpeachment"];
                if (invalidImpeach.count > 0) {
                    self.impeachInvalidButton.alpha = 1.f;
                    if (validImpeach.count > 0) {
                        self.impeachInvalidButton.titleLabel.text = NSLocalizedString(@"部分失效", nil);
                    } else {
                        self.impeachInvalidButton.titleLabel.text = NSLocalizedString(@"已失效", nil);
                    }
                } else {
                    self.impeachInvalidButton.alpha = 0.f;
                }
            } else {
                self.impeachIconImage.image = [UIImage imageNamed:@"asset_vote_judgement_unchecked"];
                self.impeachAmountLabel.text = @"--";
                self.impeachAmountLabel.alpha = 0.6f;
                self.impeachInvalidButton.alpha = 0.f;
            }
            
            if (voteAmounts[@"CRCProposal"]) {
                self.proposalIconImage.image = [UIImage imageNamed:@"cr_vote_nay"];
                NSString *proposalAmount = [[FLTools share] elaScaleConversionWith:voteAmounts[@"CRCProposal"]];
                self.proposalAmountLabel.text = [NSString stringWithFormat:@"%@ ELA", proposalAmount];
                self.proposalAmountLabel.alpha = 1.f;
                
                NSArray *invalidProposal = invalidAddrs[@"CRCProposal"];
                NSDictionary *validProposal = validPayloads[@"CRCProposal"];
                if (invalidProposal.count > 0) {
                    self.proposalInvalidButton.alpha = 1.f;
                    if (validProposal.count > 0) {
                        self.proposalInvalidButton.titleLabel.text = NSLocalizedString(@"部分失效", nil);
                    } else {
                        self.proposalInvalidButton.titleLabel.text = NSLocalizedString(@"已失效", nil);
                    }
                } else {
                    self.proposalInvalidButton.alpha = 0.f;
                }
            } else {
                self.proposalIconImage.image = [UIImage imageNamed:@"cr_vote_nay_unchecked"];
                self.proposalAmountLabel.text = @"--";
                self.proposalAmountLabel.alpha = 0.6f;
                self.proposalInvalidButton.alpha = 0.f;
            }
            
            [[FLTools share] hideLoadingView];
            self.voteDetailsButton.alpha = 1.f;
            self.voteDetailsButton.userInteractionEnabled = YES;
            
        });
        
    });
    
}


- (IBAction)voteDetailsPressed:(id)sender {
    
    self.voteDetailsButton.alpha = 0.5f;
    self.voteDetailsButton.userInteractionEnabled = NO;
    
    NSDictionary *voteInfo = [WYVoteUtils getVoteInfo:self.currentWallet.masterWalletID];
    NSDictionary *voteTimestamps = [WYVoteUtils getVoteTimestamps:voteInfo];
    
    [[FLTools share] showLoadingView];
    
    dispatch_async([WYUtils getTaskQueue], ^{
        
        NSDictionary *allInfo = [WYVoteUtils getAllInfo:voteTimestamps];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[FLTools share] hideLoadingView];
            self.voteDetailsButton.alpha = 1.0f;
            self.voteDetailsButton.userInteractionEnabled = YES;
            
            if (!allInfo) {
                [[FLTools share] showErrorInfo:NSLocalizedString(@"网络错误", nil)];
                return;
            }
            
            WYVoteDetailsViewController *voteDetailsVC = [[WYVoteDetailsViewController alloc] init];
            NSMutableDictionary *voteDataInfo = [self.voteData mutableCopy];
            voteDataInfo[@"allInfo"] = allInfo;
            voteDetailsVC.voteData = voteDataInfo;
            
            [self.navigationController pushViewController:voteDetailsVC animated:YES];
            
        });
        
    });
    
}

- (IBAction)transferEvent:(id)sender {
    self.transferButton.userInteractionEnabled=NO;
    HMWtransferViewController *transferVC=[[HMWtransferViewController alloc]init];
    transferVC.currentWallet=self.currentWallet;
    transferVC.model=self.model;
    
    if (self.allAddressAaary.count==0) {
        self.allAddressAaary=nil;
        //        return;
    }
    transferVC.addressArray=self.allAddressAaary;
    transferVC.supportOfTheCurrencyArray=self.supportOfTheCurrencyArray;
    [self.navigationController pushViewController:transferVC animated:YES];
    self.transferButton.userInteractionEnabled=YES;
    
}

- (IBAction)top_upEvent:(id)sender {
    
    if (![self.title isEqualToString:@"ELA"]) {
        HMWTop_upPageForDetailsViewController *top_upPageForDetailsVC=[[HMWTop_upPageForDetailsViewController alloc]init];
        top_upPageForDetailsVC.title=NSLocalizedString(@"主链提现", nil);
        top_upPageForDetailsVC.selectmModel=self.elaModel;
        top_upPageForDetailsVC.currentWallet=self.currentWallet;
        top_upPageForDetailsVC.fromModel=self.model;
        top_upPageForDetailsVC.type=mainChainWithdrawalType;
        top_upPageForDetailsVC.substringAddress=self.allAddressAaary.firstObject;
        [self.navigationController pushViewController:top_upPageForDetailsVC animated:YES];
        
        
    }else{
        HMWChooseSideChainViewController *chooseSideChainVC=[[HMWChooseSideChainViewController alloc]init];
        chooseSideChainVC.title=self.topUpButton.titleLabel.text;
        
        chooseSideChainVC.currentWallet=self.currentWallet;
        chooseSideChainVC.model=self.model;
        chooseSideChainVC.type=chooseSideChainType;
        chooseSideChainVC.addressArray=self.allAddressAaary;
        chooseSideChainVC.supportOfTheCurrencyArray=self.supportOfTheCurrencyArray;
        [self.navigationController pushViewController:chooseSideChainVC animated:YES];
        
    }
}

- (IBAction)collectionEvent:(id)sender {
    self.collectionButton.userInteractionEnabled=NO;
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"createAddress"];
    PluginResult * result =[[ELWalletManager share]createAddress:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]) {
        HMWcollectionViewController*collectionVC=[[HMWcollectionViewController alloc]init];
        NSArray *addrestStringArray=[NSArray arrayWithArray:self.allAddressAaary];
        if (addrestStringArray.count==0) {
            self.allAddressAaary=nil;
        }
        collectionVC.iconName=self.model.iconName;
        collectionVC.addrestStringArray=self.allAddressAaary;
        collectionVC.iconAddress=[NSString stringWithFormat:@"%@",result.message[@"success"]];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
    
    
    
    self.collectionButton.userInteractionEnabled=YES;
}

-(NSArray *)allAddressAaary{
    if (!_allAddressAaary) {
        
        _allAddressAaary=[NSArray arrayWithArray:[self loadAddress]];
    }
    
    return _allAddressAaary;
}

-(NSArray*)loadAddress{
    
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,@"0",@"100"] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllSubWalletAddress"];
    PluginResult * result =[[ELWalletManager share]getAllSubWalletAddress:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    
    if ([status isEqualToString:@"1"]) {
        NSArray *addressArray=[NSArray arrayWithArray:result.message[@"success"][@"Addresses"]];
        return   addressArray;
    }
    return NULL;
    
    
    
}

-(void)makeView{
    // FINAL VERSION REMOVED ELEMENT
    if ([self.title isEqualToString:@"ELA"]) {
        [self.topUpButton setTitle:NSLocalizedString(@"侧链充值", nil) forState:UIControlStateNormal];
        //        [self.topUpButton setImage:[UIImage imageNamed:@"asset_trade_side_recharge"] forState:UIControlStateNormal];
    }else{
        [self.topUpButton setTitle:NSLocalizedString(@"主链提现", nil) forState:UIControlStateNormal];
        //       [self.topUpButton setImage:[UIImage imageNamed:@"asset_trade_main_withdraw"] forState:UIControlStateNormal];
    }
    
    
    self.baseTableView.delegate=self;
    self.baseTableView.dataSource=self;
    self.baseTableView.rowHeight=70;
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(self) self =weakSelf;
        if ([self.leftOrRight isEqualToString:@"0"]) {
            invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[weakSelf.currentWallet.masterWalletID,self.model.iconName] callbackId:weakSelf.currentWallet.masterWalletID className:@"Wallet" methodName:@"SyncStart"];
            [[ELWalletManager share]SyncStart:mommand];
            
            self.isUpdate=YES;
            
            self.currentIndex=0;
            [self  loadAllTransactionWithIndex: self.currentIndex];
        }else{
            self.NodeReturnsIsUpdate=YES;
            self.NodeReturnsCurrentIndex=0;
            [self loadGetAllCoinBaseTransactionWithIndex:self.NodeReturnsCurrentIndex];
            
        }
        
    }];
    self.baseTableView.mj_header=header;
    self.baseTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof(self) self = weakSelf;
        if ([self.leftOrRight isEqualToString:@"0"]) {
            self.isUpdate=NO;
            if (self.allTotal<=self.currentIndex) {
                
                [self  baseTableViewEndRF];
                
                return ;
            }
            
            [self  loadAllTransactionWithIndex: self.currentIndex];
            
        }else{
            self.NodeReturnsIsUpdate=NO;
            if (self.NodeReturnsAllTotal<=self.NodeReturnsCurrentIndex) {
                [self  baseTableViewEndRF];
                
                return ;
            }
            [self loadGetAllCoinBaseTransactionWithIndex:self.NodeReturnsCurrentIndex];
            
        }
    }];
    self.baseTableView.separatorInset=UIEdgeInsetsMake(-0, 15, 0, 15);
    [self.baseTableView registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:cellString];
    [self.baseTableView registerNib:[UINib nibWithNibName:showOwnerAddressCellString bundle:nil] forCellReuseIdentifier:showOwnerAddressCellString];
    self.baseTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}

-(void)baseTableViewEndRF{
    [self.baseTableView.mj_header endRefreshing];
    [self.baseTableView.mj_footer endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.leftOrRight isEqualToString:@"0"]) {
        return self.allListArray.count;
    }
    return  self.NodeReturnsMutableArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.leftOrRight isEqualToString:@"0"]&&indexPath.row==0) {
        showOwnerAddressTableViewCell *showCell=[tableView dequeueReusableCellWithIdentifier:showOwnerAddressCellString];
        showCell.selectionStyle = UITableViewCellSelectionStyleNone;
        showCell.addreCopyTextLabel.text=self.OwnerAddressString;
        return  showCell;
    }
    
    HMWAssetDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellString];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    //    cell.niceNameString=self.model.iconName;
    cell.niceNameString=@"ELA";
    if ([self.leftOrRight isEqualToString:@"0"]) {
        cell.model=self.allListArray[indexPath.row];
    }else{
        cell.model=self.NodeReturnsMutableArray[indexPath.row];
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.leftOrRight isEqualToString:@"0"]) {
        [self loadTheOrderDetailsWithIndex:indexPath.row];
    }else{
        if (indexPath.row==0) {
            return;
        }
        [self loadGetAllCoinBaseTransactionDetailsWithIndex:indexPath.row];
    }
    
}

-(void)loadGetAllCoinBaseTransactionDetailsWithIndex:(NSInteger)index{
    assetDetailsModel *model= self.NodeReturnsMutableArray[index];
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,@"0",@"20",model.TxHash] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllTransaction"];
    PluginResult * result =[[ELWalletManager share]GetAllCoinBaseTransaction:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    
    //    NSArray * OutputPayload=[NSArray arrayWithArray:result.message[@"success"][@"Transactions"][0][@"OutputPayload"]];
    
    if (![status isEqualToString:@"1"]) {
        return;
    }
    
    NSArray *tranList=[NSArray modelArrayWithClass:assetDetailsModel.class json:result.message[@"success"][@"Transactions"]];
    
    if (tranList.count==0) {
        [[FLTools share]showErrorInfo:NSLocalizedString(@"暂无数据,请耐心等待!", nil)];
        return;
    }
    assetDetailsModel *detailsM=tranList.firstObject;
    HMWtransferTransactionDetailsViewController *transferTransactionDetailsVC=[[HMWtransferTransactionDetailsViewController alloc]init];
    
    detailsM.Amount=[NSString stringWithFormat:@"%@ ELA",[[FLTools share]elaScaleConversionWith:detailsM.Amount]];
    detailsM.Fee=[NSString stringWithFormat:@"%@ ELA",[[FLTools share]elaScaleConversionWith:detailsM.Fee]];
    //    transferTransactionDetailsVC.iconNameString=@"ELA";
    transferTransactionDetailsVC.iconNameString=self.model.iconName;
    detailsM.Type=NSLocalizedString(@"创币收益", nil);
    transferTransactionDetailsVC.TypeString=[NSString stringWithFormat:@"%@",detailsM.Type];
    if ([model.Status isEqualToString:@"Pending"]) {
        detailsM.Timestamp=@"--:--";
    }else{
        detailsM.Timestamp=[[FLTools share]YMDCommunityTimeConversToAllFromTimesTamp:detailsM.Timestamp];
        
    }
    transferTransactionDetailsVC.type=NodeReturnsType;
    transferTransactionDetailsVC.model=detailsM;
    [self.navigationController pushViewController:transferTransactionDetailsVC animated:YES];
    
}

-(void)loadTheOrderDetailsWithIndex:(NSInteger)index{
    assetDetailsModel *model= self.allListArray[index];
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,@"0",@"20",model.TxHash] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllTransaction"];
    PluginResult * result =[[ELWalletManager share]getAllTransaction:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    
    NSArray * OutputPayload=[NSArray arrayWithArray:result.message[@"success"][@"Transactions"][0][@"OutputPayload"]];
    
    if (![status isEqualToString:@"1"]) {
        return;
    }
    
    NSArray *tranList=[NSArray modelArrayWithClass:assetDetailsModel.class json:result.message[@"success"][@"Transactions"]];
    
    if (tranList.count==0) {
        [[FLTools share]showErrorInfo:NSLocalizedString(@"暂无数据,请耐心等待!", nil)];
        return;
    }
    assetDetailsModel *detailsM=tranList.firstObject;
    HMWtransferTransactionDetailsViewController *transferTransactionDetailsVC=[[HMWtransferTransactionDetailsViewController alloc]init];
    detailsM.Amount=[NSString stringWithFormat:@"%@ ELA",[[FLTools share]elaScaleConversionWith:detailsM.Amount]];
    detailsM.Fee=[NSString stringWithFormat:@"%@ ELA",[[FLTools share]elaScaleConversionWith:detailsM.Fee]];
    transferTransactionDetailsVC.iconNameString=self.model.iconName;
    transferTransactionDetailsVC.TypeString=[NSString stringWithFormat:@"%@",detailsM.Type];
    int type=[detailsM.Type intValue];
    transferTransactionDetailsVC.TypeString=[NSString stringWithFormat:@"%@",detailsM.Type];
    switch (type) {
            
        case 0:
            detailsM.Type=NSLocalizedString(@"创币交易", nil);
            break;
        case 1:
            detailsM.Type=NSLocalizedString(@"注册资产交易", nil);
            break;
        case 2:
            detailsM.Type=NSLocalizedString(@"普通转账交易", nil);
            break;
        case 3:
            detailsM.Type=NSLocalizedString(@"记录交易", nil);
            break;
        case 4:
            detailsM.Type=NSLocalizedString(@"部署交易", nil);
            break;
        case 5:
            detailsM.Type=NSLocalizedString(@"侧链挖矿交易", nil);
            break;
        case 6:
            detailsM.Type=NSLocalizedString(@"侧链充值交易", nil);
            break;
        case 7:
            detailsM.Type=NSLocalizedString(@"主链提现交易", nil);
            break;
        case 8:
        {
            NSDictionary*dic=result.message[@"success"][@"Transactions"][0][@"Payload"][0];
            transferTransactionDetailsVC.PayloadInfoString=[NSString stringWithFormat:@"%@\n%@ %@",dic[@"CrossChainAddress"],[[FLTools share] elaScaleConversionWith:dic[@"CrossChainAmount"]],@"ELA"];
            detailsM.Type=NSLocalizedString(@"跨链交易", nil);
        }
            break;
        case 9:
            detailsM.Type=NSLocalizedString(@"注册参选交易", nil);
            break;
        case 10:
            if ([self.model.iconName isEqualToString:@"IDChain"]) {
                detailsM.Type=NSLocalizedString(@"ID 交易", nil);
            }else{
                detailsM.Type=NSLocalizedString(@"取消参选交易", nil);
            }
            break;
        case 11:
            detailsM.Type=NSLocalizedString(@"更新参选交易", nil);
            break;
        case 12:
            if ([self.model.iconName isEqualToString:@"IDChain"]) {
                detailsM.Type=NSLocalizedString(@"取回参选质押资产交易", nil);
            }else{
                detailsM.Type=NSLocalizedString(@"提取DPoS质押金交易", nil);
            }
            break;
        case 13:
            detailsM.Type=NSLocalizedString(@"未知交易类型", nil);
            break;
        case 33:
            detailsM.Type=NSLocalizedString(@"注册CR参选交易", nil);
            break;
        case 34:
            detailsM.Type=NSLocalizedString(@"取消CR参选交易", nil);
            break;
        case 35:
            detailsM.Type=NSLocalizedString(@"更新CR参选信息交易", nil);
            break;
        case 36:
            if ([self.model.iconName isEqualToString:@"IDChain"]) {
                detailsM.Type=NSLocalizedString(@"取回CR参选质押资产交易", nil);
            }else{
                detailsM.Type=NSLocalizedString(@"提取CR质押金交易", nil);
            }
            break;
        case 37:
            detailsM.Type=NSLocalizedString(@"提案发起交易", nil);
            break;
        case 38:
            detailsM.Type=NSLocalizedString(@"提案评议交易", nil);
            break;
        case 39:
            detailsM.Type=NSLocalizedString(@"提案反馈交易", nil);
            break;
        case 41:
            detailsM.Type=NSLocalizedString(@"提案资金提取交易", nil);
            break;
        case 42:
            detailsM.Type=NSLocalizedString(@"拨款交易", nil);
            break;
        case 49:
            detailsM.Type=NSLocalizedString(@"CR委员节点交易", nil);
            break;
            
        default:
            break;
    }
    
    
    if ([model.Status isEqualToString:@"Pending"]) {
        detailsM.Timestamp=@"--:--";
    }else{
        detailsM.Timestamp=[[FLTools share]YMDCommunityTimeConversToAllFromTimesTamp:detailsM.Timestamp];
        
    }
    transferTransactionDetailsVC.votesString=[[FLTools share]elaScaleConversionWith:OutputPayload[0]];
    if ([detailsM.Direction isEqualToString:@"Received"]) {
        transferTransactionDetailsVC.type=transactionMultipleIntoType;
    }else if ([detailsM.Direction isEqualToString:@"Sent"]){
        transferTransactionDetailsVC.type=transactionSingleRollOutType;
    }else if (OutputPayload.count>0){
        detailsM.Type=NSLocalizedString(@"投票交易", nil);
        transferTransactionDetailsVC.type=rotationToVoteType;
        transferTransactionDetailsVC.votesString=[[FLTools share]elaScaleConversionWith:OutputPayload[0][@"Amount"]];
    }
    else{
        transferTransactionDetailsVC.type=transactionSingleIntoType;
    }
    transferTransactionDetailsVC.model=detailsM;
    
    [self.navigationController pushViewController:transferTransactionDetailsVC animated:YES];
    
}

-(void)setModel:(assetsListModel *)model{
    
    
    _model=model;
    
}

-(void)setCurrentWallet:(FLWallet *)currentWallet{
    _currentWallet=currentWallet;
}

-(void)setElaModel:(assetsListModel *)elaModel{
    _elaModel=elaModel;
}

-(void)theNormalState:(UIButton*)button{
    [button setTitleColor:RGB(160, 175, 177) forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    
}

-(void)selecttState:(UIButton*)button{
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:RGB(107, 133, 135)];
    
}

-(HMWSendSuccessPopuView *)sendSuccessPopuV{
    if (!_sendSuccessPopuV) {
        _sendSuccessPopuV =[[HMWSendSuccessPopuView alloc]init];
    }
    
    return _sendSuccessPopuV;
}

#pragma mark ---------HMWToDeleteTheWalletPopViewDelegate----------
-(void)sureToDeleteViewWithPWD:(NSString *)pwd{
    [self loadAnyChangeInTheWhole];
    [self toCancelOrCloseDelegate];
    
}
- (void)toCancelOrCloseDelegate {
    [self.utxoTheWalletPopV removeFromSuperview];
    self.utxoTheWalletPopV=nil;
    
}
-(void)pwdAndInfoWithPWD:(NSString*)pwd{
    if (self.currentWallet.TypeW==0) {
        invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.model.iconName,self.JSONString,pwd,] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"getAllTransaction"];
        PluginResult * result =[[ELWalletManager share]CreateCombineUTXOTransaction:mommand];
        NSString *status=[NSString stringWithFormat:@"%@",result.status];
        
        if ([status isEqualToString:@"1"]) {
            [self closeTransactionDetailsView];
            [self showSendSuccessPopuV];
        }
        
    }else if (self.currentWallet.TypeW==1){
        
    }else if (self.currentWallet.TypeW==2){
        
    }else if (self.currentWallet.TypeW==3){
        
    }
    
}
-(void)closeTransactionDetailsView{
    [self.TransactionDetailsV removeFromSuperview];
    self.TransactionDetailsV=nil;
}

-(void)showSendSuccessPopuV{
    UIView *manView=[self mainWindow];
    [manView addSubview:self.sendSuccessPopuV];
    [self.sendSuccessPopuV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(manView);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hiddenSendSuccessPopuV];
    });
}
-(void)hiddenSendSuccessPopuV{
    [self.sendSuccessPopuV removeFromSuperview];
    self.sendSuccessPopuV=nil;
}
-(void)setSynchronousP:(float)synchronousP{
    _synchronousP=synchronousP;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:AccountBalanceChanges];
    [[NSNotificationCenter defaultCenter] removeObserver:progressBarcallBackInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(HWMTransactionDetailsView *)TransactionDetailsV{
    if (!_TransactionDetailsV) {
        _TransactionDetailsV =[[HWMTransactionDetailsView alloc]init];
        _TransactionDetailsV.delegate=self;
        _TransactionDetailsV.DetailsType=TransactionDetails;
    }
    return _TransactionDetailsV;
}

@end
