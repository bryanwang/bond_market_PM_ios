//
//  PopupListComponent.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "PopupListComponent.h"
#import "WEPopoverController.h"


#define DEFAULT_FONT         [UIFont systemFontOfSize:16]
#define DEFAULT_FONT_COLOR         RGBCOLOR(255, 255, 255)
#define DEFAULT_FONT_COLOR_SELECTED  RGBCOLOR(221, 221, 221)
#define DEFAULT_BUTTON_SPACING      10
#define DEFAULT_TEXT_PADDING_H      10
#define DEFAULT_TEXT_PADDING_V      10
#define DEFAULT_iMAGE_PADDING_H  10
#define DEFAULT_iMAGE_PADDING_V  10

@implementation PopupListComponentItem

- (id) initWithCaption:(NSString*)caption image:(UIImage*)image itemId:(int)itemId;
{
    self = [super init];
    if (self) {
        _caption = caption;
        _image = image;
        _itemId = itemId;
    }
    return self;
}

@end


@interface PopupListComponent() <WEPopoverControllerDelegate>

@property (nonatomic, strong) WEPopoverController* myPopover;

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController;
- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController;

@end

@implementation PopupListComponent

- (id) init
{
    self = [super init];
    if (self) {
        self.font = DEFAULT_FONT;
        self.textColor = DEFAULT_FONT_COLOR;
        self.textHilightedColor = DEFAULT_FONT_COLOR_SELECTED;
        self.buttonSpacing = DEFAULT_BUTTON_SPACING;
        self.textPaddingHorizontal = DEFAULT_TEXT_PADDING_H;
        self.textPaddingVertical = DEFAULT_TEXT_PADDING_V;
        self.imagePaddingHorizontal = DEFAULT_iMAGE_PADDING_H;
        self.imagePaddingVertical = DEFAULT_iMAGE_PADDING_V;
        self.alignment = UIControlContentHorizontalAlignmentCenter;
        self.allowedArrowDirections = UIPopoverArrowDirectionUp;
    }
    return self;
}


- (void) showAnchoredTo: (UIView*)sourceItem withItems:(NSArray*)itemList
{
    if (self.myPopover && [self.myPopover isPopoverVisible]) {
        return;
    }
    if(!self.myPopover) {

        UIViewController *viewCon = [[UIViewController alloc] init];
        UIView* contents = [self makeContentsFromItemList: itemList];
        viewCon.view = contents;
        viewCon.contentSizeForViewInPopover = contents.frame.size;         
        self.myPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        
        [self.myPopover setDelegate:self];
    } 
    
   CGRect anchorRect = sourceItem.frame;
    [self.myPopover presentPopoverFromRect: anchorRect
                                    inView: sourceItem.superview
                  permittedArrowDirections: self.allowedArrowDirections
                                  animated: YES];
}


-(void) hide 
{
    [self manualDismissPopover];
}


