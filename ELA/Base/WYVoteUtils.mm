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

#import "WYVoteUtils.h"
#import "ELWalletManager.h"
#import "ELACommitteeInfoModel.h"
#import "ELANetwork.h"
#import "HWMCRListModel.h"
#import "FLCoinPointInfoModel.h"
#import "ELACouncilAndSecretariatModel.h"
#import "HWMCRSuggestionNetWorkManger.h"
#import "HWMDetailsProposalViewModel.h"

@implementation WYVoteUtils

+ (NSDictionary *)getVoteInfo:(NSString *)masterWalletID {
    @try {
        IMainchainSubWallet *mainchainSubWallet = [[ELWalletManager share] getWalletELASubWallet:masterWalletID];
        if (mainchainSubWallet) {
            Json json = mainchainSubWallet->GetVoteInfo("");
            NSString *voteInfoString = [[ELWalletManager share] stringWithJson:json];
            NSDictionary *voteInfoDic = @{};
            if(![voteInfoString isEqualToString: @"null"]){
                voteInfoDic=[[ELWalletManager share] dictionaryWithJsonString:voteInfoString];
            }
            WYLog(@"GetVoteInfo success! masterWalletID: %@, voteinfo: %@", masterWalletID, voteInfoDic);
            return voteInfoDic;
        }
        WYLog(@"GetVoteInfo failed! masterWalletID: %@", masterWalletID);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetVoteInfo Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSDictionary *)getVotePayloads:(NSDictionary *)voteInfo {
    @try {
        if (voteInfo) {
            NSMutableDictionary *votePayloads = [[NSMutableDictionary alloc] init];
            votePayloads[@"Delegate"] = @{};
            votePayloads[@"CRC"] = @{};
            votePayloads[@"CRCProposal"] = @{};
            votePayloads[@"CRCImpeachment"] = @{};
            for (id item in voteInfo) {
                votePayloads[item[@"Type"]] = item[@"Votes"];
            }
            WYLog(@"GetVotePayloads success! votePayloads: %@", votePayloads);
            return votePayloads;
        }
        WYLog(@"GetVotePayloads failed! voteInfo: %@", voteInfo);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetVotePayloads Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSDictionary *)getVoteTimestamps:(NSDictionary *)voteInfo {
    @try {
        if (voteInfo) {
            NSMutableDictionary *voteTimestamps = [[NSMutableDictionary alloc] init];
            for (id item in voteInfo) {
                voteTimestamps[item[@"Type"]] = item[@"Timestamp"];
            }
            WYLog(@"GetVoteTimestamps success! voteTimestamps: %@", voteTimestamps);
            return voteTimestamps;
        }
        WYLog(@"GetVoteTimestamps failed! voteInfo: %@", voteInfo);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetVoteTimestamps Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSInteger)getLastTimestamp:(NSDictionary *)voteTimestamps {
    @try {
        if (voteTimestamps) {
            NSInteger lastTimestamp = 0;
            for (NSString *key in voteTimestamps) {
                NSInteger currentTimestamp = [voteTimestamps[key] integerValue];
                if (currentTimestamp > lastTimestamp) {
                    lastTimestamp = currentTimestamp;
                }
            }
            WYLog(@"GetLastTimestamp success! lastTimestamp: %ld", lastTimestamp);
            return lastTimestamp;
        }
        WYLog(@"GetLastTimestamp failed! voteTimestamps: %@", voteTimestamps);
        return NO;
    } @catch (NSException *exception) {
        WYLog(@"GetLastTimestamp Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return NO;
    }
    return NO;
}

+ (NSDictionary *)getVoteAmounts:(NSDictionary *)voteInfo {
    @try {
        if (voteInfo) {
            NSMutableDictionary *voteAmounts = [[NSMutableDictionary alloc] init];
            for (id item in voteInfo) {
                voteAmounts[item[@"Type"]] = item[@"Amount"];
            }
            WYLog(@"GetVoteAmounts success! voteAmounts: %@", voteAmounts);
            return voteAmounts;
        }
        WYLog(@"GetVoteAmounts failed! voteInfo: %@", voteInfo);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetVoteAmounts Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSInteger)getTotalAmount:(NSDictionary *)voteAmounts {
    @try {
        if (voteAmounts) {
            NSInteger totalAmount = 0;
            for (NSString *key in voteAmounts) {
                NSInteger currentAmount = [voteAmounts[key] integerValue];
                if (currentAmount > totalAmount) {
                    totalAmount = currentAmount;
                }
            }
            WYLog(@"getTotalAmount success! totalAmount: %ld", totalAmount);
            return totalAmount;
        }
        WYLog(@"getTotalAmount failed! voteAmounts: %@", voteAmounts);
        return NO;
    } @catch (NSException *exception) {
        WYLog(@"getTotalAmount Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return NO;
    }
    return NO;
}

+ (NSDictionary *)getVoteAddrs:(NSDictionary *)votePayloads {
    @try {
        if (votePayloads) {
            NSMutableDictionary *voteAddrs = [[NSMutableDictionary alloc] init];
            for (NSString *key in votePayloads) {
                voteAddrs[key] = [[NSMutableArray alloc] init];
                for (NSString *addr in votePayloads[key]) {
                    [voteAddrs[key] addObject:addr];
                }
            }
            WYLog(@"GetVoteAddrs success! voteAddrs: %@", voteAddrs);
            return voteAddrs;
        }
        WYLog(@"GetVoteAddrs failed! votePayloads: %@", votePayloads);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetVoteAddrs Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSDictionary *)getInvalidAddrs:(NSDictionary *)voteAddrs withVoteTimestamps:(NSDictionary *)voteTimestamps {
    @try {
        if (voteAddrs) {
            __block NSMutableDictionary *invalidAddrs = [[NSMutableDictionary alloc] init];
            __block BOOL keyErr = NO;
            WYLog(@"dev temp voteAddrs in InvalidAddrs: %@", voteAddrs);
            
            dispatch_group_t waitGroup = dispatch_group_create();
            dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
            
            WYSetUseNetworkQueue(YES);
            for (NSString *key in voteAddrs) {
                dispatch_group_enter(waitGroup);
                dispatch_async(waitQueue, ^{
                    if ([key isEqualToString:@"Delegate"]) {
                        invalidAddrs[key] = [WYVoteUtils getInvalidDelegates:voteAddrs[key]];
                    } else if ([key isEqualToString:@"CRC"]) {
                        invalidAddrs[key] = [WYVoteUtils getInvalidCRCs:voteAddrs[key] withTimestamp:voteTimestamps[key]];
                    } else if ([key isEqualToString:@"CRCProposal"]) {
                        invalidAddrs[key] = [WYVoteUtils getInvalidProposals:voteAddrs[key]];
                    } else if ([key isEqualToString:@"CRCImpeachment"]) {
                        invalidAddrs[key] = [WYVoteUtils getInvalidImpeachments:voteAddrs[key] withTimestamp:voteTimestamps[key]];
                    } else {
                        invalidAddrs[key] = @[];
                    }
                    if (!invalidAddrs[key]) {
                        WYLog(@"GetInvalidAddrs error for key: %@", key);
                        keyErr = YES;
                    }
                    dispatch_group_leave(waitGroup);
                });
            }
            
            long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
            WYSetUseNetworkQueue(NO);
            
            if (status != 0) {
                WYLog(@"%s: getInvalidAddrs timeout!!", __func__);
                [[FLTools share] showErrorInfo:@"Network Timeout!!"];
                return nil;
            }
            
            if (keyErr) {
                return nil;
            }
            
            WYLog(@"GetInvalidAddrs success! invalidAddrs: %@", invalidAddrs);
            return invalidAddrs;
        }
        WYLog(@"GetInvalidAddrs failed! voteAddrs: %@", voteAddrs);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetInvalidAddrs Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSArray *)getInvalidDelegates:(NSArray *)delegates {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block NSArray *DposDataList = nil;
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        NSString *httpIP=[[FLTools share]http_IpFast];
        [HttpUrl NetPOSTHost:httpIP url:@"/api/dposnoderpc/check/listproducer" header:@{} body:@{@"moreInfo":@"1",@"state":@"all"} showHUD:NO WithSuccessBlock:^(id data) {
            NSDictionary *param = data[@"data"];
            DposDataList =[NSArray modelArrayWithClass:FLCoinPointInfoModel.class json:param[@"result"][@"producers"]];
            dispatch_group_leave(waitGroup);
        } WithFailBlock:^(id data) {
            WYLog(@"%s: Failed to get DposList, error: ", __func__, data[@"code"]);
            networkErr = YES;
            dispatch_group_leave(waitGroup);
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getListProducer timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    if (DposDataList) {
        NSMutableArray *invalidDelegates = [[NSMutableArray alloc] init];
        for (NSString *key in delegates) {
            BOOL keyFound = NO;
            for (FLCoinPointInfoModel *DposData in DposDataList) {
                if ([DposData.ownerpublickey isEqualToString:key]) {
                    keyFound = YES;
                    if (![DposData.state isEqualToString:@"Active"]) {
                        [invalidDelegates addObject:key];
                    }
                    break;
                }
            }
            if (!keyFound) {
                [invalidDelegates addObject:key];
            }
        }
        return invalidDelegates;
    }
    return delegates;
}

+ (NSArray *)getInvalidCRCs:(NSArray *)crcs withTimestamp:(NSString *)timestamp {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block ELACommitteeInfoModel *CRCVotingInfo = nil;
    __block NSArray *CRCDataList = nil;
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        [ELANetwork getCommitteeInfo:^(id  _Nonnull data, NSError * _Nonnull error) {
            if (error) {
                WYLog(@"%s: getCommitteeInfo failed with error code %ld", __func__, error.code);
                [[FLTools share] showErrorInfo:error.localizedDescription];
                networkErr = YES;
                dispatch_group_leave(waitGroup);
            } else {
                CRCVotingInfo = data;
                NSInteger startDate = [WYVoteUtils getCurrentCRCStartDate:CRCVotingInfo.data];
                if ([WYVoteUtils isCRCVoting:CRCVotingInfo.data] && [timestamp integerValue] >= startDate) {
                    NSString *httpIP=[[FLTools share]http_IpFast];
                    [HttpUrl NetPOSTHost:httpIP url:@"/api/dposnoderpc/check/listcrcandidates" header:@{} body:@{@"state":@"all"} showHUD:NO WithSuccessBlock:^(id data) {
                        NSDictionary *param = data[@"data"];
                        CRCDataList = [NSArray modelArrayWithClass:HWMCRListModel.class json:param[@"result"][@"crcandidatesinfo"]];
                        dispatch_group_leave(waitGroup);
                    } WithFailBlock:^(id data) {
                        WYLog(@"%s: Failed to get CRCList, error: ", __func__, data[@"code"]);
                        networkErr = YES;
                        dispatch_group_leave(waitGroup);
                    }];
                } else {
                    dispatch_group_leave(waitGroup);
                }
            }
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getCRCInfo timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    if (CRCVotingInfo) {
        if ([WYVoteUtils isCRCVoting:CRCVotingInfo.data] && CRCDataList) {
            NSMutableArray *invalidCRCs = [[NSMutableArray alloc] init];
            for (NSString *did in crcs) {
                BOOL didFound = NO;
                for (HWMCRListModel *CRCData in CRCDataList) {
                    if ([CRCData.did isEqualToString:did]) {
                        didFound = YES;
                        if (![CRCData.state isEqualToString:@"Active"]) {
                            [invalidCRCs addObject:did];
                        }
                        break;
                    }
                }
                if (!didFound) {
                    [invalidCRCs addObject:did];
                }
            }
            return invalidCRCs;
        }
    }
    return crcs;
}

+ (BOOL)isCRCVoting:(NSArray *)data {
    for(ELACommitteeInfoModel *item in data) {
        if(item.status && [item.status isEqualToString:@"VOTING"]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)getInvalidProposals:(NSArray *)proposals {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block NSArray *proposalDataList = nil;
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        [ELANetwork cvoteAllSearch:@"" page:0 results:100 type:NOTIFICATIONType block:^(id  _Nonnull data, NSError * _Nonnull error){
            if (error) {
                WYLog(@"%s: getProposalDataList failed with error code %ld", __func__, error.code);
                [[FLTools share] showErrorInfo:error.localizedDescription];
                networkErr = YES;
            } else {
                if (data[@"data"]) {
                    proposalDataList = data[@"data"][@"list"];
                }
            }
            dispatch_group_leave(waitGroup);
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getProposalList timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    if (proposalDataList) {
        NSMutableArray *invalidProposals = [[NSMutableArray alloc] init];
        for (NSString *pHash in proposals) {
            BOOL hashFound = NO;
            for (NSDictionary *proposalData in proposalDataList) {
                if ([proposalData[@"proposalHash"] isEqualToString:pHash]) {
                    hashFound = YES;
                    if (![proposalData[@"status"] isEqualToString:@"NOTIFICATION"]) {
                        [invalidProposals addObject:pHash];
                    }
                    break;
                }
            }
            if (!hashFound) {
                [invalidProposals addObject:pHash];
            }
        }
        return invalidProposals;
    }
    return proposals;
}

+ (NSArray *)getInvalidImpeachments:(NSArray *)impeachments withTimestamp:(NSString *)timestamp {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block NSArray *councilDataList = nil;
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        [ELANetwork getCommitteeInfo:^(id  _Nonnull data, NSError * _Nonnull error) {
            if (error) {
                WYLog(@"%s: getCommitteeInfo failed with error code %ld", __func__, error.code);
                [[FLTools share] showErrorInfo:error.localizedDescription];
                networkErr = YES;
                dispatch_group_leave(waitGroup);
            } else {
                ELACommitteeInfoModel *CRCInfo = data;
                NSInteger index = [WYVoteUtils getCurrentCRCIndex:CRCInfo.data];
                NSInteger startDate = [WYVoteUtils getCurrentCRCStartDate:CRCInfo.data];
                if (index && [timestamp integerValue] >= startDate) {
                    [ELANetwork getCouncilListInfo:index block:^(id  _Nonnull data, NSError * _Nonnull error) {
                        if (error) {
                            WYLog(@"%s: getCouncilList failed with error code %ld", __func__, error.code);
                            [[FLTools share] showErrorInfo:error.localizedDescription];
                            networkErr = YES;
                        } else {
                            ELACouncilAndSecretariatModel *councilAndSecretariatInfo = data;
                            councilDataList = councilAndSecretariatInfo.council;
                        }
                        dispatch_group_leave(waitGroup);
                    }];
                } else {
                    dispatch_group_leave(waitGroup);
                }
            }
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getCouncilList timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    if (councilDataList) {
        NSMutableArray *invalidImpeachments = [[NSMutableArray alloc] init];
        for (NSString *cid in impeachments) {
            BOOL cidFound = NO;
            for (ELACouncilModel *councilData in councilDataList) {
                if ([councilData.cid isEqualToString:cid]) {
                    cidFound = YES;
                    if (![councilData.status isEqualToString:@"Elected"]) {
                        [invalidImpeachments addObject:cid];
                    }
                    break;
                }
            }
            if (!cidFound) {
                [invalidImpeachments addObject:cid];
            }
        }
        return invalidImpeachments;
    }
    return impeachments;
}

+ (NSInteger)getCurrentCRCIndex:(NSArray *)data {
    for(ELACommitteeInfoModel *item in data) {
        if(item.status && [item.status isEqualToString:@"CURRENT"]) {
            return item.index;
        }
    }
    return NO;
}

+ (NSInteger)getCurrentCRCStartDate:(NSArray *)data {
    for(ELACommitteeInfoModel *item in data) {
        if(item.status && [item.status isEqualToString:@"CURRENT"]) {
            return [item.startDate integerValue];
        }
    }
    return 0;
}

+ (NSInteger)getCurrentCRCEndDate:(NSArray *)data {
    for(ELACommitteeInfoModel *item in data) {
        if(item.status && [item.status isEqualToString:@"CURRENT"]) {
            return [item.endDate integerValue];
        }
    }
    return 0;
}

+ (NSDictionary *)getValidPayloads:(NSDictionary *)payloads withInvalidAddrs:(NSDictionary *)invalidAddrs {
    @try {
        if (payloads) {
            NSMutableDictionary *validPayloads = [[NSMutableDictionary alloc] init];
            for (NSString *key in payloads) {
                validPayloads[key] = [[NSMutableDictionary alloc] init];
                for (NSString *addr in payloads[key]) {
                    if (![invalidAddrs[key] containsObject:addr]) {
                        validPayloads[key][addr] = payloads[key][addr];
                    }
                }
            }
            WYLog(@"GetValidPayloads success! validPayloads: %@", validPayloads);
            return validPayloads;
        }
        WYLog(@"GetValidPayload failed! payloads: %@", payloads);
        return nil;
    } @catch (NSException *exception) {
        WYLog(@"GetValidPayloads Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSDictionary *)mergePayloads:(NSDictionary *)curPayloads withPayloads:(NSDictionary *)prevPayloads {
    NSMutableDictionary *mergedPayloads = [[NSMutableDictionary alloc] init];
    for (NSString *key in curPayloads) {
        mergedPayloads[key] = curPayloads[key];
    }
    for (NSString *key in prevPayloads) {
        if (!mergedPayloads[key]) {
            mergedPayloads[key] = prevPayloads[key];
        }
    }
    return mergedPayloads;
}

+ (NSDictionary *)mergeProposals:(NSDictionary *)curPayloads withPayloads:(NSDictionary *)prevPayloads {
    NSMutableDictionary *mergedPayloads = [[NSMutableDictionary alloc] init];
    NSString *curKey = nil;
    for (NSString *key in curPayloads) {
        mergedPayloads[key] = curPayloads[key];
        curKey = key;
    }
    for (NSString *key in prevPayloads) {
        if (!mergedPayloads[key]) {
            mergedPayloads[key] = curPayloads[curKey];
        }
    }
    return mergedPayloads;
}

+ (NSDictionary *)prepareVoteInfo:(NSString *)masterWalletID {
    NSDictionary *voteInfo = [WYVoteUtils getVoteInfo:masterWalletID];
    if (!voteInfo) {
        return nil;
    }
    NSDictionary *votePayloads = [WYVoteUtils getVotePayloads:voteInfo];
    if (!votePayloads) {
        return nil;
    }
    NSDictionary *voteTimestamps = [WYVoteUtils getVoteTimestamps:voteInfo];
    if (!voteTimestamps) {
        return nil;
    }
    NSDictionary *voteAddrs = [WYVoteUtils getVoteAddrs:votePayloads];
    if (!voteAddrs) {
        return nil;
    }
    NSDictionary *invalidAddrs = [WYVoteUtils getInvalidAddrs:voteAddrs withVoteTimestamps:voteTimestamps];
    if (!invalidAddrs) {
        return nil;
    }
    NSDictionary *validPayloads = [WYVoteUtils getValidPayloads:votePayloads withInvalidAddrs:invalidAddrs];
    if (!validPayloads) {
        return nil;
    }
    NSMutableArray *invalidCandidates = [[NSMutableArray alloc] init];
    for (NSString *key in invalidAddrs) {
        [invalidCandidates addObject:@{
            @"Type": key,
            @"Candidates": invalidAddrs[key]
        }];
    }
    return @{
        @"validPayloads": validPayloads,
        @"invalidCandidates": invalidCandidates
    };
}

+ (NSDictionary *)createDelegateVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID {
    NSDictionary *voteInfo = [WYVoteUtils prepareVoteInfo:masterWalletID];
    if (!voteInfo) {
        return nil;
    }
    
    NSMutableArray *invalidCandidates = [[NSMutableArray alloc] init];
    for (NSDictionary *item in voteInfo[@"invalidCandidates"]) {
        if (![item[@"Type"] isEqualToString:@"Delegate"]) {
            [invalidCandidates addObject:item];
        } else {
            NSMutableArray *invalidDelegates = [item[@"Candidates"] mutableCopy];
            for (NSString *voteKey in votes) {
                if ([invalidDelegates containsObject:voteKey]) {
                    [invalidDelegates removeObject:voteKey];
                }
            }
            [invalidCandidates addObject:@{
                @"Type": @"Delegate",
                @"Candidates": invalidDelegates
            }];
        }
    }
    
    return @{
        @"votePayloads": votes,
        @"invalidCandidates": invalidCandidates
    };
}

+ (NSDictionary *)createCRCVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID {
    NSDictionary *voteInfo = [WYVoteUtils prepareVoteInfo:masterWalletID];
    if (!voteInfo) {
        return nil;
    }
    
    NSMutableArray *invalidCandidates = [[NSMutableArray alloc] init];
    for (NSDictionary *item in voteInfo[@"invalidCandidates"]) {
        if (![item[@"Type"] isEqualToString:@"CRC"]) {
            [invalidCandidates addObject:item];
        } else {
            NSMutableArray *invalidCRCs = [item[@"Candidates"] mutableCopy];
            for (NSString *voteKey in votes) {
                if ([invalidCRCs containsObject:voteKey]) {
                    [invalidCRCs removeObject:voteKey];
                }
            }
            [invalidCandidates addObject:@{
                @"Type": @"CRC",
                @"Candidates": invalidCRCs
            }];
        }
    }
    
    return @{
        @"votePayloads": votes,
        @"invalidCandidates": invalidCandidates
    };
}

+ (NSDictionary *)createProposalVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID {
    NSDictionary *voteInfo = [WYVoteUtils prepareVoteInfo:masterWalletID];
    if (!voteInfo) {
        return nil;
    }
    
    NSDictionary *votePayloads = [WYVoteUtils mergePayloads:votes withPayloads:voteInfo[@"validPayloads"][@"CRCProposal"]];
    
    //    NSDictionary *votePayloads = [WYVoteUtils mergeProposals:votes withPayloads:voteInfo[@"validPayloads"][@"CRCProposal"]];
    
    NSMutableArray *invalidCandidates = [[NSMutableArray alloc] init];
    for (NSDictionary *item in voteInfo[@"invalidCandidates"]) {
        if (![item[@"Type"] isEqualToString:@"CRCProposal"]) {
            [invalidCandidates addObject:item];
        } else {
            NSMutableArray *invalidProposals = [item[@"Candidates"] mutableCopy];
            for (NSString *voteKey in votePayloads) {
                if ([invalidProposals containsObject:voteKey]) {
                    [invalidProposals removeObject:voteKey];
                }
            }
            [invalidCandidates addObject:@{
                @"Type": @"CRCProposal",
                @"Candidates": invalidProposals
            }];
        }
    }
    
    return @{
        @"votePayloads": votePayloads,
        @"invalidCandidates": invalidCandidates
    };
}

+ (NSDictionary *)createImpeachmentVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID {
    NSDictionary *voteInfo = [WYVoteUtils prepareVoteInfo:masterWalletID];
    if (!voteInfo) {
        return nil;
    }
    
    //    NSDictionary *votePayloads = [WYVoteUtils mergePayloads:votes withPayloads:voteInfo[@"validPayloads"][@"CRCImpeachment"]];
    //    return @{
    //        @"votePayloads": votePayloads,
    //        @"invalidCandidates": voteInfo[@"invalidCandidates"]
    //    };
    
    NSMutableArray *invalidCandidates = [[NSMutableArray alloc] init];
    for (NSDictionary *item in voteInfo[@"invalidCandidates"]) {
        if (![item[@"Type"] isEqualToString:@"CRCImpeachment"]) {
            [invalidCandidates addObject:item];
        } else {
            NSMutableArray *invalidImpeachments = [item[@"Candidates"] mutableCopy];
            for (NSString *voteKey in votes) {
                if ([invalidImpeachments containsObject:voteKey]) {
                    [invalidImpeachments removeObject:voteKey];
                }
            }
            [invalidCandidates addObject:@{
                @"Type": @"CRCImpeachment",
                @"Candidates": invalidImpeachments
            }];
        }
    }
    
    return @{
        @"votePayloads": votes,
        @"invalidCandidates": invalidCandidates
    };
}

+ (NSDictionary *)getAllInfo:(NSDictionary *)voteTimestamps {
    @try {
            __block NSMutableDictionary *allInfo = [[NSMutableDictionary alloc] init];
            __block BOOL keyErr = NO;
            
            dispatch_group_t waitGroup = dispatch_group_create();
            dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
            
            WYSetUseNetworkQueue(YES);
        for (NSString *key in @[@"Delegate", @"CRC", @"CRCProposal", @"CRCImpeachment"]) {
                dispatch_group_enter(waitGroup);
                dispatch_async(waitQueue, ^{
                    if ([key isEqualToString:@"Delegate"]) {
                        allInfo[key] = [WYVoteUtils getAllDelegates];
                    } else if ([key isEqualToString:@"CRC"]) {
                        allInfo[key] = [WYVoteUtils getAllCRCs:voteTimestamps[key]];
                    } else if ([key isEqualToString:@"CRCProposal"]) {
                        allInfo[key] = [WYVoteUtils getAllProposals];
                    } else if ([key isEqualToString:@"CRCImpeachment"]) {
                        allInfo[key] = [WYVoteUtils getAllCouncilData:voteTimestamps[key]];
                    } else {
                        allInfo[key] = @[];
                    }
                    if (!allInfo[key]) {
                        WYLog(@"GetAllInfo error for key: %@", key);
                        keyErr = YES;
                    }
                    dispatch_group_leave(waitGroup);
                });
            }
            
            long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
            WYSetUseNetworkQueue(NO);
            
            if (status != 0) {
                WYLog(@"%s: getAllInfo timeout!!", __func__);
                [[FLTools share] showErrorInfo:@"Network Timeout!!"];
                return nil;
            }
            
            if (keyErr) {
                return nil;
            }
            
            WYLog(@"GetAllInfo success! Info: %@", allInfo);
            return allInfo;
    } @catch (NSException *exception) {
        WYLog(@"GetAllInfo Exception: %@", exception.reason);
        [[FLTools share] showErrorInfo:exception.reason];
        return nil;
    }
    return nil;
}

+ (NSArray *)getAllDelegates {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block NSArray *DposDataList = @[];
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        NSString *httpIP=[[FLTools share]http_IpFast];
        [HttpUrl NetPOSTHost:httpIP url:@"/api/dposnoderpc/check/listproducer" header:@{} body:@{@"moreInfo":@"1",@"state":@"all"} showHUD:NO WithSuccessBlock:^(id data) {
            NSDictionary *param = data[@"data"];
            DposDataList =[NSArray modelArrayWithClass:FLCoinPointInfoModel.class json:param[@"result"][@"producers"]];
            dispatch_group_leave(waitGroup);
        } WithFailBlock:^(id data) {
            WYLog(@"%s: Failed to get DposList, error: ", __func__, data[@"code"]);
            networkErr = YES;
            dispatch_group_leave(waitGroup);
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getListProducer timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (FLCoinPointInfoModel *item in DposDataList) {
        [resultArr addObject:@{
            @"key": item.ownerpublickey,
            @"item": item
        }];
    }
    return resultArr;
}

+ (NSArray *)getAllCRCs:(NSString *)timestamp {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block ELACommitteeInfoModel *CRCVotingInfo = nil;
    __block NSArray *CRCDataList = @[];
    __block NSInteger endDate = 0;
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        [ELANetwork getCommitteeInfo:^(id  _Nonnull data, NSError * _Nonnull error) {
            if (error) {
                WYLog(@"%s: getCommitteeInfo failed with error code %ld", __func__, error.code);
                [[FLTools share] showErrorInfo:error.localizedDescription];
                networkErr = YES;
                dispatch_group_leave(waitGroup);
            } else {
                CRCVotingInfo = data;
                NSInteger startDate = [WYVoteUtils getCurrentCRCStartDate:CRCVotingInfo.data];
                if ([WYVoteUtils isCRCVoting:CRCVotingInfo.data] && [timestamp integerValue] >= startDate) {
                    endDate = [WYVoteUtils getCurrentCRCEndDate:CRCVotingInfo.data];
                    NSString *httpIP=[[FLTools share]http_IpFast];
                    [HttpUrl NetPOSTHost:httpIP url:@"/api/dposnoderpc/check/listcrcandidates" header:@{} body:@{@"state":@"all"} showHUD:NO WithSuccessBlock:^(id data) {
                        NSDictionary *param = data[@"data"];
                        CRCDataList = [NSArray modelArrayWithClass:HWMCRListModel.class json:param[@"result"][@"crcandidatesinfo"]];
                        dispatch_group_leave(waitGroup);
                    } WithFailBlock:^(id data) {
                        WYLog(@"%s: Failed to get CRCList, error: ", __func__, data[@"code"]);
                        networkErr = YES;
                        dispatch_group_leave(waitGroup);
                    }];
                } else {
                    dispatch_group_leave(waitGroup);
                }
            }
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getCRCInfo timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (HWMCRListModel *item in CRCDataList) {
        item.endDate = endDate;
        
        [resultArr addObject:@{
            @"key": item.did,
            @"item": item
        }];
    }
    return resultArr;
}

+ (NSArray *)getAllProposals {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block NSArray *proposalDataList = @[];
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        [ELANetwork cvoteAllSearch:@"" page:0 results:100 type:NOTIFICATIONType block:^(id  _Nonnull data, NSError * _Nonnull error){
            if (error) {
                WYLog(@"%s: getProposalDataList failed with error code %ld", __func__, error.code);
                [[FLTools share] showErrorInfo:error.localizedDescription];
                networkErr = YES;
            } else {
                if (data[@"data"]) {
                    proposalDataList = data[@"data"][@"list"];
                }
            }
            dispatch_group_leave(waitGroup);
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getProposalList timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (NSDictionary *item in proposalDataList) {
        [resultArr addObject:@{
            @"key": item[@"proposalHash"],
            @"item": item
        }];
    }
    return resultArr;
}

+ (NSArray *)getAllCouncilData:(NSString *)timestamp {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block NSArray *councilDataList = @[];
    __block NSInteger endDate = 0;
    __block BOOL networkErr = NO;
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        [ELANetwork getCommitteeInfo:^(id  _Nonnull data, NSError * _Nonnull error) {
            if (error) {
                WYLog(@"%s: getCommitteeInfo failed with error code %ld", __func__, error.code);
                [[FLTools share] showErrorInfo:error.localizedDescription];
                networkErr = YES;
                dispatch_group_leave(waitGroup);
            } else {
                ELACommitteeInfoModel *CRCInfo = data;
                NSInteger index = [WYVoteUtils getCurrentCRCIndex:CRCInfo.data];
                NSInteger startDate = [WYVoteUtils getCurrentCRCStartDate:CRCInfo.data];
                if (index && [timestamp integerValue] >= startDate) {
                    endDate = [WYVoteUtils getCurrentCRCEndDate:CRCInfo.data];
                    [ELANetwork getCouncilListInfo:index block:^(id  _Nonnull data, NSError * _Nonnull error) {
                        if (error) {
                            WYLog(@"%s: getCouncilList failed with error code %ld", __func__, error.code);
                            [[FLTools share] showErrorInfo:error.localizedDescription];
                            networkErr = YES;
                        } else {
                            ELACouncilAndSecretariatModel *councilAndSecretariatInfo = data;
                            councilDataList = councilAndSecretariatInfo.council;
                        }
                        dispatch_group_leave(waitGroup);
                    }];
                } else {
                    dispatch_group_leave(waitGroup);
                }
            }
        }];
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (status != 0) {
        WYLog(@"%s: getCouncilList timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (networkErr) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (ELACouncilModel *item in councilDataList) {
        item.endDate = endDate;
        
        [resultArr addObject:@{
            @"key": item.cid,
            @"item": item
        }];
    }
    return resultArr;
}

+ (HWMDetailsProposalModel *)getProposalDetails:(NSString *)proposalHash {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block HWMDetailsProposalModel *result = nil;
    
    WYSetUseNetworkQueue(YES);
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        
    [[HWMCRSuggestionNetWorkManger shareCRSuggestionNetWorkManger]reloadCRSuggestionDetailsWithID:proposalHash withComplete:^(id  _Nonnull data) {
        [[HWMDetailsProposalViewModel alloc] detailsProposalModelDataJosn:data[@"data"] completion:^(HWMDetailsProposalModel * _Nonnull model) {
            result = model;
            dispatch_group_leave(waitGroup);
        }];
    }];
    
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    WYSetUseNetworkQueue(NO);
    
    if (status != 0) {
        WYLog(@"%s: getProposalDetails timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    return result;
}

+ (ELAInformationDetail *)getCouncilDetails:(NSString *)did {
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t waitQueue = [WYUtils getNetworkQueue];
    
    __block ELAInformationDetail *result = nil;
    __block NSError *err = nil;
    
    WYSetUseNetworkQueue(YES);
    dispatch_group_enter(waitGroup);
    dispatch_async(waitQueue, ^{
        
        [ELANetwork getInformation:did ID:-1 block:^(id  _Nonnull data, NSError * _Nonnull error) {
            result = data;
            err = error;
            dispatch_group_leave(waitGroup);;
        }];
        
    });
    
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    WYSetUseNetworkQueue(NO);
    
    if (status != 0) {
        WYLog(@"%s: getCouncilDetails timeout!!", __func__);
        [[FLTools share] showErrorInfo:@"Network Timeout!!"];
        return nil;
    }
    
    if (err) {
        WYLog(@"%s: getCouncilDetails error: %@", __func__, err.localizedDescription);
        [[FLTools share] showErrorInfo:err.localizedDescription];
        return nil;
    }
    
    return result;
}

@end
