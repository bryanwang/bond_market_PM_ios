//
//  ProjectsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-18.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "BondTableHeader.h"
#import "ProjectTableCell.h"
#import "ProjectViewController.h"
#import "PlatformProjectViewController.h"


@interface ProjectsTableViewController () {
    //存储原始数据
    NSMutableArray *projectsJson;
    // 用作筛选
    NSMutableArray *filterProjectsJson;
    // 当前的 排序方式
    ProjectsOrderType curOrderType;

    NSArray *curTypeFilterQuery;
    NSArray *curStatusFilterQuery;
}

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *projects;

@property (nonatomic, strong) BondTableHeader *projectHeader;

@end


static float TABLE_SECTION_HEIGHT = 23.0f;
static float TABLE_CELL_HEIGHT = 74.0f;

@implementation ProjectsTableViewController

- (void)filterByStatus:(NSArray *)statusquery AndType:(NSArray *)typequery
{
    filterProjectsJson = [projectsJson mutableCopy];
    
    if (statusquery.count > 0) {
        curStatusFilterQuery = statusquery;
    }

    if (typequery.count > 0) {
        curTypeFilterQuery = typequery;
    }
    
    if (curStatusFilterQuery.count > 0) {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF.ProjectInfo.Status in %@", curStatusFilterQuery];
        [filterProjectsJson filterUsingPredicate:thePredicate];
    }
    
    if (curTypeFilterQuery.count > 0) {
        //因为数据库的设计 type == 0时为bond
        //这里需要对self.type - 1
        NSPredicate *thePredicate2 = [NSPredicate predicateWithFormat:@"(SELF.Type - 1) in %@", curTypeFilterQuery];
        [filterProjectsJson filterUsingPredicate:thePredicate2];
    }
    
    [self orderBy:curOrderType];
}

- (void)orderBy:(ProjectsOrderType)orderType
{
    curOrderType = orderType;
    
    NSString *predicateStr = @"";
    if (orderType == OrderByChargePerson) {
        //sections for owner
        NSSet *uniques = [NSSet setWithArray: [filterProjectsJson valueForKeyPath:@"OwnerInfo.Name"]];
        self.sections = [[uniques allObjects] mutableCopy];
        predicateStr = @"(OwnerInfo.Name like %@)";
    } else {
        //sections for update time
        NSSet *uniques = [NSSet setWithArray: [filterProjectsJson valueForKeyPath:@"ProjectInfo.UpdateTime"]];
        self.sections = [[uniques allObjects] mutableCopy];
        predicateStr = @"(ProjectInfo.UpdateTime like %@)";
        
        // update time sort
        if (orderType == OrderByTime) {
            self.sections = [[self.sections sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *aDate= [[[QuickDialogHelper sharedInstance] dateFormater] dateFromString:a];
                NSDate *bDate = [[[QuickDialogHelper sharedInstance] dateFormater] dateFromString:b];
                return [aDate compare:bDate];
            }] mutableCopy];
        }
        else if (orderType == OrderByTimeDesc) {
            self.sections = [[self.sections sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *aDate= [[[QuickDialogHelper sharedInstance] dateFormater] dateFromString:a];
                NSDate *bDate = [[[QuickDialogHelper sharedInstance] dateFormater] dateFromString:b];
                return [bDate compare:aDate];
            }] mutableCopy];
        }
    }
    
    //generate projects array for each section
    NSMutableArray *tmps2 = [NSMutableArray array];
    [self.sections enumerateObjectsUsingBlock:^(id section, NSUInteger index, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateStr, section];
        NSArray *temp = [filterProjectsJson filteredArrayUsingPredicate:predicate];
        [tmps2 addObject:temp];
    }];
    
    self.projects = tmps2;
    
    [self.tableView reloadData];
}

- (void)convertProjectsUpdateTimeAndOwner: (NSMutableArray *)projects
{
    //change every project create time
    NSMutableArray *tmps = [NSMutableArray array];
    [projects enumerateObjectsUsingBlock:^(id project, NSUInteger index, BOOL *stop) {
        NSMutableDictionary *mutProject = [project mutableCopy];
        NSMutableDictionary *mutInfo = [mutProject[@"ProjectInfo"] mutableCopy];
        //only date
        mutInfo[@"UpdateTime"] = [mutInfo[@"UpdateTime"] substringToIndex:10];
        mutProject[@"ProjectInfo"] = [mutInfo copy];
        //owner
        if (mutProject[@"OwnerInfo"] == nil ||[mutProject[@"OwnerInfo"] isEqual:[NSNull null]]) {
            NSMutableDictionary *mutOwner = [NSMutableDictionary dictionary];
            mutOwner[@"Name"] = NSLocalizedString(@"no owner", "");
            mutProject[@"OwnerInfo"] = mutOwner;
        }

        [tmps addObject:mutProject];
    }];
    
    filterProjectsJson =  [tmps mutableCopy];
    projectsJson =  [tmps mutableCopy];
}


- (void)fetchMyProjects
{
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    NSString *userid = [[LoginManager sharedInstance] fetchUserId];
    if (userid != nil) {
        NSDictionary *params = @{@"userid": userid};
        [[PMHttpClient shareIntance]getPath:MY_PROJECTS_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];

            [self convertProjectsUpdateTimeAndOwner:(NSMutableArray *) responseObject];
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
        [[PMHttpClient shareIntance]getPath:MY_PROJECTS_INPUTINFO_INTERFACE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *info = (NSDictionary *)responseObject;
            self.projectHeader.inputInfo= info;
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
    self.projectHeader = (BondTableHeader *)[[[NSBundle mainBundle]loadNibNamed:@"BondTableHeader" owner:self options:nil] lastObject];
    self.tableView.tableHeaderView = self.projectHeader;
    
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
    NSArray *array = self.projects[section];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectTableCell";
    ProjectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ProjectTableCell *)[[[NSBundle mainBundle]loadNibNamed:@"ProjectTableCell" owner:self options:nil] lastObject];
    }
    
    cell.project = self.projects[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *project = self.projects[indexPath.section][indexPath.row];
    if ([project[@"Type"] integerValue] == Project) {
        ProjectViewController *pc = [[ProjectViewController alloc] initWithProject:project];
        [((UIViewController *)self.delegate).navigationController pushViewController:pc animated:YES];
    }
    else if ([project[@"Type"] integerValue] == PlatformProject) {
        PlatformProjectViewController *pc = [[PlatformProjectViewController alloc] initWithPlatformProject:project];
        [((UIViewController *)self.delegate).navigationController pushViewController:pc animated:YES];
    }
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