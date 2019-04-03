//
//  UIViewController+FLVCExt.h
//  FLWALLET
//
//  Created by fxl on 2018/4/17.
//  Copyright © 2018年 fxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FLVCExt)
-(void)defultBack;
-(void)defultWhite;
-(void)NewStateView:(UIColor*)color;
-(void)setBackgroundImg:(NSString*)img;
-(void)setNavBarClearColor;

-(void)CNTOdefultWhite;


-(void)shareArray:(NSArray*)arr;
-(void)shearText:(NSString*)text;
-(void)shareTitle:(NSString*)title content:(NSString*)content images:(NSArray*)imageArray url:(NSURL*)url;
- (void)QRCodeScanVC:(UIViewController *)scanVC ;

- (UIWindow *)mainWindow;
-(void)GotoMainTabBarVC;

-(BOOL)isPhoneNumber:(NSString *)text;
-(BOOL)isMathNumber:(NSString*)text;
-(BOOL)isIdCardNumber:(NSString*)text;
-(BOOL)isPassWord:(NSString*)text;

- (NSString *)aes256_encrypt:(NSString*)text withKey:(NSString *)key;
- (NSString *)aes256_decrypt:(NSString*)text withKey:(NSString *)key;
- (NSString *)getLeftNowTimeWithEndTime:(NSString*)endTime;


-(NSString *)convertToJsonData:(NSDictionary *)dict;
-(void)makeBordersWithView:(UIView*)view;
-(void)NotificationCenter;
-(void)reMovNotificationCenter;
@end