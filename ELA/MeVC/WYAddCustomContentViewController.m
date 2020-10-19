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


#import "WYAddCustomContentViewController.h"

@interface WYAddCustomContentViewController () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *contentTextView;

@end

@implementation WYAddCustomContentViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentTextView.textColor = [UIColor whiteColor];
    self.contentTextView.font = [UIFont systemFontOfSize:12.f];
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.layer.cornerRadius=5.f;
    self.contentTextView.layer.borderWidth=1.f;
    self.contentTextView.layer.borderColor=RGBA(255, 255, 255, 0.5).CGColor;
    [self.view addSubview:self.contentTextView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contentTextView.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor constant:15.f],
        [self.contentTextView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor constant:-15.f],
        [self.contentTextView.topAnchor constraintEqualToAnchor:margin.topAnchor constant:30.f],
        [self.contentTextView.heightAnchor constraintEqualToConstant:300.f]
    ]];
    
    UIButton *nextButton = [[UIButton alloc] init];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [nextButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [nextButton setBackgroundColor:RGBA(255.f, 255.f, 255.f, 0.2f)];
    [nextButton.layer setBorderWidth:1.f];
    [nextButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:nextButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [nextButton.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor constant:63.f],
        [nextButton.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor constant:-63.f],
        [nextButton.heightAnchor constraintEqualToConstant:40.f],
        [nextButton.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor constant:-140.f]
    ]];
    
    [nextButton addTarget:self action:@selector(nextPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentTextView.returnKeyType = UIReturnKeyDone;
    self.contentTextView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    [self refreshData];
}

- (void)setNextBlock:(void (^)(NSString * _Nonnull))nextBlock {
    _nextBlock = nextBlock;
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
}

- (void)refreshData {
    if (self.contentTextView) {
        self.contentTextView.text = self.contentText;
    }
}

- (void)nextPressed:(id)sender {
    WYLog(@"=== dev temp === content Text: %@", self.contentTextView.text);
    if (self.nextBlock && self.contentTextView) {
        WYLog(@"=== dev temp === textView text: %@", self.contentTextView.text);
        self.nextBlock(self.contentTextView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
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
