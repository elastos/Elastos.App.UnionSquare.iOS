//
//  HMWtheContactInformationViewController.m
//  ELA
//

#import "HMWtheContactInformationViewController.h"
#import "HMWaddContactViewController.h"
#import "HMWToDeleteTheWalletPopView.h"
#import "HMWQrCodePopupWindowView.h"
#import "HMWFMDBManager.h"
#import "WYDIDInfoViewController.h"
#import "WYDIDUtils.h"
#import "WYDIDChainInfoModel.h"

@interface HMWtheContactInformationViewController ()<HMWToDeleteTheWalletPopViewDelegate,HMWQrCodePopupWindowViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *theWalletAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *DIDAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *QrCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UIButton *DIDButton;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNOTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteFrButton;
@property (weak, nonatomic) IBOutlet UIButton *theEditorFrButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *DIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

/*
 *<# #>
 */
@property(strong,nonatomic)HMWToDeleteTheWalletPopView *toDeleteTheWalletPopV;
/*
 *<# #>
 */
@property(strong,nonatomic)HMWQrCodePopupWindowView *QrCodePopupWindowV;

@end

@implementation HMWtheContactInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.nickNameTextField.enabled=NO;
    self.theWalletAddressTextField.enabled=NO;
    self.DIDAddressTextField.enabled = NO;
    self.mobilePhoneNOTextField.enabled=NO;
    self.emailTextField.enabled=NO;
    self.noteTextField.enabled=NO;
    self.title=NSLocalizedString(@"联系人信息", nil);
    
    self.nameLabel.text = NSLocalizedString(@"姓名", nil);
    self.addressLabel.text = NSLocalizedString(@"收款地址", nil);
    self.DIDLabel.text = NSLocalizedString(@"DID", nil);
    self.mobileLabel.text = NSLocalizedString(@"联系方式", nil);
    self.emailLabel.text = NSLocalizedString(@"邮箱", nil);
    self.noteLabel.text = NSLocalizedString(@"备注", nil);
    
//    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.nickNameTextField withTxt:NSLocalizedString(@"请输入姓名（必填）", nil)];
//    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.theWalletAddressTextField withTxt:NSLocalizedString(@"请输入钱包地址（必填）", nil)];
//
//    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.mobilePhoneNOTextField withTxt:NSLocalizedString(@"请输入手机号码", nil)];
//    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.emailTextField withTxt:NSLocalizedString(@"请输入邮箱", nil)];
//    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.noteTextField withTxt:NSLocalizedString(@"请输入备注", nil)];
    
    [[HMWCommView share]makeBordersWithView:self.deleteFrButton];
    [[HMWCommView share]makeBordersWithView:self.theEditorFrButton];
    
    [self.theEditorFrButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [self.deleteFrButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nickNameTextField.text=self.model.nameString;
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setAlignment:NSTextAlignmentRight];
    [pStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    NSMutableAttributedString *addressText = [[NSMutableAttributedString alloc] initWithString:self.model.address];
    [addressText addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, addressText.length)];
    self.theWalletAddressTextField.attributedText = addressText;
    
//    self.theWalletAddressTextField.text=self.model.address;
    
    NSMutableAttributedString *didText = [[NSMutableAttributedString alloc] initWithString:self.model.did];
    [didText addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, didText.length)];
    self.DIDAddressTextField.attributedText = didText;
    
//    self.DIDAddressTextField.text = self.model.did;
    
    self.mobilePhoneNOTextField.text=self.model.mobilePhoneNo;
    self.emailTextField.text=self.model.email;
    self.noteTextField.text=self.model.note;
    
    if ([self.DIDAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
           self.DIDButton.alpha = 1.f;
       } else {
           self.DIDButton.alpha = 0.f;
       }
}

- (IBAction)editTheContactEvent:(id)sender {
    HMWaddContactViewController *addContactVC=[[HMWaddContactViewController alloc]init];
    addContactVC.title=NSLocalizedString(@"编辑联系人", nil);
    addContactVC.model=self.model;
    addContactVC.typeInfo=ChangeInfo;
    addContactVC.contactInfoVC = self;
    [self.navigationController pushViewController:addContactVC animated:YES];
}
- (IBAction)deleteTheContactEvent:(id)sender {
    
    UIView *maView=[self mainWindow];
    [maView addSubview:self.toDeleteTheWalletPopV];
    [self.toDeleteTheWalletPopV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(maView);
    }];
}
-(HMWQrCodePopupWindowView *)QrCodePopupWindowV{
    if (!_QrCodePopupWindowV) {
        _QrCodePopupWindowV =[[HMWQrCodePopupWindowView alloc]init];
        _QrCodePopupWindowV.walletAddressString=self.model.address;
        _QrCodePopupWindowV.delegate=self;
    }
    
    return _QrCodePopupWindowV;
}
-(HMWToDeleteTheWalletPopView *)toDeleteTheWalletPopV{
    if (!_toDeleteTheWalletPopV) {
        _toDeleteTheWalletPopV =[[HMWToDeleteTheWalletPopView alloc]init];
        _toDeleteTheWalletPopV.delegate=self;
        _toDeleteTheWalletPopV.deleteType=deleteFriends;
    }
    
    return _toDeleteTheWalletPopV;
}
#pragma mark --------HMWToDeleteTheWalletPopViewDelegate----------
-(void)sureToDeleteViewDelegate{
    
    if ([[HMWFMDBManager sharedManagerType:friendsModelType]delectRecord:self.model]){
        [[FLTools share]showErrorInfo:NSLocalizedString(@"添加成功！", nil)];
        [self toCancelOrCloseDelegate];
        
    }
    
    
    
}
-(void)toCancelOrCloseDelegate{
    
    [self.toDeleteTheWalletPopV removeFromSuperview];
    self.toDeleteTheWalletPopV=nil;
}


- (IBAction)addressCopyToClipboard:(id)sender {
    [[FLTools share]copiedToTheClipboardWithString:self.theWalletAddressTextField.text];
}

- (IBAction)accordingToQRCodeEvent:(id)sender {
    UIView *manView =[self mainWindow];
    [manView addSubview:self.QrCodePopupWindowV];
    
    [self.QrCodePopupWindowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(manView);
    }];
    
}

- (IBAction)DIDButtonPressed:(id)sender {
    NSDictionary *didInfo = [WYDIDUtils getDIDInfoFromString:self.DIDAddressTextField.text];
    if (didInfo) {
        WYDIDInfoViewController *DIDInfoVC = [[WYDIDInfoViewController alloc] init];
        WYDIDChainInfoModel *model = [[WYDIDChainInfoModel alloc] init];
        model.didName = didInfo[@"didName"];
        model.didAddress = didInfo[@"DIDString"];
        model.expireTime = didInfo[@"endTime"];
        DIDInfoVC.model = model;
        DIDInfoVC.extraInfo = didInfo[@"extraInfo"];
        [self.navigationController pushViewController:DIDInfoVC animated:YES];
    } else {
        [[FLTools share] showErrorInfo:NSLocalizedString(@"DID无链上信息", nil)];
        return;
    }
}

-(void)QrCodePopupWindowHidde{
    
    [self.QrCodePopupWindowV removeFromSuperview];
    
    self.QrCodePopupWindowV=nil;
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)setModel:(friendsModel *)model{
    _model=model;
    
}

-(void)sureToDeleteViewWithPWD:(NSString*)pwd{
    
    if ([[HMWFMDBManager sharedManagerType:friendsModelType] delectRecord:self.model]){
        [[FLTools share]showErrorInfo:NSLocalizedString(@"删除成功", nil)];
        [self toCancelOrCloseDelegate];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
