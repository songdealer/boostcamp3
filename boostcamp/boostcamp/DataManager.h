//
//  DataManager.h
//  boostcamp
//
//  Created by user on 15/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (instancetype)sharedData;

@property (strong, nonatomic) NSMutableDictionary *DataDictionary;
@property (strong, nonatomic) NSMutableDictionary *thumbImageDictionary;
@property (strong, nonatomic) NSMutableDictionary *movieImageDictionary;

- (void)initDataDictionary;

@end

NS_ASSUME_NONNULL_END
