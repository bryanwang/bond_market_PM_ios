//
// Copyright 2011 ESCOZ Inc  - http://escoz.com
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "QTableViewCell.h"


//add by bruce
typedef enum  QCellBackgroundViewPosition: NSUInteger{
    QCellBackgroundViewPositionSingle,
	QCellBackgroundViewPositionTop,
	QCellBackgroundViewPositionBottom,
    QCellBackgroundViewPositionMiddle
} QCellBackgroundViewPosition;

@interface QCellBackgroundView : UIView

@property (nonatomic) QCellBackgroundViewPosition position;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor* separatorColor;
@property (nonatomic) CGFloat separatorHeight;

@end

@implementation QCellBackgroundView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.cornerRadius = 4.0f;
        self.separatorHeight = 1.0f;
        self.separatorColor = [UIColor colorWithRed:197.0f/255.0f green:193.0f/255.0f blue:186.0f/255.0f alpha:1];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	}
    
	return self;
}

- (BOOL)isOpaque {
	return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //position
    UITableView* tableView = (UITableView*)self.superview.superview;
    NSIndexPath* indexPath = [tableView indexPathForCell:(UITableViewCell*)self.superview];
    
    if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
        self.position = QCellBackgroundViewPositionSingle;
    }
    else if (indexPath.row == 0) {
        self.position = QCellBackgroundViewPositionTop;
    }
    else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        self.position = QCellBackgroundViewPositionBottom;
    }
    else {
        self.position = QCellBackgroundViewPositionMiddle;
    }
}

- (void)drawRect:(CGRect)aRect {
    //Determine tableView style
    UITableView* tableView = (UITableView*)self.superview.superview;
    if (tableView.style != UITableViewStyleGrouped) {
        self.cornerRadius = 0.f;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
	int lineWidth = 1;
    
	CGRect rect = [self bounds];
	CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
	CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);
	minY -= 1;
    
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
	CGContextSetLineWidth(c, lineWidth);
	CGContextSetAllowsAntialiasing(c, YES);
	CGContextSetShouldAntialias(c, YES);
    
	if (self.position == QCellBackgroundViewPositionTop) {
		minY += 1;
        
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, minX, maxY);
		CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, self.cornerRadius);
		CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, maxY, self.cornerRadius);
		CGPathAddLineToPoint(path, NULL, maxX, maxY);
		CGPathAddLineToPoint(path, NULL, minX, maxY);
		CGPathCloseSubpath(path);
        
		CGContextSaveGState(c);
		CGContextAddPath(c, path);
		CGContextClip(c);
        
        CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
        CGContextFillRect(c, self.bounds);
        CGContextSetFillColorWithColor(c, self.separatorColor.CGColor);
        CGContextFillRect(c, CGRectMake(0, self.bounds.size.height - self.separatorHeight, self.bounds.size.width, self.bounds.size.height - self.separatorHeight));
        
		CGContextAddPath(c, path);
		CGPathRelease(path);
        CGContextRestoreGState(c);
	} else if (self.position == QCellBackgroundViewPositionBottom) {
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, minX, minY);
		CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, self.cornerRadius);
		CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, minY, self.cornerRadius);
		CGPathAddLineToPoint(path, NULL, maxX, minY);
		CGPathAddLineToPoint(path, NULL, minX, minY);
		CGPathCloseSubpath(path);
        
		CGContextSaveGState(c);
		CGContextAddPath(c, path);
		CGContextClip(c);
        
		CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
        CGContextFillRect(c, self.bounds);
        if (self.cornerRadius == 0.f) {
            CGContextSetFillColorWithColor(c, self.separatorColor.CGColor);
            CGContextFillRect(c, CGRectMake(0, self.bounds.size.height - self.separatorHeight, self.bounds.size.width, self.bounds.size.height - self.separatorHeight));
        }
        
		CGContextAddPath(c, path);
		CGPathRelease(path);
		CGContextRestoreGState(c);
	} else if (self.position == QCellBackgroundViewPositionMiddle) {
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, minX, minY);
		CGPathAddLineToPoint(path, NULL, maxX, minY);
		CGPathAddLineToPoint(path, NULL, maxX, maxY);
		CGPathAddLineToPoint(path, NULL, minX, maxY);
		CGPathAddLineToPoint(path, NULL, minX, minY);
		CGPathCloseSubpath(path);
        
		CGContextSaveGState(c);
		CGContextAddPath(c, path);
		CGContextClip(c);
        
		CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
        CGContextFillRect(c, self.bounds);
        CGContextSetFillColorWithColor(c, self.separatorColor.CGColor);
        CGContextFillRect(c, CGRectMake(0, self.bounds.size.height - self.separatorHeight, self.bounds.size.width, self.bounds.size.height - self.separatorHeight));
        
		CGContextAddPath(c, path);
		CGPathRelease(path);
		CGContextRestoreGState(c);
	} else if (self.position == QCellBackgroundViewPositionSingle) {
		minY += 1;
        
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, minX, midY);
		CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, self.cornerRadius);
		CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, midY, self.cornerRadius);
		CGPathAddArcToPoint(path, NULL, maxX, maxY, midX, maxY, self.cornerRadius);
		CGPathAddArcToPoint(path, NULL, minX, maxY, minX, midY, self.cornerRadius);
		CGPathCloseSubpath(path);
        
		CGContextSaveGState(c);
		CGContextAddPath(c, path);
		CGContextClip(c);
        
		CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
        CGContextFillRect(c, self.bounds);
        
		CGContextAddPath(c, path);
		CGPathRelease(path);
		CGContextRestoreGState(c);
	}
    
	CGColorSpaceRelease(colorspace);
}

