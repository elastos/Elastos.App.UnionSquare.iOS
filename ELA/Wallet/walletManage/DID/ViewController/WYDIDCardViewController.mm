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


#import "WYDIDCardViewController.h"
#import "ELWalletManager.h"

@interface WYDIDCardViewController ()

@property (strong, nonatomic) UIImageView *qrCardView;
@property (strong, nonatomic) UIView *infoCardView;
@property (strong, nonatomic) UILabel *didNameLabel;
@property (strong, nonatomic) UIButton *includeAddressButton;
@property (assign, nonatomic) BOOL includeAddress;
@property (strong, nonatomic) NSString *walletAddress;

@end

@implementation WYDIDCardViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    self.infoCardView = [[UIView alloc] init];
    self.infoCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoCardView.backgroundColor = RGBA(83.f, 132.f, 136.f, 1.f);
    self.infoCardView.layer.masksToBounds = YES;
    self.infoCardView.layer.cornerRadius = 12.f;
    [self.view addSubview:self.infoCardView];
    
    self.didNameLabel = [[UILabel alloc] init];
    self.didNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.didNameLabel.textColor = [UIColor whiteColor];
    self.didNameLabel.backgroundColor = [UIColor clearColor];
    self.didNameLabel.text = @"--";
    self.didNameLabel.font = [UIFont systemFontOfSize:16.f];
    [self.infoCardView addSubview:self.didNameLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.didNameLabel.centerYAnchor constraintEqualToAnchor:self.infoCardView.topAnchor constant:33.f],
        [self.didNameLabel.centerXAnchor constraintEqualToAnchor:self.infoCardView.centerXAnchor],
        [self.didNameLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.infoCardView.widthAnchor multiplier:0.9f],
        [self.didNameLabel.heightAnchor constraintLessThanOrEqualToConstant:50.f]
    ]];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = [NSString stringWithFormat:@"- %@ -", NSLocalizedString(@"扫码查看DID信息", nil)];
    tipLabel.font = [UIFont systemFontOfSize:10.f];
    [self.infoCardView addSubview:tipLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [tipLabel.centerYAnchor constraintEqualToAnchor:self.infoCardView.bottomAnchor constant:-18.f],
        [tipLabel.centerXAnchor constraintEqualToAnchor:self.infoCardView.centerXAnchor]
    ]];
    
    UIView *includeAddressPanel = [[UIView alloc] init];
    includeAddressPanel.translatesAutoresizingMaskIntoConstraints = NO;
    includeAddressPanel.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.3f);
    includeAddressPanel.layer.masksToBounds = YES;
    includeAddressPanel.layer.cornerRadius = 18.f;
    [self.view addSubview:includeAddressPanel];
    
    [NSLayoutConstraint activateConstraints:@[
        [includeAddressPanel.topAnchor constraintEqualToAnchor:self.infoCardView.bottomAnchor constant:36.f],
        [includeAddressPanel.centerXAnchor constraintEqualToAnchor:self.infoCardView.centerXAnchor],
        [includeAddressPanel.heightAnchor constraintEqualToConstant:36.f]
    ]];
    
    UIButton* includeAddressTitle = [[UIButton alloc] init];
    includeAddressTitle.translatesAutoresizingMaskIntoConstraints = NO;
    includeAddressTitle.backgroundColor = [UIColor clearColor];
    [includeAddressTitle setTitle:NSLocalizedString(@"包含收款地址", nil) forState:UIControlStateNormal];
    [includeAddressTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    includeAddressTitle.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [includeAddressTitle addTarget:self action:@selector(includeAddressPressed:) forControlEvents:UIControlEventTouchUpInside];
    [includeAddressPanel addSubview:includeAddressTitle];
    
    self.includeAddressButton = [[UIButton alloc] init];
    self.includeAddressButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.includeAddressButton.backgroundColor = [UIColor whiteColor];
    [self.includeAddressButton setImage:[UIImage imageNamed:@"asset_option_unchecked"] forState:UIControlStateNormal];
    [self.includeAddressButton setImage:[UIImage imageNamed:@"asset_option_checked"] forState:UIControlStateSelected];
//    [self.includeAddressButton setImage:[UIImage imageNamed:@"asset_option_checked"] forState:UIControlStateHighlighted];
//    self.includeAddressButton.adjustsImageWhenHighlighted = YES;
    self.includeAddressButton.layer.masksToBounds = YES;
    self.includeAddressButton.layer.cornerRadius = 3.f;
    self.includeAddress = NO;
    [self.includeAddressButton addTarget:self action:@selector(includeAddressPressed:) forControlEvents:UIControlEventTouchUpInside];
    [includeAddressPanel addSubview:self.includeAddressButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.includeAddressButton.centerYAnchor constraintEqualToAnchor:includeAddressPanel.centerYAnchor],
        [self.includeAddressButton.leadingAnchor constraintEqualToAnchor:includeAddressPanel.leadingAnchor constant:16.f],
        [self.includeAddressButton.widthAnchor constraintEqualToConstant:16.f],
        [self.includeAddressButton.heightAnchor constraintEqualToAnchor:self.includeAddressButton.widthAnchor],
        
        [includeAddressTitle.centerYAnchor constraintEqualToAnchor:includeAddressPanel.centerYAnchor],
        [includeAddressTitle.leadingAnchor constraintEqualToAnchor:self.includeAddressButton.trailingAnchor constant:10.f],
        [includeAddressTitle.trailingAnchor constraintEqualToAnchor:includeAddressPanel.trailingAnchor constant:-16.f]
    ]];
    
    UIButton *shareButton = [[UIButton alloc] init];
    shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    shareButton.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.3f);
    [shareButton setImage:[UIImage imageNamed:@"top_share"] forState:UIControlStateNormal];
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.cornerRadius = 18.f;
    [shareButton addTarget:self action:@selector(shareCardPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [shareButton.topAnchor constraintEqualToAnchor:includeAddressPanel.bottomAnchor constant:42.f],
        [shareButton.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [shareButton.widthAnchor constraintEqualToConstant:36.f],
        [shareButton.heightAnchor constraintEqualToAnchor:shareButton.widthAnchor]
    ]];
    
    UIView *qrPanelView = [[UIView alloc] init];
    qrPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    qrPanelView.backgroundColor = [UIColor whiteColor];
    qrPanelView.layer.masksToBounds = YES;
    qrPanelView.layer.cornerRadius = 8.f;
    [self.infoCardView addSubview:qrPanelView];
    
    [NSLayoutConstraint activateConstraints:@[
        [qrPanelView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [qrPanelView.centerYAnchor constraintEqualToAnchor:margin.centerYAnchor constant:-60.f],
        [qrPanelView.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.7f],
        [qrPanelView.heightAnchor constraintEqualToAnchor:qrPanelView.widthAnchor],
        
        [self.infoCardView.topAnchor constraintEqualToAnchor:qrPanelView.topAnchor constant:-66.f],
        [self.infoCardView.bottomAnchor constraintEqualToAnchor:qrPanelView.bottomAnchor constant:36.f],
        [self.infoCardView.centerXAnchor constraintEqualToAnchor:qrPanelView.centerXAnchor],
        [self.infoCardView.widthAnchor constraintEqualToAnchor:qrPanelView.widthAnchor constant:30.f]
    ]];
    
    self.qrCardView = [[UIImageView alloc] init];
    self.qrCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.qrCardView.backgroundColor = [UIColor whiteColor];
    [qrPanelView addSubview:self.qrCardView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.qrCardView.centerXAnchor constraintEqualToAnchor:qrPanelView.centerXAnchor],
        [self.qrCardView.centerYAnchor constraintEqualToAnchor:qrPanelView.centerYAnchor],
        [self.qrCardView.widthAnchor constraintEqualToAnchor:qrPanelView.widthAnchor constant:-10.f],
        [self.qrCardView.heightAnchor constraintEqualToAnchor:self.qrCardView.widthAnchor]
    ]];
    
    UIView *overlayView = [[UIView alloc] init];
    overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    overlayView.backgroundColor = [UIColor whiteColor];
    overlayView.layer.masksToBounds = YES;
    overlayView.layer.cornerRadius = 5.f;
    [self.qrCardView addSubview:overlayView];
    
    [NSLayoutConstraint activateConstraints:@[
        [overlayView.centerXAnchor constraintEqualToAnchor:self.qrCardView.centerXAnchor],
        [overlayView.centerYAnchor constraintEqualToAnchor:self.qrCardView.centerYAnchor],
        [overlayView.widthAnchor constraintEqualToAnchor:self.qrCardView.widthAnchor multiplier:0.25f],
        [overlayView.heightAnchor constraintEqualToAnchor:self.qrCardView.heightAnchor multiplier:0.25f]
    ]];
    
    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    overlayImage.translatesAutoresizingMaskIntoConstraints = NO;
    overlayImage.backgroundColor = [UIColor whiteColor];
    overlayImage.layer.masksToBounds = YES;
    overlayImage.layer.cornerRadius = 5.f;
    [overlayView addSubview:overlayImage];
    
    [NSLayoutConstraint activateConstraints:@[
        [overlayImage.centerXAnchor constraintEqualToAnchor:overlayView.centerXAnchor],
        [overlayImage.centerYAnchor constraintEqualToAnchor:overlayView.centerYAnchor],
        [overlayImage.widthAnchor constraintEqualToAnchor:overlayView.widthAnchor constant:-5.f],
        [overlayImage.heightAnchor constraintEqualToAnchor:overlayView.heightAnchor constant:-5.f]
    ]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    
    self.title = NSLocalizedString(@"DID名片", nil);
    self.didNameLabel.text = self.didName;
    
    invokedUrlCommand *mommand=[[invokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID, @"ELA"] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"createAddress"];
    
    PluginResult * result =[[ELWalletManager share]createAddress:mommand];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if ([status isEqualToString:@"1"]) {
        self.walletAddress = [NSString stringWithFormat:@"%@",result.message[@"success"]];
        WYLog(@"=== dev temp === currentWalletAddress: %@", self.walletAddress);
        [self refreshQRCode];
    } else {
        [[FLTools share] showErrorInfo:@"获取钱包地址错误"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)includeAddressPressed:(id)sender {
    self.includeAddress = !self.includeAddress;
    [self.includeAddressButton setSelected:self.includeAddress];
    [self refreshQRCode];
}

- (void)shareCardPressed:(id)sender {
    UIImage *cardImg = [WYUtils viewToImage:self.infoCardView];
    [WYUtils shareItems:@[cardImg] onVC:self];
}

- (void)refreshQRCode {
    NSMutableDictionary *qrDataDict = [[NSMutableDictionary alloc] init];
    qrDataDict[@"didString"] = self.didString;
    if (self.includeAddress) {
        qrDataDict[@"address"] = self.walletAddress;
    }
    NSMutableDictionary *qrDict = [@{
        @"data": qrDataDict,
        @"extra": @{
            @"subWallet": @"ELA",
            @"transType": @(-1),
            @"type": @(5)
        },
        @"index": @(1),
        @"total": @(1),
        @"name": @"MultiQrContent",
        @"version": @(0)
    } mutableCopy];
    NSString *qrString = [WYUtils dicToJSONString:qrDict];
    self.qrCardView.image = [[FLTools share] imageWithSize:300.f andColorWithRed:3.f Green:3.f Blue:5.f andQRString:qrString];
}

- (void)setDidName:(NSString *)didName {
    _didName = didName;
}

- (void)setDidString:(NSString *)didString {
    _didString = didString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
