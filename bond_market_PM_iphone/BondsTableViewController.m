//
//  BondsTableViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BondsTableViewController.h"
#import "BondTableCell.h"

@interface BondsTableViewController () {
    NSMutableArray *bondsJson;
}

@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *bonds;

@end

@implementation BondsTableViewController

- (void)generatedatesAndBonds: (NSMutableArray *)bonds
{
    @autoreleasepool {
        //change every bond create time
        NSMutableArray *tmps = [NSMutableArray array];
        [bonds enumerateObjectsUsingBlock:^(id bond, NSUInteger index, BOOL *stop) {
            NSMutableDictionary *mutBond = [bond mutableCopy];
            NSMutableDictionary *mutInfo = [mutBond[@"NewBondInfo"] mutableCopy];
            //only date
            mutInfo[@"UpdateTime"] = [mutInfo[@"UpdateTime"] substringToIndex:10];
            mutBond[@"NewBondInfo"] = [mutInfo copy];
            [tmps addObject:mutBond];
        }];
        
        //dates
        NSSet *uniqueDates = [NSSet setWithArray: [tmps valueForKeyPath:@"NewBondInfo.UpdateTime"]];
        self.dates = [[uniqueDates allObjects] mutableCopy];

        //bonds
        NSMutableArray *tmps2 = [NSMutableArray array];
        [self.dates enumerateObjectsUsingBlock:^(id date, NSUInteger index, BOOL *stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(NewBondInfo.UpdateTime like %@)", date];
            NSArray *temp = [tmps filteredArrayUsingPredicate:predicate];
            [tmps2 addObject:temp];
        }];
        self.bonds = tmps2;
    }
}

- (void) fetchMyBonds
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ID_KEY];
    if (userid != nil) {
        NSDictionary *params = @{@"userid": userid};
        [[PMHttpClient shareIntance]getPath:MY_BONDS_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            bondsJson = (NSMutableArray *)responseObject;
            [self generatedatesAndBonds: bondsJson];
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    else {
        //todo: not login
    }
}

- (void)setOrderType:(BondsOrderType)orderType
{
    if (_orderType != orderType) {
        _orderType = orderType;
        switch (orderType) {
            case OrderByTime:

                break;
            case OrderByTimeDesc:
                
                break;
            case OrderByChargePerson:
                
                break;
            default:
                break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)reloadTableview
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(224, 221, 215);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.bonds[section];
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect  r = {0.0f, 0.0f, tableView.bounds.size.width, TABLE_SECTION_HEIGHT};
	UIView* customView = [[UIView alloc] initWithFrame:r];
    customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-section.png"]];
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, tableView.bounds.size.width - 20.0f, TABLE_SECTION_HEIGHT)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = RGBCOLOR(100, 100, 100);
	headerLabel.font = [UIFont systemFontOfSize:14];
	headerLabel.text = self.dates[section];
	[customView addSubview:headerLabel];
    
	return customView;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_SECTION_HEIGHT;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0f;
}

- (BondTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *CellIdentifier = @"BondTableCell";
    BondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (BondTableCell *)[[[NSBundle mainBundle]loadNibNamed:@"BondTableCell" owner:self options:nil] lastObject];
    }
    
    cell.bond = self.bonds[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    UIView *nor = [[UIView alloc]initWithFrame:cell.bounds];
    nor.backgroundColor = RGBCOLOR(255, 255, 255);
    cell.backgroundView  = nor;
    
    UIView *sel = [[UIView alloc]initWithFrame:cell.bounds];
    sel.backgroundColor = RGBCOLOR(221, 221, 221);
    cell.selectedBackgroundView = sel;
}

@end