- (void)setPosition:(QCellBackgroundViewPosition)position {
    _position = position;
    
    [self setNeedsDisplay];
}

@end

@implementation QTableViewCell

@synthesize labelingPolicy = _labelingPolicy;

- (QTableViewCell *)initWithReuseIdentifier:(NSString *)string {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];

    if (_labelingPolicy == QLabelingPolicyTrimTitle)
    {
        CGSize imageSize = CGSizeZero;
            if (self.imageView!=nil)
                imageSize = self.imageView.frame.size;

        CGSize valueSize = CGSizeZero;
        if (self.detailTextLabel.text!=nil)
            valueSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font];

        CGRect labelFrame = self.textLabel.frame;
        self.textLabel.frame = CGRectMake(labelFrame.origin.x, labelFrame.origin.y,
                self.contentView.bounds.size.width - valueSize.width - imageSize.width - 20, labelFrame.size.height);

        CGRect detailsFrame = self.detailTextLabel.frame;
        self.detailTextLabel.frame = CGRectMake(
                self.contentView.bounds.size.width - valueSize.width - 10,
                detailsFrame.origin.y, valueSize.width, detailsFrame.size.height);
    }
}



- (void)applyAppearanceForElement:(QElement *)element {
    QAppearance *appearance = element.appearance;
    self.textLabel.textColor = element.enabled  ? appearance.labelColorEnabled : appearance.labelColorDisabled;
    self.textLabel.font = appearance.labelFont;
    self.textLabel.textAlignment = appearance.labelAlignment;

    self.detailTextLabel.textColor = element.enabled ? appearance.valueColorEnabled : appearance.valueColorDisabled;
    self.detailTextLabel.font = appearance.valueFont;
    self.detailTextLabel.textAlignment = appearance.valueAlignment;

    //add by bruce
    self.textLabel.highlightedTextColor = element.enabled  ? appearance.labelColorEnabled : appearance.labelColorDisabled;
    self.detailTextLabel.textColor = element.enabled ? appearance.valueColorEnabled : appearance.valueColorDisabled;

    QCellBackgroundView* backgroundView = [QCellBackgroundView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;
    
    QCellBackgroundView* selectedBackgroundView = [QCellBackgroundView new];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:236.0f/255.0f blue:231.0f/255.0f alpha:1];
    self.selectedBackgroundView = selectedBackgroundView;

//    self.backgroundColor = element.enabled ? appearance.backgroundColorEnabled : appearance.backgroundColorDisabled;
//    self.selectedBackgroundView = element.appearance.selectedBackgroundView;
}

@end
