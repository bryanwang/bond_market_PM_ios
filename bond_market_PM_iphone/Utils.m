//
//  Utils.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "Utils.h"
#import <AFHTTPClient.h>

void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_main_queue(),  block);
}

@implementation PMHttpClient

+ (PMHttpClient *)shareIntance
{
    static PMHttpClient *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken,^{
        sharedInstance = [[PMHttpClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *) url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end

@implementation Utils

- (NSArray *)arears
{
    if (_arears == nil) {
        _arears = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    }
    
    return _arears;
}

+ (Utils *)sharedInstance
{
    static Utils *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken,^{
        sharedInstance = [[Utils alloc] init];
    });
    
    return sharedInstance;
}
@end

@implementation NSObject(BY)

//隐藏键盘
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

@end

@implementation UIBarButtonItem (BY)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)normalImage
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                   selector:(SEL)selector
{
    CGRect imageFrame = CGRectZero;
	imageFrame.size = normalImage.size;
    
	UIButton *innerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    innerButton.frame = imageFrame;
	[innerButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [innerButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [innerButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
	barButtonItem.target = target;
	barButtonItem.action = selector;
    
	return barButtonItem;
}

+ (NSArray *)barButtonItemWithUnpaddedImage:(UIImage *)normalImage
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                   selector:(SEL)selector
{
    NSMutableArray *barItems = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    [barItems addObject:negativeSpacer];
    [barItems addObject:[UIBarButtonItem barButtonItemWithImage:normalImage
                                               highlightedImage:highlightedImage
                                                         target:target selector:selector]];
    [barItems addObject:negativeSpacer];
    
    return barItems;
}


@end