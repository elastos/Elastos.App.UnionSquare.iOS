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
#import "HWMDIDInfoShowTableViewCell.h"

static NSString *cellID = @"HWMDIDInfoShowTableViewCell";

@interface WYDIDInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *DIDAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *expireTimeTextField;

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
    
    self.nameTextField.enabled = NO;
    self.DIDAddressTextField.enabled = NO;
    self.expireTimeTextField.enabled = NO;
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    self.extraTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.extraTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.extraTable.backgroundColor = [UIColor clearColor];
    self.extraTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.extraTable];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.extraTable.topAnchor constraintEqualToAnchor:self.expireTimeTextField.bottomAnchor],
        [self.extraTable.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor],
        [self.extraTable.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
        [self.extraTable.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor]
    ]];
    
    self.extraTable.delegate = self;
    self.extraTable.dataSource = self;
    [self.extraTable registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setAlignment:NSTextAlignmentRight];
    [pStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    if (self.model.didName) {
        self.nameTextField.text = self.model.didName;
    }
    if (self.model.didAddress) {
        NSMutableAttributedString *didText = [[NSMutableAttributedString alloc] initWithString:self.model.didAddress];
        [didText addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, didText.length)];
        self.DIDAddressTextField.attributedText = didText;
        //        self.DIDAddressTextField.text = self.model.didAddress;
    }
    if (self.model.expireTime) {
        self.expireTimeTextField.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"至", nil),[[FLTools share]YMDCommunityTimeConversionTimeFromTimesTamp:self.model.expireTime]];
    }
    
    WYLog(@"=== dev temp === extraInfo: %@", self.extraInfo);
    
    [self prepareDisplayList];
    [self.extraTable reloadData];
    
    if (self.displayList.count > 0) {
        self.extraTable.alpha = 1.f;
    } else {
        self.extraTable.alpha = 0.f;
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

- (IBAction)DIDCopyToClipboard:(id)sender {
    [[FLTools share]copiedToTheClipboardWithString:self.DIDAddressTextField.text];
}

- (void)setModel:(WYDIDChainInfoModel *) model {
    _model = model;
}

- (void)setExtraInfo:(NSDictionary *)extraInfo {
    _extraInfo = extraInfo;
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
        WYLog(@"=== dev temp === Table rows: %d", self.displayList.count);
        return self.displayList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYLog(@"=== dev temp === rowHeight called");
    if (indexPath.section == 1) {
        NSDictionary *item = self.displayList[indexPath.row];
        if ([item[@"key"] isEqualToString:@"avatar"]) {
            return 85.f;
        }
    }
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWMDIDInfoShowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *item = self.displayList[indexPath.row];
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
                if (data) {
                    cell.headIocnImageView.image=data;
                }else{
                    cell.headIocnImageView.image=[UIImage imageNamed:@"mine_did_default_avator"];
                }
            }];
        }else{
            cell.headIocnImageView.image=[UIImage imageNamed:@"mine_did_default_avator"];
        }
        cell.rightLabel.alpha=0.f;
        
    }
    
    WYLog(@"=== dev temp === Cell returned: %@", title);
    
    return cell;
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
