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


#import "WYDIDInfoViewController.h"
#import "HWMDIDInfoTableViewCell.h"
#import "HWMDIDInfoShowTableViewCell.h"
#import "HWMshowIntroductionInfoViewController.h"
#import "WYShowCustomContentViewController.h"
#import "HWMDIDInfoModel.h"
#import "WYSelectContactViewController.h"
#import "HMWFMDBManager.h"
#import "HMWtheContactInformationViewController.h"
#import "HMWaddContactViewController.h"

static NSString *cellID1 = @"HWMDIDInfoTableViewCell";
static NSString *cellID2 = @"HWMDIDInfoShowTableViewCell";

@interface WYDIDInfoViewController () <UITableViewDelegate, UITableViewDataSource, WYSelectContactViewControllerDelegate>

@property(copy,nonatomic)NSArray *dataArray;
@property (copy, nonatomic) NSArray *allExtraInfoList;
@property (strong, nonatomic) NSMutableArray *displayList;

@property (strong, nonatomic) UITableView *extraTable;

@end

@implementation WYDIDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title = NSLocalizedString(@"名片信息", nil);
    
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"window_750_close"];
    
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
        [footerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    if (self.walletAddress.length > 0) {
        [footerView.heightAnchor constraintEqualToConstant:80.f].active = YES;
    } else {
        [footerView.heightAnchor constraintEqualToConstant:0.f].active = YES;
    }
    
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
    
    UIButton *addContactButton = [[UIButton alloc] init];
    addContactButton.translatesAutoresizingMaskIntoConstraints = NO;
    [addContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addContactButton setTitle:NSLocalizedString(@"添加到联系人", nil) forState:UIControlStateNormal];
    addContactButton.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
    [self makeBordersWithView:addContactButton];
    [addContactButton addTarget:self action:@selector(addContactPressed:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addContactButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [addContactButton.centerXAnchor constraintEqualToAnchor:footerView.centerXAnchor],
        [addContactButton.centerYAnchor constraintEqualToAnchor:footerView.centerYAnchor],
        [addContactButton.widthAnchor constraintEqualToConstant:250.f],
        [addContactButton.heightAnchor constraintEqualToConstant:40.f]
    ]];
    
    self.extraTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.extraTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.extraTable.backgroundColor = [UIColor clearColor];
    self.extraTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.extraTable];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.extraTable.topAnchor constraintEqualToAnchor:margin.topAnchor],
        [self.extraTable.bottomAnchor constraintEqualToAnchor:footerView.topAnchor],
        [self.extraTable.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
        [self.extraTable.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor]
    ]];
    
    self.extraTable.delegate = self;
    self.extraTable.dataSource = self;
    [self.extraTable registerNib:[UINib nibWithNibName:cellID1 bundle:nil] forCellReuseIdentifier:cellID1];
    [self.extraTable registerNib:[UINib nibWithNibName:cellID2 bundle:nil] forCellReuseIdentifier:cellID2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WYLog(@"=== dev temp === extraInfo: %@", self.extraInfo);
    
    [self prepareDisplayList];
    [self.extraTable reloadData];
    
    if (self.displayList.count > 0) {
        self.extraTable.alpha = 1.f;
    } else {
        self.extraTable.alpha = 0.f;
    }
}

- (void)addContactPressed:(id)sender {
    WYSelectContactViewController *selectContactVC = [[WYSelectContactViewController alloc] init];
    selectContactVC.delegate = self;
    [self.navigationController pushViewController:selectContactVC animated:YES];
}

