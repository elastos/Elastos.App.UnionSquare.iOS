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


#import "WYContactListViewController.h"
#import "HMWFMDBManager.h"
#import "HMWmyContactListTableViewCell.h"
#import "friendsModel.h"
#import "HMWtheContactInformationViewController.h"
#import "HMWaddContactViewController.h"
#import "ELAUtils.h"

static NSString *theContactCell=@"HMWmyContactListTableViewCell";

@interface WYContactListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *theContactMutableArray;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *buttonView;
@property (nonatomic, strong) UILabel *labelView;

@end

@implementation WYContactListViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.table  = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.table registerNib:[UINib nibWithNibName:theContactCell bundle:nil] forCellReuseIdentifier:theContactCell];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    UIImageView *bgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self CAGradientColorFrome:RGB(83, 136, 136) withToColor:RGB(16, 47, 58) withView:bgview];
    self.table.backgroundView = bgview;
    self.table.rowHeight = 60;
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AppWidth, 40)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myfriendNeedUpdateInfo) name:myfriendNeedUpdate object:nil];
}

-(void)myfriendNeedUpdateInfo {
    [self.theContactMutableArray removeAllObjects];
    self.theContactMutableArray=nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.table reloadData];
    
    if (self.theContactMutableArray.count > 0) {
        if (self.imageView) {
            [self.imageView removeFromSuperview];
            self.imageView = nil;
        }
        if (self.labelView) {
            [self.labelView removeFromSuperview];
            self.labelView = nil;
        }
        if (self.buttonView) {
            [self.buttonView removeFromSuperview];
            self.buttonView = nil;
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"add_contact"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(addContact)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        
        UILayoutGuide *margin = self.view.layoutMarginsGuide;
        CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
        WYLog(@"=== dev temp === vc height is: %f", viewHeight);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_contact"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:imageView];
        self.imageView = imageView;
        
        [NSLayoutConstraint activateConstraints:@[
            [imageView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
            [imageView.topAnchor constraintEqualToAnchor:margin.centerYAnchor constant:-(viewHeight * 0.3f)]
        ]];
        
        UILabel *labelView = [[UILabel alloc] init];
        labelView.translatesAutoresizingMaskIntoConstraints = NO;
        [labelView setText:NSLocalizedString(@"暂无联系人", nil)];
        [labelView setTextColor:ELARGB(202, 213, 226)];
        [labelView setBackgroundColor:[UIColor clearColor]];
        [labelView setFont:PingFangRegular(18)];
        [self.view addSubview:labelView];
        self.labelView = labelView;
        
        [NSLayoutConstraint activateConstraints:@[
            [labelView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
            [labelView.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:20.f]
        ]];
        
        UIButton *buttonView = [[UIButton alloc] init];
        buttonView.translatesAutoresizingMaskIntoConstraints = NO;
        [buttonView setTitle:NSLocalizedString(@"添加联系人", nil) forState:UIControlStateNormal];
        [buttonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonView.titleLabel.font = PingFangRegular(14);
        [buttonView setBackgroundColor:ELARGB(63, 93, 101)];
        [buttonView.layer setBorderWidth:1.f];
        [buttonView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view addSubview:buttonView];
        self.buttonView = buttonView;
        
        [NSLayoutConstraint activateConstraints:@[
            [buttonView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
            [buttonView.topAnchor constraintEqualToAnchor:margin.centerYAnchor constant:(viewHeight * 0.2f)],
            [buttonView.widthAnchor constraintEqualToConstant:250.f],
            [buttonView.heightAnchor constraintEqualToConstant:40.f]
        ]];
        
        [buttonView addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addContact {
    HMWaddContactViewController *addContactVC=[[HMWaddContactViewController alloc]init];
    addContactVC.title=NSLocalizedString(@"添加联系人", nil);
    addContactVC.typeInfo=updateInfo;
    [self.navigationController pushViewController:addContactVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.theContactMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMWmyContactListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:theContactCell];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    friendsModel *model=self.theContactMutableArray[indexPath.row];
    cell.nickNameLabel.text=model.nameString;
    cell.BGView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.BGView.backgroundColor = RGB(97, 139, 143);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HMWtheContactInformationViewController *theContactInformationVC=[[HMWtheContactInformationViewController alloc]init];
    theContactInformationVC.model=self.theContactMutableArray[indexPath.row];
    [self.navigationController pushViewController:theContactInformationVC animated:YES];
}

- (NSMutableArray *)theContactMutableArray {
    
    if (!_theContactMutableArray) {
        NSSortDescriptor *localizedSortWithName = [NSSortDescriptor sortDescriptorWithKey:@"nameString" ascending:YES selector:@selector(localizedCompare:)];
        NSArray *sortedContacts =[[[HMWFMDBManager sharedManagerType:friendsModelType] allRecord] sortedArrayUsingDescriptors:@[localizedSortWithName]];
        _theContactMutableArray =[[NSMutableArray alloc]initWithArray:sortedContacts];
    }
    return _theContactMutableArray;
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
