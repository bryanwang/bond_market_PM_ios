//
//  UseOfFoundsViewController.m
//  bond_market_PM_iphone
//
//  Created by Bruce yang on 13-6-17.
//  Copyright (c) 2013年 pyrating. All rights reserved.
//

#import "UseOfFoundsViewController.h"
#import "AddUseOfFoundsViewController.h"
#import "BYKeyValueCell.h"

@interface UseOfFoundsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *useOfFoundsArray;
@property (nonatomic, strong)UITableView *table;
@end

@implementation UseOfFoundsViewController

- (NSMutableArray *)useOfFoundsArray
{
    if (_useOfFoundsArray == nil)
        _useOfFoundsArray = [NSMutableArray array];
    return _useOfFoundsArray;
}

- (void)setStatus:(UseOfFoundsEditStatus)status
{
    _status = status;
    UIBarButtonItem *item = nil;
    if (status == UseOfFoundsEditing) {
        item = [UIBarButtonItem redBarButtonItemWithtitle:@"新增"  target:self selector:@selector(addUseOfFounds)];
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

- (void)bindObject:(NSMutableArray *)useOfFoundsArray
{
    if (![useOfFoundsArray isEqual:self.useOfFoundsArray]) {
        self.useOfFoundsArray = [useOfFoundsArray mutableCopy];
        if (useOfFoundsArray.count > 0) {
            [self.table reloadData];
        }
    }
}

- (NSMutableArray *)fetchData
{
    return self.useOfFoundsArray;
}

- (void)addUseOfFounds
{
    AddUseOfFoundsViewController *ac = [[AddUseOfFoundsViewController alloc]init];
    [self.navigationController pushViewController:ac animated:YES];
}

- (void)popViewController:  (NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:YES];
    
    NSDictionary *info = notification.userInfo;
    NSDictionary *useOfFounds = [info objectForKey:BYTRUSTINCREASEKEY];
    [self.useOfFoundsArray addObject:useOfFounds];
    [self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资金用途";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewController:) name:BYPOPVIEWCONTOLLERNOTIFICATION object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.status == UseOfFoundsEditing) {
        if (self.useOfFoundsArray.count == 0) {
            UIImageView *noItem = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"no-use" ofType:@"png"]]];
            SET_VIEW_X(noItem, 80.0f);
            SET_VIEW_Y(noItem, 20.0f);
            [self.view addSubview:noItem];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.useOfFoundsArray.count;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  这里有性能问题 懒得计算了 就这样把..
    BYKeyValueCell *cell = [[BYKeyValueCell alloc] init];
    cell.data = self.useOfFoundsArray[indexPath.row];
    return [cell cellHeight];
}

- (BYKeyValueCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"UseOfFoundCell";
    BYKeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[BYKeyValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.data = self.useOfFoundsArray[indexPath.row];
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
    return self.status == UseOfFoundsEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.useOfFoundsArray removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
