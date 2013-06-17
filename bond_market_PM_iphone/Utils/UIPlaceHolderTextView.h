//
//  HDTextView.h
//  HaidaoFM_ios
//
//  Created by Bruce Yang on 1/27/13.
//  Copyright (c) 2013 HaidaoFM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) UIColor *realTextColor;

@end


