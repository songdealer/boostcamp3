//
//  ViewController.m
//  boostcamp
//
//  Created by user on 10/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import "TableViewController.h"
#import "ParentViewController.h"
#import "DataManager.h"
#import "define.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ParentViewController *parent = self.parentViewController;
    [parent mappingChildVC:self];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)startForAppearance {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, __ViewStartOrigin, __ViewWidth, __ViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.autoresizingMask = UIViewAutoresizingNone;
        [_tableView setSectionHeaderHeight:0];
        [self.view addSubview:_tableView];
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        
        refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@""];
        [_tableView addSubview:refreshControl];
        [[SessionManager sharedData] sendDataForImageSubURL:__moviesURL];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [_tableView reloadData];
        });
    }
    //NSLog(@"tableView reload is OK.");
    
}

- (void)handleRefresh:(UIRefreshControl *)sender {
    [sender endRefreshing];
    [self startForAppearance];
}


- (BOOL)subViews:(NSArray *)array containsClass:(Class)class {
    for(UIView* view in array) {
        if([view.class isEqual:class]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [[[DataManager sharedData].DataDictionary objectForKey:__moviesURL] objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [data objectForKey:@"id"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __ViewWidth, __tableCellHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(__tableCellTitleLeftMargin, __tableCellTextMargin, __tableCellLabelWidth, __tableCellLabelHeight)];
        [titleLabel setText:[data objectForKey:@"title"]];
        [titleLabel setFont:[UIFont systemFontOfSize:__titleCellFontSize]];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(__tableCellTitleLeftMargin, __tableCellSubTitleTopMargin, __tableCellLabelWidth, __tableCellLabelHeight)];
        [subTitleLabel setText:[NSString stringWithFormat:@"평점 : %g 예매순위 : %@ 예매율 : %g", [[data objectForKey:@"user_rating"] doubleValue], [data objectForKey:@"reservation_grade"], [[data objectForKey:@"reservation_rate"] doubleValue]]];
        [subTitleLabel setFont:[UIFont systemFontOfSize:__subTitleCellFontSize]];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(__tableCellTitleLeftMargin, __tableCellDateTopMargin, __tableCellLabelWidth, __tableCellLabelHeight)];
        [dateLabel setText:[NSString stringWithFormat:@"개봉일 : %@", [data objectForKey:@"date"]]];
        [dateLabel setFont:[UIFont systemFontOfSize:__dateCellFontSize]];
        
        [contentView addSubview:titleLabel];
        [contentView addSubview:subTitleLabel];
        [contentView addSubview:dateLabel];
        
        [cell.contentView addSubview:contentView];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //NSLog(@"%@ contentView created.", cellIdentifier);
    }
    else {
        UIView *contentView = [cell.contentView.subviews firstObject];
        NSData *thumbData = [[DataManager sharedData].thumbImageDictionary objectForKey:cellIdentifier];
        
        if (![self subViews:contentView.subviews containsClass:UIImageView.class] && thumbData) {
            UIImage *img_thumb = [UIImage imageWithData:thumbData];
            UIImageView *imgView_thumb = [[UIImageView alloc] initWithImage:img_thumb];
            [imgView_thumb setFrame:CGRectMake(__tableCellImgLeftMargin, 0, __tableCellImgWidth, __tableCellHeight)];
            
            [contentView addSubview:imgView_thumb];
            //NSLog(@"added %@", cellIdentifier);
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.parentViewController.navigationItem.title = @"영화목록";
    
    ParentViewController *parent = self.parentViewController;
    [parent startLoading];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *data = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
    data = [NSString stringWithFormat:@"id=%@", data];
    [dataArray addObject:data];
    [[SessionManager sharedData] pushDataWith:self.parentViewController baseURL:__baseURL subURL:__movieURL data:dataArray methodString:@"GET"];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Header";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return __tableCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [[DataManager sharedData].DataDictionary objectForKey:__moviesURL];
    return array.count;
}

- (void)backButtonAction {
    NSLog(@"backButtonAction");
    ParentViewController *parent = self.parentViewController;
    [parent DataArray];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
