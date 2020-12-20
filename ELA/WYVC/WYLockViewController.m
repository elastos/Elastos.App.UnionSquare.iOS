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


#import "WYLockViewController.h"
#import "WYAuthViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface WYLockViewController ()

@end

@implementation WYLockViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)authPressed:(UIButton *)sender {
    [self systemAuth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImg:@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self systemAuth];
}

- (void)systemAuth {
    LAContext *authContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *authLocalizedReasonString = NSLocalizedString(@"安全验证", nil);
    if ([authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
        [authContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                    localizedReason:authLocalizedReasonString
                              reply:^(BOOL success, NSError *error) {
            if (success) {
                WYLog(@"=== Auth Success ===");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 0), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:nil];
                });
            } else {
                WYLog(@"=== Auth Failed === : %@", error.localizedDescription);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 0), dispatch_get_main_queue(), ^{
                    WYAuthViewController *authVC = [[WYAuthViewController alloc] init];
                    authVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:authVC animated:NO completion:nil];
                });
            }
        }];
    } else {
        WYLog(@"=== Cannot Auth === : %@", authError.localizedDescription);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:NO forKey:@"authOn"];
        [[FLTools share] showErrorInfo:NSLocalizedString(@"未设置系统锁屏密码", nil)];
        [self dismissViewControllerAnimated:NO completion:nil];
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
