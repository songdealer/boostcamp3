//
//  CollectionViewController.h
//  boostcamp
//
//  Created by user on 12/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"
#import "define.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

- (void)startForAppearance;

@end

NS_ASSUME_NONNULL_END
