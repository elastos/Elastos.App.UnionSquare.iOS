//
//  HWMDIDManager.m
//  elastos wallet
//
//  Created by  on 2020/2/18.
//


#import "HWMDIDManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <stdio.h>
#import "ELWalletManager.h"
#import "JWT.h"
#import "MF_Base64Additions.h"
#import "NSObject+YYModel.h"
#import "NSDictionary+YYAdd.h"
#import "YYKit.h"
#import "WYDIDUtils.h"
//#import "ELAWallet-Swift.h"
#define SIGNATURE_BYTES         64

static HWMDIDManager *_instance;
DIDStore *store;
DID *did;
const char *tmp;
@interface HWMDIDManager ()
@property(copy,nonatomic)NSString *mRootPath;
@property(assign,nonatomic)BOOL hasBen;
@end
@implementation HWMDIDManager
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareDIDManager
{
    //return _instance;
    // 最好用self 用DIDManager他的子类调用时会出现错误
    
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
typedef struct TestDIDAdaptor {
    DIDAdapter base;
    
    char *pwd;
    char *walletId;
} TestDIDAdaptor;

bool TestDIDAdaptor_CreateIdTransaction(DIDAdapter *_adapter, const char *payload, const char *memo)
{
    TestDIDAdaptor *adapter = (TestDIDAdaptor*)_adapter;
    NSString *password=[NSString stringWithFormat:@"%s",adapter->pwd];
    NSString * walletID=[NSString stringWithFormat:@"%s",adapter->walletId];
    NSString *payloadJsonString=[NSString stringWithFormat:@"%s",payload];
    //    NSDictionary *dicPayJson=[[FLTools share]dictionaryWithJsonString:payloadJsonString];
    //    payloadJsonString=dicPayJson[@"payload"];
    NSString *memoString=[NSString stringWithFormat:@"%s",memo];
    if (!adapter || !payload){
        return false;
        
    }
    invokedUrlCommand *cmommand=[[invokedUrlCommand alloc]initWithArguments:@[walletID,@"IDChain",password,memoString,@"",payloadJsonString] callbackId:walletID className:@"wallet" methodName:@"SpvDidAdapter_CreateIdTransactionEXWith"];
    PluginResult * resultBase =[[ELWalletManager share]SpvDidAdapter_CreateIdTransactionEXWith:cmommand];
    NSString *statusBase=[NSString stringWithFormat:@"%@",resultBase.status];
    
    if ([statusBase isEqualToString:@"1"] ) {
        return true;
        
    }else{
        return false;
    }
    
}

DIDAdapter *TestDIDAdapter_Create(const char *pwd, const char *walletId)
{
    TestDIDAdaptor *adapter;
    
    adapter = (TestDIDAdaptor*)calloc(1, sizeof(TestDIDAdaptor));
    if (!adapter)
        return NULL;
    adapter->base.createIdTransaction = TestDIDAdaptor_CreateIdTransaction;
    NSString *pwdString=[NSString stringWithFormat:@"%s",pwd];
    if (![pwdString isEqualToString:@"1"]) {
        adapter->pwd=strdup(pwd);
        adapter->walletId = strdup(walletId);
    }
    return (DIDAdapter*)adapter;
}
-(instancetype)init{
    if (self==nil) {
        self=[super init];
        
    }
    _mRootPath=[MyUtil DIDRootPath];
    return self;
    
}
-(NSString*)hasDIDWithPWD:(NSString *)passWord withDIDString:(NSString*)DIDString
     WithPrivatekeyString:(NSString*)privatekeyString
         WithmastWalletID:(NSString*)mastWalletID needCreatDIDString:(BOOL)need{
    bool force=false;
    if (need) {
        [[FLTools share]showLoadingView];
        force=true;
    }
    
    NSInteger re;
    self.passWord=passWord;
    self.privatekeyString=privatekeyString;
    if (mastWalletID.length>0) {
        self.mastWalletID=mastWalletID;
    }
    if (DIDString.length>0) {
        self.DIDString=DIDString;
    }
    if (self.passWord.length>0&&privatekeyString.length==0) {
        invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.mastWalletID,self.passWord] callbackId:self.mastWalletID className:@"Wallet" methodName:@"ExportxPrivateKey"];
        self.privatekeyString=[[ELWalletManager share]ExportxPrivateKey:mommand];
        if (self.privatekeyString.length==0){
            return @"";
        }
    }
    // 添加null逻辑判断
    tmp =[[NSString stringWithFormat:@"%@%@",_mRootPath,self.mastWalletID] UTF8String];
    DIDAdapter * didAdapter = TestDIDAdapter_Create([self.passWord UTF8String],[self.mastWalletID UTF8String]);
    store=DIDStore_Open(tmp, didAdapter);
    if (store==NULL) {//
        return @"";
    }
    re= DIDBackend_InitializeDefault([didSDKNet UTF8String],tmp);// 变量
    if (self.privatekeyString.length!=0){
        if (!DIDStore_ContainsPrivateIdentity(store)) {//检测
            re = DIDStore_InitPrivateIdentityFromRootKey(store, [self.passWord UTF8String], [self.privatekeyString UTF8String], NO);//no 待定// 有失败的可能
            if (re==-1) {// 失败 是否在create的时候 补救
                return @"";
            }
        }else{
        }
    }
    
    //    if (self.DIDString.length==0){
    did=DIDStore_GetDIDByIndex(store, 0);//
    char _didstring[ELA_MAX_DID_LEN];
    const char *didstring;
    didstring = DID_ToString(did, _didstring, sizeof(_didstring));
    self.DIDString=[self charToString:didstring];
    //    }else{
    //        did=DID_FromString([self.DIDString UTF8String]);// 获取DID
    //        char _didstring[ELA_MAX_DID_LEN];
    //        const char *didstring;
    //        didstring = DID_ToString(did, _didstring, sizeof(_didstring));
    //        self.DIDString=[self charToString:didstring];
    //    }
    DIDDocument *  doc=DID_Resolve(did,force);
    
    if (doc) {//先看一下链上有没有
        DIDURL *url=DIDURL_NewByDid(did, "primary");
        if (DIDStore_ContainsPrivateKey(store,did, url)) {
            DIDStore_StoreDID(store, doc);// 保存到本地
            
            // Obsolete logic for old didsdk version
//            DIDDocument *  nedoc=DIDStore_LoadDID(store, did);//绑定
//            DID * newdid= DIDDocument_GetSubject(nedoc);
//            DID_Copy(did, newdid);
            
            DIDURL_Destroy(url);
            DIDDocument_Destroy(doc);
//            DIDDocument_Destroy(nedoc);
            if (need) {
                [[FLTools share]hideLoadingView];
            }
            self.hasBen=YES;
            return self.DIDString;
        }else{
            DIDDocument *reDoc=DIDStore_NewDIDByIndex(store, [self.passWord UTF8String], 0, "name");//
            if (reDoc) {
                DIDStore_StoreDID(store, reDoc);// 保存到本地
                
                // Obsolete logic for old didsdk version
//                DID * newdid= DIDDocument_GetSubject(reDoc);
//                DID_Copy(did, newdid);
                
                DIDDocument_Destroy(reDoc);
                if (need) {
                    [[FLTools share]hideLoadingView];
                }
                self.hasBen=NO;
                return self.DIDString;
            }else{
                if (need) {
                    [[FLTools share]hideLoadingView];
                }
                self.hasBen=NO;
                return @"";// 失败返回
            }
        }
    }else{//没有
        doc=DIDStore_LoadDID(store, did);
        if (doc==NULL) {
            doc=DIDStore_NewDIDByIndex(store, [self.passWord UTF8String], 0, "name");//
            DIDDocument_Destroy(doc);
        }
        if (need) {
            [[FLTools share]hideLoadingView];
        }
        
        self.hasBen=NO;
        return self.DIDString;
        
    }
}
-(NSDictionary*)getDIDInfo{
    if (did==nil||store==nil) {
        //        [[FLTools share]showErrorInfo:@"本地没有"];
        return nil;
    }
    NSDictionary *reDic = nil;
    DIDDocument *doc=DIDStore_LoadDID(store, did);
    
    time_t endTime= DIDDocument_GetExpires(doc);
    NSString *endTimeString=[[FLTools share]SpecialTimeZoneConversion:[NSString stringWithFormat:@"%@",@(endTime)]];
    
    DIDURL *url = DIDURL_NewByDid(did, "credencial");
    Credential *cre = DIDDocument_GetCredential(doc, url);
    if (cre) {
        const char *credentialCJson = Credential_GetProperties(cre);
        NSString *credentialJson = (credentialCJson == NULL) ? nil : [NSString stringWithUTF8String:credentialCJson];
        credentialJson = [WYDIDUtils postLoadCustomInfos:credentialJson];
        NSDictionary *credentialDic = [[FLTools share] dictionaryWithJsonString:credentialJson];
        NSString *didName = credentialDic[@"didName"];
        reDic = @{
            @"nickName": didName,
            @"endTime": endTimeString,
            @"DIDString": self.DIDString
        };
    } else {
        url=DIDURL_NewByDid(did, "name");
        cre= DIDDocument_GetCredential(doc,url);
        const char * suInfo = Credential_GetProperty(cre, "name");
        NSString * didName=[self charToString:suInfo];
        didName= [didName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (self.DIDString.length==0) {
            didName=@"";
        }
        reDic = @{
            @"nickName":didName,
            @"endTime":endTimeString,
            @"DIDString":self.DIDString
        };
    }
    DIDURL_Destroy(url);
    DIDDocument_Destroy(doc);
    return reDic;
}
-(BOOL)updateInfoWithInfo:(HWMDIDInfoModel*)model {
    NSString *tempDid = model.did;
    NSString *tempDidName = model.didName;
    NSString *tempEndString = model.endString;
    
    int rt;
    DIDURL *url=DIDURL_NewByDid(did, "name");
    DIDURL *creatCredentialID=DIDURL_NewByDid(did, "credencial");
    
    DIDDocument *doc=DIDStore_LoadDID(store, did);
    if (doc==NULL) {
        WYLog(@"=== dev temp === updateInfoWithInfo: doc is NULL");
        return NO;
    }
    DIDDocumentBuilder *build=DIDDocument_Edit(doc);
    Credential *cr  = DIDDocument_GetCredential(doc, url);
    Credential *cre = DIDDocument_GetCredential(doc, url);
    DIDDocument_Destroy(doc);
    model.didName=[model.didName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    time_t endTime=[model.endString longValue];
    
    if (model.editTime.length==0) {
        model.editTime=[[FLTools share]getNowTimeTimestampS];
    }
    
    model.did=self.DIDString;
    if (model.didName.length==0) {
        model.didName=@"unknown";
    }
    model.endString=NULL;
    
    if (cr) {
        DIDDocumentBuilder_RemoveCredential(build, url);
    }
    if (cre) {
        DIDDocumentBuilder_RemoveCredential(build, creatCredentialID);
    }
    
    const char * types[1] = {"BasicProfileCredential"};//
    Property props[1];
    char * nickName =(char*)[model.didName UTF8String];
    
    WYLog(@"=== dev temp === updateInfoWithInfo: nickName is %s", nickName);
    
    props[0].key = "name";
    props[0].value = nickName;
    rt= DIDDocumentBuilder_AddSelfClaimedCredential(build, url, types,1,  props, 1, endTime, [self.passWord UTF8String]);
    if (rt!=0) {
        WYLog(@"=== dev temp === updateInfoWithInfo: add nickName failed");
        model.did = tempDid;
        model.didName = tempDidName;
        model.endString = tempEndString;
        return NO;
    }
    
    NSString *CredentialSubjectBean = [WYDIDUtils preStoreCustomInfos:[model modelToJSONString]];
    
    const char *nickNameCre =[CredentialSubjectBean UTF8String];
    WYLog(@"=== dev temp === updateInfoWithInfo: nickNameCre is %s", nickNameCre);
    Issuer *isser=Issuer_Create(did, NULL, store);
    Credential *c =  Issuer_CreateCredentialByString(isser, did, creatCredentialID, types, 1, nickNameCre, endTime, [self.passWord UTF8String]);
    rt = DIDDocumentBuilder_AddCredential(build, c);
    
    model.did = tempDid;
    model.didName = tempDidName;
    model.endString = tempEndString;
    
    if (rt!=0) {
        WYLog(@"=== dev temp === updateInfoWithInfo: add nickNameCre failed");
        return NO;
    }
    
    rt=DIDDocumentBuilder_SetExpires(build, endTime);
    if (rt!=0) {
        WYLog(@"=== dev temp === updateInfoWithInfo: set endTime failed");
        return NO;
    }
    DIDDocument * newDoc=  DIDDocumentBuilder_Seal(build, [self.passWord UTF8String]);
    const  char *doString=DIDDocument_ToJson(newDoc, false);
    rt=  DIDStore_StoreDID(store,newDoc);// 已经签名
    
    bool r = DIDStore_PublishDID(store, [self.passWord UTF8String], did, NULL,true);
    
    Issuer_Destroy(isser);
    Credential_Destroy(c);
    
    DIDURL_Destroy(url);
    DIDURL_Destroy(creatCredentialID);
    DIDDocument_Destroy(newDoc);
    if (r) {
        return YES;
    }else{
        WYLog(@"=== dev temp === updateInfoWithInfo: Store and Publish failed");
        //        [[FLTools share]showErrorInfo:@"发布失败"];
        return NO;
    }
}
-(void)setPassWord:(NSString *)passWord{
    _passWord=passWord;
}
-(void)setDIDString:(NSString *)DIDString{
    _DIDString=DIDString;
}
-(void)setPrivatekeyString:(NSString *)privatekeyString{
    _privatekeyString=privatekeyString;
}
-(void)setMastWalletID:(NSString *)mastWalletID{
    _mastWalletID=mastWalletID;
}

-(NSString*)charToString:(const char*)needChar{
    if (needChar ==NULL) {
        WYLog(@"===dev temp === charToString: needChar is NULL!!");
        return @"";
    }
    WYLog(@"===dev temp === charToString: needChar is NOT NULL");
    return  [NSString stringWithUTF8String:needChar];
    
}
-(BOOL)saveDIDCredentialWithDIDModel:(HWMDIDInfoModel*)model{// 保存本地凭证
    if (did==NULL||store==NULL) {
        return NO;
    }
    if (model==nil) {
        NSDictionary *red=[self getDIDInfo];
        model=[[HWMDIDInfoModel alloc]init];
        model.did=red[@"DIDString"];
        model.didName=red[@"nickName"];
        model.endString=red[@"endTime"];
    }
    Issuer *isser=Issuer_Create(did, NULL, store);
    NSDictionary *dic=[self getDIDInfo];
    time_t endTime=[model.endString integerValue];//
    if (endTime==0){
        endTime= [dic[@"endTime"] integerValue];
    }
    const char *types[1] = {"BasicProfileCredential"};//类型名称
    
//    const char *types[1] = {"SelfProclaimedCredential"};//类型名称
    
    DIDURL *creatCredentialID=DIDURL_NewByDid(did, "outPut");// 相当于文件  不同的需求 需要创建不同的名字  只能通过这个别名 拿去 Credential
    if (model.editTime.length==0) {
        model.editTime=[[FLTools share]getNowTimeTimestampS];
    }
    model.did=self.DIDString;
    if (model.didName.length==0) {
        model.didName=@"unknown";
    }
    model.endString=NULL;
    
    NSString *CredentialSubjectBean = [WYDIDUtils preStoreCustomInfos:[model modelToJSONString]];
    
//    NSMutableDictionary *tempDic = [[WYUtils dicFromJSONString:CredentialSubjectBean] mutableCopy];
//    if ([tempDic[@"customInfos"] isKindOfClass:[NSString class]]) {
//        tempDic[@"customInfos"] = [WYUtils dicFromJSONString:tempDic[@"customInfos"]];
//        CredentialSubjectBean = [WYUtils dicToJSONString:tempDic];
//    }
    
//    CredentialSubjectBean = [CredentialSubjectBean stringByReplacingOccurrencesOfString:@"\\\"" withString:@"#SpEciaL\\\\\\\"#sPeciaL"];
    
    WYLog(@"=== dev temp === saveDIDCredentialWithDIDModel: beanString %@ === did %@ === birth %@ === customInfos %@", CredentialSubjectBean, model.did, model.birthday, model.customInfos);
    
    const char *nickName =[CredentialSubjectBean UTF8String];
    
//    bool isDelete = DIDStore_DeleteCredential(store, did, creatCredentialID);
//    WYLog(@"=== dev temp === saveDIDCredentialWithDIDModel: isDelete %d", isDelete
//          );
//    if (!isDelete) {
//        const char *err = DIDError_GetMessage();
//        WYLog(@"=== dev temp === saveDIDCredentialWithDIDModel: Delete Error %s", err);
//    }
        
    WYLog(@"=== dev temp === saveDIDCredentialWithDIDModel: nickName %s", nickName);
    
    Credential *c =  Issuer_CreateCredentialByString(isser, did, creatCredentialID, types, 1, nickName, endTime, [self.passWord UTF8String]);
    int r=DIDStore_StoreCredential(store, c);
    
//    int r=DIDStore_StoreCredential(store, c, "SelfProclaimedCredential");
    
    Issuer_Destroy(isser);
    DIDURL_Destroy(creatCredentialID);
    Credential_Destroy(c);
    if (r==0) {
        return YES;
    }else{
        const char *err = DIDError_GetMessage();
        WYLog(@"=== dev temp === saveDIDCredentialWithDIDModel Error: c %s === r %d === err %s", c, r, err);
        return NO;
    }
}

-(HWMDIDInfoModel*)readDIDCredential{// 获取did本地凭证
    DIDURL *url=DIDURL_NewByDid(did,"outPut");
    Credential *cre=DIDStore_LoadCredential(store, did, url);
    const char *suInfo  = Credential_GetProperties(cre);
    
    WYLog(@"===dev temp === readDIDCredential: suInfo %s ===", suInfo);
    
    NSString *modelString = [WYDIDUtils postLoadCustomInfos:[self charToString:suInfo]];
//    modelString = [modelString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
//    modelString = [modelString stringByReplacingOccurrencesOfString:@"#SpEciaL\"#sPeciaL" withString:@"\\\""];
    
//    WYLog(@"=== dev temp === readDIDCredential: modelString raw string from Local %@", modelString);
    
//    NSMutableDictionary *tempDic = [[WYUtils dicFromJSONString:modelString] mutableCopy];
//
//    if (tempDic[@"customInfos"] && ![tempDic[@"customInfos"] isKindOfClass:[NSString class]]) {
//        if ([tempDic[@"customInfos"] isKindOfClass:[NSArray class]]) {
//            tempDic[@"customInfos"] = [WYUtils arrToJSONString:tempDic[@"customInfos"]];
//        } else if ([tempDic[@"customInfos"] isKindOfClass:[NSDictionary class]]) {
//            tempDic[@"customInfos"] = [WYUtils dicToJSONString:tempDic[@"customInfos"]];
//        } else {
//            tempDic[@"customInfos"] = nil;
//        }
//        modelString = [WYUtils dicToJSONString:tempDic];
//    }
    
    HWMDIDInfoModel *model=[HWMDIDInfoModel modelWithJSON:modelString];
    
    WYLog(@"=== dev temp === readDIDCredential: modelString %@ === customInfos %@", modelString, model.customInfos);
    
    if (model==nil) {
        model=[[HWMDIDInfoModel alloc]init];
        
    }
    NSDictionary *dic= [self getDIDInfo];
    model.didName=dic[@"nickName"];
    if (model.didName.length==0) {
        model.didName=@"unknow";
    }
    //    if (model.did.length==0) {
    //        model.did=dic[@"DIDString"];
    //    }
    //    model.did=self.DIDString;
    
    DIDURL_Destroy(url);
    
    WYLog(@"=== dev temp === readDIDCredential: model did %@ === name %@ === customInfos %@", model.did, model.didName, model.customInfos);
    
    return model;
}
-(NSString*)generateDIDCredentialString{
    DIDURL *url=DIDURL_NewByDid(did, "outPut");
    Credential * cre=DIDStore_LoadCredential(store, did, url);
    const char *suInfo  = Credential_ToJson(cre, false);
    NSString *generateDIDString=[self charToString:suInfo];
    DIDURL_Destroy(url);
    return generateDIDString;
}
//二维码验签名
-(BOOL)jwtSignatureWithDIDString:(NSString*)didString withSignature:(NSString*)signatureStr withUnSignature:(NSString*)UnSignature{
    int r;
    r= DIDBackend_InitializeDefault([didSDKNet UTF8String],tmp);// 变量
    char * signature= (char*)[signatureStr UTF8String];// 已经签名数据
    char * usignature= (char*)[UnSignature UTF8String];//未签名数据
    DID *jwtDID=DID_FromString([didString UTF8String]);
    DIDDocument * jwtDoc=DID_Resolve(jwtDID,false);
    if (jwtDoc==NULL) {
        [[FLTools share]showErrorInfo:@"DID无效"];
        return NO;
    }
    DIDURL *url=DIDURL_NewByDid(jwtDID, "primary");
    r= DIDDocument_Verify(jwtDoc,url,signature, 1,usignature,strlen(usignature));
    DIDURL_Destroy(url);
    DID_Destroy(jwtDID);
    DIDDocument_Destroy(jwtDoc);
    if (r==0) {
        return YES;
    }else{
        [[FLTools share]showErrorInfo:@"验签失败!"];
        return NO;
    }
    
}

-(id)jwtDecodeWithJwtStringInfo:(NSString *)jwtStr {
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
    NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
    
    UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    if ([jsonDict[@"exp"] intValue]<[[[FLTools share]getNowTimeTimestampS] intValue])  {
        
        [[FLTools share]showErrorInfo:NSLocalizedString(@"二维码已过期", nil)];
        return nil;
    }
    
    if ([self jwtSignatureWithDIDString:jsonDict[@"iss"] withSignature:manySecrets.lastObject withUnSignature:UnSignature]) {
        return jsonDict;
    }else{
        WYLog(@"%s : wallet did invalid Manager", __func__);
        [[FLTools share]showErrorInfo:NSLocalizedString(@"钱包DID不匹配", nil)];
        return @"1";
    }
    
    return nil;
}
-(BOOL)qrTimeWithString:(NSString*)jwtStr{
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
    NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
    
    UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    if ([jsonDict[@"exp"] intValue]<[[[FLTools share]getNowTimeTimestampS] intValue])  {
        
        YES;
    }
    return NO;
    
    
}
-(BOOL)AuthenticationWithString:(NSString*)jwtStr{
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
    NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
    UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    bool isDID=[self.DIDString isEqualToString:jsonDict[@"data"][@"did"]];
    if (isDID){
        return NO;
    }else{
        return YES;
        
    }
    
}
-(id)CRInfoDecodeWithJwtStringInfo:(NSString *)jwtStr {
    
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
    NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return jsonDict;
}

- (NSString *)removeSpaceAndNewline:(NSString *)str

{
    
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    return text;
    
}
-(id)jwtInfo:(NSString*)jtwStr{
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[jtwStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return jsonDict;
}


-(NSString*)DIDSignatureWithString:(NSString*)sigString{
    int r;
    if (store==NULL) {//
        return @"-1";
    }
    DIDDocument *doc=DIDStore_LoadDID(store, did);
    if (doc==NULL) {
        [[FLTools share]showErrorInfo:@"DID不存在"];
        return @"-1";
    }
    char signature[SIGNATURE_BYTES * 2 + 16];
    char *sig =(char *)[sigString UTF8String];
    r=DIDDocument_Sign(doc, NULL, [self.passWord UTF8String],
                       signature,1,sig,strlen(sig));
    
    //xxl 0.0.0 do not forget to
    //    NSString *str = [self charToString:signature];
    //    NSData *data = [JWTBase64Coder dataWithBase64UrlEncodedString:str];
    //    NSString *hexString = data.hexString;
    //
    //    if (r==0) {
    //        return hexString;
    //    }
    
    if (r==0) {
        return [self charToString:signature];
    }
    return @"-1";
}
-(BOOL)ImportLocalCredentialsWithModel:(HWMDIDInfoModel*)model{
    return YES;
}
-(bool)CheckDIDwhetherExpiredWithDIDString:(NSString*)didString WithmastWalletID:(NSString*)walletID{
    [self hasDIDWithPWD:@"" withDIDString:didString WithPrivatekeyString:@"" WithmastWalletID:walletID needCreatDIDString:NO];
    NSDictionary *dic=[self getDIDInfo];
    if ([dic[@"endTime"] intValue]<[[[FLTools share]getNowTimeTimestampS] intValue]) {
        [[FLTools share]showErrorInfo:NSLocalizedString(@"DID已过期", nil)];
        return NO;
    }
    return YES;
}
-(BOOL)ComparedWithThePublicKeyWithmastWalletID:(NSString*)walletID withStringInfo:(NSString *)jwtStr{
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[walletID,@"ELA",@"0",@"100"] callbackId:walletID className:@"Wallet" methodName:@"getAllSubWallets"];
    PluginResult *re=[[ELWalletManager share]getAllPublicKeys:mommand];
    NSString *pubKey;
    if ([re.status isEqualToNumber:@(1)]) {
        NSArray *pubA=re.message[@"success"][@"PublicKeys"];
        pubKey=pubA.firstObject;
    }else{
        return false;
    }
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
       NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
       NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
       NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
       UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
       bool isDID=[pubKey isEqualToString:jsonDict[@"data"][@"ownerpubkey"]];
       if (isDID){
           return NO;
       }else{
           return YES;
           
       }
    return YES;
}
-(BOOL)adviceComparedWithThePublicKeyWithmastWalletID:(NSString*)walletID withStringInfo:(NSString *)jwtStr{
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[walletID,@"ELA",@"0",@"100"] callbackId:walletID className:@"Wallet" methodName:@"getAllSubWallets"];
    PluginResult *re=[[ELWalletManager share]getAllPublicKeys:mommand];
    NSString *pubKey;
    if ([re.status isEqualToNumber:@(1)]) {
        NSArray *pubA=re.message[@"success"][@"PublicKeys"];
        pubKey=pubA.firstObject;
    }else{
        return false;
    }
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
       NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
       NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
       NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
       UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
       bool isDID=[pubKey isEqualToString:jsonDict[@"data"][@"ownerpublickey"]];
    WYLog(@"=== dev temp === QR JWT dic: %@", jsonDict);
    WYLog(@"pubKey==%@-------ownerpublickey==%@",pubKey,jsonDict[@"data"][@"ownerpublickey"]);
       if (isDID){
           return NO;
       }else{
           return YES;
           
       }
    return YES;
}

-(BOOL)comparedWithTheDIDWithmastWalletID:(NSString*)walletID withStringInfo:(NSString *)jwtStr{
    NSString *didString = [[HWMDIDManager shareDIDManager]hasDIDWithPWD:@"" withDIDString:@"" WithPrivatekeyString:@"" WithmastWalletID:walletID needCreatDIDString:NO];
    
    if (didString && didString.length < 35) {
        didString = [NSString stringWithFormat:@"did:elastos:%@", didString];
    }
    
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
       NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
       NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
       NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
       UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
       bool isDID=[didString isEqualToString:jsonDict[@"data"][@"userdid"]];
    
    WYLog(@"=== dev temp === QR JWT dic: %@", jsonDict);
    WYLog(@"didString==%@-------userdid==%@",didString,jsonDict[@"data"][@"userdid"]);
    
    if (isDID){
        return NO;
    }else{
        return YES;
    }
    
    return YES;
}

-(BOOL)voteforProposalQrCodeTypeWithString:(NSString*)jwtStr{
    NSArray * manySecrets = [jwtStr componentsSeparatedByString:@"."];
    NSString *base=[NSString stringFromBase64UrlEncodedString:manySecrets[1]];
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[base dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString* UnSignature=[NSString stringWithFormat:@"%@.%@",[self removeSpaceAndNewline:manySecrets.firstObject],manySecrets[1]];
    UnSignature=[UnSignature stringByReplacingOccurrencesOfString:@"//n" withString:@""];
    bool isDID=[self.DIDString isEqualToString:jsonDict[@"iss"]];
    if (isDID){
        return NO;
    }else{
        return YES;
        
    }
    
}
-(BOOL)GenerateLocalCredentialsWithFielNameWithFielName:(NSString*)FielName{
    NSString *jwtString= [self generateDIDCredentialString];
    return  [MyUtil saveDIDPathWithWalletID:self.mastWalletID withString:jwtString WithFielName:FielName];
}
-(NSArray*)shareJWTWithmastWalletID:(NSString*)walletID withFileName:(NSString*)fileName needDlea:(void(^)(BOOL de))needDleFile{
    NSString *res=[MyUtil jwtPathWithWalletID:walletID withFileName:fileName];
    if (res.length==0) {
        [MyUtil saveDIDPathWithWalletID:@"share" withString:[self generateDIDCredentialString] WithFielName:fileName];
        res=[MyUtil jwtPathWithWalletID:@"share" withFileName:fileName];
        needDleFile(YES);
    }
    if (res) {
        NSData *data =[NSData dataWithContentsOfFile:res];
        NSURL *URL=[NSURL fileURLWithPath:res];
        return [NSArray arrayWithObjects:data,@"jwt",URL,nil];
    };
    return nil;
}
-(BOOL)CertificateUpdateWithWalletID:(NSString*)walletID WithFileName:(NSString*)fileName{
    NSString *res=[MyUtil jwtPathWithWalletID:walletID withFileName:fileName];
    NSData *data =[NSData dataWithContentsOfFile:res];
    NSString *infoString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *infoDic=[[FLTools share]dictionaryWithJsonString:infoString];
    HWMDIDInfoModel *model=[HWMDIDInfoModel modelWithDictionary:infoDic[@"credentialSubject"]];
    model.endString=[[FLTools share]SpecialTimeZoneConversion:infoDic[@"expirationDate"]];
    BOOL  Credential=[self saveDIDCredentialWithDIDModel:model];
    //    BOOL updateInfo= [self updateInfoWithInfo:model];
    if (Credential) {
        return YES;
    }
    return NO;
}
-(BOOL)HasBeenOnTheChain{
    return self.hasBen;
}
-(NSString*)adviceTheSignatureWithPWD:(NSString*)pwdString withDigestChar:(char*)DigestChar{
    int r;
    if (store==NULL) {//
        return @"-1";
    }
    DIDDocument *doc=DIDStore_LoadDID(store, did);
    if (doc==NULL) {
        [[FLTools share]showErrorInfo:@"DID不存在"];
        return @"-1";
    }
    char signature[SIGNATURE_BYTES * 2 + 16];
    
    uint8_t *digest = (uint8_t*)DigestChar;
    r=DIDDocument_SignDigest(doc, NULL, [pwdString UTF8String],
                             signature,digest,DIGEST_LEN);
    
    //xxl 0.0.0 do not forget to
    NSString *str = [self charToString:signature];
    NSData *data = [JWTBase64Coder dataWithBase64UrlEncodedString:str];
    NSString *hexString = data.hexString;
    
    if (r==0) {
        return hexString;//[self charToString:signature];
    }
    
    //    if (r==0) {
    //        return str;
    //    }
    return @"-1";
}
-(NSString*)proposalTheSignatureWithPWD:(NSString*)pwdString withDigestChar:(char*)DigestChar{
    int r;
    if (store==NULL) {//
        return @"-1";
    }
    DIDDocument *doc=DIDStore_LoadDID(store, did);
    if (doc==NULL) {
        [[FLTools share]showErrorInfo:@"DID不存在"];
        return @"-1";
    }
    char signature[SIGNATURE_BYTES * 2 + 16];
    uint8_t *digest = (uint8_t*)DigestChar;
    r=DIDDocument_SignDigest(doc, NULL, [pwdString UTF8String],
                             signature,digest,DIGEST_LEN);
    NSString *str = [self charToString:signature];
    NSData *data = [JWTBase64Coder dataWithBase64UrlEncodedString:str];
    NSString *hexString = data.hexString;
    if (r==0) {
        return hexString;//[self charToString:signature];
    }
    return @"-1";
}

@end

