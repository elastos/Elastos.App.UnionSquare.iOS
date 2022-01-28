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


#import "WYVoteDetailsCollectionViewCell.h"
#import "WYVoteDetailsTableViewCell.h"
#import "WYVoteDetailsListViewCellType1.h"
#import "WYVoteDetailsListViewCellType2.h"
#import "ELACouncilAndSecretariatModel.h"
#import "HWMCRListModel.h"

static NSString *tableCellID = @"CellForTable";
static NSString *listCellIDType1 = @"Type1CellForList";
static NSString *listCellIDType2 = @"Type2CellForList";

@interface WYVoteDetailsCollectionViewCell () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *listView;

@property (strong, nonatomic) NSString *cellType;
@property (strong, nonatomic) NSString *cellTimestamp;
@property (strong, nonatomic) NSString *cellAmount;
@property (strong, nonatomic) NSArray *cellInfo;

@end

@implementation WYVoteDetailsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILayoutGuide *margin = self.layoutMarginsGuide;
        
        UIView *containerView = [[UIView alloc] init];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        containerView.backgroundColor = RGBA(0.f, 0.f, 0.f, 0.5f);
        [[HMWCommView share] makeBordersWithView:containerView];
        [self addSubview:containerView];
        
        [NSLayoutConstraint activateConstraints:@[
            [containerView.topAnchor constraintEqualToAnchor:margin.topAnchor],
            [containerView.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
            [containerView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor],
            [containerView.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor]
        ]];
        
        UILayoutGuide *containerMargin = containerView.layoutMarginsGuide;
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.scrollEnabled = NO;
        [containerView addSubview:self.tableView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.tableView.topAnchor constraintEqualToAnchor:containerMargin.topAnchor],
            [self.tableView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
            [self.tableView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor]
        ]];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[WYVoteDetailsTableViewCell class] forCellReuseIdentifier:tableCellID];
        
        UILayoutGuide *tableMargin = self.tableView.layoutMarginsGuide;
        
        UICollectionViewFlowLayout *listLayout = [[UICollectionViewFlowLayout alloc] init];
        [listLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        listLayout.estimatedItemSize = CGSizeMake(1.f, 1.f);
        
        self.listView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:listLayout];
        self.listView.translatesAutoresizingMaskIntoConstraints = NO;
        self.listView.backgroundColor = [UIColor clearColor];
        self.listView.showsVerticalScrollIndicator = YES;
        self.listView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [containerView addSubview:self.listView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.listView.topAnchor constraintEqualToAnchor:self.tableView.bottomAnchor],
            [self.listView.leadingAnchor constraintEqualToAnchor:tableMargin.leadingAnchor],
            [self.listView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
            [self.listView.bottomAnchor constraintEqualToAnchor:containerMargin.bottomAnchor]
        ]];
        
        self.listView.delegate = self;
        self.listView.dataSource = self;
        [self.listView registerClass:[WYVoteDetailsListViewCellType1 class] forCellWithReuseIdentifier:listCellIDType1];
        [self.listView registerClass:[WYVoteDetailsListViewCellType2 class] forCellWithReuseIdentifier:listCellIDType2];
    }
    return self;
}

