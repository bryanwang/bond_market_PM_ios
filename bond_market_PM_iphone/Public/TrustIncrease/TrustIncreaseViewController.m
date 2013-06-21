//
//  TrustIncreaseViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "TrustIncreaseViewController.h"
#import "AddTrustIncreaseViewController.h"
#import "BYKeyValueCell.h"

@interface TrustIncreaseViewController ()
@property (nonatomic)TrustIncreaseSpecies trustIncreaseSpecies;
@property (nonatomic, strong)NSMutableArray *trustIncreaseArray;
@property (strong, nonatomic)UITableView *table;
@end


@implementation TrustIncreaseViewController

- (id)initWithTrustIncreaseStatus:(TrustIncreaseSpecies)status
{
    self = [super init];
    if (self != nil) {
        self.trustIncreaseSpecies = status;
    }
    return self;
}

- (NSMutableArray *)trustIncreaseArray
{
    if (_trustIncreaseArray == nil)
        _trustIncreaseArray = [NSMutableArray array];
    return _trustIncreaseArray;
}

- (void)setStatus:(TrustIncreaseEditStatus)status
{
    _status = status;
    UIBarButtonItem *item = nil;
    if (status == TrustIncreaseEditing) {
        item = [UIBarButtonItem redBarButtonItemWithtitle:@"新增"  target:self selector:@selector(addTrustWay)];
    }
    self.navigationItem.rightBarButtonItem = item;
}

- (UITableView *)table
{
    if (_table == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = RGBCOLOR(224, 221, 215);
        [self.view addSubview:table];
        _table = table;
    }
    return _table;
}

- (void)bindObject:(NSMutableArray *)trustIncreaseArray
{
    if (![trustIncreaseArray isEqual:self.trustIncreaseArray]) {
        self.trustIncreaseArray = [trustIncreaseArray mutableCopy];
        if (trustIncreaseArray.count > 0) {
//            self.noitemTips.layer.hidden = YES;
            [self.table reloadData];
        }
    }
}

- (NSMutableArray *)fetchData
{
    return self.trustIncreaseArray;
}

- (void)popViewController:  (NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:YES];
    
    NSDictionary *info = notification.userInfo;
    NSDictionary *increase = [info objectForKey:BYTRUSTINCREASEKEY];
    [self.trustIncreaseArray addObject:increase];
    [self.table reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"增信方式";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewController:) name:BYPOPVIEWCONTOLLERNOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.status == TrustIncreaseEditing) {
        if (self.trustIncreaseArray.count == 0) {
            UIImageView *noItem = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"no-item" ofType:@"png"]]];
            SET_VIEW_X(noItem, 80.0f);
            SET_VIEW_Y(noItem, 20.0f);
            [self.view addSubview:noItem];
        }
    }
}


-  (void)addTrustWay
{
    NSString *bulider = nil;
    switch (self.trustIncreaseSpecies) {
        case BondTrustIncrease:
            bulider = @"TrutWaysDataBuilder";
            break;
        case PlatformProjectTrustIncrease:
            bulider = @"PlatformTrutWaysDataBuilder";
        case NonPlatformProjectTrustIncrease:
            bulider= @"NonPlatformTrutWaysDataBuilder";
        default:
            break;
    }

    AddTrustIncreaseViewController *tc = [[AddTrustIncreaseViewController alloc] initWithDataBuilder: bulider];
    [self.navigationController pushViewController:tc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYPOPVIEWCONTOLLERNOTIFICATION object:nil];
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
    BYKeyValueCell *cell = [[BYKeyValueCell alloc] init];
    cell.data = self.trustIncreaseArray[indexPath.row];
    return [cell cellHeight];
}

- (BYKeyValueCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"TrustIncreaseCell_%d";
    BYKeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[BYKeyValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.data = self.trustIncreaseArray[indexPath.row];
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
