//
//  HWMSignThePurseHeadView.h
//  elastos wallet
//
//  Created by 韩铭文 on 2019/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWMSignThePurseHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *changeNumberSignatureButton;
@property (weak, nonatomic) IBOutlet UITextField *walletNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addPurseButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

NS_ASSUME_NONNULL_END