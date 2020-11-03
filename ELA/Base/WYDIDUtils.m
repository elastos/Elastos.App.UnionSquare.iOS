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


#import "WYDIDUtils.h"
#import "ela_did.h"
#import "HWMDIDInfoModel.h"

@implementation WYDIDUtils

+ (NSString *)validateDIDString:(NSString *)DIDString {
    if (![DIDString hasPrefix:@"did:elastos:"]) {
        DIDString = [NSString stringWithFormat:@"%@%@", @"did:elastos:", DIDString];
    }
    if (![DIDString hasPrefix:@"did:elastos:i"] || DIDString.length != 46) {
        return nil;
    }
    NSString *bodyString = [DIDString substringFromIndex:12];
    if ([WYUtils matchString:bodyString withRegex:@"[A-Z0-9a-z]+"]) {
        return DIDString;
    }
    return nil;
}

+ (NSDictionary *)getDIDInfoFromString:(NSString *)DIDString {
    WYLog(@"=== dev temp === DIDString: %@", DIDString);
    NSDictionary *result = nil;
    const char *DIDCString = [DIDString UTF8String];
    DID *did = DID_FromString(DIDCString);
    DIDDocument *doc = DID_Resolve(did, true);
    if (doc) {
        time_t endTime = DIDDocument_GetExpires(doc);
        NSString *endTimeString=[[FLTools share]SpecialTimeZoneConversion:[NSString stringWithFormat:@"%@",@(endTime)]];
        
        DIDURL *url = DIDURL_NewByDid(did, "credencial");
        Credential *cred = DIDDocument_GetCredential(doc, url);
        if (cred) {
            const char *credentialCJson = Credential_GetProperties(cred);
            NSString *credentialJson = (credentialCJson == NULL) ? nil : [NSString stringWithUTF8String:credentialCJson];
            
            WYLog(@"=== dev temp === credentialJson raw string from Chain: %@", credentialJson);
            
            credentialJson = [WYDIDUtils postLoadCustomInfos:credentialJson];
            
            WYLog(@"=== dev temp === credentialJson processed string from Chain: %@", credentialJson);
            
            NSDictionary *credentialDic = [[FLTools share] dictionaryWithJsonString:credentialJson];
            
            WYLog(@"=== dev temp === credentialDic: %@ === customInfos: %@", credentialDic, credentialDic[@"customInfos"]);
            
            NSString *didName = credentialDic[@"didName"];
            NSMutableDictionary *extraInfo = [credentialDic mutableCopy];
            [extraInfo removeObjectForKey:@"didName"];
            [extraInfo removeObjectForKey:@"did"];
            [extraInfo removeObjectForKey:@"editTime"];
            NSMutableDictionary *fullInfo = [credentialDic mutableCopy];
            fullInfo[@"endTime"] = endTimeString;
            fullInfo[@"endString"] = endTimeString;
            result = @{
                @"didName": didName,
                @"endTime": endTimeString,
                @"DIDString": DIDString,
                @"fullInfo": fullInfo,
                @"extraInfo": extraInfo
            };
        } else {
            url = DIDURL_NewByDid(did, "name");
            cred = DIDDocument_GetCredential(doc, url);
            const char *didCName = Credential_GetProperty(cred, "name");
            NSString *didName = (didCName == NULL) ? nil : [NSString stringWithUTF8String:didCName];
            result = @{
                @"didName": didName,
                @"endTime": endTimeString,
                @"DIDString": DIDString,
                @"fullInfo": @{
                        @"did": DIDString,
                        @"didName": didName,
                        @"endTime": endTimeString,
                        @"endString": endTimeString
                },
                @"extraInfo": @{}
            };
        }
        DIDURL_Destroy(url);
        DIDDocument_Destroy(doc);
        DID_Destroy(did);
        return result;
    }
    DIDDocument_Destroy(doc);
    DID_Destroy(did);
    return nil;
}

- (BOOL)saveDIDInfoToString:(NSString *)DIDString withModel:(HWMDIDInfoModel *)model withPwd:(NSString *)pwd {
    return YES;
}

+ (NSString *)postLoadCustomInfos:(NSString *)jsonString {
    NSMutableDictionary *jsonDic = [[WYUtils dicFromJSONString:jsonString] mutableCopy];
    
    if (jsonDic[@"customInfos"] && ![jsonDic[@"customInfos"] isKindOfClass:[NSString class]]) {
        if ([jsonDic[@"customInfos"] isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSDictionary *item in jsonDic[@"customInfos"]) {
                NSMutableDictionary *tempDic = [item mutableCopy];
                if (tempDic[@"type"]) {
                    tempDic[@"type"] = [NSString stringWithFormat:@"%@", tempDic[@"type"]];
                }
                [tempArr addObject:tempDic];
            }
            jsonDic[@"customInfos"] = tempArr;
            
            jsonDic[@"customInfos"] = [WYUtils arrToJSONString:jsonDic[@"customInfos"]];
        } else if ([jsonDic[@"customInfos"] isKindOfClass:[NSDictionary class]]) {
            jsonDic[@"customInfos"] = [WYUtils dicToJSONString:jsonDic[@"customInfos"]];
        } else {
            jsonDic[@"customInfos"] = nil;
        }
    }
    
    return [WYUtils dicToJSONString:jsonDic];
}

+ (NSString *)preStoreCustomInfos:(NSString *)jsonString {
    NSMutableDictionary *jsonDic = [[WYUtils dicFromJSONString:jsonString] mutableCopy];
    
    NSDictionary *tempDic = [jsonDic copy];
    
    for (NSString *key in tempDic) {
        if ([jsonDic[key] isKindOfClass:[NSString class]]) {
            NSString *value = jsonDic[key];
            if (value.length < 1) {
                [jsonDic removeObjectForKey:key];
            }
        }
        
        if ([jsonDic[key] isKindOfClass:[NSArray class]]) {
            NSArray *value = jsonDic[key];
            if (value.count < 1) {
                [jsonDic removeObjectForKey:key];
            }
        }
        
        if ([jsonDic[key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *value = jsonDic[key];
            if (value.count < 1) {
                [jsonDic removeObjectForKey:key];
            }
        }
    }
    
    if ([jsonDic[@"customInfos"] isKindOfClass:[NSString class]]) {
        jsonDic[@"customInfos"] = [WYUtils dicFromJSONString:jsonDic[@"customInfos"]];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *item in jsonDic[@"customInfos"]) {
            NSMutableDictionary *tempDic = [item mutableCopy];
            if (tempDic[@"type"]) {
                tempDic[@"type"] = @([tempDic[@"type"] intValue]);
            }
            [tempArr addObject:tempDic];
        }
        jsonDic[@"customInfos"] = tempArr;
        
    }
    return [WYUtils dicToJSONString:jsonDic];
}

@end
