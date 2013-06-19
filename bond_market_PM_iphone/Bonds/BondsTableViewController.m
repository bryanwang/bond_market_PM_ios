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
#import "BondViewController.h"

@interface BondsTableViewController () {
    //存储原始数据
    NSMutableArray *bondsJson;
    // 用作筛选
    NSMutableArray *filterBondsJson;
    // 当前的 排序方式
    BondsOrderType curOrderType;
}

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *bonds;

@property (nonatomic, strong) BondTableHeader *bondHeader;

@end


static float TABLE_SECTION_HEIGHT = 23.0f;
static float TABLE_CELL_HEIGHT = 74.0f;

@implementation BondsTableViewController

- (void)filterBy: (NSArray *)query
{
    //还原数据
    filterBondsJson = [bondsJson mutableCopy];
    
    if (query.count == 0) {
        //全部
    }
    else {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF.NewBondInfo.Status in %@", query];
        [filterBondsJson filterUsingPredicate:thePredicate];
    }

    [self orderBy:curOrderType];
}

- (void)orderBy:(BondsOrderType)orderType
{
    curOrderType = orderType;
    
    NSString *predicateStr = @"";
    if (orderType == OrderByChargePerson) {
        //sections for owner
        NSSet *uniques = [NSSet setWithArray: [filterBondsJson valueForKeyPath:@"OwnerInfo.Name"]];
        self.sections = [[uniques allObjects] mutableCopy];
        predicateStr = @"(OwnerInfo.Name like %@)";
    } else {
        //sections for update time
        NSSet *uniques = [NSSet setWithArray: [filterBondsJson valueForKeyPath:@"NewBondInfo.UpdateTime"]];
        self.sections = [[uniques allObjects] mutableCopy];
        predicateStr = @"(NewBondInfo.UpdateTime like %@)";
        
        // update time sort
        if (orderType == OrderByTime) {
            self.sections = [[self.sections sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *aDate= [[[QuickDialogHelper sharedInstance] dateFormater] dateFromString:a];
                NSDate *bDate = [[[QuickDialogHelper sharedInstance] dateFormater]  dateFromString:b];
                return [aDate compare:bDate];
            }] mutableCopy];
        }
        else if (orderType == OrderByTimeDesc) {
            self.sections = [[self.sections sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *aDate= [[[QuickDialogHelper sharedInstance] dateFormater]  dateFromString:a];
                NSDate *bDate = [[[QuickDialogHelper sharedInstance] dateFormater]  dateFromString:b];
                NSLog(@"%@", aDate);
                NSLog(@"%@", bDate);
                return [bDate compare:aDate];
            }] mutableCopy];
        }
    }
    
    //generate bonds array for each section
    NSMutableArray *tmps2 = [NSMutableArray array];
    [self.sections enumerateObjectsUsingBlock:^(id section, NSUInteger index, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateStr, section];
        NSArray *temp = [filterBondsJson filteredArrayUsingPredicate:predicate];
        [tmps2 addObject:temp];
    }];
    
    self.bonds = tmps2;
    
    [self.tableView reloadData];
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
    
    filterBondsJson =  [tmps mutableCopy];
    bondsJson =  [tmps mutableCopy];
}


- (void) fetchMyBonds
{
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    NSString *userid = [[LoginManager sharedInstance] fetchUserId];
    if (userid != nil) {
        NSDictionary *params = @{@"userid": userid};
        [[PMHttpClient shareIntance]getPath:MY_BONDS_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
            
            [self convertBondsUpdateTimeFormaterAndOwner:  (NSMutableArray *)responseObject];
            [self orderBy:OrderByTime];
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
    NSString *userid = [[LoginManager sharedInstance] fetchUserId];
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
	UIView* customView = [[UIView alloc] initWithFrame:(CGRect){0.0f, 0.0f, tableView.bounds.size.width, TABLE_SECTION_HEIGHT}];
    customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-section.png"]];
    
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectInset(customView.bounds, 10.0f, 0)];
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
    return TABLE_CELL_HEIGHT;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BondViewController *nc = [[BondViewController alloc]initWithBond:self.bonds[indexPath.section][indexPath.row]];
    [((UIViewController *)self.delegate).navigationController pushViewController:nc animated:YES];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    UIView *nor = [[UIView alloc]initWithFrame:cell.bounds];
    nor.backgroundColor = RGBCOLOR(255, 255, 255);
    cell.backgroundView  = nor;
    
    UIView *sel = [[UIView alloc]initWithFrame:cell.bounds];
    sel.backgroundColor = RGBCOLOR(250, 248, 244);
    cell.selectedBackgroundView = sel;
}

@end
