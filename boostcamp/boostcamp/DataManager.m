//
//  DataManager.m
//  boostcamp
//
//  Created by user on 15/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)sharedData {
    static DataManager* sharedData;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedData = [[DataManager alloc] init];
    });
    return sharedData;
}

- (void)initDataDictionary {
    _DataDictionary = [NSMutableDictionary dictionary];
    _thumbImageDictionary = [NSMutableDictionary dictionary];
    _movieImageDictionary = [NSMutableDictionary dictionary];
    NSLog(@"initialize Dictionary");
}

@end
