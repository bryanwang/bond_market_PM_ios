//
//  UseOfFoundsViewController.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UseOfFoundsEditStatus: NSUInteger {
    UseOfFoundsEditing,
    UseOfFoundsNormal
}UseOfFoundsEditStatus;

@interface UseOfFoundsViewController : BBCustomBackButtonViewController
@property (nonatomic) UseOfFoundsEditStatus status;

- (void)bindObject: (NSMutableArray *)useOfFoundsArray;
- (NSMutableArray *)fetchData;

@end
