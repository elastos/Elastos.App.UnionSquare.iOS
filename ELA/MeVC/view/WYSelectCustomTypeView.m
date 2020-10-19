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


#import "WYSelectCustomTypeView.h"
#import "HWMCreateDIDListTableViewCell.h"

static NSString *cellClass = @"HWMCreateDIDListTableViewCell";

@interface WYSelectCustomTypeView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation WYSelectCustomTypeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UILayoutGuide *margin = self.layoutMarginsGuide;
        
        UIButton *backButton = [[UIButton alloc] init];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        backButton.backgroundColor = [UIColor clearColor];
        UIImage *btnImage = [UIImage imageNamed:@"window_750_back"];
        [backButton setImage:btnImage forState:UIControlStateNormal];
        [self addSubview:backButton];
        
        [NSLayoutConstraint activateConstraints:@[
            [backButton.topAnchor constraintEqualToAnchor:margin.topAnchor],
            [backButton.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
            [backButton.heightAnchor constraintEqualToConstant:60.f],
            [backButton.widthAnchor constraintEqualToConstant:60.f]
        ]];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = NSLocalizedString(@"添加自定义信息", nil);
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:titleLabel];
        
        [NSLayoutConstraint activateConstraints:@[
            [titleLabel.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
            [titleLabel.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor]
        ]];
        
        UITableView *optionTable = [[UITableView alloc] init];
        optionTable.translatesAutoresizingMaskIntoConstraints = NO;
        optionTable.backgroundColor = [UIColor clearColor];
        optionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        optionTable.rowHeight = 55.f;
        [self addSubview:optionTable];
        
        [NSLayoutConstraint activateConstraints:@[
            [optionTable.topAnchor constraintEqualToAnchor:backButton.bottomAnchor],
            [optionTable.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor],
            [optionTable.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
            [optionTable.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor]
        ]];
        
        optionTable.delegate = self;
        optionTable.dataSource = self;
        [optionTable registerNib:[UINib nibWithNibName:cellClass bundle:nil] forCellReuseIdentifier:cellClass];
        
        [backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [optionTable reloadData];
    }
    return self;
}

- (void)backPressed:(id)sender {
    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWMCreateDIDListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClass];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoLabel.alpha = 1.f;
    cell.intPutTextField.alpha = 0.f;
    if (indexPath.row == 0) {
        cell.infoLabel.text = NSLocalizedString(@"单行文本", nil);
    } else if (indexPath.row == 1) {
        cell.infoLabel.text = NSLocalizedString(@"多行文本", nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeFromSuperview];
    if (indexPath.row == 0) {
        [self.delegate addCustomType:@"-1"];
    } else if (indexPath.row == 1) {
        [self.delegate addCustomType:@"-2"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
