//
//  Utils.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "Utils.h"

void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_main_queue(),  block);
}

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
