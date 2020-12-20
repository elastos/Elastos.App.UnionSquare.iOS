//
//  FLthirdViewController.m
//  FLWALLET
//
#import "FLMyVC.h"
#import "FLMeHeadView.h"
#import "MJRefresh.h"
#import "FLShareVC.h"
#import "FLTableViewDefultCell.h"
#import "HMWClassificationOfLanguageTableViewCell.h"
#import "HMWaddWalletListTableViewCell.h"
#import "HMWNotAddContactTableViewCell.h"
#import "HMWmyContactListTableViewCell.h"
#import "HMWaddContactViewController.h"
#import "HMWtheContactInformationViewController.h"
#import "HMWFMDBManager.h"
#import "friendsModel.h"
#import "AboutELAWalletViewController.h"
#import "HWMTheMessageCenterViewController.h"
#import "HMWToDeleteTheWalletPopView.h"
#import "WYContactListViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

static NSString *MyIncomeOrWealthCell=@"HMWMyIncomeOrWealthTableViewCell";
static NSString *LanguageCell=@"HMWClassificationOfLanguageTableViewCell";
static NSString *addListCell=@"HMWaddWalletListTableViewCell";
static NSString *notAddCell=@"HMWNotAddContactTableViewCell";
static NSString *theContactCell=@"HMWmyContactListTableViewCell";

@interface FLMyVC ()<UITableViewDataSource, UITableViewDelegate, FLMeHeadViewDelegate, HMWToDeleteTheWalletPopViewDelegate>

@property (nonatomic, strong)FLMeHeadView *headerView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong)NSArray *dataSorse;

/*
 *<# #>
 */
@property(assign,nonatomic)BOOL theContactOpen;
/*
 *<# #>
 */
@property(strong,nonatomic)NSMutableArray *theContactMutableArray;
/*
 *<# #>
 */
@property(strong,nonatomic)NSIndexPath *selectIndex;

@property(strong,nonatomic)UIButton *meeasseButton;

@property (strong, nonatomic) HMWToDeleteTheWalletPopView *authSwitchOffPopView;

@end

