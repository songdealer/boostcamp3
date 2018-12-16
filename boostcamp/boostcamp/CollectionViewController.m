//
//  CollectionViewController.m
//  boostcamp
//
//  Created by user on 12/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import "CollectionViewController.h"
#import "ParentViewController.h"
#import "DataManager.h"
#import "define.h"

@interface CollectionViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *createdCellArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ParentViewController *parent = self.parentViewController;
    [parent mappingChildVC:self];
    
    [self startForAppearance];
    
    // Do any additional setup after loading the view.
}

- (void)startForAppearance {
    if(!_collectionView) {
        _createdCellArray = [NSMutableArray array];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(__collectionCellWidth, __collectionCellHeight);
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, __ViewStartOrigin, __ViewWidth, __ViewHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundView = nil;
        _collectionView.autoresizingMask = UIViewAutoresizingNone;
        [self.view addSubview:_collectionView];
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        
        refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@""];
        [_collectionView addSubview:refreshControl];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [_collectionView reloadData];
        });
    }
    //NSLog(@"collectionView reload is OK.");
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

#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [[[DataManager sharedData].DataDictionary objectForKey:__moviesURL] objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [data objectForKey:@"id"];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(![_createdCellArray containsObject:cell]) {
        [_createdCellArray addObject:cell];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __collectionCellWidth, __collectionCellHeight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(__collectionCellViewMargin, __collectionCellTitleTopMargin, __collectionCellViewWidth, __collectionCellLabelHeight)];
        [titleLabel setText:[data objectForKey:@"title"]];
        [titleLabel setFont:[UIFont systemFontOfSize:__titleCellFontSize]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(__collectionCellViewMargin, __collectionCellSubTitleTopMargin, __collectionCellViewWidth, __collectionCellLabelHeight)];
        [subTitleLabel setText:[NSString stringWithFormat:@"%@위(%g) / %g%%", [data objectForKey:@"reservation_grade"], [[data objectForKey:@"user_rating"] doubleValue], [[data objectForKey:@"reservation_rate"] doubleValue]]];
        [subTitleLabel setFont:[UIFont systemFontOfSize:__subTitleCellFontSize]];
        [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(__collectionCellViewMargin, __collectionCellDateTopMargin, __collectionCellViewWidth, __collectionCellLabelHeight)];
        [dateLabel setText:[NSString stringWithFormat:@"%@", [data objectForKey:@"date"]]];
        [dateLabel setFont:[UIFont systemFontOfSize:__dateCellFontSize]];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        
        [contentView addSubview:titleLabel];
        [contentView addSubview:subTitleLabel];
        [contentView addSubview:dateLabel];
        
        [cell.contentView addSubview:contentView];
        
        cell.backgroundColor = [UIColor clearColor];
        //NSLog(@"%@ contentView created.", cellIdentifier);
    }
    UIView *contentView = [cell.contentView.subviews firstObject];
    NSData *thumbData = [[DataManager sharedData].thumbImageDictionary objectForKey:cellIdentifier];
    
    if (![self subViews:contentView.subviews containsClass:UIImageView.class] && thumbData) {
        UIImage *img_thumb = [UIImage imageWithData:thumbData];
        UIImageView *imgView_thumb = [[UIImageView alloc] initWithImage:img_thumb];
        [imgView_thumb setFrame:CGRectMake(__collectionCellViewMargin, __collectionCellViewMargin, __collectionCellViewWidth, __collectionCellImgHeight)];
        
        [contentView addSubview:imgView_thumb];
        //NSLog(@"updated");//, cellIdentifier);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.parentViewController.navigationItem.title = @"영화목록";
    
    ParentViewController *parent = self.parentViewController;
    [parent startLoading];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSString *data = [collectionView cellForItemAtIndexPath:indexPath].reuseIdentifier;
    data = [NSString stringWithFormat:@"id=%@", data];
    [dataArray addObject:data];
    [[SessionManager sharedData] pushDataWith:self.parentViewController baseURL:__baseURL subURL:__movieURL data:dataArray methodString:@"GET"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = [[DataManager sharedData].DataDictionary objectForKey:__moviesURL];
    return array.count;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
