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


#import "WYVoteDetailsListViewCellType2.h"
#import "WYVoteUtils.h"
#import "ELACouncilAndSecretariatModel.h"

@interface WYVoteDetailsListViewCellType2 ()

@property (strong, nonatomic) NSLayoutConstraint *cellWidth;

@property (strong, nonatomic) UILabel *cellTitle;
@property (strong, nonatomic) UILabel *expireInfo;
@property (strong, nonatomic) UIButton *invalidButton;
@property (strong, nonatomic) UILabel *amountInfo;
@property (strong, nonatomic) UILabel *progressInfo;
@property (strong, nonatomic) UILabel *amountTitle;
@property (strong, nonatomic) UILabel *progressTitle;


@end

@implementation WYVoteDetailsListViewCellType2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.cellWidth = [self.widthAnchor constraintEqualToConstant:0.f];
        
        self.backgroundColor = [UIColor clearColor];
        
        UILayoutGuide *margin = self.layoutMarginsGuide;
        
        UIView *containerView = [[UIView alloc] init];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        containerView.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
        containerView.layer.masksToBounds = YES;
        containerView.layer.cornerRadius = 5.f;
        [self addSubview:containerView];
        
        [NSLayoutConstraint activateConstraints:@[
            [containerView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [containerView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor constant:-6.f],
            [containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        
        UILayoutGuide *containerMargin = containerView.layoutMarginsGuide;
        
        self.cellTitle = [[UILabel alloc] init];
        self.cellTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellTitle.font = [UIFont systemFontOfSize:14.f];
        self.cellTitle.text = @"--";
        self.cellTitle.textColor = [UIColor whiteColor];
        self.cellTitle.backgroundColor = [UIColor clearColor];
        self.cellTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.cellTitle.numberOfLines = 0;
        [containerView addSubview:self.cellTitle];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.cellTitle.topAnchor constraintEqualToAnchor:containerMargin.topAnchor],
            [self.cellTitle.leadingAnchor constraintEqualToAnchor:containerMargin.leadingAnchor],
            [self.cellTitle.widthAnchor constraintLessThanOrEqualToAnchor:containerMargin.widthAnchor]
        ]];
        
        self.expireInfo = [[UILabel alloc] init];
        self.expireInfo.translatesAutoresizingMaskIntoConstraints = NO;
        self.expireInfo.font = [UIFont systemFontOfSize:12.f];
        self.expireInfo.text = @"--";
        self.expireInfo.textColor = RGBA(255.f, 255.f, 255.f, 0.5f);
        self.expireInfo.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.expireInfo];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.expireInfo.topAnchor constraintEqualToAnchor:self.cellTitle.bottomAnchor constant:5.f],
            [self.expireInfo.leadingAnchor constraintEqualToAnchor:containerMargin.leadingAnchor]
        ]];
        
        self.invalidButton = [[UIButton alloc] init];
        self.invalidButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.invalidButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.invalidButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.invalidButton.titleLabel.minimumScaleFactor = 0.5f;
        [self.invalidButton setTitle:NSLocalizedString(@"已失效", nil) forState:UIControlStateNormal];
        [self.invalidButton setTitleColor:RGBA(255.f, 255.f, 255.f, 0.5f) forState:UIControlStateNormal];
        self.invalidButton.backgroundColor = [UIColor clearColor];
        self.invalidButton.layer.borderColor = RGBA(255.f, 255.f, 255.f, 0.5f).CGColor;
        self.invalidButton.layer.borderWidth = 1.f;
        self.invalidButton.layer.cornerRadius = 5.f;
        self.invalidButton.layer.masksToBounds = YES;
        self.invalidButton.contentEdgeInsets = UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f);
        self.invalidButton.userInteractionEnabled = NO;
        self.invalidButton.alpha = 0.f;
        [containerView addSubview:self.invalidButton];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.invalidButton.topAnchor constraintEqualToAnchor:self.cellTitle.bottomAnchor constant:5.f],
            [self.invalidButton.leadingAnchor constraintEqualToAnchor:containerMargin.leadingAnchor]
        ]];
        
        self.amountTitle = [[UILabel alloc] init];
        self.amountTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.amountTitle.font = [UIFont systemFontOfSize:12.f];
        self.amountTitle.adjustsFontSizeToFitWidth = YES;
        self.amountTitle.minimumScaleFactor = 0.5f;
        self.amountTitle.text = @"--";
        self.amountTitle.textColor = RGBA(255.f, 255.f, 255.f, 0.5f);
        self.amountTitle.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.amountTitle];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.amountTitle.bottomAnchor constraintEqualToAnchor:containerMargin.bottomAnchor],
            [self.amountTitle.leadingAnchor constraintEqualToAnchor:containerMargin.leadingAnchor],
            [self.amountTitle.widthAnchor constraintEqualToAnchor:containerMargin.widthAnchor multiplier:0.5f]
        ]];
        
        self.progressTitle = [[UILabel alloc] init];
        self.progressTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressTitle.font = [UIFont systemFontOfSize:12.f];
        self.progressTitle.adjustsFontSizeToFitWidth = YES;
        self.progressTitle.minimumScaleFactor = 0.5f;
        self.progressTitle.textAlignment = NSTextAlignmentRight;
        self.progressTitle.text = @"--";
        self.progressTitle.textColor = RGBA(255.f, 255.f, 255.f, 0.5f);
        self.progressTitle.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.progressTitle];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.progressTitle.bottomAnchor constraintEqualToAnchor:containerMargin.bottomAnchor],
            [self.progressTitle.leadingAnchor constraintEqualToAnchor:self.amountTitle.trailingAnchor],
            [self.progressTitle.trailingAnchor constraintEqualToAnchor:containerMargin.trailingAnchor]
        ]];
        
        self.amountInfo = [[UILabel alloc] init];
        self.amountInfo.translatesAutoresizingMaskIntoConstraints = NO;
        self.amountInfo.font = [UIFont systemFontOfSize:14.f];
        self.amountInfo.text = @"--";
        self.amountInfo.textColor = [UIColor whiteColor];
        self.amountInfo.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.amountInfo];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.amountInfo.topAnchor constraintGreaterThanOrEqualToAnchor:self.expireInfo.bottomAnchor constant:20.f],
            [self.amountInfo.topAnchor constraintGreaterThanOrEqualToAnchor:self.invalidButton.bottomAnchor constant:20.f],
            [self.amountInfo.bottomAnchor constraintEqualToAnchor:self.amountTitle.topAnchor constant:-5.f],
            [self.amountInfo.leadingAnchor constraintEqualToAnchor:self.amountTitle.leadingAnchor],
            [self.amountInfo.trailingAnchor constraintEqualToAnchor:self.amountTitle.trailingAnchor]
        ]];
        
        self.progressInfo = [[UILabel alloc] init];
        self.progressInfo.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressInfo.font = [UIFont systemFontOfSize:14.f];
        self.progressInfo.textAlignment = NSTextAlignmentRight;
        self.progressInfo.text = @"--";
        self.progressInfo.textColor = [UIColor whiteColor];
        self.progressInfo.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.progressInfo];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.progressInfo.topAnchor constraintGreaterThanOrEqualToAnchor:self.expireInfo.bottomAnchor constant:20.f],
            [self.progressInfo.topAnchor constraintGreaterThanOrEqualToAnchor:self.invalidButton.bottomAnchor constant:20.f],
            [self.progressInfo.bottomAnchor constraintEqualToAnchor:self.progressTitle.topAnchor constant:-5.f],
            [self.progressInfo.leadingAnchor constraintEqualToAnchor:self.progressTitle.leadingAnchor],
            [self.progressInfo.trailingAnchor constraintEqualToAnchor:self.progressTitle.trailingAnchor]
        ]];
    }
    return self;
}

