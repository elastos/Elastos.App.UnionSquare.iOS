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


#import "WYFinalNoteViewController.h"
#import "ELAUtils.h"

@interface TickBox : UIButton
@property (nonatomic, assign) BOOL isChecked;

@end
@implementation TickBox

- (id)init
{
    self = [super init];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:ImageNamed(@"authorization_empty") forState:(UIControlStateNormal)];
        [self setImage:ImageNamed(@"authorization_selected") forState:(UIControlStateSelected)];
    }
    return self;
}
- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;

    [self setSelected:_isChecked];

}

@end

@interface WYFinalNoteViewController ()

@property(strong, nonatomic) TickBox *tickBox;

@end

@implementation WYFinalNoteViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    UIView *popupView = [[UIView alloc] init];
    popupView.translatesAutoresizingMaskIntoConstraints = NO;
    popupView.backgroundColor = RGB(42.f, 42.f, 42.f);
    [self.view addSubview:popupView];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [closeBtn setImage:ImageNamed(@"window_54_close") forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.userInteractionEnabled = YES;
    [popupView addSubview:closeBtn];
    
    UITextView *titleTextView = [[UITextView alloc] init];
    titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    titleTextView.backgroundColor = [UIColor clearColor];
    titleTextView.textColor = [UIColor whiteColor];
    titleTextView.font = [UIFont systemFontOfSize:14.f];
    titleTextView.textAlignment = NSTextAlignmentCenter;
    titleTextView.text = NSLocalizedString(@"当前版本是Ela Wallet v1.5.0版，本版仅保留亦来云主链的资产管理功能，更多功能请使用 Essentials App", nil);
    titleTextView.userInteractionEnabled = YES;
    titleTextView.editable = NO;
    [popupView addSubview:titleTextView];
    
    UIView *spacer1 = [[UIView alloc] init];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    spacer1.backgroundColor = [UIColor clearColor];
    [popupView addSubview:spacer1];
    
    self.tickBox = [[TickBox alloc] init];
    self.tickBox.translatesAutoresizingMaskIntoConstraints = NO;
    [popupView addSubview:self.tickBox];
    
    UILabel *tickLabel = [[UILabel alloc] init];
    tickLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tickLabel.backgroundColor = [UIColor clearColor];
    tickLabel.textColor = [UIColor whiteColor];
    tickLabel.font = [UIFont systemFontOfSize:12.f];
    tickLabel.textAlignment = NSTextAlignmentNatural;
    tickLabel.text = NSLocalizedString(@"不再提示", nil);
    [popupView addSubview:tickLabel];
    
    UIView *spacer2 = [[UIView alloc] init];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    spacer2.backgroundColor = [UIColor clearColor];
    [popupView addSubview:spacer2];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    confirmBtn.backgroundColor = RGB(103.f, 135.f, 136.f);
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn setTitle:NSLocalizedString(@"我知道了", nil) forState:UIControlStateNormal];
    [popupView addSubview:confirmBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [popupView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [popupView.centerYAnchor constraintEqualToAnchor:margin.centerYAnchor],
        [popupView.widthAnchor constraintEqualToConstant:290.f],
        [popupView.heightAnchor constraintEqualToConstant:232.f]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.topAnchor constraintEqualToAnchor:popupView.topAnchor],
        [closeBtn.rightAnchor constraintEqualToAnchor:popupView.rightAnchor],
        [closeBtn.widthAnchor constraintEqualToConstant:45.f],
        [closeBtn.heightAnchor constraintEqualToConstant:45.f]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleTextView.topAnchor constraintEqualToAnchor:closeBtn.bottomAnchor],
        [titleTextView.centerXAnchor constraintEqualToAnchor:popupView.centerXAnchor],
        [titleTextView.widthAnchor constraintEqualToAnchor:popupView.widthAnchor multiplier:0.85f],
        [titleTextView.bottomAnchor constraintEqualToAnchor:self.tickBox.topAnchor constant:-10.f]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [spacer1.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor],
        [spacer1.trailingAnchor constraintEqualToAnchor:self.tickBox.leadingAnchor],
        [self.tickBox.trailingAnchor constraintEqualToAnchor:tickLabel.leadingAnchor constant:-5.f],
        [tickLabel.trailingAnchor constraintEqualToAnchor:spacer2.leadingAnchor],
        [spacer2.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor],
        [spacer1.widthAnchor constraintEqualToAnchor:spacer2.widthAnchor],
        [self.tickBox.bottomAnchor constraintEqualToAnchor:confirmBtn.topAnchor constant:-20.f],
        [tickLabel.centerYAnchor constraintEqualToAnchor:self.tickBox.centerYAnchor],
        [spacer1.centerYAnchor constraintEqualToAnchor:self.tickBox.centerYAnchor],
        [spacer2.centerYAnchor constraintEqualToAnchor:self.tickBox.centerYAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [confirmBtn.leadingAnchor constraintEqualToAnchor:popupView.leadingAnchor],
        [confirmBtn.trailingAnchor constraintEqualToAnchor:popupView.trailingAnchor],
        [confirmBtn.bottomAnchor constraintEqualToAnchor:popupView.bottomAnchor],
        [confirmBtn.heightAnchor constraintEqualToConstant:50.f]
    ]];
    
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tickBox addTarget:self action:@selector(tickBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)tickBoxAction:(TickBox *)sender {
    sender.isChecked = !sender.isChecked;
}

- (void)confirmBtnAction:(UIButton *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:self.tickBox.isChecked forKey:@"noteOff"];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackgroundImg:@""];
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
