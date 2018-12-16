//
//  movieViewController.m
//  boostcamp
//
//  Created by user on 17/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#import "movieViewController.h"
#import "SessionManager.h"
#import "DataManager.h"
#import "define.h"

@interface movieViewController ()

@property (strong, nonatomic) UIScrollView *scView;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation movieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollView];
    [_contentView addSubview:[self topView]];
    // Do any additional setup after loading the view.
}

- (UIView *)topView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __ViewWidth, __scViewHeight * 0.5)];
    
    NSDictionary *data = [[DataManager sharedData].DataDictionary objectForKey:__movieURL];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __topLabelWidth, __topLabelHeight)];
    [titleLabel setCenter:CGPointMake(0, __topTitleCenter)];
    [titleLabel setFrame:CGRectMake(__topLabelX, titleLabel.frame.origin.y, __topLabelWidth, __topLabelHeight)];
    [titleLabel setText:[NSString stringWithFormat:@"%@", [data objectForKey:@"title"]]];
    [titleLabel setFont:[UIFont systemFontOfSize:__titleCellFontSize]];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __topLabelWidth, __topLabelHeight)];
    [dateLabel setFrame:CGRectMake(__topLabelX, titleLabel.frame.origin.y + __topLabelHeight + __tableCellImgLeftMargin, __topLabelWidth, __topLabelHeight)];
    [dateLabel setText:[NSString stringWithFormat:@"%@개봉", [data objectForKey:@"date"]]];
    [dateLabel setFont:[UIFont systemFontOfSize:__titleCellFontSize]];
    
    UILabel *genreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __topLabelWidth, __topLabelHeight)];
    [genreLabel setFrame:CGRectMake(__topLabelX, dateLabel.frame.origin.y + __topLabelHeight + __tableCellImgLeftMargin, __topLabelWidth, __topLabelHeight)];
    [genreLabel setText:[NSString stringWithFormat:@"%@/%@개봉", [data objectForKey:@"genre"], [data objectForKey:@"duration"]]];
    [genreLabel setFont:[UIFont systemFontOfSize:__titleCellFontSize]];
    
    
    [topView addSubview:titleLabel];
    [topView addSubview:dateLabel];
    [topView addSubview:genreLabel];
    
    return topView;
}

- (void)initScrollView {
    _scView = [[UIScrollView alloc] init];
    [self.view addSubview:_scView];
    
    _scView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint *pointerC = [NSLayoutConstraint constraintWithItem:_scView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_scView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [_scView.superview addConstraint:pointerC]; //leading
    
    pointerC = [NSLayoutConstraint constraintWithItem:_scView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:__ViewStartOrigin];
    [_scView.superview addConstraint:pointerC]; //top
    
    pointerC = [NSLayoutConstraint constraintWithItem:_scView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:__ViewWidth];
    [_scView.superview addConstraint:pointerC]; //width
    
    pointerC = [NSLayoutConstraint constraintWithItem:_scView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:__scViewHeight];
    [_scView.superview addConstraint:pointerC]; //height
    
    
    _contentView = [[UIView alloc] init];
    [_scView addSubview:_contentView];
    
    _contentView.translatesAutoresizingMaskIntoConstraints = false;
    
    pointerC = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [_contentView.superview addConstraint:pointerC]; //leading
    
    pointerC = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [_contentView.superview addConstraint:pointerC]; //Top
    
    pointerC = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [_contentView.superview addConstraint:pointerC]; //Trailing
    
    pointerC = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:__scViewEndOrigin];
    [_contentView.superview addConstraint:pointerC]; //Bottom
    
    pointerC = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:__ViewWidth];
    [_contentView.superview addConstraint:pointerC]; //Width
    
    pointerC = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2000];
    [_contentView.superview addConstraint:pointerC]; //Height
    
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
