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


#import "HWMCommunityProposalViewController.h"
#import "HWMCommunityProposalBaseView.h"
#import "HWMCRsearchViewController.h"
#import "HWMCommentPerioDetailsViewController.h"

@interface HWMCommunityProposalViewController ()<UIScrollViewDelegate,HWMCommunityProposalBaseViewDelegate>
@property(strong,nonatomic)UIImageView *placeHolferImage;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIButton *MemberReviewButton;
@property (weak, nonatomic) IBOutlet UIView *MemberReviewView;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet UIView *publicView;
@property (weak, nonatomic) IBOutlet UIButton *executionButton;
@property (weak, nonatomic) IBOutlet UIView *executionView;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;
@property (weak, nonatomic) IBOutlet UIView *completedView;
@property (weak, nonatomic) IBOutlet UIButton *abolishedButton;
@property (weak, nonatomic) IBOutlet UIView *abolishedView;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScroView;
@property(strong,nonatomic)HWMCommunityProposalBaseView *allBaseView;
@property(strong,nonatomic)HWMCommunityProposalBaseView *MemberReviewBaseView;
@property(strong,nonatomic)HWMCommunityProposalBaseView *publicBaseView;
@property(strong,nonatomic)HWMCommunityProposalBaseView *executionBaseView;
@property(strong,nonatomic)HWMCommunityProposalBaseView *completedBaseView;
@property(strong,nonatomic)HWMCommunityProposalBaseView *abolishedBaseView;
@end

