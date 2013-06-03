//
//  HDTextView.m
//  HaidaoFM_ios
//
//  Created by Bruce Yang on 1/27/13.
//  Copyright (c) 2013 HaidaoFM. All rights reserved.
//

#import "HDTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface HDTextView ()

@property (nonatomic, readonly) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation HDTextView
@synthesize placeholder = _placeholder;


- (void)awakeFromNib
{
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius= 0.5f;
}


- (void) setPlaceholder:(NSString *)aPlaceholder {
    _placeholder = aPlaceholder;
    self.text = aPlaceholder;
    [self endEditing:nil];
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
        self.textColor = [UIColor lightGrayColor];
}

- (NSString *) realText {
    return [super text];
}

- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
    }
    self.textColor = [UIColor blackColor];
}

- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.placeholder;
        self.textColor = [UIColor lightGrayColor];
    }
}


@end


@implementation HDTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius= 0.5f;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

@end
