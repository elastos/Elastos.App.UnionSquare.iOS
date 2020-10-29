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

#import "WYUtils.h"
#import "MyUtil.h"
#import "ELWalletManager.h"

static BOOL useNetworkQueue = NO;
static NSUncaughtExceptionHandler *nextHandler = nil;
static NSMutableDictionary *globalDic = nil;

@implementation WYUtils

+ (WYUtils *)shared {
    static WYUtils *sharedWYUtils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWYUtils = [[WYUtils alloc] init];
    });
    return sharedWYUtils;
}

+ (void)setGlobal:(NSString *)key withValue:(id _Nullable)value {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalDic = [[NSMutableDictionary alloc] init];
    });
    globalDic[key] = value;
}

+ (id)getGlobal:(NSString *)key {
    if (!globalDic) {
        return nil;
    }
    return globalDic[key];
}

+ (dispatch_queue_t)getNetworkQueue {
    static dispatch_queue_t networkQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkQueue = dispatch_queue_create("elastos.elawallet.NetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return networkQueue;
}

+ (dispatch_queue_t)getTaskQueue {
    static dispatch_queue_t taskQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskQueue = dispatch_queue_create("elastos.elawallet.TaskQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return taskQueue;
}

+ (dispatch_queue_t)getSerialQueue {
    static dispatch_queue_t serialQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("elastos.elawallet.TaskQueue", DISPATCH_QUEUE_SERIAL);
    });
    return serialQueue;
}

+ (NSString *)getLogPath {
    NSString *rootPath = [MyUtil getRootPath];
    return [rootPath stringByAppendingPathComponent:LOG_FILE_NAME];
}

+ (BOOL)trimHead:(NSFileHandle *)file lower:(unsigned long long)lower size:(unsigned long long)size {
    // If file size is not given, calculate it
    if (!size)
    {
        [file seekToEndOfFile];
        size = file.offsetInFile;
    }
    
    // Calculate where we want to trim
    unsigned long long src = 0;
    if (size > lower) {
        src = size - lower;
    }
    
    // Move pointer
    [file seekToFileOffset:src];
    
    // What we are looking for
    NSData * nl = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    // Read some data
    NSUInteger len = 100;   // Arbitrary but small as we are just looking for the next nl
    
    while (src < size) {
        if (size - src < len) {
            len = size - src;
        }
        
        NSData *data = [file readDataOfLength:len];
        NSRange r = [data rangeOfData:nl options:0 range:NSMakeRange(0, data.length)];
        
        if (r.location != NSNotFound) {
            src += r.location + nl.length;
            break;
        }
        
        src += data.length;
    }
    
    if (src < size) {
        // Data destination
        unsigned long long dst = 0;
        
        // New buffer size - can be a bit larger
        len = 100000;
        
        // Now shuffle the bytes from here to the start
        while (src < size) {
            [file seekToFileOffset:src];
            
            if (size - src < len) {
                len = size - src;
            }
            
            NSData * data = [file readDataOfLength:len];
            
            [file seekToFileOffset:dst];
            [file writeData:data];
            
            dst += data.length;
            src += data.length;
        }
        
        // Done
        [file truncateFileAtOffset:dst];
        
        return YES;
    } else {
        return NO;
    }
}

+ (void)setExceptionHandler {
    if (NSGetUncaughtExceptionHandler() != WYExceptionHandler) {
        nextHandler = NSGetUncaughtExceptionHandler();
    }
    NSSetUncaughtExceptionHandler(&WYExceptionHandler);
}

+ (NSDictionary *)syncGET:(NSString *)url headers:(NSDictionary *)headers showLoading:(BOOL)show {
    __block NSString *resultStr = nil;
    __block NSError *resultErr = nil;
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_queue_t networkQueue = [WYUtils getNetworkQueue];
    
    if (show) {
        [[FLTools share] showLoadingView];
    }
    dispatch_group_enter(waitGroup);
    dispatch_async(networkQueue, ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.completionQueue = networkQueue;
        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:url parameters:nil headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            WYLog(@"SyncGET success: %@", responseStr);
            resultStr = responseStr;
            dispatch_group_leave(waitGroup);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WYLog(@"SyncGET error: %@", error.localizedDescription);
            resultErr = error;
            dispatch_group_leave(waitGroup);
        }];
        
    });
    long status = dispatch_group_wait(waitGroup, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * WAIT_TIMEOUT));
    if (show) {
        [[FLTools share] hideLoadingView];
    }
    
    if (status != 0) {
        WYLog(@"SyncGET timeout: ld%", status);
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey: NSLocalizedString(@"网络超时", nil),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"网络超时", nil),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"请稍后重试", nil)
        };
        resultErr = [NSError errorWithDomain:@"elastos.elawallet.SyncGETTimeout" code:status userInfo:userInfo];
    }
    
    return @{
        @"result": resultStr,
        @"error": resultErr
    };
    
}

