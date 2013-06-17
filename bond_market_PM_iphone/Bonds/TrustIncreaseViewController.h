//
//  TrustIncreaseViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

//平台项目 非平台项目 新债 增信方式不同
typedef enum TrustIncreaseEditStatus: NSUInteger {
    TrustIncreaseEditing,
    TrustIncreaseNormal
}TrustIncreaseEditStatus;

//修改和查看 两种状态
typedef enum TrustIncreaseSpecies: NSUInteger {
    PlatformProjectTrustIncrease,
    NonPlatformProjectTrustIncrease,
    BondTrustIncrease
} TrustIncreaseSpecies;

@interface TrustIncreaseViewController : BBCustomBackButtonViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic)TrustIncreaseEditStatus status;

- (id)initWithTrustIncreaseStatus: (TrustIncreaseSpecies) status;
- (void)bindObject: (NSMutableArray *)trustIncreaseArray;
- (NSMutableArray *)fetchData;

@end
