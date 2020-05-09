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


#import "HWMCRsearchViewController.h"

@interface HWMCRsearchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backVC;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation HWMCRsearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    UIView *righView =[[UIView alloc]initWithFrame: CGRectMake(0,0, 34, 34)];
    UIImageView *rightImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 14, 14)];
    rightImageView.image=[UIImage imageNamed:@"cr_search_icon"];
    [righView addSubview:rightImageView];
    self.searchTextField.leftView=righView;
    self.searchTextField.leftViewMode=UITextFieldViewModeAlways;
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.searchTextField withTxt:NSLocalizedString(@"请输入提案号、提案名称或提案人", nil)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (IBAction)searchEvent:(id)sender {
}
- (IBAction)backEV:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
