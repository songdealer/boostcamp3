//
//  SessionManager.h
//  boostcamp
//
//  Created by user on 10/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SessionDataDelegate <NSObject>

- (void)SuccessReceivedData:(NSData *)data URL:(NSString *)URL;
- (void)FailReceivedData:(NSError *)error URL:(NSString *)URL;
- (void)BackgroundReceivedData:(NSURL *)location URL:(NSString *)URL;
- (void)refreshChildViews;

@end

@interface SessionManager : NSObject <NSURLSessionDataDelegate>

+ (instancetype)sharedData;
@property (nonatomic, weak) id<SessionDataDelegate> delegate;

- (void)pushDataWith:(NSObject *)main baseURL:(NSString *)baseURL subURL:(NSString *)subURL data:(NSArray *)data methodString:(NSString *)method;
- (void)sendDataForImageSubURL:__moviesURL;

@end

NS_ASSUME_NONNULL_END
