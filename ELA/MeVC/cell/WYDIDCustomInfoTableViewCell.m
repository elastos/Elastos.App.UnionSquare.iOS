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


#import "WYDIDCustomInfoTableViewCell.h"

@interface WYDIDCustomInfoTableViewCell() <UITextFieldDelegate>

@end

@implementation WYDIDCustomInfoTableViewCell

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
        
        UILayoutGuide *margin = self.contentView.layoutMarginsGuide;
        
        self.cellTitle = [[UITextField alloc] init];
        self.cellTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellTitle.textAlignment = NSTextAlignmentLeft;
        self.cellTitle.font = [UIFont systemFontOfSize:14.f];
        self.cellTitle.textColor = [UIColor whiteColor];
        self.cellTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellTitle];
        
        self.cellContent = [[UITextField alloc] init];
        self.cellContent.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellContent.textAlignment = NSTextAlignmentRight;
        self.cellContent.font = [UIFont systemFontOfSize:14.f];
        self.cellContent.textColor = [UIColor whiteColor];
        self.cellContent.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellContent];
        
        self.cellStore = [[UILabel alloc] init];
        self.cellStore.translatesAutoresizingMaskIntoConstraints = NO;
        self.cellStore.textAlignment = NSTextAlignmentRight;
        self.cellStore.font = [UIFont systemFontOfSize:14.f];
        self.cellStore.textColor = [UIColor whiteColor];
        self.cellStore.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellStore];
        
        UIView *titleSep = [[UIView alloc] init];
        titleSep.translatesAutoresizingMaskIntoConstraints = NO;
        titleSep.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.5f);
        [self.contentView addSubview:titleSep];
        
        UIView *contentSep = [[UIView alloc] init];
        contentSep.translatesAutoresizingMaskIntoConstraints = NO;
        contentSep.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.5f);
        [self.contentView addSubview:contentSep];
        
        UIButton *delButton = [[UIButton alloc] init];
        delButton.translatesAutoresizingMaskIntoConstraints = NO;
        delButton.backgroundColor = [UIColor clearColor];
        UIImage *btnImage = [UIImage imageNamed:@"asset_cancel"];
        [delButton setImage:btnImage forState:UIControlStateNormal];
        delButton.imageEdgeInsets = UIEdgeInsetsMake(0.f, 14.f, 0.f, -14.f);
        [self.contentView addSubview:delButton];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.cellTitle.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.cellContent.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            
            [titleSep.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [contentSep.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            
            [self.cellTitle.bottomAnchor constraintEqualToAnchor:titleSep.topAnchor],
            [self.cellContent.bottomAnchor constraintEqualToAnchor:contentSep.topAnchor],
            
            [delButton.topAnchor constraintEqualToAnchor:self.cellContent.topAnchor],
            [delButton.bottomAnchor constraintEqualToAnchor:self.cellContent.bottomAnchor],
            
            [titleSep.heightAnchor constraintEqualToConstant:1.f],
            [contentSep.heightAnchor constraintEqualToConstant:1.f],
            
            [self.cellTitle.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
            [self.cellContent.leadingAnchor constraintEqualToAnchor:self.cellTitle.trailingAnchor constant:15.f],
            [self.cellContent.trailingAnchor constraintEqualToAnchor:delButton.leadingAnchor],
            [delButton.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor],
            
            [titleSep.leadingAnchor constraintEqualToAnchor:self.cellTitle.leadingAnchor],
            [titleSep.trailingAnchor constraintEqualToAnchor:self.cellTitle.trailingAnchor],
            [contentSep.leadingAnchor constraintEqualToAnchor:self.cellContent.leadingAnchor],
            [contentSep.trailingAnchor constraintEqualToAnchor:delButton.trailingAnchor],
            
            [self.cellTitle.widthAnchor constraintEqualToAnchor:margin.widthAnchor multiplier:0.4f],
            [delButton.widthAnchor constraintEqualToConstant:50.f],
            
            [self.cellStore.topAnchor constraintEqualToAnchor:self.cellContent.topAnchor],
            [self.cellStore.bottomAnchor constraintEqualToAnchor:self.cellContent.bottomAnchor],
            [self.cellStore.leadingAnchor constraintEqualToAnchor:self.cellContent.leadingAnchor],
            [self.cellStore.trailingAnchor constraintEqualToAnchor:self.cellContent.trailingAnchor]
        ]];
        
        self.cellContent.alpha = 1.f;
        self.cellStore.alpha = 0.f;
        
        [delButton addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)reloadData {
    if ([self.cellType isEqualToString:@"-1"]) {
        [[HMWCommView share] makeTextFieldPlaceHoTextColorWithTextField:self.cellTitle withTxt:NSLocalizedString(@"单行文本项目", nil)];
    } else if ([self.cellType isEqualToString:@"-2"]) {
        [[HMWCommView share] makeTextFieldPlaceHoTextColorWithTextField:self.cellTitle withTxt:NSLocalizedString(@"多行文本项目", nil)];
    }
    
    [[HMWCommView share] makeTextFieldPlaceHoTextColorWithTextField:self.cellContent withTxt:NSLocalizedString(@"请输入内容", nil)];
    
    self.cellTitle.returnKeyType = UIReturnKeyDone;
    self.cellTitle.delegate = self;
    self.cellTitle.tag = 1;
    self.cellContent.returnKeyType = UIReturnKeyDone;
    self.cellContent.delegate = self;
    self.cellContent.tag = 2;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.cellType isEqualToString:@"-2"] && textField.tag == 2) {
        WYLog(@"=== dev temp === WYCustom cell content pressed!!");
        
        NSString *titleText = self.cellTitle.text;
        if (titleText.length < 1) {
            titleText = @"多行文本项目";
        }
        
        __weak __typeof__ (self) weakSelf = self;
        [self.delegate customInfoMultiPressed:titleText withContent:self.cellStore.text withNextBlock:^(NSString * _Nonnull newContent) {
            WYLog(@"=== dev temp === newContent Received: %@", newContent);
            weakSelf.cellContent.text = newContent;
            weakSelf.cellStore.text = newContent;
            WYLog(@"=== dev temp === cellContent Set: %@", weakSelf.cellContent.text);
            WYLog(@"=== dev temp === cellStore Set: %@", weakSelf.cellStore.text);
            
            [weakSelf.delegate updateCustomInfosDic:self.index withDic:@{
                @"type": weakSelf.cellType,
                @"title": weakSelf.cellTitle.text,
                @"content":weakSelf.cellStore.text
            }];
        }];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.cellContent) {
        self.cellStore.text = self.cellContent.text;
    }
    
    [self.delegate updateCustomInfosDic:self.index withDic:@{
        @"type": self.cellType,
        @"title": self.cellTitle.text,
        @"content":self.cellStore.text
    }];
    return YES;
}

- (void)deletePressed:(id)sender {
    WYLog(@"=== dev temp === delete index: %@", self.index);
    if (self.delegate) {
        [self.delegate deleteWithIndex:self.index];
    }
}

- (void)setIndex:(NSString *)index {
    _index = index;
}

- (void)setCellType:(NSString *)cellType {
    _cellType = cellType;
}

@end
