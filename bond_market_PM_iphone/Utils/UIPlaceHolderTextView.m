//
//  HDTextView.m
//  HaidaoFM_ios
//
//  Created by Bruce Yang on 1/27/13.
//  Copyright (c) 2013 HaidaoFM. All rights reserved.
//

#import "UIPlaceHolderTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIPlaceHolderTextView ()

@property (nonatomic, readonly) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation UIPlaceHolderTextView

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) ) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:RGBCOLOR(149, 149, 149)];
        [self setRealTextColor:RGBCOLOR(100, 100, 100)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:RGBCOLOR(149, 149, 149)];
    }
    
    if (!self.realTextColor) {
        [self setRealTextColor:RGBCOLOR(100, 100, 100)];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}


- (void) setPlaceholder:(NSString *)aPlaceholder {
    _placeholder = aPlaceholder;
    self.text = aPlaceholder;
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder])
        return @"";
    return text;
}

- (void) setText:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil)
        super.text = self.placeholder;
    else
        super.text = text;
    
    if ([text isEqualToString:self.placeholder])
        self.textColor = self.placeholderColor;
}

- (NSString *) realText {
    return [super text];
}

- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
    }
    self.textColor = self.realTextColor;
}

- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.placeholder;
        self.textColor = self.placeholderColor;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius= 0.5f;
    self.layer.masksToBounds = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
 
