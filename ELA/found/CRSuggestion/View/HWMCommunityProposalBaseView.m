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


#import "HWMCommunityProposalBaseView.h"
#import "HWMCommunityProposalBaseTableViewCell.h"
#import "HWMCommentPerioDetailsViewController.h"

static NSString *cellBaseString=@"HWMCommunityProposalBaseTableViewCell";
UINib *_basenib;
@interface HWMCommunityProposalBaseView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *baseTabView;


@end

@implementation HWMCommunityProposalBaseView

-(instancetype)init{
    self =[super init];
    if (self) {
        self =[[NSBundle mainBundle]loadNibNamed:@"HWMCommunityProposalBaseView" owner:nil options:nil].firstObject;
        [self makeView];
    }
    return self;
}
-(void)makeView{
 
    self.baseTabView.separatorStyle= UITableViewCellSeparatorStyleNone;
    _basenib=[UINib nibWithNibName:cellBaseString bundle:nil];
    [self.baseTabView registerNib:_basenib forCellReuseIdentifier:cellBaseString];
    self.baseTabView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    __weak __typeof(self) weakSelf = self;
    MJRefreshHeader *header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//         weakSelf.UNREADNumber=-1;
//        [[FLTools share]setLastReadTime];
//      weakSelf.UNREADNumber=[[FLTools share]readLastReadTime];
//        [weakSelf.MessageList removeAllObjects];
//        [weakSelf.MessageList addObjectsFromArray:[[HMWFMDBManager sharedManagerType:MessageCenterType]allMessageListWithIndex:0]];
//        [weakSelf findNunreadMessageIndexWithFomeIndex:0];
        [weakSelf.baseTabView reloadData];
        [weakSelf.baseTabView.mj_header endRefreshing];
        
    }];
    self.baseTabView.mj_header=header;
    self.baseTabView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        HWMMessageCenterModel *model=weakSelf.MessageList.lastObject;
//        if (model.walletName.length==0) {
//            [weakSelf.MessageList removeLastObject];
//        }
//        if (weakSelf.MessageList.count<weakSelf.allCount) {
//            [weakSelf.MessageList addObjectsFromArray:[[HMWFMDBManager sharedManagerType:MessageCenterType]allMessageListWithIndex:weakSelf.MessageList.count]];
//        }
//        [self findNunreadMessageIndexWithFomeIndex:(int)weakSelf.MessageList.count];
        [weakSelf.baseTabView.mj_footer endRefreshing];
        [weakSelf.baseTabView reloadData];
        
    }];
    self.baseTabView.delegate=self;
     self.baseTabView.dataSource=self;
    [self.baseTabView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 100;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  HWMCommunityProposalBaseTableViewCell *cell=  [_basenib instantiateWithOwner:nil options:nil][0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didShowDetailsWithIndex:)]) {
        [self.delegate didShowDetailsWithIndex:indexPath.row];
    }
    
}
-(void)setDataSourceArray:(NSMutableArray *)dataSourceArray{
    _dataSourceArray=dataSourceArray;
}

@end