@implementation FLMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theContactOpen=NO;
    self.title= NSLocalizedString(@"我的", nil);
    self.languageOpen =[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpen"];
    [self makeUI];
    [self.table reloadData];
    [self setBackgroundImg:@""];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myfriendNeedUpdateInfo) name:myfriendNeedUpdate object:nil];
    //    UIBarButtonItem *ClickMorenButton =  [[UIBarButtonItem alloc]initWithCustomView:self.meeasseButton];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                                                                    target:nil
    //                                                                                    action:nil];
    //    negativeSpacer.width =-20;
    //    NSArray *buttonArray = [[NSArray alloc]initWithObjects:negativeSpacer,ClickMorenButton,nil];
    //    self.navigationItem.rightBarButtonItems = buttonArray;
}
-(void)messageCenter{
    UIView *reView =[self.meeasseButton viewWithTag:999];
    reView.alpha=0.f;
    HWMTheMessageCenterViewController *TheMessageCenterVC=[[HWMTheMessageCenterViewController alloc]init];
    [self.navigationController pushViewController:TheMessageCenterVC animated:YES];
}
-(void)myfriendNeedUpdateInfo{
    [self.theContactMutableArray removeAllObjects];
    self.theContactMutableArray=nil;
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.selectIndex.section];
    [self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
-(NSMutableArray *)theContactMutableArray{
    
    if (!_theContactMutableArray) {
        NSSortDescriptor *localizedSortWithName = [NSSortDescriptor sortDescriptorWithKey:@"nameString" ascending:YES selector:@selector(localizedCompare:)];
        _theContactMutableArray = [[NSMutableArray alloc] initWithArray:[[[HMWFMDBManager sharedManagerType:friendsModelType] allRecord] sortedArrayUsingDescriptors:@[localizedSortWithName]]];
    }
    return _theContactMutableArray;
}
-(void)makeUI{
    self.table  = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.table registerNib:[UINib nibWithNibName:@"FLTableViewDefultCell" bundle:nil] forCellReuseIdentifier:@"FLTableViewDefultCell"];
    [self.table registerNib:[UINib nibWithNibName:LanguageCell bundle:nil] forCellReuseIdentifier:LanguageCell];
    
    [self.table registerNib:[UINib nibWithNibName:addListCell bundle:nil] forCellReuseIdentifier:addListCell];
    [self.table registerNib:[UINib nibWithNibName:notAddCell bundle:nil] forCellReuseIdentifier:notAddCell];
    [self.table registerNib:[UINib nibWithNibName:theContactCell bundle:nil] forCellReuseIdentifier:theContactCell];
    
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.table.delegate =self;
    self.table.dataSource =self;
    [self.view addSubview:self.table];
    UIImageView *bgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self CAGradientColorFrome:RGB(83, 136, 136) withToColor:RGB(16, 47, 58) withView:bgview];
    self.table.backgroundView = bgview;
    
    
    
    
    self.table.rowHeight = 60;
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AppWidth, 40)];
    
    self.dataSorse = @[
        @{@"img":@"mine_mission",@"title":NSLocalizedString(@"语言", nil),@"url":@"/app/task.html",@"subTitle":@""},
        @{@"img":@"mine_sugar",@"title":NSLocalizedString(@"联系人", nil),@"url":@"/app/vlink/wallet.html",@"subTitle":@""},
        @{@"img":@"mine_mission",@"title":NSLocalizedString(@"安全验证", nil),@"url":@"/app/vlink/wallet.html",@"subTitle":@""},
        @{@"img":@"mine_sugar",@"title":NSLocalizedString(@"关于", nil),@"url":@"/app/vlink/wallet.html",@"subTitle":@""}
    ];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self defultWhite];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem = nil;
    NSString *messageImage=@"mine_message_center";
    UIView *reView =[self.meeasseButton viewWithTag:999];
    if ([[FLTools share]hasMessageNeedRead:@""]&&[[FLTools share]MseeagPRead:@""]) {
        reView.alpha=1;
    }else{
        reView.alpha=0;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.languageOpen) {
        if (section==0) {
            
            
            return 2;
        }
        
    }
    
    if (self.theContactOpen) {
        if (section==1) {
            if (self.theContactMutableArray.count==0) {
                return self.theContactMutableArray.count+3;
            }
            return self.theContactMutableArray.count+2;
            
        }
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.languageOpen) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                FLTableViewDefultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLTableViewDefultCell"];
                
                NSDictionary*dict =self.dataSorse[indexPath.row];
                cell.nameLab.text  = dict[@"title"];
                cell.subImag.image=[UIImage imageNamed:@"setting_list_arrow"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            HMWClassificationOfLanguageTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:LanguageCell];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
