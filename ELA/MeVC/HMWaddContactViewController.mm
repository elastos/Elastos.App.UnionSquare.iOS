//
//  HMWaddContactViewController.m
//  ELA
//

#import "HMWaddContactViewController.h"
#import "HMWFMDBManager.h"
#import "friendsModel.h"
#import "WCQRCodeScanningVC.h"
#import "ELWalletManager.h"
#import "WYDIDUtils.h"

@interface HMWaddContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *theWalletAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *DIDAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *QrCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNOTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UIButton *addBuddyButton;

@end

@implementation HMWaddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self defultWhite];
    [self setBackgroundImg:@""];
    
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField: self.nickNameTextField withTxt:NSLocalizedString(@"请输入姓名（必填）", nil)];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.theWalletAddressTextField withTxt:NSLocalizedString(@"请输入收款地址（必填）", nil)];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.DIDAddressTextField withTxt:NSLocalizedString(@"请输入did", nil)];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.mobilePhoneNOTextField withTxt:NSLocalizedString(@"请输入手机号码", nil)];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.emailTextField withTxt:NSLocalizedString(@"请输入邮箱", nil)];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.noteTextField withTxt:NSLocalizedString(@"请输入备注", nil)];
    
    [[HMWCommView share]makeBordersWithView:self.addBuddyButton];
    [self.addBuddyButton setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    if (self.model.nameString.length>0) {
        
        self.nickNameTextField.text=self.model.nameString;
        
        self.theWalletAddressTextField.text=self.model.address;
        
        self.DIDAddressTextField.text = self.model.did;
        
        self.mobilePhoneNOTextField.text=self.model.mobilePhoneNo;
        self.emailTextField.text=self.model.email;
        
        self.noteTextField.text=self.model.note;
        
        [self.addBuddyButton setTitle:NSLocalizedString(@"确认修改", nil) forState:UIControlStateNormal];
    }
    if (self.addressString.length>0) {
        self.theWalletAddressTextField.text=self.addressString;
    }
    if (self.didString.length>0) {
        self.DIDAddressTextField.text = self.didString;
    }
}

- (IBAction)sweepTheQRCodeEvent:(id)sender {
    __weak __typeof__(self) weakSelf = self;
    WCQRCodeScanningVC *WCQRCode=[[WCQRCodeScanningVC alloc]init];
    WCQRCode.scanBack=^(NSString *addr){
        weakSelf.theWalletAddressTextField.text=addr;
        
    };
    [self QRCodeScanVC:WCQRCode];
}

- (IBAction)pasteTheEvent:(id)sender {
    self.theWalletAddressTextField.text = [[FLTools share]pastingTextFromTheClipboard];
    
}

- (IBAction)pasteDIDFromClipboard:(id)sender {
    self.DIDAddressTextField.text = [[FLTools share]pastingTextFromTheClipboard];
}


- (IBAction)addBuddyEvent:(id)sender {
    self.nickNameTextField.text = [self.nickNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.theWalletAddressTextField.text = [self.theWalletAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.DIDAddressTextField.text = [self.DIDAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.mobilePhoneNOTextField.text = [self.mobilePhoneNOTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.emailTextField.text = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.nickNameTextField.text.length==0) {
        [[FLTools share] showErrorInfo:@"请输入姓名"];
        return;
    }
    if (self.nickNameTextField.text.length > 50) {
        [[FLTools share] showErrorInfo:@"姓名过长"];
        return;
    }
    if (self.theWalletAddressTextField.text.length==0) {
        [[FLTools share] showErrorInfo:@"请输入钱包地址"];
        return;
    }
    
    NSString *masterWalletID = [ELWalletManager share].currentWallet.masterWalletID;
    if (![[ELWalletManager share] IsAddressValidWithMastID:masterWalletID WithAddress:self.theWalletAddressTextField.text]) {
        [[FLTools share] showErrorInfo:@"钱包地址无效"];
        return;
    }
    
    if (self.DIDAddressTextField.text.length > 0) {
        NSString *DIDString = [WYDIDUtils validateDIDString:self.DIDAddressTextField.text];
        if (!DIDString) {
            [[FLTools share] showErrorInfo:@"DID无效"];
            return;
        }
        self.DIDAddressTextField.text = DIDString;
    }
    
    friendsModel *model=[[friendsModel alloc]init];
    
    model.nameString=self.nickNameTextField.text;
    model.address=self.theWalletAddressTextField.text;
    model.did = self.DIDAddressTextField.text;
    model.mobilePhoneNo=self.mobilePhoneNOTextField.text;
    model.email=self.emailTextField.text;
    model.note=self.noteTextField.text;
    
    if (self.contactInfoVC) {
        self.contactInfoVC.model = model;
    }
    
    if (self.model.nameString.length==0) {
        if ([[HMWFMDBManager sharedManagerType:friendsModelType]addRecord:model]){
            [[FLTools share]showErrorInfo:NSLocalizedString(@"添加成功！", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        model.ID=self.model.ID;
        if ([[HMWFMDBManager sharedManagerType:friendsModelType]updateRecord:model]){
            [[FLTools share]showErrorInfo:NSLocalizedString(@"修改成功！", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
-(void)setModel:(friendsModel *)model{
    _model=model;
    
}
@end
