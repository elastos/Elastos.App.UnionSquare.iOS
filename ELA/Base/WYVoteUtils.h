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

#import <Foundation/Foundation.h>
#import "HWMDetailsProposalModel.h"
#import "ELAInformationDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYVoteUtils : NSObject

+ (NSDictionary *)getVoteInfo:(NSString *)masterWalletID;
+ (NSDictionary *)getVotePayloads:(NSDictionary *)voteInfo;
+ (NSDictionary *)getVoteAddrs:(NSDictionary *)votePayloads;
+ (NSDictionary *)getVoteTimestamps:(NSDictionary *)voteInfo;
+ (NSInteger)getLastTimestamp:(NSDictionary *)voteTimestamps;
+ (NSDictionary *)getVoteAmounts:(NSDictionary *)voteInfo;
+ (NSInteger)getTotalAmount:(NSDictionary *)voteAmounts;
+ (NSDictionary *)getInvalidAddrs:(NSDictionary *)voteAddrs withVoteTimestamps:(NSDictionary *)voteTimestamps;
+ (NSDictionary *)getValidPayloads:(NSDictionary *)payloads withInvalidAddrs:(NSDictionary *)invalidAddrs;
+ (NSDictionary *)prepareVoteInfo:(NSString *)masterWalletID;
+ (NSDictionary *)createDelegateVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID;
+ (NSDictionary *)createCRCVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID;
+ (NSDictionary *)createProposalVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID;
+ (NSDictionary *)createImpeachmentVote:(NSDictionary *)votes withWallet:(NSString *)masterWalletID;
+ (NSInteger)getCurrentCRCIndex:(NSArray *)data;
+ (NSInteger)getCurrentCRCStartDate:(NSArray *)data;
+ (NSInteger)getCurrentCRCEndDate:(NSArray *)data;
+ (NSArray *)getAllDelegates;
+ (NSArray *)getAllCRCs:(NSString *)timestamp;
+ (NSArray *)getAllProposals;
+ (NSArray *)getAllCouncilData:(NSString *)timestamp;
+ (NSDictionary *)getAllInfo:(NSDictionary *)voteTimestamps;
+ (HWMDetailsProposalModel *)getProposalDetails:(NSString *)proposalHash;
+ (ELAInformationDetail *)getCouncilDetails:(NSString *)did;

@end

NS_ASSUME_NONNULL_END