- (void)contactSelected:(friendsModel *)model {
    if (model) {
        model.address = self.walletAddress;
        model.did = self.model.didAddress;
        if ([[HMWFMDBManager sharedManagerType:friendsModelType]updateRecord:model]){
            [[FLTools share]showErrorInfo:NSLocalizedString(@"修改成功！", nil)];
            [self.navigationController popViewControllerAnimated:YES];
            HMWtheContactInformationViewController *theContactInformationVC=[[HMWtheContactInformationViewController alloc]init];
            theContactInformationVC.model = model;
            [self.navigationController pushViewController:theContactInformationVC animated:YES];
        } else {
            [[FLTools share]showErrorInfo:NSLocalizedString(@"修改失败！", nil)];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        HMWaddContactViewController *addContactVC=[[HMWaddContactViewController alloc]init];
        addContactVC.title=NSLocalizedString(@"添加联系人", nil);
        addContactVC.addressString = self.walletAddress;
        addContactVC.didString = self.model.didAddress;
        addContactVC.typeInfo=updateInfo;
        [self.navigationController pushViewController:addContactVC animated:YES];
    }
}

- (void)prepareDisplayList {
    self.displayList = [[NSMutableArray alloc] init];
    for (NSDictionary *item in self.allExtraInfoList) {
        NSString *key = item[@"key"];
        NSString *value = self.extraInfo[key];
        if (value.length > 0) {
            NSString *content = value;
            if ([key isEqualToString:@"phone"]) {
                NSString *phoneCode = self.extraInfo[@"phoneCode"];
                if (phoneCode.length > 0) {
                    content = [NSString stringWithFormat:@"%@ %@", phoneCode, content];
                }
            }
            
            if ([key isEqualToString:@"gender"]) {
                content = [[FLTools share]genderStringWithType:content];
            }
            
            if ([key isEqualToString:@"birthday"]) {
                content = [[FLTools share]TimeFormatConversionBirthday:content];
            }
            
            if ([key isEqualToString:@"nation"]) {
                content = [[FLTools share]contryNameTransLateByCode:[content integerValue]];
            }
            
            if ([key isEqualToString:@"customInfos"]) {
                NSDictionary *customInfosDic = [WYUtils dicFromJSONString:content];
                for (NSDictionary *customInfoItem in customInfosDic) {
                    NSDictionary *displayItem = @{
                        @"title": customInfoItem[@"title"],
                        @"content": customInfoItem[@"content"],
                        @"type": customInfoItem[@"type"],
                        @"key": key
                    };
                    [self.displayList addObject:displayItem];
                }
            } else {
                NSDictionary *displayItem = @{
                    @"title": item[@"text"],
                    @"content": content,
                    @"type": item[@"type"],
                    @"key": key
                };
                [self.displayList addObject:displayItem];
            }
        }
    }
    
    WYLog(@"=== dev temp === displayList prepared: %@", self.displayList);
}

- (void)setModel:(WYDIDChainInfoModel *) model {
    _model = model;
}

- (void)setExtraInfo:(NSDictionary *)extraInfo {
    _extraInfo = extraInfo;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        if (self.walletAddress.length > 0) {
            _dataArray =[NSArray arrayWithObjects:NSLocalizedString(@"收款地址", nil),NSLocalizedString(@"姓名", nil),NSLocalizedString(@"DID", nil),NSLocalizedString(@"有效期", nil), nil];
        } else {
            _dataArray =[NSArray arrayWithObjects:NSLocalizedString(@"姓名", nil),NSLocalizedString(@"DID", nil),NSLocalizedString(@"有效期", nil), nil];
        }
    }
    return _dataArray;
}