+ (BOOL)matchString:(NSString *)inputStr withRegex:(NSString *)regexStr {
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [testRegex evaluateWithObject:inputStr];
}

+ (NSDictionary *)processAddressOrCryptoName:(NSString *)inputStr withMasterWalletID:(NSString *)masterWalletID {
    NSString *elaAddress = nil;
    NSString *errMsg = nil;
    NSString *alphanumRegex = @"[A-Z0-9a-z]+";
    NSPredicate *testAlphanum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphanumRegex];
    if (inputStr.length < 1) {
        errMsg = NSLocalizedString(@"收款地址不能为空", nil);
    } else if (inputStr.length > 24) {
        if([[ELWalletManager share] IsAddressValidWithMastID:masterWalletID WithAddress:inputStr]) {
            elaAddress = inputStr;
        } else {
            errMsg = NSLocalizedString(@"收款地址格式错误", nil);
        }
    } else if ([testAlphanum evaluateWithObject:inputStr]) {
        NSString *cryptoName = [inputStr lowercaseString];
        NSString *cryptoNameUrl = [NSString stringWithFormat:@"https://%@.elastos.name/ela.address", cryptoName];
        NSDictionary *resultAddr = [WYUtils syncGET:cryptoNameUrl headers:nil showLoading:YES];
        WYLog(@"CryptoName GET result: %@", resultAddr);
        if (!resultAddr[@"error"]) {
            elaAddress = resultAddr[@"result"];
        } else {
            NSError *resultErr = resultAddr[@"error"];
            if ([resultErr.domain isEqualToString:@"elastos.elawallet.SyncGETTimeout"]) {
                errMsg = NSLocalizedString(@"CryptoName连接超时", nil);
            } else {
                errMsg = NSLocalizedString(@"CryptoName地址错误", nil);
            }
        }
    } else {
        errMsg = NSLocalizedString(@"CryptoName地址错误", nil);
    }
    return @{
        @"address": elaAddress,
        @"error": errMsg
    };
}

+ (UIViewController *)topViewController {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)topViewController;
            topViewController = nav.topViewController;
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

+ (NSString *)dicToJSONString:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:kNilOptions
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSString *)arrToJSONString:(NSArray *)arr {
    if (arr == nil) {
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSDictionary *)dicFromJSONString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    return dic;
}

@end

void WYLog(NSString *fmt, ...) {
    static dispatch_queue_t logQueue = nil;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        logQueue = dispatch_queue_create("elastos.elawallet.LogQueue", DISPATCH_QUEUE_SERIAL);
    });
    
    static NSString *logPath = nil;
    static dispatch_once_t oncePath;
    dispatch_once(&oncePath, ^{
        NSString *rootPath = [MyUtil getRootPath];
        logPath = [rootPath stringByAppendingPathComponent:LOG_FILE_NAME];
    });
    
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceFormatter;
    dispatch_once(&onceFormatter, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    });
    
    @autoreleasepool {
        va_list args;
        va_start(args, fmt);
        NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);
        NSLog(@"%@", msg);
        if (![msg hasSuffix:@"\n"]) {
            msg = [NSString stringWithFormat:@"%@\n", msg];
        }
        NSDate *currentDate = [NSDate date];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        msg = [NSString stringWithFormat:@"[%@] %@", dateString, msg];
        
        dispatch_async(logQueue, ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:logPath]) {
                [msg writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            } else {
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
                [fileHandle closeFile];
            }
            
            unsigned long long fs = [[[NSFileManager defaultManager] attributesOfItemAtPath:logPath error:nil] fileSize];
            if (fs > LOG_SIZE_LIMIT) {
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
                [WYUtils trimHead:fileHandle lower:LOG_SIZE_LIMIT * 0.9 size:fs];
                [fileHandle closeFile];
            }
        });
        
    }
    
}

void WYExceptionHandler(NSException *exception) {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"crashed"];
    [prefs setObject:exception.reason forKey:@"crashReason"];
    WYLog(@"App Crashed: %@", exception.reason);
    
    if (nextHandler) {
        nextHandler(exception);
    }
}

BOOL WYUseNetworkQueue(void) {
    return useNetworkQueue;
}

void WYSetUseNetworkQueue(BOOL useFlag) {
    useNetworkQueue = useFlag;
}