//    if (self.theContactOpen) {
//        if (indexPath.section==1) {
//            if (indexPath.row==0) {
//                FLTableViewDefultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLTableViewDefultCell"];
//
//                NSDictionary*dict =self.dataSorse[indexPath.section];
//                cell.nameLab.text  = dict[@"title"];
//                cell.subImag.image=[UIImage imageNamed:@"setting_list_arrow"];
//                return cell;
//                cell.selectionStyle=UITableViewCellSelectionStyleNone;
//            }
//            if (self.theContactMutableArray.count==0) {
//
//                if(indexPath.row==self.theContactMutableArray.count+2) {
//                    HMWaddWalletListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:addListCell];
//                    cell.backgroundColor=[UIColor clearColor];
//                    [[HMWCommView share] makeBordersWithView:cell.BGView];
//                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//                    return cell;
//
//                }
//                HMWNotAddContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:notAddCell];
//                cell.backgroundColor=[UIColor clearColor];
//                cell.selectionStyle=UITableViewCellSelectionStyleNone;
//                return cell;
//
//            } else {
//                if (indexPath.row==self.theContactMutableArray.count+1) {
//                    HMWaddWalletListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:addListCell];
//
//                    cell.backgroundColor=[UIColor clearColor];
//                    [[HMWCommView share] makeBordersWithView:cell.BGView];
//
//                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//                    return cell;
//                }
//                HMWmyContactListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:theContactCell];
//
//                cell.backgroundColor=[UIColor clearColor];
//                cell.selectionStyle=UITableViewCellSelectionStyleNone;
//
//
//                friendsModel *model=self.theContactMutableArray[indexPath.row-1];
//                cell.nickNameLabel.text=model.nameString;
//
//                return cell;
//
//            }
//
//        }
//    }
    
    FLTableViewDefultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLTableViewDefultCell"];
    
    NSDictionary*dict =self.dataSorse[indexPath.section];
    cell.nameLab.text  = dict[@"title"];
    cell.subImag.image=[UIImage imageNamed:@"setting_list_arrow_fold"];
    
    if (indexPath.section == 2) {
        cell.subImag.alpha = 0.f;
        cell.pwdSwitch.alpha = 1.f;
        cell.pwdSwitch.onTintColor = [UIColor greenColor];
        [self authSwitchStateInit:cell.pwdSwitch];
        [cell.pwdSwitch addTarget:self action:@selector(authSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.table reloadData];
}

- (void)authSwitchStateInit:(UISwitch *)pwdSwitch {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL authOn = [prefs boolForKey:@"authOn"];
    if (authOn) {
        LAContext *authContext = [[LAContext alloc] init];
        NSError *authError = nil;
        if (![authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
            [[FLTools share] showErrorInfo:NSLocalizedString(@"未设置系统锁屏密码", nil)];
            authOn = NO;
            [prefs setBool:authOn forKey:@"authOn"];
        }
    }
    [pwdSwitch setOn:authOn animated:NO];
}

- (void)authSwitchDidChange:(UISwitch *)sender {
    WYLog(@"=== dev temp === isOn: %d", sender.isOn);
    __block BOOL authOn = sender.isOn;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    LAContext *authContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *authLocalizedReasonString = NSLocalizedString(@"安全验证", nil);
    if (![authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
        [[FLTools share] showErrorInfo:NSLocalizedString(@"未设置系统锁屏密码", nil)];
        authOn = NO;
        [prefs setBool:authOn forKey:@"authOn"];
        [sender setOn:authOn animated:NO];
    } else {
        if (authOn) {
            [authContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                        localizedReason:authLocalizedReasonString
                                  reply:^(BOOL success, NSError *error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 0), dispatch_get_main_queue(), ^{
                    if (!success) {
                        authOn = !authOn;
                    }
                    [prefs setBool:authOn forKey:@"authOn"];
                    [sender setOn:authOn animated:NO];
                });
            }];
        } else {
            UIView *mainWindow = [self mainWindow];
            [mainWindow addSubview:self.authSwitchOffPopView];
            [self.authSwitchOffPopView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(mainWindow);
            }];
        }
    }
}

- (HMWToDeleteTheWalletPopView *)authSwitchOffPopView {
    if (!_authSwitchOffPopView) {
        _authSwitchOffPopView = [[HMWToDeleteTheWalletPopView alloc] init];
        _authSwitchOffPopView.delegate = self;
        _authSwitchOffPopView.deleteType = AuthSwitchOffType;
    }
    return _authSwitchOffPopView;
}

-(void)sureToDeleteViewWithPWD:(NSString *)pwd {
    LAContext *authContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *authLocalizedReasonString = NSLocalizedString(@"安全验证", nil);
    if (![authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
        [[FLTools share] showErrorInfo:NSLocalizedString(@"未设置系统锁屏密码", nil)];
        [self toCancelOrCloseDelegate];
    } else {
        [authContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                    localizedReason:authLocalizedReasonString
                              reply:^(BOOL success, NSError *error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 0), dispatch_get_main_queue(), ^{
                if (success) {
                    [self doAuthSwitchOff];
                } else {
                    [self toCancelOrCloseDelegate];
                }
            });
        }];
    }
}

-(void)doAuthSwitchOff {
    NSIndexPath *authSwitchPath = [NSIndexPath indexPathForRow:0 inSection:2];
    FLTableViewDefultCell *authSwitchCell = [self.table cellForRowAtIndexPath:authSwitchPath];
    BOOL authOn = authSwitchCell.pwdSwitch.isOn;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:authOn forKey:@"authOn"];
    [self hideAuthSwitchOffPopView];
}

