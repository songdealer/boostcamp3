//
//  ParentViewController.h
//  boostcamp
//
//  Created by user on 13/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "CollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN
 //tableView reload is OK. 와 Receving Data is OK 사이에서 dic setobject 에러, receving data 다음 다시 tableview reload
@interface ParentViewController : UITabBarController

@property (strong, nonatomic) TableViewController *tableVC;
@property (strong, nonatomic) CollectionViewController *collectionVC;

- (void)mappingChildVC:(UIViewController *)childVC;
- (NSMutableArray *)DataArray;
- (void)startLoading;
- (void)endLoading;

@end

NS_ASSUME_NONNULL_END
