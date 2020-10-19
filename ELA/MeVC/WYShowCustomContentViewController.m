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


#import "WYShowCustomContentViewController.h"

@interface WYShowCustomContentViewController ()

@property (strong, nonatomic) UITextView *contentTextView;

@end

@implementation WYShowCustomContentViewController

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
    [self.view addSubview:self.contentTextView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contentTextView.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
        [self.contentTextView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor],
        [self.contentTextView.topAnchor constraintEqualToAnchor:margin.topAnchor],
        [self.contentTextView.heightAnchor constraintEqualToConstant:300.f]
    ]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    [self refreshData];
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
}

- (void)refreshData {
    if (self.contentTextView) {
        self.contentTextView.text = self.contentText;
    }
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
