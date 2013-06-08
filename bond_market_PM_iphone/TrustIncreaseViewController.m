//
//  TrustIncreaseViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "TrustIncreaseViewController.h"
#import "AddTrustIncreaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TrustIncreaseCell : UITableViewCell
@property (nonatomic, strong)NSDictionary *increase;
- (float)cellHeight;
@end

@interface TrustIncreaseViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *noitemTips;
@property (strong, nonatomic)UITableView *table;
@end

@implementation TrustIncreaseCell {
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

- (void)setIncrease:(NSDictionary *)increase
{
    _increase = increase;
    //background
    UIView *bg = [[UIView alloc]initWithFrame:CGRectZero];
    bg.layer.borderColor = RGBCOLOR(191, 189, 184).CGColor;
    bg.backgroundColor = [UIColor whiteColor];
    bg.layer.shadowColor = RGBCOLOR(209, 206, 201).CGColor;
    bg.layer.shadowOffset = CGSizeMake(3, 3);
    bg.layer.borderWidth = 1.0f;
    bg.layer.cornerRadius = 6.0f;
    bg.clipsToBounds = YES;
    
    //tag
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, y, 4, 16)];
    tagView.backgroundColor = RGBCOLOR(185, 12, 16);
    
    [bg addSubview:tagView];
    //type
    NSString *type = increase[@"type"];
    UIFont *typeFont = [UIFont systemFontOfSize:14.0f];
    CGSize typeSize = [type sizeWithFont:typeFont];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, y, typeSize.width, typeSize.height)];
    typeLabel.font =typeFont;
    typeLabel.textColor = RGBCOLOR(49, 49, 49);
    typeLabel.text = type;
    
    [bg addSubview:typeLabel];

    y += MAX(tagView.bounds.size.height, typeLabel.bounds.size.height);
        
    //data
    NSMutableArray *data = increase[@"data"];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
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


@implementation TrustIncreaseViewController

- (void)setStatus:(TrustIncreaseEditStatus)status
{
    _status = status;
    if (status == TrustIncreaseEditing) {
        UIBarButtonItem *item = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav-btn-red-nor"] highlightedImage:[UIImage imageNamed:@"nav-btn-red-sel"] target:self selector:@selector(addTrustWay)];
        ((UIButton *)(item.customView)).titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [((UIButton *)(item.customView)) setTitle:@"新增" forState:UIControlStateNormal];
        [((UIButton *)(item.customView)) setTintColor: RGBCOLOR(255, 255, 255)];
        
        self.navigationItem.rightBarButtonItem = item;
    }
    else {
        self.navigationController.navigationItem.rightBarButtonItem = nil;
    }
}

- (UITableView *)table
{
    if (_table == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = RGBCOLOR(224, 221, 215);
        _table = table;
    }
    return _table;
}

- (void)setTrustIncreaseArray:(NSMutableArray *)trustIncreaseArray
{
    if (![trustIncreaseArray isEqual:_trustIncreaseArray]) {
        _trustIncreaseArray = [trustIncreaseArray mutableCopy];
        if (trustIncreaseArray.count > 0) {
            [self.view addSubview:self.table];
            [self.table reloadData];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"增信方式";
}


-  (void)addTrustWay
{
    QRootElement *root  = [[QRootElement alloc] initWithJSONFile:@"TrutWaysDataBuilder" andData:nil];
    AddTrustIncreaseViewController *tc = [[AddTrustIncreaseViewController alloc]initWithRoot:root];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:tc forKey:BYCONTROLLERKEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYPUSHVIEWCONTOLLERNOTIFICATION
                                                        object:self
                                                      userInfo:dict];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trustIncreaseArray.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  这里有性能问题 懒得计算了 就这样把..
    TrustIncreaseCell *cell = [[TrustIncreaseCell alloc] init];
    cell.increase = self.trustIncreaseArray[indexPath.row];
    return [cell cellHeight];
}

- (TrustIncreaseCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"TrustIncreaseCell_%d";
    TrustIncreaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[TrustIncreaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.increase = self.trustIncreaseArray[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.status == TrustIncreaseEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.trustIncreaseArray removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
