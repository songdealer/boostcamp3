//
//  ViewController.h
//  boostcamp
//
//  Created by user on 10/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
- (void)startForAppearance;

@end

