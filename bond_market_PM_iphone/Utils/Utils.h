//
//  Utils.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void));

@interface Utils : NSObject
+ (Utils *)sharedInstance;

@property (nonatomic, strong) NSArray *Arears;
@property (nonatomic, strong) NSArray *FinancingArray;
@property (nonatomic, strong) NSArray *LandAndEstateProperties;
@property (nonatomic, strong) NSArray *EnhancementsProperties;
@property (nonatomic, strong) NSArray *SecurityWays;
@property (nonatomic, strong) NSArray *ApprovalTypes;


@end


@interface QuickDialogHelper: NSObject

+ (QuickDialogHelper *)sharedInstance;

- (void)setUpArearsPickerRoles;

@end

@interface NSObject(BY)
- (void)hideKeyBoard;
@end


@interface PMHttpClient : AFHTTPClient

+ (PMHttpClient *)shareIntance;

@end


@interface NSString(BY)
- (NSString *)trim;
@end


@interface UIBarButtonItem (BY)

+ (UIBarButtonItem *)redBarButtonItemWithtitle: (NSString *)title
                                     target:(id)target
                                      selector:(SEL)selector;


+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)normalImage
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                   selector:(SEL)selector;

@end

@interface UIFont(BY)

+ (UIFont *)BertholdFontOfSize:(CGFloat)size;

@end


@interface LoginManager: NSObject

+ (LoginManager *)sharedInstance;

- (void)saveLoginUserInfo:(NSDictionary *)userInfo;

- (NSString *)fetchUserId;

- (NSString *)fetchUserMobile;

@end