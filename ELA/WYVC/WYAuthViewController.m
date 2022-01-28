//
/*
 * Copyright (c) 2022 Gelaxy Team
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


#import "WYAuthViewController.h"
#import "ELAUtils.h"

@interface WYAuthViewController ()

@end

@implementation WYAuthViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    WYLog(@"=== dev temp === vc height is: %f", viewHeight);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_ela_logo_noborder"]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [imageView.topAnchor constraintEqualToAnchor:margin.centerYAnchor constant:-(viewHeight * 0.3f)]
    ]];
    
    UIButton *buttonView = [[UIButton alloc] init];
    buttonView.translatesAutoresizingMaskIntoConstraints = NO;
    [buttonView setTitle:NSLocalizedString(@"重新验证", nil) forState:UIControlStateNormal];
    [buttonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonView.titleLabel.font = PingFangRegular(14);
    [buttonView setBackgroundColor:ELARGB(63, 93, 101)];
    [buttonView.layer setBorderWidth:1.f];
    [buttonView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:buttonView];
    
    
    [NSLayoutConstraint activateConstraints:@[
        [buttonView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [buttonView.topAnchor constraintEqualToAnchor:margin.centerYAnchor constant:(viewHeight * 0.2f)],
        [buttonView.widthAnchor constraintEqualToConstant:250.f],
        [buttonView.heightAnchor constraintEqualToConstant:40.f]
    ]];
    
    [buttonView addTarget:self action:@selector(authPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)authPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
