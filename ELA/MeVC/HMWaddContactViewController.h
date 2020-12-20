//
//  HMWaddContactViewController.h
//  ELA
//

#import <UIKit/UIKit.h>
#import "friendsModel.h"
#import "HMWtheContactInformationViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, updateOrChangeInfo) {
   updateInfo = 0,
   ChangeInfo,
};

@interface HMWaddContactViewController : UIViewController
/*
 *<# #>
 */
@property(copy,nonatomic)friendsModel *model;
/*
 *<# #>
 */
@property(assign,nonatomic)updateOrChangeInfo  typeInfo;
/*
 *<# #>
 */
@property(copy,nonatomic)NSString *addressString;
@property(copy,nonatomic)NSString *didString;

@property (nonatomic, weak) HMWtheContactInformationViewController *contactInfoVC;

@end

NS_ASSUME_NONNULL_END