-(void)toCancelOrCloseDelegate {
    NSIndexPath *authSwitchPath = [NSIndexPath indexPathForRow:0 inSection:2];
    FLTableViewDefultCell *authSwitchCell = [self.table cellForRowAtIndexPath:authSwitchPath];
    BOOL authOn = authSwitchCell.pwdSwitch.isOn;
    authOn = !authOn;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:authOn forKey:@"authOn"];
    [authSwitchCell.pwdSwitch setOn:authOn animated:NO];
    [self hideAuthSwitchOffPopView];
}

-(void)CancelEvent {
    [self hideAuthSwitchOffPopView];
}

-(void)hideAuthSwitchOffPopView {
    [self.authSwitchOffPopView removeFromSuperview];
    self.authSwitchOffPopView = nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = self.dataSorse[indexPath.section];
    
    NSString *name = dict[@"title"];
    if ([name isEqualToString:@"语言"]||[name isEqualToString:@"Language"]) {
        if (indexPath.row==0) {
            self.languageOpen=!self.languageOpen;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [self.table reloadSections:indexSet withRowAnimation: UITableViewRowAnimationAutomatic];
        }
//    } else if ([name isEqualToString:@"联系人"]||[name isEqualToString:@"Contacts"]) {
//        self.selectIndex=indexPath;
//        if (indexPath.row==0) {
//            self.theContactOpen=!self.theContactOpen;
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
//            [self.table reloadSections:indexSet withRowAnimation: UITableViewRowAnimationAutomatic];
//
//
//        }else{
//            if (self.theContactMutableArray.count==0) {
//                HMWaddContactViewController *addContactVC=[[ HMWaddContactViewController alloc]init];
//                addContactVC.title=NSLocalizedString(@"添加联系人", nil);
//                addContactVC.typeInfo=updateInfo;
//                [self.navigationController pushViewController:addContactVC animated:YES];
//            }else{
//                if (indexPath.row==self.theContactMutableArray.count+1) {//添加
//                    HMWaddContactViewController *addContactVC=[[ HMWaddContactViewController alloc]init];
//                    addContactVC.title=NSLocalizedString(@"添加联系人", nil);
//                    [self.navigationController pushViewController:addContactVC animated:YES];
//
//                }else{
//
//                    HMWtheContactInformationViewController *theContactInformationVC=[[HMWtheContactInformationViewController alloc]init];
//                    theContactInformationVC.model=self.theContactMutableArray[indexPath.row-1];
//                    [self.navigationController pushViewController:theContactInformationVC animated:YES];}
//            }
//
//        }
        
    } else if ([name isEqualToString:NSLocalizedString(@"关于", nil)]) {
                AboutELAWalletViewController* AboutELAWalletVC =[[AboutELAWalletViewController alloc]init];
                AboutELAWalletVC.title=name;
                [self.navigationController pushViewController:AboutELAWalletVC animated:YES];
                
            } else if ([name isEqualToString:NSLocalizedString(@"联系人", nil)]) {
                WYContactListViewController *contactListVC = [[WYContactListViewController alloc] init];
                contactListVC.title = name;
                [self.navigationController pushViewController:contactListVC animated:YES];
            }
    
    
}
-(void)head:(FLMeHeadView *)header click:(NSInteger)index
{
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(UIButton *)meeasseButton{
    if (!_meeasseButton) {
        _meeasseButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        //        [_meeasseButton setImage:[UIImage imageNamed:@"mine_message_center"] forState:UIControlStateNormal];
        UIImageView *showImageview =[[UIImageView alloc]init];
        showImageview.image=[UIImage imageNamed:@"mine_message_center"];
        [_meeasseButton addSubview:showImageview];
        [showImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_meeasseButton);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        [_meeasseButton addTarget:self action:@selector(messageCenter) forControlEvents:UIControlEventTouchUpInside];
        UIView *badgeView = [[UIView alloc]init];
        badgeView.userInteractionEnabled = YES;
        badgeView.layer.cornerRadius = 4;
        badgeView.tag = 999;
        badgeView.alpha=0.f;
        badgeView.backgroundColor = [UIColor redColor];
        [_meeasseButton addSubview:badgeView];
        [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showImageview.mas_left).offset(16);
            make.top.equalTo(showImageview.mas_top).offset(-2);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
    }
    return _meeasseButton;;
}
@end
