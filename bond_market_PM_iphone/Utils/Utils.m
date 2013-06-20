//
//  Utils.m
//  Form_test
//
//  Created by Bruce yang on 13-5-30.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "Utils.h"
#import "define.h"
#import <objc/runtime.h>
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

- (NSArray *)Arears
{
    if (_Arears == nil) {
        _Arears = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    }
    
    return _Arears;
}

- (NSArray *)FinancingArray
{
    return @[
             @"银行贷款",
             @"信托",
             @"债券",
             @"股权质押",
             @"委托贷款",
             @"融资租赁",
             @"大股东支持",
             @"注册资本金",
             @"项目盈利",
             @"其他"
             ];
}

- (NSArray *)LandAndEstateProperties
{
    return @[
                    @"商业",
                    @"住宅"
                ];
}


- (NSArray *)SecurityWays
{
    return @[
                 @"全额无条件不可撤销连带责任",
                 @"有限责任",
                 @"部分担保"
                 ];
}

- (NSArray *)EnhancementsProperties
{
    return @[
             @"偿债基金",
             @"结构化分级"
             ];
}

- (NSArray *)ApprovalTypes
{
    return @[
            @"发改委批文",
            @"环评",
            @"用地许可"
            ];
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


@implementation QuickDialogHelper

+ (QuickDialogHelper *)sharedInstance
{
    static QuickDialogHelper *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken,^{
        sharedInstance = [[QuickDialogHelper alloc] init];
    });
    
    return sharedInstance;
}

const char ArearsPickerSelectedProvincey;
const char ArearsPickerSelectedCity;

- (NSArray *)fetchProvinces
{
    @autoreleasepool {
        NSArray *ps = [Utils sharedInstance].Arears;
        NSMutableArray *array = [NSMutableArray array];
        [ps enumerateObjectsUsingBlock:^(id p, NSUInteger index, BOOL*stop) {
            [array addObject:p[@"state"]];
        }];
        
        return [array copy];
    }
}

- (NSArray *)fetchCitiesWithProvincesIndex: (NSInteger)index
{
    @autoreleasepool {
        NSArray *cs = [Utils sharedInstance].Arears[index][@"cities"];
        NSMutableArray *array = [NSMutableArray array];
        [cs enumerateObjectsUsingBlock:^(id c, NSUInteger index, BOOL*stop) {
            [array addObject:c[@"city"]];
        }];
        
        return [array copy];
    }
}

- (NSArray *)fetchAreasWithCityIndex: (NSInteger)cindex AndProvincesIndex: (NSInteger )pindex
{
    @autoreleasepool {
        NSArray *as  =[Utils sharedInstance].Arears[pindex][@"cities"][cindex][@"areas"];
        NSMutableArray *array = [NSMutableArray array];
        [as enumerateObjectsUsingBlock:^(id a, NSUInteger index, BOOL*stop) {
            [array addObject:a];
        }];
        
        if (array.count == 0) {
            [array addObject:@""];
        }
        
        return  [array copy];
    }
}

- (void)setUpArearsPickerRoles:(QPickerElement *)picker
{
    __block id selectedProvince = objc_getAssociatedObject(picker, &ArearsPickerSelectedProvincey);
    __block id selectedCity = objc_getAssociatedObject(picker, &ArearsPickerSelectedCity);
    
    if(selectedProvince == nil) {
        selectedProvince = @0;
        objc_setAssociatedObject(picker, &ArearsPickerSelectedProvincey, selectedProvince, OBJC_ASSOCIATION_RETAIN);
    }
    
    if(selectedCity == nil) {
        selectedCity = @0;
        objc_setAssociatedObject(picker, &ArearsPickerSelectedCity, selectedProvince, OBJC_ASSOCIATION_RETAIN);
    }
    
    
    __block NSArray *provinces = [self fetchProvinces];
    __block  NSArray *cities = [self fetchCitiesWithProvincesIndex: [selectedProvince integerValue]];
    __block  NSArray *areas = [self fetchAreasWithCityIndex:[selectedCity integerValue] AndProvincesIndex:[selectedProvince integerValue]];

    picker.items =  @[provinces, cities, areas];
    picker.onValueChanged = ^(QRootElement *el) {
        QPickerElement *p =  (QPickerElement *)el;
        //provinces selected index
        NSNumber *pi = p.selectedIndexes[0];
        //cities selected index
        NSNumber *ci = p.selectedIndexes[1];
        if ([pi integerValue] != [selectedProvince integerValue]) { //if provinces selected index changed, set cities and areas selected index to 0
            [p selectRow:0 inComponent:1 animated:NO];
            [p selectRow:0 inComponent:2 animated:NO];
            
            selectedCity = @0;
            selectedProvince = pi;
        } else if ([ci integerValue] != [selectedCity integerValue]) {//if cities selected index changed, set areas selected index to 0
            [p selectRow:0 inComponent:2 animated:NO];
            selectedCity = ci;
        }
        
        cities = [self fetchCitiesWithProvincesIndex:[pi integerValue]];
        areas =  [self fetchAreasWithCityIndex:[ci integerValue] AndProvincesIndex: [pi integerValue]];
        p.items =  @[provinces, cities, areas];
        
        [p reloadAllComponents];
    };
}

