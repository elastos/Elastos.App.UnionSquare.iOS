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


#import "WYSelectContactViewController.h"
#import "HMWSideChainAndTheContactTableViewCell.h"
#import "HMWFMDBManager.h"
#import "HMWToDeleteTheWalletPopView.h"

static NSString *cellID = @"HMWSideChainAndTheContactTableViewCell";

@interface WYSelectContactViewController () <UITableViewDelegate, UITableViewDataSource, HMWToDeleteTheWalletPopViewDelegate>

@property (strong, nonatomic) UITableView *contactListTable;
@property (strong, nonatomic) NSArray *contactListArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) HMWToDeleteTheWalletPopView *confirmContactPopView;

@end

@implementation WYSelectContactViewController

- (void)loadView {
    self.title = NSLocalizedString(@"请选择联系人", nil);
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.translatesAutoresizingMaskIntoConstraints = NO;
    footerView.backgroundColor = RGBA(0.f, 0.f, 0.f, 0.3f);
    footerView.clipsToBounds = YES;
    footerView.layer.masksToBounds = YES;
    [self.view addSubview:footerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [footerView.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor],
        [footerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [footerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [footerView.heightAnchor constraintEqualToConstant:80.f]
    ]];
    
    UIView *footerSep = [[UIView alloc] init];
    footerSep.translatesAutoresizingMaskIntoConstraints = NO;
    footerSep.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.5f);
    [footerView addSubview:footerSep];
    
    [NSLayoutConstraint activateConstraints:@[
        [footerSep.topAnchor constraintEqualToAnchor:footerView.topAnchor],
        [footerSep.leadingAnchor constraintEqualToAnchor:footerView.leadingAnchor],
        [footerSep.trailingAnchor constraintEqualToAnchor:footerView.trailingAnchor],
        [footerSep.heightAnchor constraintEqualToConstant:1.f]
    ]];
    
    UIButton *newContactButton = [[UIButton alloc] init];
    newContactButton.translatesAutoresizingMaskIntoConstraints = NO;
    [newContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newContactButton setTitle:NSLocalizedString(@"新建联系人", nil) forState:UIControlStateNormal];
    newContactButton.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
    [self makeBordersWithView:newContactButton];
    [newContactButton addTarget:self action:@selector(newContactPressed:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:newContactButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [newContactButton.centerXAnchor constraintEqualToAnchor:footerView.centerXAnchor],
        [newContactButton.centerYAnchor constraintEqualToAnchor:footerView.centerYAnchor],
        [newContactButton.widthAnchor constraintEqualToConstant:250.f],
        [newContactButton.heightAnchor constraintEqualToConstant:40.f]
    ]];
    
    self.contactListTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.contactListTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.contactListTable.backgroundColor = [UIColor clearColor];
    self.contactListTable.rowHeight = 44.f;
    self.contactListTable.separatorInset = UIEdgeInsetsMake(-0.f, 15.f, 0.f, 15.f);
    self.contactListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contactListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.contactListTable];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contactListTable.topAnchor constraintEqualToAnchor:margin.topAnchor],
        [self.contactListTable.bottomAnchor constraintEqualToAnchor:footerView.topAnchor],
        [self.contactListTable.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
        [self.contactListTable.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor]
    ]];
    
    self.contactListTable.delegate = self;
    self.contactListTable.dataSource = self;
    [self.contactListTable registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
    [confirmButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    
    self.selectedIndex = -1;
    [self.contactListTable reloadData];
}

- (NSArray *)contactListArray {
    if (!_contactListArray) {
        NSSortDescriptor *localizedSortWithName = [NSSortDescriptor sortDescriptorWithKey:@"nameString" ascending:YES selector:@selector(localizedCompare:)];
        _contactListArray = [[NSArray arrayWithArray:[[HMWFMDBManager sharedManagerType:friendsModelType] allRecord]] sortedArrayUsingDescriptors:@[localizedSortWithName]];
    }
    return _contactListArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMWSideChainAndTheContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.selectedIndex == indexPath.section) {
        cell.selectImageView.image = [UIImage imageNamed:@"asset_linkman_select"];
    } else {
        cell.selectImageView.image = [UIImage imageNamed:@"asset_linkman"];
    }
    
    friendsModel *model = self.contactListArray[indexPath.section];
    cell.iChinaLabel.text = model.nameString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndex >= 0) {
        HMWSideChainAndTheContactTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectedIndex]];
        cell.selectImageView.image = [UIImage imageNamed:@"asset_linkman"];
    }
    
    HMWSideChainAndTheContactTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    cell.selectImageView.image = [UIImage imageNamed:@"asset_linkman_select"];
    self.selectedIndex = indexPath.section;
}

- (HMWToDeleteTheWalletPopView *)confirmContactPopView {
    if (!_confirmContactPopView) {
        _confirmContactPopView = [[HMWToDeleteTheWalletPopView alloc] init];
        _confirmContactPopView.delegate = self;
        _confirmContactPopView.deleteType = ConfirmContactType;
    }
    return _confirmContactPopView;
}

- (void)confirmPressed:(id)sender {
    if (self.selectedIndex < 0) {
        [[FLTools share]showErrorInfo:@"未选择联系人"];
        return;
    }
    UIView *mainWindow = [self mainWindow];
    [mainWindow addSubview:self.confirmContactPopView];
    [self.confirmContactPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(mainWindow);
    }];
}

- (void)CancelEvent {
    [self.confirmContactPopView removeFromSuperview];
    self.confirmContactPopView = nil;
}

- (void)toCancelOrCloseDelegate {
    [self CancelEvent];
}

- (void)sureToDeleteViewWithPWD:(NSString *)pwd {
    [self CancelEvent];
    if (self.delegate) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate contactSelected:self.contactListArray[self.selectedIndex]];
    }
}

- (void)newContactPressed:(id)sender {
    if (self.delegate) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate contactSelected:nil];
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
