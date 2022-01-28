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


#import "WYVoteDetailsListViewCellType1.h"
#import "FLCoinPointInfoModel.h"
#import "HWMCRListModel.h"

@interface WYVoteDetailsListViewCellType1 ()

@property (strong, nonatomic) NSLayoutConstraint *cellWidth;

@property (strong, nonatomic) UILabel *cellTitle;
@property (strong, nonatomic) UILabel *cellContent;

@end

@implementation WYVoteDetailsListViewCellType1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.cellWidth = [self.widthAnchor constraintEqualToConstant:0.f];
        
        self.backgroundColor = [UIColor clearColor];
        
        UILayoutGuide *margin = self.layoutMarginsGuide;
        
        self.cellTitle = [[UILabel alloc] init];
        self.cellTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellTitle.font = [UIFont systemFontOfSize:12.f];
        self.cellTitle.text = @"--";
        self.cellTitle.textColor = [UIColor whiteColor];
        self.cellTitle.backgroundColor = [UIColor clearColor];
        self.cellTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.cellTitle.numberOfLines = 0;
        [self addSubview:self.cellTitle];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.cellTitle.topAnchor constraintEqualToAnchor:margin.topAnchor constant:5.f],
            [self.cellTitle.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
            [self.cellTitle.widthAnchor constraintGreaterThanOrEqualToConstant:100.f],
            [self.cellTitle.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor constant:-5.f]
        ]];
        
        self.cellContent = [[UILabel alloc] init];
        self.cellContent.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellContent.font = [UIFont systemFontOfSize:12.f];
        self.cellContent.text = @"--";
        self.cellContent.textAlignment = NSTextAlignmentRight;
        self.cellContent.textColor = [UIColor whiteColor];
        self.cellContent.backgroundColor = [UIColor clearColor];
        self.cellContent.lineBreakMode = NSLineBreakByTruncatingTail;
        self.cellContent.numberOfLines = 0;
        [self addSubview:self.cellContent];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.cellContent.topAnchor constraintEqualToAnchor:margin.topAnchor constant:5.f],
            [self.cellContent.leadingAnchor constraintEqualToAnchor:self.cellTitle.trailingAnchor constant:30.f],
            [self.cellContent.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.25f],
            [self.cellContent.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor],
            [self.cellContent.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor constant:-5.f]
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
    NSString *cellType = self.listCellData[@"type"];
    NSObject *valid = self.listCellData[@"valid"];
    if ([cellType isEqualToString:@"Delegate"]) {
        if ([valid isEqual:@YES]) {
            FLCoinPointInfoModel *info = self.listCellData[@"info"];
            self.cellTitle.text = info.nickname;
            self.cellContent.text = [NSString stringWithFormat:@"No.%ld", (info.index + 1)];
        } else {
            self.cellTitle.text = NSLocalizedString(@"候选节点已失效", nil);
            self.cellTitle.alpha = 0.5f;
            self.cellContent.text = @"--";
            self.cellContent.alpha = 0.5f;
        }
    } else if ([cellType isEqualToString:@"CRC"]) {
        HWMCRListModel *info = self.listCellData[@"info"];
        NSInteger votes = [info.SinceVotes intValue];
        if (votes < 1) {
            self.cellContent.text = [NSString stringWithFormat:@"<1 %@", NSLocalizedString(@"票", nil)];
        } else {
            self.cellContent.text = [NSString stringWithFormat:@"%ld %@", votes, NSLocalizedString(@"票", nil)];
        }
        if ([valid isEqual:@YES]) {
            self.cellTitle.text = [NSString stringWithFormat:@"No.%@ %@", info.index, info.nickname];
        } else {
            self.cellTitle.text = NSLocalizedString(@"候选节点已失效", nil);
            self.cellTitle.alpha = 0.5f;
            self.cellContent.alpha = 0.5f;
        }
    }
}

@end
