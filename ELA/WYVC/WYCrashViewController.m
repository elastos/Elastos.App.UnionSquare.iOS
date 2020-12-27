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


#import "WYCrashViewController.h"
#import "AppDelegate.h"
#import "FLFLTabBarVC.h"
#import "SSZipArchive.h"
#import "MyUtil.h"

@interface WYCrashViewController ()

@end

@implementation WYCrashViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    UIView *marginTop = [[UIView alloc] init];
    marginTop.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:marginTop];
    
    UIImageView *warningIcon = [[UIImageView alloc] init];
    warningIcon.translatesAutoresizingMaskIntoConstraints = NO;
    warningIcon.image = [UIImage imageNamed:@"warning"];
    [self.view addSubview:warningIcon];
    
    [NSLayoutConstraint activateConstraints:@[
        [marginTop.topAnchor constraintEqualToAnchor:margin.topAnchor],
        [marginTop.heightAnchor constraintEqualToAnchor:margin.heightAnchor multiplier:0.1f],
        [warningIcon.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [warningIcon.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.3f],
        [warningIcon.heightAnchor constraintEqualToAnchor:warningIcon.widthAnchor],
        [warningIcon.topAnchor constraintEqualToAnchor:marginTop.bottomAnchor]
    ]];
    
    UILabel *labelView = [[UILabel alloc] init];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;
    labelView.text = @"很抱歉，由于程序错误导致软件崩溃，是否转发运行日志？";
    labelView.numberOfLines = 0;
    labelView.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightSemibold];
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.textColor = [UIColor whiteColor];
    labelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelView];
    
    [NSLayoutConstraint activateConstraints:@[
        [labelView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [labelView.topAnchor constraintEqualToAnchor:warningIcon.bottomAnchor constant:36.f],
        [labelView.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.8f]
    ]];
    
    UIView *marginLeft = [[UIView alloc] init];
    marginLeft.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:marginLeft];
    
    UIButton *reportButton = [[UIButton alloc] init];
    reportButton.translatesAutoresizingMaskIntoConstraints = NO;
    [reportButton setTitle:@"转发日志" forState:UIControlStateNormal];
    reportButton.backgroundColor = [UIColor blackColor];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
    reportButton.titleLabel.textColor = [UIColor whiteColor];
    reportButton.layer.cornerRadius = 5.f;
    reportButton.layer.masksToBounds = YES;
    reportButton.layer.borderWidth = 1.f;
    [self.view addSubview:reportButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [marginLeft.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.1f],
        [marginLeft.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
        [marginLeft.topAnchor constraintEqualToAnchor:labelView.bottomAnchor constant:60.f],
        [reportButton.topAnchor constraintEqualToAnchor:marginLeft.topAnchor],
        [reportButton.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.35f],
        [reportButton.leadingAnchor constraintEqualToAnchor:marginLeft.trailingAnchor]
    ]];
    
    [reportButton addTarget:self action:@selector(reportPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *marginRight = [[UIView alloc] init];
    marginRight.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:marginRight];
    
    UIButton *continueButton = [[UIButton alloc] init];
    continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [continueButton setTitle:@"进入应用" forState:UIControlStateNormal];
    continueButton.backgroundColor = [UIColor blackColor];
    continueButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
    continueButton.titleLabel.textColor = [UIColor whiteColor];
    continueButton.layer.cornerRadius = 5.f;
    continueButton.layer.masksToBounds = YES;
    continueButton.layer.borderWidth = 1.f;
    [self.view addSubview:continueButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [marginRight.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.1f],
        [marginRight.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor],
        [marginRight.topAnchor constraintEqualToAnchor:marginLeft.topAnchor],
        [continueButton.topAnchor constraintEqualToAnchor:marginLeft.topAnchor],
        [continueButton.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.35f],
        [continueButton.heightAnchor constraintEqualToAnchor:reportButton.heightAnchor],
        [continueButton.trailingAnchor constraintEqualToAnchor:marginRight.leadingAnchor]
    ]];
    
    [continueButton addTarget:self action:@selector(continuePressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reportPressed:(UIButton *)button {
    NSArray *fileNames = @[@"spvsdk.log", LOG_FILE_NAME, @"didsdk.log"];
    NSString *zipName = @"elawalletlogs.zip";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [MyUtil getRootPath];
    NSMutableArray *srcPath = [[NSMutableArray alloc] init];
    for (NSString *fname in fileNames) {
        NSString *testPath = [rootPath stringByAppendingPathComponent:fname];
        if ([fileManager fileExistsAtPath:testPath]) {
            [srcPath addObject:testPath];
        }
    }
    NSString *zipPath = [rootPath stringByAppendingPathComponent:zipName];
    if ([srcPath count] > 0) {
        [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:srcPath];
        NSData *data =[NSData dataWithContentsOfFile:zipPath];
        NSURL *URL =[NSURL fileURLWithPath:zipPath];
//        NSArray *ARR=[NSArray arrayWithObjects:data,@"log",URL,nil];
        NSArray *ARR= @[URL];
        [self mq_share:ARR];
    }
}

-(void)mq_share:(NSArray *)items{
    if (items.count == 0) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityVC.excludedActivityTypes = [self excludetypes];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(NSArray *)excludetypes{
    
    NSMutableArray *excludeTypesM =  [NSMutableArray arrayWithArray:@[//UIActivityTypePostToFacebook,
        UIActivityTypePostToTwitter,
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop,
        UIActivityTypeOpenInIBooks]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        [excludeTypesM addObject:UIActivityTypeMarkupAsPDF];
    }
    
    return excludeTypesM;
}

- (void)continuePressed:(UIButton *)button {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FLFLTabBarVC *tabVC = [[FLFLTabBarVC alloc]init];
    appdelegate.window.rootViewController = tabVC;
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
