//
//  BondsTableViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-4.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "BondsTableViewController.h"
#import "BondTableCell.h"
#import "BondTableHeader.h"

@interface BondsTableViewController () {
    NSMutableArray *bondsJson;
}

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *bonds;

@property (nonatomic, strong) BondTableHeader *bondHeader;

@property (nonatomic, strong) NSDateFormatter *fomart;

@end


@implementation BondsTableViewController

- (NSDateFormatter *)fomart
{
    if (_fomart == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        _fomart = dateFormatter;
    }
    
    return _fomart;
}

- (void)setOrderType:(BondsOrderType)orderType
{
    _orderType = orderType;
    
    NSString *predicateStr = @"";
    if (orderType == OrderByChargePerson) {
        //sections for owner
        NSSet *uniques = [NSSet setWithArray: [bondsJson valueForKeyPath:@"OwnerInfo.Name"]];
        self.sections = [[uniques allObjects] mutableCopy];
        predicateStr = @"(OwnerInfo.Name like %@)";
    } else {
        //sections for update time
        NSSet *uniques = [NSSet setWithArray: [bondsJson valueForKeyPath:@"NewBondInfo.UpdateTime"]];
        self.sections = [[uniques allObjects] mutableCopy];
        predicateStr = @"(NewBondInfo.UpdateTime like %@)";
        
        // update time sort
        if (orderType == OrderByTime) {
            self.sections = [[self.sections sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *aDate= [self.fomart dateFromString:a];
                NSDate *bDate = [self.fomart dateFromString:b];
                return [aDate compare:bDate];
            }] mutableCopy];
        }
        else if (orderType == OrderByTimeDesc) {
            self.sections = [[self.sections sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *aDate= [self.fomart dateFromString:a];
                NSDate *bDate = [self.fomart dateFromString:b];
                return ![aDate compare:bDate];
            }] mutableCopy];
        }
    }
    
    //generate bonds array for each section
    NSMutableArray *tmps2 = [NSMutableArray array];
    [self.sections enumerateObjectsUsingBlock:^(id section, NSUInteger index, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateStr, section];
        NSArray *temp = [bondsJson filteredArrayUsingPredicate:predicate];
        [tmps2 addObject:temp];
    }];
    
    self.bonds = tmps2;
}

- (void)convertBondsUpdateTimeFormaterAndOwner: (NSMutableArray *)bonds
{
    //change every bond create time
    NSMutableArray *tmps = [NSMutableArray array];
    [bonds enumerateObjectsUsingBlock:^(id bond, NSUInteger index, BOOL *stop) {
        NSMutableDictionary *mutBond = [bond mutableCopy];
        NSMutableDictionary *mutInfo = [mutBond[@"NewBondInfo"] mutableCopy];
        //only date
        mutInfo[@"UpdateTime"] = [mutInfo[@"UpdateTime"] substringToIndex:10];
        mutBond[@"NewBondInfo"] = [mutInfo copy];
        //owner
        if (mutBond[@"OwnerInfo"] == nil ||[mutBond[@"OwnerInfo"] isEqual:[NSNull null]]) {
            NSMutableDictionary *mutOwner = [NSMutableDictionary dictionary];
            mutOwner[@"Name"] = NSLocalizedString(@"no owner", "");
            mutBond[@"OwnerInfo"] = mutOwner;
        }
        
        [tmps addObject:mutBond];
    }];
    
    bondsJson = tmps;
}

- (void) fetchMyBonds
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ID_KEY];
    if (userid != nil) {
        NSDictionary *params = @{@"userid": userid};
        [[PMHttpClient shareIntance]getPath:MY_BONDS_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self convertBondsUpdateTimeFormaterAndOwner:  (NSMutableArray *)responseObject];
            [self setOrderType:OrderByTime];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    else {
        //todo: not login
    }
}

- (void)fetchMyInputInfo
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ID_KEY];
    if (userid != nil) {
        NSDictionary *params = @{@"userid": userid};
        [[PMHttpClient shareIntance]getPath:MY_BONDS_INPUTUBFI_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *info = (NSDictionary *)responseObject;
            self.bondHeader.inputInfo= info;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    else {
        //todo: not login
    }

}

- (void)reloadTableview
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bondHeader = (BondTableHeader *)[[[NSBundle mainBundle]loadNibNamed:@"BondTableHeader" owner:self options:nil] lastObject];
    self.tableView.tableHeaderView = self.bondHeader;
    
    self.tableView.backgroundColor = RGBCOLOR(255, 255, 255);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
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
	headerLabel.text = self.sections[section];
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