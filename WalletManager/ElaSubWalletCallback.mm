//
//  ElasubWalletCallback.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/1/21.
//

#import "ElaSubWalletCallback.h"
#import "ELWalletManager.h"
#include <wchar.h>

NSString *wallID;
//
using namespace Elastos::ElaWallet;

//@implementation ElaSubWalletCallback

ElaSubWalletCallback::ElaSubWalletCallback(const std::string &callBackInfo)
{
    
    //    NSString *string=@"";
    _callBackInfo=callBackInfo;
    
    //    wallID=[NSS]walletID;
}

ElaSubWalletCallback::~ElaSubWalletCallback()
{
    
}

void ElaSubWalletCallback:: OnTransactionStatusChanged( const std::string &txid,
                                                       const std::string &status,
                                                       const nlohmann::json &desc,
                                                       uint32_t confirms){

    NSDictionary *dic=@{@"txid":[NSString stringWithUTF8String:txid.c_str()],
                        @"status":[NSString stringWithUTF8String:status.c_str()],
                        @"desc":[NSString stringWithUTF8String:desc.dump().c_str()],
                        };
    DLog(@"交易金额:  %@",dic);
    [[NSNotificationCenter defaultCenter] postNotificationName:TransactionStatusChanged object:dic];

    
}

void ElaSubWalletCallback::OnBlockSyncStarted()
{
    
}

void ElaSubWalletCallback::OnBlockSyncProgress(uint32_t currentBlockHeight, uint32_t estimatedHeight)
{
    NSString *walletIDString = [NSString stringWithCString:_callBackInfo.c_str() encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic=@{@"currentBlockHeight":@(currentBlockHeight),@"progress":@(estimatedHeight),@"callBackInfo":walletIDString};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:progressBarcallBackInfo object:dic];
    
    //    NSLog(@"%u%d",currentBlockHeight,progress);
}

void ElaSubWalletCallback::OnBlockSyncStopped()
{
    
}

void ElaSubWalletCallback::OnTxPublished(const std::string &hash, const nlohmann::json &result)
{
    
    NSString *hash1 = [NSString stringWithCString:hash.c_str() encoding:NSUTF8StringEncoding];
    NSString *resultString = [NSString stringWithCString:result.dump().c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"hash":hash1,@"result":resultString};

    [[NSNotificationCenter defaultCenter] postNotificationName:OnTxPublishedResult object:dic];

}

void ElaSubWalletCallback::OnTxDeleted(const std::string &hash, bool notifyUser, bool recommendRescan)
{
    
    
}

/**
 * Callback method fired when best block chain height increased. This callback could be used to show progress.
 * @param currentBlockHeight is the of current block when callback fired.
 * @param progress is current progress when block height increased.
 */
// void ElaSubWalletCallback:: OnBlockHeightIncreased(uint32_t currentBlockHeight, int progress)
//{
//
////   NSString *walletIDString = [NSString stringWithCString:_walletID.c_str() encoding:NSUTF8StringEncoding];
////
////    NSDictionary *dic=@{@"currentBlockHeight":@(currentBlockHeight),@"progress":@(progress),@"walletID":walletIDString};
////
////    [[NSNotificationCenter defaultCenter] postNotificationName:progressBarcallBackInfo object:dic];
////
////    NSLog(@"%u%d",currentBlockHeight,progress);
//}

/**
 * Callback method fired when block end synchronizing with a peer. This callback could be used to show progress.
 */

void ElaSubWalletCallback:: OnBalanceChanged(const std::string &asset, uint64_t balance)
{
    
    
    NSString *walletIDString = [NSString stringWithCString:_callBackInfo.c_str() encoding:NSUTF8StringEncoding];
    
    
       NSString *assetString = [NSString stringWithCString:asset.c_str() encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic=@{@"asset":assetString,@"balance":@(balance),@"callBackInfo":walletIDString};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AccountBalanceChanges object:dic];
    
    
    
    
}
//@end