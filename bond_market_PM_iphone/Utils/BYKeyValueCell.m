//
//  BYKeyValueCell.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BYKeyValueCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BYKeyValueCell {
    float y;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        y = 10.0f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    //background
    UIView *bg = [[UIView alloc]initWithFrame:CGRectZero];
    bg.layer.borderColor = RGBCOLOR(197, 193, 186).CGColor;
    bg.backgroundColor = [UIColor whiteColor];
    bg.layer.shadowColor = RGBCOLOR(224, 221, 215).CGColor;
    bg.layer.shadowOffset = CGSizeMake(3, 3);
    bg.layer.borderWidth = 1.0f;
    bg.layer.cornerRadius = 6.0f;
    bg.clipsToBounds = YES;
    
    //tag
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, y, 4, 16)];
    tagView.backgroundColor = RGBCOLOR(185, 12, 16);
    
    [bg addSubview:tagView];
    //type
    NSString *type = data[@"type"];
    UIFont *typeFont = [UIFont systemFontOfSize:14.0f];
    CGSize typeSize = [type sizeWithFont:typeFont];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, y, typeSize.width, typeSize.height)];
    typeLabel.font =typeFont;
    typeLabel.textColor = RGBCOLOR(49, 49, 49);
    typeLabel.text = type;
    
    [bg addSubview:typeLabel];
    
    y += MAX(tagView.bounds.size.height, typeLabel.bounds.size.height);
    
    //data
    NSMutableArray *detail = data[@"data"];
    [detail enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        NSString *key = obj[@"key"];
        id value = obj[@"value"];
        
        UIFont *dataFont = [UIFont systemFontOfSize:12.0f];
        CGSize keySize = [key sizeWithFont:dataFont];
        UILabel *keyLable = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, y, keySize.width, keySize.height)];
        keyLable.text = key;
        keyLable.font = dataFont;
        keyLable.textColor = RGBCOLOR(149, 149, 149);
        
        __block NSMutableArray *valueArray = [NSMutableArray array];
        if ([value isKindOfClass:[NSString class]])
            [valueArray addObject:value];
        else if ([value isKindOfClass:[NSArray class]])
            [valueArray addObjectsFromArray:value];
        else if ([value integerValue] == 1)
            [valueArray addObject:@"是"];
        
        [valueArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            CGSize valueSize = [obj sizeWithFont:dataFont];
            UILabel *valueLable = [[UILabel alloc]initWithFrame:CGRectMake(120.0f, y, valueSize.width, valueSize.height)];
            valueLable.text = obj;
            valueLable.font = dataFont;
            valueLable.textColor = RGBCOLOR(100, 100, 100);
            
            [bg addSubview:keyLable];
            [bg addSubview:valueLable];
            
            y += MAX(keyLable.bounds.size.height, valueLable.bounds.size.height);
        }];
    }];
    
    bg.frame = CGRectMake(5.0f, 5.0f, self.bounds.size.width - 10.0f, y + 10.0f);
    [self addSubview:bg];
}

- (float)cellHeight
{
    return y + 10.0f + 10.0f;
}

@end
