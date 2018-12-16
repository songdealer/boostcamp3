//
//  SessionManager.m
//  boostcamp
//
//  Created by user on 10/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import "SessionManager.h"
#import "ParentViewController.h"
#import "DataManager.h"
#import "define.h"

@interface SessionManager ()

@property (strong, nonatomic) NSMutableArray *dataQueue;
@property (strong, nonatomic) NSData *receiveData;
@property (strong, nonatomic) NSString *workingURL;
@property (strong, nonatomic) NSMutableData *appendedData;
@property (strong, nonatomic) NSMutableArray *downloadTaskArray;

@end

@implementation SessionManager

+ (instancetype)sharedData {
    static SessionManager* sharedData;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedData = [[SessionManager alloc] init];
    });
    return sharedData;
}

- (void)pushDataWith:(NSObject *)main baseURL:(NSString *)baseURL subURL:(NSString *)subURL data:(NSArray *)data methodString:(NSString *)method {
    NSMutableDictionary *dataGroup = [NSMutableDictionary dictionary];
    
    [dataGroup setObject:main forKey:@"main"];
    [dataGroup setObject:baseURL forKey:@"baseURL"];
    [dataGroup setObject:subURL forKey:@"subURL"];
    [dataGroup setObject:data forKey:@"data"];
    [dataGroup setObject:method forKey:@"method"];
    
    //NSLog(@"pushData is OK.");
    if(_dataQueue == nil) {
        _dataQueue = [NSMutableArray array];
        [_dataQueue addObject:dataGroup];
        [self sendDataWithData:dataGroup];
    }
    else {
        [_dataQueue addObject:dataGroup];
    }
}

- (void)popData {
    //NSLog(@"data queue 뺌.");
    _workingURL = nil;
    [_dataQueue removeObject:[_dataQueue firstObject]];
    if(_dataQueue.count) {
        [self sendDataWithData:[_dataQueue firstObject]];
    }
    else {
        _dataQueue = nil;
    }
}

- (void)sendDataWithData:(NSDictionary *)dataGroup {
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    //[conf setTimeoutIntervalForRequest:30];
    conf.discretionary = true;
    [conf setTimeoutIntervalForResource:30];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSArray *dataArray = [dataGroup objectForKey:@"data"];
    NSString *dataString = @"";
    
    for(NSString *data in dataArray) { // data parameter
        dataString = [dataString stringByAppendingString:data];
        dataString = [dataString stringByAppendingString:@"&"];
    }
    dataString = [dataString substringToIndex: dataString.length - 1];
    
    NSString *addr = [NSString stringWithFormat:@"%@%@", [dataGroup objectForKey:@"baseURL"], [dataGroup objectForKey:@"subURL"]];
    
    _workingURL = addr;
    
    NSURL *url = [NSURL URLWithString:addr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *method = [dataGroup objectForKey:@"method"];
    
    if([method isEqualToString:@"GET"]) {
        addr = [addr stringByAppendingString:@"?"];
        addr = [addr stringByAppendingString:dataString];
        url = [NSURL URLWithString:addr];
        urlRequest = [NSMutableURLRequest requestWithURL:url];
    }
    else { // POST
        [urlRequest setHTTPBody:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [urlRequest setHTTPMethod:method];
    
    NSURLSessionDataTask *mainDataTask = [session dataTaskWithRequest:urlRequest];
    [mainDataTask resume];
    //NSLog(@"%@ data보냄.", addr);
}

- (void)makeDataTaskWithDataArray:(NSArray *)dataArray URL:(NSURL *)URL {
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"%@_%@", [dataArray firstObject], [dataArray lastObject]]];
    //first : thumb, image / last : titleName
    //NSLog(@"conf : %@", conf.identifier);
    conf.discretionary = true;
    [conf setTimeoutIntervalForResource:30];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *mainDataTask = [session downloadTaskWithURL:URL];
    if(_downloadTaskArray) {
    }
    else {
        _downloadTaskArray = [NSMutableArray array];
    }
    [_downloadTaskArray addObject:mainDataTask];
    
    [mainDataTask resume];
}

- (void)sendDataForImageSubURL:(NSString *)subURL {
    NSArray *dataArray =[[DataManager sharedData].DataDictionary objectForKey:subURL];
    
    if([subURL isEqualToString:@"/movies"]) {
        for(NSDictionary *data in dataArray) {
            NSMutableArray *dataSet = [NSMutableArray array];
            [dataSet addObject:@"thumb"];
            [dataSet addObject:[data objectForKey:@"id"]];
            NSURL *url = [NSURL URLWithString:[data objectForKey:@"thumb"]];
            [self makeDataTaskWithDataArray:dataSet URL:url];
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if(_appendedData) {
        [_appendedData appendData:data];
    }
    else {
        _appendedData = [data mutableCopy];
    }
    
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:_appendedData options:nil error:nil];
    
    if(json) {
        NSObject *main = [[_dataQueue firstObject] objectForKey:@"main"];
        self.delegate = main;
        
        NSString *subURL = [[_dataQueue firstObject] objectForKey:@"subURL"];
        
        if([subURL isEqualToString:__movieURL]) {
            [[DataManager sharedData].DataDictionary setObject:json forKey:subURL];
        }
        else if([subURL isEqualToString:__moviesURL]) {
            NSString *key = [subURL substringFromIndex:1];
            [[DataManager sharedData].DataDictionary setObject:[json objectForKey:key] forKey:subURL];
        }
        else {
            [[DataManager sharedData].DataDictionary setObject:[json objectForKey:subURL] forKey:subURL];
        }
        //NSLog(@"working : %@", _workingURL);
        
        [self.delegate SuccessReceivedData:data URL:_workingURL];
        [self popData];
        _appendedData = nil;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    /*NSLog(@"location : %@", location);
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"paths : %@", paths);
    NSString *documentsDirectory = [paths firstObject];
    //NSLog(@"docu DIR : %@", documentsDirectory);
    NSString *download = [documentsDirectory stringByAppendingPathComponent:location.lastPathComponent];
    NSURL *downloadURL = [NSURL fileURLWithPath:download];
    NSLog(@"downURL : %@", downloadURL.absoluteString);
    BOOL success = [NSFileManager.defaultManager moveItemAtURL:location toURL:downloadURL error:&error];
    NSLog(@"success : %@", success ? @"YES" : @"NO");
    if(error) {
        NSLog(@"moved error : %@", error);
    }*/
    
    [self.delegate BackgroundReceivedData:location URL:session.configuration.identifier];
    
    /*dispatch_async(dispatch_get_main_queue(), ^(void){
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSLog(@"location : %@", location);
        //NSLog(@"data : %@, error : %@", data.description, error);
        
        NSLog(@"final : %@", data.description);
        //[self.delegate SuccessReceivedData:data URL:session.configuration.identifier];
        NSLog(@"img req받음.");
    });*/
    //NSLog(@"success : %@", session.configuration.identifier);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if(error) {
        NSObject *main = [[_dataQueue firstObject] objectForKey:@"main"];
        self.delegate = main;
        
        [self.delegate FailReceivedData:error URL:_workingURL];
        [self popData];
    }
}

@end
