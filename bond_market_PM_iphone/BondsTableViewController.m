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

- (void) fetchMyBonds
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ID_KEY];
    if (userid != nil) {
//        NSDictionary *params = @{@"userid": userid};
//        [[PMHttpClient shareIntance]getPath:MY_BONDS_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary *result = (NSDictionary *)responseObject;
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@", error);
//        }];
        
        //mock data
        self.dates = [@[@1] copy];
        NSArray *array = @[@1,@2];
        self.bonds = [NSMutableArray arrayWithObject:array];
        
        [self.tableView reloadData];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[BondTableCell class] forCellReuseIdentifier:@"BondTableCell"];
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
	headerLabel.text = @"2013-1-1";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BondTableCell" forIndexPath:indexPath];
    cell.textLabel.text = @"test";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
