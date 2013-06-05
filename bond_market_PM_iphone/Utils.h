//
//  Utils.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface Utils : NSObject
+ (Utils *)sharedInstance;

@property (nonatomic, strong) NSArray *arears;

@end


@interface NSObject(BY)
- (void)hideKeyBoard;
@end


@interface PMHttpClient : AFHTTPClient

+ (PMHttpClient *)shareIntance;

@end



@interface UIBarButtonItem (BY)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)normalImage
                           highlightedImage:(UIImage *)highlightedImage
                                     target:(id)target
                                   selector:(SEL)selector;


@end

@interface UIFont(BY)

+ (UIFont *)BertholdFontOfSize:(CGFloat)size;

@end