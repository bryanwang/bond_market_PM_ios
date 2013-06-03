//
//  Utils.h
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (Utils *)sharedInstance;

@property (nonatomic, strong) NSArray *arears;

@end


@interface NSObject(BY)
- (void)hideKeyBoard;
@end