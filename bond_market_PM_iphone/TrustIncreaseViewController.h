//
//  TrustIncreaseViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum TrustIncreaseEditStatus: NSUInteger {
    TrustIncreaseEditing,
    TrustIncreaseNormal
}TrustIncreaseEditStatus;

@interface TrustIncreaseViewController : BBCustomBackButtonViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *trustIncreaseArray;
@property (nonatomic)TrustIncreaseEditStatus status;
@end
