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

#ifndef LOG_SIZE_LIMIT
#define LOG_SIZE_LIMIT 50 * 1024 * 1024
#endif

#ifndef LOG_FILE_NAME
#define LOG_FILE_NAME @"walletapp.log"
#endif

#ifndef CRASH_REPORT
#define CRASH_REPORT NO
#endif

#ifndef WAIT_TIMEOUT
#define WAIT_TIMEOUT 25
#endif

#ifndef QUEUE_TIMEOUT
#define QUEUE_TIMEOUT 20
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYUtils : NSObject

+ (NSString *)getLogPath;
+ (void)setExceptionHandler;
+ (void)setGlobal:(NSString *)key withValue:(id _Nullable)value;
+ (id)getGlobal:(NSString *)key;
+ (dispatch_queue_t)getNetworkQueue;
+ (dispatch_queue_t)getTaskQueue;
+ (dispatch_queue_t)getSerialQueue;
+ (NSDictionary *)syncGET:(NSString *)url headers:(NSDictionary * _Nullable)headers showLoading:(BOOL)show;
+ (BOOL)matchString:(NSString *)inputStr withRegex:(NSString *)regexStr;
+ (NSDictionary *)processAddressOrCryptoName:(NSString *)inputStr withMasterWalletID:(NSString *)masterWalletID;
+ (UIViewController *)topViewController;
+ (NSString *)dicToJSONString:(NSDictionary *)dic;
+ (NSString *)arrToJSONString:(NSArray *)arr;
+ (NSDictionary *)dicFromJSONString:(NSString *)jsonString;

@end

#ifdef __cplusplus
extern "C" {
#endif

void WYLog(NSString *fmt, ...);
void WYExceptionHandler(NSException *exception);
BOOL WYUseNetworkQueue(void);
void WYSetUseNetworkQueue(BOOL useFlag);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
