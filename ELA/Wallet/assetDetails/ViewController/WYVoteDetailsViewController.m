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


#import "WYVoteDetailsViewController.h"
#import "WYVoteDetailsCollectionViewCell.h"

static NSString *cellID = @"WYVoteDetailsCell";

@interface WYVoteDetailsViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *slideView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *dataArr;

@end

@implementation WYVoteDetailsViewController

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    UICollectionViewFlowLayout *slideLayout = [[UICollectionViewFlowLayout alloc] init];
    [slideLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.slideView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:slideLayout];
    self.slideView.translatesAutoresizingMaskIntoConstraints = NO;
    self.slideView.backgroundColor = [UIColor clearColor];
    self.slideView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.slideView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.slideView.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [self.slideView.topAnchor constraintEqualToAnchor:margin.topAnchor constant:20.f],
        [self.slideView.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor constant:-100.f],
        [self.slideView.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor],
        [self.slideView.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor]
    ]];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.pageControl.centerXAnchor constraintEqualToAnchor:margin.centerXAnchor],
        [self.pageControl.topAnchor constraintEqualToAnchor:self.slideView.bottomAnchor constant:5.f]
    ]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@""];
    self.title = NSLocalizedString(@"投票详情", nil);
    WYLog(@"Vote Data: %@", self.voteData);
    [self processData];
    self.pageControl.numberOfPages = self.dataArr.count;
    self.slideView.delegate = self;
    self.slideView.dataSource = self;
    [self.slideView registerClass:[WYVoteDetailsCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.slideView setPagingEnabled:YES];
}

- (void)processData {
    NSDictionary *votePayloads = self.voteData[@"votePayloads"];
    NSDictionary *voteTimestamps = self.voteData[@"voteTimestamps"];
    NSDictionary *voteAmounts = self.voteData[@"voteAmounts"];
    NSDictionary *validPayloads = self.voteData[@"validPayloads"];
    NSDictionary *allInfo = self.voteData[@"allInfo"];
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSString *key in @[@"Delegate", @"CRC", @"CRCImpeachment", @"CRCProposal"]) {
        NSDictionary *keyPayload = votePayloads[key];
        if (keyPayload.count > 0) {
            NSDictionary *dataDic = @{
                @"type": key,
                @"payload": votePayloads[key],
                @"timestamp": voteTimestamps[key],
                @"amount": voteAmounts[key],
                @"validPayload": validPayloads[key],
                @"allInfo": allInfo[key]
            };
            [dataArr addObject:dataDic];
        }
    }
    self.dataArr = dataArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYVoteDetailsCollectionViewCell *cell = [self.slideView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.cellData = [self.dataArr objectAtIndex:indexPath.item];
    [cell reloadData];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(round(scrollView.contentOffset.x / self.slideView.frame.size.width));
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