- (void)reloadWidth:(CGFloat)width {
    self.cellWidth.active = NO;
    self.cellWidth.constant = width;
    self.cellWidth.active = YES;
}

- (void)reloadData {
    NSString *address = self.listCellData[@"address"];
    NSString *cellType = self.listCellData[@"type"];
    NSObject *valid = self.listCellData[@"valid"];
    
    if ([valid isEqual:@NO]) {
        self.invalidButton.alpha = 1.f;
        self.expireInfo.alpha = 0.f;
        [self.expireInfo.heightAnchor constraintEqualToConstant:0.f].active = YES;
    } else {
        self.invalidButton.alpha = 0.f;
        [self.invalidButton.heightAnchor constraintEqualToConstant:0.f].active = YES;
        self.expireInfo.alpha = 1.f;
    }
    
    //    self.amountInfo.text = [[FLTools share] elaScaleConversionWith:amount];
    
    if ([cellType isEqualToString:@"CRCProposal"]) {
        NSDictionary *info = self.listCellData[@"info"];
        self.amountTitle.text = [NSString stringWithFormat:@"%@(ELA)", NSLocalizedString(@"反对票数", nil)];
        self.progressTitle.text = NSLocalizedString(@"反对进度", nil);
        
        if (info) {
            WYLog(@"=== dev temp === Proposal Cell Info: %@", info);
            
            self.cellTitle.text = info[@"title"];
            
            if (info[@"voteEndsIn"]) {
                self.expireInfo.text = [[FLTools share] RemainingTimeFormatting:info[@"voteEndsIn"]];
            }
            
            if (info[@"rejectAmount"]) {
                self.amountInfo.text = [NSString stringWithFormat:@"%@", info[@"rejectAmount"]];
            }
            
            if (info[@"rejectRatio"]) {
                self.progressInfo.text = [NSString stringWithFormat:@"%.2f%%", [info[@"rejectRatio"] floatValue] * 100.f];
            }
        }
        
//        if ([valid isEqual:@YES]) {
//
//            dispatch_async([WYUtils getSerialQueue], ^{
//
//                HWMDetailsProposalModel *details = [WYVoteUtils getProposalDetails:address];
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    if ([valid isEqual:@YES]) {
//                        self.expireInfo.text = details.duration;
//                    }
//                    if (details.rejectAmount) {
//                        self.amountInfo.text = details.rejectAmount;
//                    }
//                    if (details) {
//                        self.progressInfo.text = [NSString stringWithFormat:@"%.2f%%", details.rejectRatio * 100.f];
//                    }
//
//                });
//
//            });
//
//        }
        
    } else if ([cellType isEqualToString:@"CRCImpeachment"]) {
        ELACouncilModel *info = self.listCellData[@"info"];
        if ([valid isEqual:@YES]) {
            self.expireInfo.alpha = 0.f;
            [self.expireInfo.heightAnchor constraintEqualToConstant:0.f].active = YES;
        }
        self.amountTitle.text = [NSString stringWithFormat:@"%@(ELA)", NSLocalizedString(@"弹劾票数", nil)];
        self.progressTitle.text = NSLocalizedString(@"弹劾进度", nil);
        
        if (info) {
            self.cellTitle.text = info.didName;
            
            WYLog(@"=== dev temp === Council Cell impeachmentVotes: %@", info.impeachmentVotes);
            WYLog(@"=== dev temp === Council Cell rejectRatio: %@", info.rejectRatio);
            
            if (info.impeachmentVotes) {
                self.amountInfo.text = [NSString stringWithFormat:@"%ld", [info.impeachmentVotes integerValue]];
            }
            
            if (info.rejectRatio) {
                self.progressInfo.text = [NSString stringWithFormat:@"%.2f%%", [info.rejectRatio floatValue] * 100.f];
            }
            
//            if ([valid isEqual:@YES]) {
//
//                dispatch_async([WYUtils getSerialQueue], ^{
//
//                    ELAInformationDetail *details = [WYVoteUtils getCouncilDetails:info.did];
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (details) {
//                            self.amountInfo.text = [NSString stringWithFormat:@"%ld", lround(details.impeachmentVotes)];
//                            self.progressInfo.text = [NSString stringWithFormat:@"%.2f%%", details.impeachmentRatio * 100.f];
//                        }
//
//                    });
//
//                });
//
//            }
            
        }
    }
    
}

@end