@implementation HWMCommunityProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title=NSLocalizedString(@"社区提案", nil);
    
    self.baseScroView.contentSize = CGSizeMake( self.view.bounds.size.width,self.view.bounds.size.height *6);
    [self makeUI];
    
}
-(void)makeUI{
   UIBarButtonItem *ClickMorenButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cr_search_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(searchVC)];
       self.navigationItem.rightBarButtonItem=ClickMorenButton;
    self.baseScroView.showsHorizontalScrollIndicator =NO;
    self.baseScroView.showsVerticalScrollIndicator=NO;
    [self.allButton setTitle:NSLocalizedString(@"全部", nil) forState:UIControlStateNormal];
    [self.MemberReviewButton setTitle:NSLocalizedString(@"委员评议", nil) forState:UIControlStateNormal];
    [self.publicButton setTitle:NSLocalizedString(@"公示中", nil) forState:UIControlStateNormal];
    [self.executionButton setTitle:NSLocalizedString(@"执行中", nil) forState:UIControlStateNormal];
    [self.completedButton setTitle:NSLocalizedString(@"已完成", nil) forState:UIControlStateNormal];
    [self.abolishedButton setTitle:NSLocalizedString(@"已废止", nil) forState:UIControlStateNormal];
    [self allButtonStateNormal];
    [self StateSelectedWithButton:self.allButton withNormalView:self.allView];
    [self.baseScroView addSubview:self.allBaseView];
    [self.allBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScroView.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(@(AppWidth));
    }];
    [self.baseScroView addSubview:self.MemberReviewBaseView];
    [self.MemberReviewBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.allBaseView);
        
        make.width.mas_equalTo(@(AppWidth));
        make.left.equalTo(self.allBaseView.mas_right).offset(0);
    }];
    [self.baseScroView addSubview:self.publicBaseView];
    [self.publicBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.allBaseView);
        make.width.mas_equalTo(@(AppWidth));
        make.left.equalTo(self.MemberReviewBaseView.mas_right).offset(0);
    }];
    [self.baseScroView addSubview:self.executionBaseView];
    [self.executionBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.allBaseView);
        make.width.mas_equalTo(@(AppWidth));
        make.left.equalTo(self.publicBaseView.mas_right).offset(0);
    }];
    [self.baseScroView addSubview:self.completedBaseView];
    [self.completedBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.allBaseView);
        make.width.mas_equalTo(@(AppWidth));
        make.left.equalTo(self.executionBaseView.mas_right).offset(0);
    }];
    [self.baseScroView addSubview:self.abolishedBaseView];
    [self.abolishedBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.allBaseView);
        make.width.mas_equalTo(@(AppWidth));
        make.left.equalTo(self.completedBaseView.mas_right).offset(0);
    }];
}
-(UIImageView *)placeHolferImage
{
    if (!_placeHolferImage) {
        _placeHolferImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"no_proposal"]];
        UILabel *textLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 160, 160, 40)];
        textLable.textColor=RGB(149, 159, 171);
        textLable.textAlignment=NSTextAlignmentCenter;
        textLable.text=NSLocalizedString(@"暂无提案", nil);
        [_placeHolferImage addSubview:textLable];
    }
    return _placeHolferImage;
    
}
- (IBAction)buttonChangeEvent:(id)sender {
    UIButton *button=sender;
    NSInteger buttonTag=button.tag;
    [self allButtonStateNormal];
    switch (buttonTag) {
        case 10:
            [self StateSelectedWithButton:self.allButton withNormalView:self.allView];
            break;
        case 11:
            [self StateSelectedWithButton:self.MemberReviewButton withNormalView:self.MemberReviewView];
            break;
        case 12:
            [self StateSelectedWithButton:self.publicButton withNormalView:self.publicView];
            break;
        case 13:
            [self StateSelectedWithButton:self.executionButton withNormalView:self.executionView];
            break;
        case 14:
            [self StateSelectedWithButton:self.completedButton withNormalView:self.completedView];
            break;
        case 15:
            [self StateSelectedWithButton:self.abolishedButton withNormalView:self.abolishedView];
            break;
        default:
            break;
    }
    [self showContextViewWithTag:buttonTag-10];
    
}
-(void)showContextViewWithTag:(NSInteger)tag{
    
    [self.baseScroView setContentOffset:CGPointMake(tag*AppWidth,0) animated:YES];
    self.baseScroView.bouncesZoom = NO;
}
-(void)allButtonStateNormal{
    [self StateNormalWithButton:self.allButton withNormalView:self.allView];
    [self StateNormalWithButton:self.MemberReviewButton withNormalView:self.MemberReviewView];
    [self StateNormalWithButton:self.publicButton withNormalView:self.publicView];
    [self StateNormalWithButton:self.executionButton withNormalView:self.executionView];
    [self StateNormalWithButton:self.completedButton withNormalView:self.completedView];
    [self StateNormalWithButton:self.abolishedButton withNormalView:self.abolishedView];
}
-(void)StateNormalWithButton:(UIButton*)button withNormalView:(UIView*)subView{
    [button setTitleColor:RGBA(255, 255, 225, 0.5) forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:11];
    subView.alpha=0.f;
    
}
-(void)StateSelectedWithButton:(UIButton*)button withNormalView:(UIView*)subView{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:13];
    subView.alpha=1.f;
    
}
-(HWMCommunityProposalBaseView *)allBaseView{
    if (!_allBaseView) {
        _allBaseView=[[HWMCommunityProposalBaseView alloc]init];
        _allBaseView.delegate=self;
    }
    return _allBaseView;
}
-(HWMCommunityProposalBaseView *)MemberReviewBaseView{
    if (!_MemberReviewBaseView) {
        _MemberReviewBaseView=[[HWMCommunityProposalBaseView alloc]init];
        _MemberReviewBaseView.delegate=self;
    }
    return _MemberReviewBaseView;
}
-(HWMCommunityProposalBaseView *)publicBaseView{
    if (!_publicBaseView) {
        _publicBaseView=[[HWMCommunityProposalBaseView alloc]init];
        _publicBaseView.delegate=self;
    }
    return _publicBaseView;
}
-(HWMCommunityProposalBaseView *)executionBaseView{
    if (!_executionBaseView) {
        _executionBaseView=[[HWMCommunityProposalBaseView alloc]init];
        _executionBaseView.delegate=self;
    }
    return _executionBaseView;
}
-(HWMCommunityProposalBaseView *)completedBaseView{
    if (!_completedBaseView) {
        _completedBaseView=[[HWMCommunityProposalBaseView alloc]init];
        _completedBaseView.delegate=self;
    }
    return _completedBaseView;
}
-(HWMCommunityProposalBaseView *)abolishedBaseView{
    if (!_abolishedBaseView) {
        _abolishedBaseView=[[HWMCommunityProposalBaseView alloc]init];
        _abolishedBaseView.delegate=self;
    }
    return _abolishedBaseView;
}
-(void)searchVC{
    HWMCRsearchViewController  *searchVC=[[HWMCRsearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:NO];
}
-(void)didShowDetailsWithIndex:(NSInteger)index{
HWMCommentPerioDetailsViewController *CommentPerioDetailsVC=[[HWMCommentPerioDetailsViewController alloc]init];
    [self.navigationController pushViewController:CommentPerioDetailsVC animated:YES];
    
}
@end
