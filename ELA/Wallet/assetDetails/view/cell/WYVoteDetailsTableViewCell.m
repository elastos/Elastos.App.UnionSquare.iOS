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


#import "WYVoteDetailsTableViewCell.h"

@interface WYVoteDetailsTableViewCell ()

@end

@implementation WYVoteDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILayoutGuide *margin = self.layoutMarginsGuide;
        
        self.cellTitle = [[UILabel alloc] init];
        self.cellTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellTitle.textAlignment = NSTextAlignmentLeft;
        self.cellTitle.font = [UIFont systemFontOfSize:14.f];
        self.cellTitle.adjustsFontSizeToFitWidth = YES;
        self.cellTitle.minimumScaleFactor = 0.5f;
        self.cellTitle.text = @"--";
        self.cellTitle.textColor = RGBA(255.f, 255.f, 255.f, 0.5f);
        self.cellTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellTitle];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.cellTitle.topAnchor constraintEqualToAnchor:margin.topAnchor],
            [self.cellTitle.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
            [self.cellTitle.widthAnchor constraintEqualToConstant:95.f],
            [self.cellTitle.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor]
        ]];
        
        self.cellContent = [[UILabel alloc] init];
        self.cellContent.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellContent.textAlignment = NSTextAlignmentRight;
        self.cellContent.font = [UIFont systemFontOfSize:14.f];
        self.cellContent.text = @"--";
        self.cellContent.textColor = [UIColor whiteColor];
        self.cellContent.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellContent];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.cellContent.topAnchor constraintEqualToAnchor:margin.topAnchor],
            [self.cellContent.leadingAnchor constraintEqualToAnchor:self.cellTitle.trailingAnchor],
            [self.cellContent.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor],
            [self.cellContent.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor]
        ]];
        
        self.invalidButton = [[UIButton alloc] init];
        self.invalidButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.invalidButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.invalidButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.invalidButton.titleLabel.minimumScaleFactor = 0.5f;
        [self.invalidButton setTitle:NSLocalizedString(@"已失效", nil) forState:UIControlStateNormal];
        [self.invalidButton setTitleColor:RGBA(255.f, 255.f, 255.f, 0.5f) forState:UIControlStateNormal];
        self.invalidButton.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
        self.invalidButton.layer.borderColor = RGBA(255.f, 255.f, 255.f, 0.5f).CGColor;
        self.invalidButton.layer.borderWidth = 1.f;
        self.invalidButton.layer.cornerRadius = 5.f;
        self.invalidButton.layer.masksToBounds = YES;
        self.invalidButton.contentEdgeInsets = UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f);
        self.invalidButton.userInteractionEnabled = NO;
        self.invalidButton.alpha = 0.f;
        [self addSubview:self.invalidButton];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.invalidButton.centerYAnchor constraintEqualToAnchor:self.cellContent.centerYAnchor],
            [self.invalidButton.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor]
        ]];
    }
    return self;
}

- (void)reloadData {
    
}

@end
