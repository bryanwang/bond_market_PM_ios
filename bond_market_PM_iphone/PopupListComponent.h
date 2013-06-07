//
//  PopupListComponent.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

// you keep this copyright and license notice intact.


#import <Foundation/Foundation.h>

@protocol PopupListComponentDelegate;

@interface PopupListComponent : NSObject

@property int textPaddingHorizontal;
@property int textPaddingVertical;
@property int imagePaddingHorizontal;
@property int imagePaddingVertical;
@property int buttonSpacing;

@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* textHilightedColor;

@property UIControlContentHorizontalAlignment alignment;
@property UIPopoverArrowDirection allowedArrowDirections;

//blocks
@property (nonatomic, strong) void(^choosedItemCallback)  (int itemId);
@property (nonatomic, strong) void(^popupDismissedCallback)  ();

//methods
- (id) init;
- (void) showAnchoredTo: (UIView*)sourceItem withItems:(NSArray*)itemList;
- (void) hide;

@end

@interface PopupListComponentItem : NSObject

@property (nonatomic, strong) NSString* caption;
@property (nonatomic, strong) UIImage* image;
@property int itemId;

- (id) initWithCaption:(NSString*)caption image:(UIImage*)image itemId:(int)itemId;

@end



