//
//  define.h
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#ifndef define_h
#define define_h

//web api
//#define BASE_URL @"http://192.168.1.152:7000/"
#define BASE_URL @"http://192.168.1.152:63000/"
#define LOGIN_INTERFACE @"/api/ios/signin"

//bond
#define MY_BONDS_INTERFACE @"/api/ios/newbond/mine"
#define UPDATE_NEWBOND_INTERFACE @"/api/ios/newbond/update"
#define DELETE_NEWBOND_INTERFACE @"/api/ios/newbond/delete"
#define MY_BONDS_INPUTINFO_INTERFACE @"/api/ios/newbond/bonus"

//non-platform project
#define UPDATE_NON_PLATFORM_PROJECT_INTERFACE @"/api/ios/nonplatformproject/update"
#define MY_NONPLATFORM_PROJECTS_INTERFACE @"/api/ios/nonplatformproject/mine"
#define MY_NONPLATFORM_PROJECTS_INPUTINFO_INTERFACE @"/api/ios/nonplatformproject/bonus"

//platformProject
#define UPDATE_PLATFORMPROJECT_INTERFACE @"/api/ios/platformproject/update"
#define MY_PLATFORMPROJECTS_INTERFACE @"/api/ios/platformproject/mine"
#define MY_PLATFORMPROJECTS_INPUTINFO_INTERFACE @"/api/ios/platformproject/bonus"

// return all types of 
#define MY_PROJECTS_INTERFACE @"/api/ios/project/mine"
#define MY_PROJECTS_INPUTINFO_INTERFACE @"/api/ios/project/bonus"


//notification
#define BYPOPVIEWCONTOLLERNOTIFICATION @"popviewcontroller"
#define BYTRUSTINCREASEKEY @"trustincreasedic"
#define BYPROJECTFILTERNOTIFICATION @"filterprojects"
#define BYPROJECTSTATUSFILTERQUERY @"statusfilterquery"
#define BYPROJECTTYPEFILTERQUERY @"typefilterquery"



//basic tools
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 )
#define APP_SCREEN_BOUNDS   [[UIScreen mainScreen] bounds]
#define APP_SCREEN_HEIGHT   (APP_SCREEN_BOUNDS.size.height)
#define APP_SCREEN_WIDTH    (APP_SCREEN_BOUNDS.size.width)
#define APP_STATUS_FRAME    [UIApplication sharedApplication].statusBarFrame
#define APP_CONTENT_WIDTH   (APP_SCREEN_BOUNDS.size.width)
#define APP_CONTENT_HEIGHT  (APP_SCREEN_BOUNDS.size.height-APP_STATUS_FRAME.size.height)
#define APP_ROOT_VIEW [UIApplication sharedApplication].keyWindow.rootViewController.view
#define APP_WINDOW [UIApplication sharedApplication].keyWindow

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define CLEARCOLOR [UIColor clearColor]


//获取View的x、y、宽度、高度
#define	GET_VIEW_X(ctlName)				((ctlName).frame.origin.x)
#define	GET_VIEW_Y(ctlName)				((ctlName).frame.origin.y)
#define	GET_VIEW_WIDTH(ctlName)			((ctlName).frame.size.width)
#define	GET_VIEW_HEIGHT(ctlName)        ((ctlName).frame.size.height)

///设置View的x、y、宽度、高度
#define	SET_VIEW_X(ctlName, newX)	\
{				\
CGRect rect = ctlName.frame;	\
rect.origin.x = (newX);			\
ctlName.frame = rect;			\
}

#define	SET_VIEW_Y(ctlName, newY)	\
{				\
CGRect rect = ctlName.frame;	\
rect.origin.y = (newY);			\
ctlName.frame = rect;			\
}

#define	SET_VIEW_WIDTH(ctlName, newWidth)	\
{				\
CGRect rect = ctlName.frame;	\
rect.size.width = (newWidth);	\
ctlName.frame = rect;			\
}

#define	SET_VIEW_HEIGHT(ctlName, newHeight)	\
{				\
CGRect rect = ctlName.frame;	\
rect.size.height = (newHeight);	\
ctlName.frame = rect;			\
}

#define	SET_VIEW_FRAME(ctlName, x, y, width, height)	\
{				\
CGRect rect = CGRectMake(x, y, width, height);  \
ctlName.frame = rect;                           \
}

//刷新界面
#define	UPDATE_VIEW(view)	[view setNeedsDisplay]

//创建VIEW
#define	UI_ALLOC_CREATE(UIctlName, x, y, width, height)	[[UIctlName alloc] initWithFrame:CGRectMake((x), (y), (width), (height))]

#define	UI_ALLOC_CREATE_EX(UIctlName, rect)             [[UIctlName alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)]


#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname) \
\
+ (classname *)shared##classname;


#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \

#endif