- (NSArray *)allExtraInfoList {
    if (!_allExtraInfoList) {
        _allExtraInfoList = @[
            @{@"text":NSLocalizedString(@"昵称", nil),
              @"index":@"0",@"type":@"1",
              @"key":@"nickname"},
            @{@"text":NSLocalizedString(@"性别",nil),
              @"index":@"1",@"type":@"2",
              @"key":@"gender"},
            @{@"text":NSLocalizedString(@"出生日期",nil),
              @"index":@"2",@"type":@"2",
              @"key":@"birthday"},
            @{@"text":NSLocalizedString(@"头像地址1",nil),
              @"index":@"3",@"type":@"1",
              @"key":@"avatar"},
            @{@"text":NSLocalizedString(@"邮箱",nil),
              @"index":@"4",@"type":@"1",
              @"key":@"email"},
            @{@"text":NSLocalizedString(@"手机号", nil),
              @"index":@"5",@"type":@"3",
              @"key":@"phone"},
            @{@"text":NSLocalizedString(@"国家/地区", nil),
              @"index":@"6",@"type":@"2",
              @"key":@"nation"},
            @{@"text":NSLocalizedString(@"个人简介qe",nil),
              @"index":@"7",@"type":@"4",
              @"key":@"introduction"},
            @{@"text":NSLocalizedString(@"个人主页网址",nil),
              @"index":@"8",@"type":@"1",
              @"key":@"homePage"},
            @{@"text":NSLocalizedString(@"Facebook账号",nil),
              @"index":@"9",@"type":@"1",
              @"key":@"facebook"},
            @{@"text":NSLocalizedString(@"Twitter账号",nil),
              @"index":@"10",@"type":@"1",
              @"key":@"twitter"},
            @{@"text":NSLocalizedString(@"微博账号",nul),
              @"index":@"11",@"type":@"1",
              @"key":@"weibo"},
            @{@"text":NSLocalizedString(@"微信账号",null),
              @"index":@"12",@"type":@"1",
              @"key":@"wechat"},
            @{@"text":NSLocalizedString(@"谷歌账号1",null),
              @"index":@"13",@"type":@"1",
              @"key":@"googleAccount"},
            @{@"text":NSLocalizedString(@"自定义信息",null),
              @"index":@"14",@"type":@"666",
              @"key":@"customInfos"}
        ];
    }
    return _allExtraInfoList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.displayList.count + self.dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row >= self.dataArray.count) {
        NSDictionary *item = self.displayList[indexPath.row - self.dataArray.count];
        if ([item[@"key"] isEqualToString:@"avatar"]) {
            return 85.f;
        }
    }
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        HWMDIDInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTextLabel.text=self.dataArray[indexPath.row];
        
        NSInteger rowNum = indexPath.row;
        if (self.walletAddress.length > 0) {
            rowNum--;
        }
        
        switch (rowNum) {
            case -1:
                cell.arrImageView.alpha = 0.f;
                cell.infoLabel.alpha = 0.f;
                cell.longInfoLabel.text = self.walletAddress;
                break;
            case 0:
                cell.arrImageView.alpha = 0.f;
                cell.infoLabel.alpha = 0.f;
                cell.longInfoLabel.text = self.model.didName;
                break;
            case 1:
                cell.longInfoLabel.alpha = 0.f;
                cell.infoLabel.text = self.model.didAddress;
                break;
            case 2:
                cell.arrImageView.alpha = 0.f;
                cell.infoLabel.alpha = 0.f;
                if (self.model.expireTime.length > 0) {
                    cell.longInfoLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"至", nil),[[FLTools share]YMDCommunityTimeConversionTimeFromTimesTamp:self.model.expireTime]];
                }
                break;
            default:
                break;
        }
        
        return cell;
    } else {
        HWMDIDInfoShowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSDictionary *item = self.displayList[indexPath.row - self.dataArray.count];
        NSString *title = item[@"title"];
        NSString *content = item[@"content"];
        cell.leftLabel.text = title;
        cell.rightLabel.text = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        if ([item[@"key"] isEqualToString:@"avatar"]) {
            
            cell.headIocnImageView.alpha=1.f;
            if (content.length>4) {
               
                NSString *typeString=[content substringFromIndex:content.length-4];
                if ([typeString isEqualToString:@".svg"]) {
                    cell.headIocnImageView.contentMode=UIViewContentModeScaleAspectFit;
                }else{
                    cell.headIocnImageView.contentMode=UIViewContentModeScaleAspectFill;
                }
                [[FLTools share]loadUrlSVGAndPNG:content WithSuccessBlock:^(id data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            cell.headIocnImageView.image=data;
                        }else{
                            cell.headIocnImageView.image=[UIImage imageNamed:@"mine_did_default_avator"];
                        }
                    });
                }];
            }else{
                cell.headIocnImageView.image=[UIImage imageNamed:@"mine_did_default_avator"];
            }
            cell.rightLabel.alpha=0.f;
            
        }
        
        return cell;
    }
    
    HWMDIDInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row >= self.dataArray.count) {
        NSDictionary *infoSelected = self.displayList[indexPath.row - self.dataArray.count];
        WYLog(@"=== dev temp === infoSelected: %@", infoSelected);
        if ([infoSelected[@"key"] isEqualToString:@"introduction"]) {
            HWMshowIntroductionInfoViewController *AddPersonalProfileVC=[[HWMshowIntroductionInfoViewController alloc]init];
            AddPersonalProfileVC.model= [HWMDIDInfoModel modelWithDictionary:self.extraInfo];
            [self.navigationController pushViewController:AddPersonalProfileVC animated:YES];
        } else if ([infoSelected[@"key"] isEqualToString:@"customInfos"] && [infoSelected[@"type"] isEqualToString:@"-2"]) {
            WYShowCustomContentViewController *contentVC = [[WYShowCustomContentViewController alloc] init];
            contentVC.title = infoSelected[@"title"];
            contentVC.contentText = infoSelected[@"content"];
            [contentVC refreshData];
            [self.navigationController pushViewController:contentVC animated:YES];
        }
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