- (void)reloadData {
    if (self.cellData) {
        self.cellType = self.cellData[@"type"];
        self.cellTimestamp = self.cellData[@"timestamp"];
        self.cellAmount = self.cellData[@"amount"];
        
        NSMutableArray *payloadInfo = [[NSMutableArray alloc] init];
        NSMutableArray *foundKeys = [[NSMutableArray alloc] init];
        
        NSDictionary *payload = self.cellData[@"payload"];
        NSMutableArray *payloadAddrs = [[NSMutableArray alloc] init];
        for (NSString *key in payload) {
            [payloadAddrs addObject:key];
        }
        
        NSArray *allInfo = self.cellData[@"allInfo"];
        
        NSDictionary *validPayload = self.cellData[@"validPayload"];
        NSMutableArray *validAddrs = [[NSMutableArray alloc] init];
        for (NSString *key in validPayload) {
            [validAddrs addObject:key];
        }
        
        for (NSDictionary *item in allInfo) {
            NSString *key = item[@"key"];
            if ([payloadAddrs containsObject:key]) {
                NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                info[@"address"] = key;
                info[@"amount"] = payload[key];
                info[@"type"] = self.cellType;
                if ([validAddrs containsObject:key]) {
                    info[@"valid"] = @YES;
                } else {
                    info[@"valid"] = @NO;
                }
                info[@"info"] = item[@"item"];
                
                [payloadInfo addObject:info];
                [foundKeys addObject:key];
            }
        }
        
        for (NSString *key in payloadAddrs) {
            if (![foundKeys containsObject:key]) {
                NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                info[@"address"] = key;
                info[@"amount"] = payload[key];
                info[@"type"] = self.cellType;
                info[@"valid"] = @NO;
                info[@"info"] = nil;
                
                [payloadInfo addObject:info];
            }
        }
        
        //        for (NSString *key in payload) {
        //            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        //            info[@"address"] = key;
        //            info[@"amount"] = payload[key];
        //            info[@"type"] = self.cellType;
        //            if ([validAddrs containsObject:key]) {
        //                info[@"valid"] = @YES;
        //            } else {
        //                info[@"valid"] = @NO;
        //            }
        //            info[@"info"] = allInfo[key];
        //
        //            [payloadInfo addObject:info];
        //        }
        self.cellInfo = payloadInfo;
    } else {
        self.cellType = nil;
        self.cellTimestamp = nil;
        self.cellAmount = nil;
        self.cellInfo = nil;
    }
    
    [self.tableView reloadData];
    [self.tableView.heightAnchor constraintEqualToConstant:([self.tableView numberOfRowsInSection:0] * 44.f)].active = YES;
    [self.listView reloadData];
    if ([self.cellType isEqualToString:@"Delegate"] || [self.cellType isEqualToString:@"CRC"]) {
        UILayoutGuide *tableMargin = self.tableView.layoutMarginsGuide;
        [self.listView.trailingAnchor constraintEqualToAnchor:tableMargin.trailingAnchor].active = YES;
        self.listView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, -3.f);
    } else {
        [self.listView.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
        self.listView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 2.f);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.cellType isEqualToString:@"Delegate"] || [self.cellType isEqualToString:@"CRC"]) {
        return 5;
    } else if ([self.cellType isEqualToString:@"CRCImpeachment"]) {
        return 4;
    } else if ([self.cellType isEqualToString:@"CRCProposal"]) {
        return 3;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYVoteDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:tableCellID];
    if (indexPath.row == 0) {
        cell.cellTitle.text = NSLocalizedString(@"投票类型", nil);
        if ([self.cellType isEqualToString:@"Delegate"]) {
            cell.cellContent.text = NSLocalizedString(@"DPoS节点选举", nil);
        } else if ([self.cellType isEqualToString:@"CRC"]) {
            cell.cellContent.text = NSLocalizedString(@"CR委员选举", nil);
        } else if ([self.cellType isEqualToString:@"CRCImpeachment"]) {
            cell.cellContent.text = NSLocalizedString(@"CR委员弹劾", nil);
        } else if ([self.cellType isEqualToString:@"CRCProposal"]) {
            cell.cellContent.text = NSLocalizedString(@"社区提案反对票", nil);
        }
    } else if (indexPath.row == 1) {
        cell.cellTitle.text = NSLocalizedString(@"投票时间", nil);
        if (self.cellTimestamp) {
            cell.cellContent.text = [[FLTools share] YMDHMSgetTimeFromTimesTamp:self.cellTimestamp];
        }
    } else if (indexPath.row == 2) {
        if ([self.cellType isEqualToString:@"CRCProposal"]) {
            cell.cellTitle.text = NSLocalizedString(@"反对提案", nil);
            cell.cellContent.text = @"";
        } else {
            cell.cellTitle.text = NSLocalizedString(@"剩余有效期", nil);
            
            if ([self.cellType isEqualToString:@"CRCImpeachment"]) {
                
                NSInteger endDate = 0;
                if ([self.cellInfo count] > 0) {
                    NSDictionary *firstInfo = [self.cellInfo objectAtIndex:0];
                    if (firstInfo[@"info"]) {
                        ELACouncilModel *info = firstInfo[@"info"];
                        endDate = info.endDate;
                    }
                }
                
                NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
                NSInteger currentDate = [[NSNumber numberWithDouble:currentTimestamp] integerValue];
                
                if (currentDate <= endDate) {
                    NSString *duration = [NSString stringWithFormat:@"%ld", endDate - currentDate];
                    cell.cellContent.text = [[FLTools share] RemainingTimeFormatting:duration];
                } else {
                    cell.cellContent.alpha = 0.f;
                    cell.invalidButton.alpha = 1.f;
                }
                
            } else if ([self.cellType isEqualToString:@"CRC"]) {
                
                NSInteger endDate = 0;
                if ([self.cellInfo count] > 0) {
                    NSDictionary *firstInfo = [self.cellInfo objectAtIndex:0];
                    if (firstInfo[@"info"]) {
                        HWMCRListModel *info = firstInfo[@"info"];
                        endDate = info.endDate;
                    }
                }
                
                NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
                NSInteger currentDate = [[NSNumber numberWithDouble:currentTimestamp] integerValue];
                
                if (currentDate <= endDate) {
                    NSString *duration = [NSString stringWithFormat:@"%ld", endDate - currentDate];
                    cell.cellContent.text = [[FLTools share] RemainingTimeFormatting:duration];
                } else {
                    cell.cellContent.alpha = 0.f;
                    cell.invalidButton.alpha = 1.f;
                }
                
            }
        }
    } else if (indexPath.row == 3) {
        if ([self.cellType isEqualToString:@"CRCImpeachment"]) {
            cell.cellTitle.text = NSLocalizedString(@"弹劾名单", nil);
            cell.cellContent.text = @"";
        } else {
            if ([self.cellType isEqualToString:@"Delegate"]) {
                cell.cellTitle.text = NSLocalizedString(@"票数", nil);
            } else {
                cell.cellTitle.text = NSLocalizedString(@"总票数", nil);
            }
            if (self.cellAmount) {
                cell.cellContent.text = [NSString stringWithFormat:@"%@ ELA", [[FLTools share] elaScaleConversionWith:self.cellAmount]];
            }
        }
    } else if (indexPath.row == 4) {
        if ([self.cellType isEqualToString:@"Delegate"]) {
            cell.cellTitle.text = [NSString stringWithFormat:@"%@ (%ld)", NSLocalizedString(@"节点列表", nil), self.cellInfo.count];
        } else {
            cell.cellTitle.text = [NSString stringWithFormat:@"%@ (%ld)", NSLocalizedString(@"投票列表", nil), self.cellInfo.count];
        }
        cell.cellContent.text = @"";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellInfo.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cellType isEqualToString:@"Delegate"] || [self.cellType isEqualToString:@"CRC"]) {
        WYVoteDetailsListViewCellType1 *cell = [self.listView dequeueReusableCellWithReuseIdentifier:listCellIDType1 forIndexPath:indexPath];
        
        [cell reloadWidth:collectionView.frame.size.width];
        
        cell.backgroundColor = RGBA(255.f, 255.f, 255.f, 0.2f);
        cell.layer.masksToBounds = YES;
        NSInteger cellCount = [collectionView numberOfItemsInSection:indexPath.section];
        if (cellCount < 2) {
            cell.layer.cornerRadius = 5.f;
        } else if (indexPath.item == 0) {
            if (@available(iOS 11.0, *)) {
                cell.layer.cornerRadius = 5.f;
                cell.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
            }
        } else if (indexPath.item == cellCount - 1) {
            if (@available(iOS 11.0, *)) {
                cell.layer.cornerRadius = 5.f;
                cell.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
            }
        } else {
            cell.layer.cornerRadius = 0.f;
        }
        cell.listCellData = [self.cellInfo objectAtIndex:indexPath.row];
        [cell reloadData];
        return cell;
    } else {
        WYVoteDetailsListViewCellType2 *cell = [self.listView dequeueReusableCellWithReuseIdentifier:listCellIDType2 forIndexPath:indexPath];
        
        [cell reloadWidth:collectionView.frame.size.width];
        
        cell.listCellData = [self.cellInfo objectAtIndex:indexPath.row];
        [cell reloadData];
        return cell;
    }
    
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.cellType isEqualToString:@"Delegate"] || [self.cellType isEqualToString:@"CRC"]) {
        return 0.f;
    }
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.cellType isEqualToString:@"Delegate"] || [self.cellType isEqualToString:@"CRC"]) {
//        return CGSizeMake(collectionView.frame.size.width, 44.f);
//    }
//    return CGSizeMake(collectionView.frame.size.width, 105.f);
//}

@end
