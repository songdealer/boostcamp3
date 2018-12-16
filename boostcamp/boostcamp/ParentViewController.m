//
//  ParentViewController.m
//  boostcamp
//
//  Created by user on 13/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import "ParentViewController.h"
#import "movieViewController.h"
#import "SessionManager.h"
#import "DataManager.h"
#import "define.h"

@interface ParentViewController () <SessionDataDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UIView *loading_cover;

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoading];
    [self readyDataSessionWithData:[self DataArray]];
    
    
    UIBarButtonItem *btn_settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonAction)];
    
    [self.navigationItem setRightBarButtonItem:btn_settings];
    
    // Do any additional setup after loading the view.
}

- (void)mappingChildVC:(UIViewController *)childVC {
    if([childVC.class isEqual:TableViewController.class]) {
        _tableVC = (TableViewController *)childVC;
        //NSLog(@"tableVC mapping is OK.");
    }
    else if([childVC.class isEqual:CollectionViewController.class]) {
        _collectionVC = (CollectionViewController *)childVC;
        //NSLog(@"collectionVC mapping is OK.");
    }
}

- (NSMutableArray *)DataArray{
    NSString *order_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"order_type"];
    if(!order_type) {
        order_type = @"0";
    }
    if([order_type isEqualToString:@"0"]) {
        self.navigationItem.title = @"예매율순";
    }
    else if([order_type isEqualToString:@"1"]) {
        self.navigationItem.title = @"큐레이션순";
    }
    else {
        self.navigationItem.title = @"개봉일순";
    }
    NSString *data = [NSString stringWithFormat:@"order_type=%@", order_type];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:data];
    
    return dataArray;
}

- (void)readyDataSessionWithData:(NSMutableArray *)dataArray {
    [self startLoading];
    
    [[SessionManager sharedData] pushDataWith:self baseURL:__baseURL subURL:__moviesURL data:dataArray methodString:@"GET"];
}

#pragma mark - loading
- (void)initLoading {
    _loading_cover = [[UIView alloc] initWithFrame:self.view.frame];
    [_loading_cover setBackgroundColor:[UIColor blackColor]];
    [_loading_cover setAlpha:0.4];
    
    _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_loading setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [_loading setHidesWhenStopped:YES];
    
    [self.view addSubview:_loading_cover];
    [self.view addSubview:_loading];
    [_loading_cover setHidden:YES];
}

- (void)startLoading {
    if(![_loading isAnimating]) {
        [_loading_cover setHidden:NO];
        [_loading startAnimating];
    }
}

- (void)endLoading {
    [_loading_cover setHidden:YES];
    [_loading stopAnimating];
}

- (void)refreshChildViews {
    [_tableVC startForAppearance];
    [_collectionVC startForAppearance];
}

#pragma mark - SessionDelegate
- (void)BackgroundReceivedData:(NSURL *)location URL:(NSString *)URL {
    //NSLog(@"url : %@",URL);
    NSArray *dataSet = [URL componentsSeparatedByString:@"_"];
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    if([[dataSet firstObject] isEqualToString:@"thumb"]) {
        [[DataManager sharedData].thumbImageDictionary setObject:imageData forKey:[dataSet lastObject]];
        [self refreshChildViews];
    }
    else {
        
    }
}
- (void)SuccessReceivedData:(NSData *)data URL:(NSString *)URL {
    if([URL isEqualToString:[NSString stringWithFormat:@"%@%@", __baseURL, __moviesURL]]) {
        //NSLog(@"Receving Data is OK.");
        [self endLoading];
        [self refreshChildViews];
        NSLog(@"movies");
        
    }
    else if ([URL isEqualToString:[NSString stringWithFormat:@"%@%@", __baseURL, __movieURL]]) {
        //NSLog(@"Receving ThumbImage is OK.");
        [self endLoading];
        movieViewController *movieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieVC"];
        [self.navigationController pushViewController:movieVC animated:YES];
        
        UIBarButtonItem *btn_back = [[UIBarButtonItem alloc] initWithTitle:@"< 영화목록" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
        [self.navigationItem setLeftBarButtonItem:btn_back];
    }
    else if ([URL isEqualToString:[NSString stringWithFormat:@"%@%@", __baseURL, __commentsURL]]) {
        NSLog(@"comments");
    }
}

- (void)FailReceivedData:(NSError *)error URL:(NSString *)URL {
    if([error.localizedDescription isEqualToString:@"The request timed out."]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Request Timed out" message:@"시간 초과" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* confirm = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self endLoading];
        }];
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"네트워크를 확인해주세요" message:@"데이터를 불러오지 못했습니다" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* confirm = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self endLoading];
        }];
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
}

#pragma mark - ButtonAction
- (void)settingsButtonAction {
    UIAlertController *sortingAlert = [UIAlertController alertControllerWithTitle:@"정렬방식 선택" message:@"영화를 어떤 방식으로 정렬할까요?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *rate = [UIAlertAction actionWithTitle:@"예매율" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"order_type"];
        [self readyDataSessionWithData:[self DataArray]];
    }];
    UIAlertAction *curation = [UIAlertAction actionWithTitle:@"큐레이션" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"order_type"];
        [self readyDataSessionWithData:[self DataArray]];
    }];
    UIAlertAction *date = [UIAlertAction actionWithTitle:@"개봉일" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"order_type"];
        [self readyDataSessionWithData:[self DataArray]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {
    }];
    
    [sortingAlert addAction:rate];
    [sortingAlert addAction:curation];
    [sortingAlert addAction:date];
    [sortingAlert addAction:cancel];
    
    [self presentViewController:sortingAlert animated:YES completion:nil];
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
