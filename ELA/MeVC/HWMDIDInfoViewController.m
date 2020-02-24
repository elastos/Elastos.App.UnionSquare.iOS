//
//  HWMDIDInfoViewController.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/10/30.
//

#import "HWMDIDInfoViewController.h"
#import "HWMDIDInfoTableViewCell.h"
#import "HWMTheEditorDIDInfoViewController.h"
#import "HWMConfidentialInformationViewController.h"
#import "HMWFMDBManager.h"
#import "HMWToDeleteTheWalletPopView.h"


static NSString *cellString=@"HWMDIDInfoTableViewCell";
@interface HWMDIDInfoViewController ()<UITableViewDataSource,UITableViewDelegate,HMWToDeleteTheWalletPopViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *DIDInfoTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *theEditorButton;
@property (weak, nonatomic) IBOutlet UIButton *ConfidentialInformationButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
 

@property(copy,nonatomic)NSArray *dataArray;
@property(strong,nonatomic)HMWToDeleteTheWalletPopView *deleteDIDPopView;
@end

@implementation HWMDIDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
          [self setBackgroundImg:@""];
    self.title=self.model.didName;
    self.DIDInfoTextLabel.text=NSLocalizedString(@"DID信息", nil);
    [[HMWCommView share]makeBordersWithView:self.theEditorButton];
    [[HMWCommView share]makeBordersWithView:self.ConfidentialInformationButton];
    [self.theEditorButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [self.ConfidentialInformationButton setTitle:NSLocalizedString(@"凭证信息", nil) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"del_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteDIDEvent)];
    [self makeUI];
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[NSArray arrayWithObjects:NSLocalizedString(@"DID名称", nil),NSLocalizedString(@"主管理公钥", nil),NSLocalizedString(@"DID", nil),NSLocalizedString(@"有效期", nil), nil];
    }
    return _dataArray;
}
-(void)deleteDIDEvent{
  
//    if ([[HMWFMDBManager sharedManagerType:DIDInfoType]delectDIDInfo:self.model WithWalletID:self.model.walletID]) {
//        [[FLTools share]showErrorInfo:NSLocalizedString(@"删除成功", nil)];
//        if (self.delegate) {
//            [self.delegate needUpdateDIDInfo];
//        }
//        [self.navigationController popViewControllerAnimated:NO];
//    }else{
//        [[FLTools share]showErrorInfo:NSLocalizedString(@"删除失败", nil)];
//    }
    UIView * mainView=[self mainWindow];
    [mainView addSubview:self.deleteDIDPopView];
    [self.deleteDIDPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(mainView);
    }];
    
}
-(HMWToDeleteTheWalletPopView *)deleteDIDPopView{
    if (!_deleteDIDPopView) {
        _deleteDIDPopView =[[HMWToDeleteTheWalletPopView alloc]init];
        _deleteDIDPopView.delegate=self;
        _deleteDIDPopView.deleteType=deleteDIDInfoType;
    }
    return _deleteDIDPopView;
}

-(void)sureToDeleteViewWithPWD:(NSString*)pwd{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self toCancelOrCloseDelegate];
}
-(void)toCancelOrCloseDelegate{
    [self.deleteDIDPopView removeFromSuperview];
    self.deleteDIDPopView=nil;
    
}
- (IBAction)theEditorEvent:(id)sender {
    HWMTheEditorDIDInfoViewController *TheEditorDIDInfoVC=[[HWMTheEditorDIDInfoViewController alloc]init];
    TheEditorDIDInfoVC.model=self.model;
    [self.navigationController pushViewController:TheEditorDIDInfoVC animated:YES];
}
- (IBAction)ConfidentialInformationEvent:(id)sender {
    HWMConfidentialInformationViewController *ConfidentialInformationVC=[[HWMConfidentialInformationViewController alloc]init];
    ConfidentialInformationVC.model=self.model;
    [self.navigationController pushViewController:ConfidentialInformationVC animated:YES];
}
-(void)makeUI{
     [self.table registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:cellString];
        
           self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
         self.table.rowHeight = 55;
           self.table.delegate =self;
           self.table.dataSource =self;
        self.table.backgroundColor=[UIColor clearColor];
        [self.table reloadData];
        
    }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {

      HWMDIDInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        cell.leftTextLabel.text=self.dataArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.infoLabel.text=self.model.didName;
            break;
            case 1:
                cell.infoLabel.text=self.model.PubKeyString;
            break;
            case 2:
                cell.infoLabel.text=self.model.did;
                
            break;
            case 3:
                cell.arrImageView.alpha=0.f;
                if (self.model.issuanceDate.length>0) {
                    cell.infoLabel.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"至", nil),[[FLTools share]YMDCommunityTimeConversionTimeFromTimesTamp:self.model.issuanceDate]];
                }
              
            break;
                
            default:
                
            break;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return self.dataArray.count;
    }
    -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {

    }
-(void)setModel:(HWMDIDInfoModel *)model{
    _model=model;
}

@end