- (void)setUpSelectRoleWithAllSelecte:(QSelectSection *)all AndQuerySelect:(QSelectSection *)query WithChangedCallback:(selectChangedCallback)callback
{
    __weak QSelectSection *allsection = all;
    __weak QSelectSection *querysection = query;
    allsection.onSelected = ^{
        NSMutableArray *items = [NSMutableArray array];
        if (allsection.selectedIndexes.count == allsection.items.count) {
            for (QElement *el in querysection.elements) {
                [items addObject: [NSNumber numberWithInt:((QSelectItemElement *)el).index]];
            }
            querysection.selectedIndexes = items;
        } else {
            [querysection setSelectedIndexes:items];
        }
        
        if (callback)
            callback();
    };
    
    querysection.onSelected = ^{
        if (querysection.selectedIndexes.count > 0) {
            [allsection setSelectedIndexes:[NSMutableArray array]];
        }
        
        if (callback)
            callback();
    };
}

- (id)convertJSONStrToObject: (NSString *)str
{
    NSError *error;
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error)
        return obj;
    else
        return nil;
}


- (NSString *)convertObjectToJSONStr:(id)obj
{
    NSError *error = nil;
    NSData *data;
    NSString *JsonStr;
    data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (data)
         JsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!error)
        return JsonStr;
    else
        return  nil;
}


- (NSDateFormatter *)fulldateFormater
{
    if (_fulldateFormater == nil) {
        _fulldateFormater = [[NSDateFormatter alloc] init];
        [_fulldateFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }

    return _fulldateFormater;
}

- (NSDateFormatter *)dateFormater
{
    if (_dateFormater == nil) {
        _dateFormater = [[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"yyyy-MM-dd"];
    }
    
    return _dateFormater;
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

@implementation NSString(BY)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

@implementation UIBarButtonItem (BY)

+ (UIBarButtonItem *)redBarButtonItemWithtitle:(NSString *)title
                                        target:(id)target
                                      selector:(SEL)selector
{
    UIBarButtonItem *redButton =   [self barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"]
                highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"]
                          target:target
                        selector:selector];
    ((UIButton *)redButton.customView).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [((UIButton *)redButton.customView) setTitle:title forState:UIControlStateNormal];
    [((UIButton *)redButton.customView) setTintColor: RGBCOLOR(255, 255, 255)];

    return redButton;
}

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

@implementation UIFont(BY)

+ (UIFont *)BertholdFontOfSize:(CGFloat)size
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"Berthold Akzidenz Grotesk BE Condensed" withExtension:@"ttf"];
		CFErrorRef error;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
        error = nil;
    });
    
    return [UIFont fontWithName:@"Berthold Akzidenz Grotesk BE" size:size];
}

@end

static NSString *USER_DEFAULTS_MOBILE_KEY  = @"mobile";
static NSString * USER_DEFAULTS_ID_KEY = @"userid";

@implementation LoginManager

+ (LoginManager *)sharedInstance
{
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken,^{
        sharedInstance = [[LoginManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)saveLoginUserInfo:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"Id"] forKey:USER_DEFAULTS_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"MobliePhone"]  forKey:USER_DEFAULTS_MOBILE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)fetchUserId
{
    //由于服务端没做 用户验证 所以 获取个人信息的所有接口 都要传递userId 参数...
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ID_KEY];
}

- (NSString *)fetchUserMobile
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_MOBILE_KEY];
}

@end