#pragma  ui elements
- (UIButton*)makeButtonForItem: (PopupListComponentItem*)item
                        yOffset: (int)yoffset  xOffset:(int)xOffset
              withButtonMaxSize: (CGSize) buttonFrameSize
{
    CGRect frame = CGRectMake(0, 0, buttonFrameSize.width, buttonFrameSize.height);
    
    CGRect buttonFrame = CGRectMake(xOffset, yoffset, frame.size.width, frame.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    if (item.image) {
        [button setImage:item.image forState:UIControlStateNormal];
    }
    if (item.caption) {
        
        UIColor* textColor = self.textColor;
        UIColor* textColorActive = self.textHilightedColor;
        
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setTitleColor:textColorActive forState:UIControlStateHighlighted];
        [button setTitle:item.caption forState:UIControlStateNormal];
        button.titleLabel.font = self.font;
        button.contentHorizontalAlignment =  self.alignment;
    }
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(self.imagePaddingVertical, self.imagePaddingHorizontal,
                                                self.imagePaddingVertical, self.imagePaddingHorizontal);
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(self.textPaddingVertical, self.textPaddingHorizontal,
                                                self.textPaddingVertical, self.textPaddingHorizontal);
    if (item.image) {
        button.imageEdgeInsets = imageInsets;
    }
    if (item.caption) {
        if (item.image) {
            titleInsets.left = titleInsets.left + imageInsets.left + imageInsets.right;
        }
        button.titleEdgeInsets = titleInsets;
    }
    
    
    button.tag = item.itemId;
    [button addTarget:self action:@selector(choosedItemCallback:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (CGSize)calculateNeededButtonSize: (NSArray*) popupListComponentItems
{
    CGSize globalMax = CGSizeMake(0, 0);
    
    for (PopupListComponentItem* item in popupListComponentItems) {
        
        CGSize imageSize = CGSizeMake(0, 0);
        CGSize textSize = CGSizeMake(0, 0);
        
        if (item.image) {
            CGSize size = [item.image size];
            NSInteger x = size.width  + 2*self.imagePaddingHorizontal;
            NSInteger y = size.height + 2*self.imagePaddingVertical;
            imageSize.width = x;
            imageSize.height = y;
        }
        
        if (item.caption) {
            CGSize size;
            if (item.caption.length < 3)
                size = [@"MM." sizeWithFont: self.font];
            else
                size = [item.caption sizeWithFont: self.font];
            
            NSInteger x = size.width  + 2*self.textPaddingHorizontal;
            NSInteger y = size.height + 2*self.textPaddingVertical;
            textSize.width = x;
            textSize.height = y;
        }
        
        CGSize itemSize;
        if (item.image && item.caption) {
            itemSize = CGSizeMake(imageSize.width + textSize.width, MAX(imageSize.height, textSize.height));
        }
        else if (item.image) {
            itemSize = imageSize;
        }
        else {
            itemSize = textSize;
        }
        
        globalMax.width  = MAX(itemSize.width, globalMax.width);
        globalMax.height = MAX(itemSize.height, globalMax.height);
    }
    
    return globalMax;
}


- (UIView*)makeContentsFromItemList:(NSArray*) popupListComponentItems
{
    int numButtons = popupListComponentItems.count;
    
    CGSize buttonFrameSize = [self calculateNeededButtonSize:popupListComponentItems];
    NSMutableArray* buttonArray = [[NSMutableArray alloc] initWithCapacity: numButtons];
    NSInteger maxY = 0;
    NSInteger maxX = 0;
    NSInteger yoffset = 0;
    
    for (PopupListComponentItem* item in popupListComponentItems) {
        UIButton* option = [self makeButtonForItem:item yOffset:yoffset  xOffset:0 withButtonMaxSize: buttonFrameSize];
        CGPoint origin = option.frame.origin;
        CGSize size = option.frame.size;
        if (maxY < origin.y + size.height) {
            maxY = origin.y + size.height;
        }
        if (maxX < origin.x + size.width) {
            maxX = origin.x + size.width;
        }
        [buttonArray addObject:option];
        
        yoffset += size.height + self.buttonSpacing;
    }
    
    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, maxX, maxY)];
    for (int i=0; i<numButtons; i++) {
        UIButton* b = (UIButton*) [buttonArray objectAtIndex:i];
        [view addSubview:b];
    }
    
    return view;
}

#pragma action
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{    
    [self.myPopover setDelegate:nil];
    self.myPopover = nil;
    if (self.popupDismissedCallback)
        self.popupDismissedCallback();
}


- (void)choosedItemCallback: (id) sender
{
    UIButton* b = (UIButton*) sender;
    NSInteger tag = b.tag;
    if (self.choosedItemCallback)
        self.choosedItemCallback(tag);
}

- (void)manualDismissPopover
{
    [self.myPopover dismissPopoverAnimated:YES];
    [self.myPopover setDelegate:nil];
    self.myPopover = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController
{
    return YES;
}

@end
