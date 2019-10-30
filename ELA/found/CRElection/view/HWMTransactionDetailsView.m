//
//  HWMTransactionDetailsView.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/10/8.
//

#import "HWMTransactionDetailsView.h"
#import "HMWpwdPopupView.h"
@interface HWMTransactionDetailsView ()<HMWpwdPopupViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *theNextStepButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *feeTextLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *amountTextLab;

/*
 *<# #>
 */
@property(strong,nonatomic)HMWpwdPopupView*pwdPopupV;

@end

@implementation HWMTransactionDetailsView
-(instancetype)init{
   
    self =[[NSBundle mainBundle]loadNibNamed:@"HWMTransactionDetailsView" owner:nil options:nil].firstObject;

   
        [[HMWCommView share]makeBordersWithView:self.theNextStepButton];
    self.titleLab.text =NSLocalizedString(@"交易详情", nil);
    [self.theNextStepButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    self.feeTextLab.text=NSLocalizedString(@"手续费", nil);
    self.amountTextLab.text=NSLocalizedString(@"金额", nil);
    return self;
}

- (IBAction)theNextStepEvent:(id)sender {
      [self addSubview:self.pwdPopupV];
      [self.pwdPopupV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.top.bottom.equalTo(self);
      }];
  }
-(void)makeSureWithPWD:(NSString*)pwd{
      if (pwd.length==0) {
          return;
      }
      if (self.delegate) {
          [self.delegate pwdAndInfoWithPWD:pwd];
          [self cancelThePWDPageView];
      }
  }
-(void)cancelThePWDPageView{
    [self.pwdPopupV removeFromSuperview];
    self.pwdPopupV=nil;
  }
-(HMWpwdPopupView *)pwdPopupV{
    if (!_pwdPopupV) {
        _pwdPopupV=[[HMWpwdPopupView alloc]init];
        _pwdPopupV.delegate=self;
    }
    return _pwdPopupV;
    
}
- (IBAction)closeView:(id)sender {
    if (self.delegate) {
        [self.delegate closeTransactionDetailsView];
    }
}
-(void)TransactionDetailsWithFee:(NSString*)fee withTransactionDetailsAumont:(NSString*)aumont{
    if (self.DetailsType==didInfoType) {
        self.feeTextLab.alpha=0.f;
        self.feeLab.alpha=0.f;
        self.amountTextLab.text=NSLocalizedString(@"手续费", nil);
        self.amountLab.text= [NSString stringWithFormat:@"%@ ELA",fee];
    }else{
    self.feeLab.text=[NSString stringWithFormat:@"%@ ELA",fee];
        self.amountLab.text=[NSString stringWithFormat:@"%@ ELA",aumont];
        
    }
    
}
-(void)setPopViewTitle:(NSString *)popViewTitle{
     self.titleLab.text =NSLocalizedString(popViewTitle, nil);
    _popViewTitle=popViewTitle;
    
}
-(void)setDetailsType:(TransactionDetailsType)DetailsType{
    _DetailsType=DetailsType;
    
}
@end