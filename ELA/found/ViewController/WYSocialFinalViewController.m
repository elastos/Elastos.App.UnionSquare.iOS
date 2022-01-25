//
/*
 * Copyright (c) 2022 Elastos Foundation
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


#import "WYSocialFinalViewController.h"

@interface WYSocialFinalViewController ()

@end

@implementation WYSocialFinalViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    contentTextView.textColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:14.f];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.text = NSLocalizedString(@"ELA Wallet 是专注于支持亦来云生态数字资产安全、便捷的 SPV 轻节点客户端钱包。当前，ELA Wallet Android 和 IOS v1.5.0版本钱包已发布。此次更新修复了钱包同步过程中可能出现闪退的问题。\n\n同时，为整合资源，以为用户提供更友好的服务，Elastos Essentials作为亦来云生态系统的旗舰级钱包，将会在亦来云 CR 社区、DPoS 选举及 DID 等功能方面提供更加优质的体验，并将继续在集成亦来云核心技术及完善功能和服务等方面深耕。ELA Wallet 在此次更新后将仅保留基础转账功能，技术支持将于2022年Q1结束截止，建议 ELA Wallet 用户尽快迁移至Elastos Essentials。", nil);
    contentTextView.userInteractionEnabled = YES;
    contentTextView.editable = NO;
    [self.view addSubview:contentTextView];
    
    UIButton *nextButton = [[UIButton alloc] init];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [nextButton setTitle:NSLocalizedString(@"下载并安装/启动 Essentials APP", nil) forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [nextButton setBackgroundColor:[UIColor clearColor]];
    nextButton.layer.cornerRadius = 5.f;
    nextButton.layer.masksToBounds = YES;
    [nextButton.layer setBorderWidth:1.f];
    [nextButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:nextButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [contentTextView.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor constant:16.f],
        [contentTextView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor constant:-16.f],
        [contentTextView.topAnchor constraintEqualToAnchor:margin.topAnchor constant:26.f],
        [contentTextView.bottomAnchor constraintEqualToAnchor:nextButton.topAnchor constant:-36.f]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [nextButton.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor constant:26.f],
        [nextButton.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor constant:-26.f],
        [nextButton.heightAnchor constraintEqualToConstant:40.f],
        [nextButton.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor constant:-100.f]
    ]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title=NSLocalizedString(@"社区", nil);
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
