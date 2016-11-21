//
//  ViewController.m
//  Weather
//
//  Created by DongMeiliang on 25/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "UIColor+DMLAdditions.h"
#import "UIImage+DMLAdditions.h"
#import "NSUserDefaults+DMLAppSpecific.h"
#import "NSTimer+EOCBlocksSupport.h"

#import "DMLWeatherViewController.h"
#import "DMLWeatherCollectionCell.h"
#import "DMLWeatherTableCell.h"
#import "DMLSubtitleTableCell.h"
#import "DMLHairLineDecorateView.h"
#import "DMLCurrentWeatherAPIManager.h"
#import "DMLDailyForecastAPIManager.h"
#import "DMLPerThreeHourForecastAPIManager.h"

@import CoreLocation;

// Weather Icons: https://www.openweathermap.org/weather-conditions
/*
    outlineView = 500 - 40 = 460 px = 230 pt
 
    todayView = 554 - 500 = 54 px = 27 pt
 
    hourWeatherView = 745 - 554 = 191 px = 96 pt
    
    week weather view = 916 - 392 = 524 px = 262 pt
 
    todayWeatherDescribleLabel = 1038 - 916 = 122 px = 61 pt
 
    weather information view = 1048 - 410 = 638 px = 319 pt
    
    contentSize = 280 + 27 + 96 + 262 + 61 + 319 = 1045
 
 ---
 
    outlineView: | locationLabel(34) - weatherLabel(21) - temperatureLabel(112) - |

 */

static const CGFloat sOutlineViewHeight = 230.0;
static const CGFloat sContentViewHeight = 450.0;
static const CGFloat sCollapseOutlineViewHeight = 55.0;

static const CGFloat sDistanceAffectAlpha = 50.0;

static const CGFloat sLocationLabelHeight = 34.0;
static const CGFloat sWeatherLabelHeight = 21.0;
static const CGFloat sTemperatureLabelHeight = 112.0;

static const CGFloat sMaxTopPaddingOfLocationLabel = 30.0;

static const CGFloat sTodayViewHeight = 27.0;
static const CGFloat sHourWeatherViewHeight = 96.0;

static const CGFloat sInnerContentViewHeight = 652.0;

static const CGFloat sItemWidth = 75.0;

static const CGFloat sWeatherCellHeight = 32.0;
static const CGFloat sSubtitleCellHeight = 52.0;

static const CGFloat sStandarPadding = 20.0;

static const NSUInteger sWeatherForecastSections = 2;
static const NSUInteger sDaysOfForecast = 9;

static NSString *const sWeatherCollectionCellIdentifier = @"sWeatherCollectionCellIdentifier";
static NSString *const sWeatherTableCellIdentifier = @"sWeatherTableCellIdentifier";
static NSString *const sSubtitleTableCellIdentifier = @"sSubtitleTableCellIdentifier";

static NSString *const sSunriseKey = @"Sunrise";
static NSString *const sSunsetKey = @"Sunset";
static NSString *const sChanceOfRainKey = @"Chance Of Rain";
static NSString *const sHumidityKey = @"Humidity";
static NSString *const sWindKey = @"Wind";
static NSString *const sFeelsLikeKey = @"Feels Like";
static NSString *const sPrecipitationKey = @"Precipitation";
static NSString *const sPressureKey = @"Pressure";
static NSString *const sVisibilityKey = @"Visibility";
static NSString *const sUVIndexKey = @"UV Index";

static NSString *const sWeatherIconBaseURLString = @"http://openweathermap.org/img/w/";

@interface DMLWeatherViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, CLLocationManagerDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *contentView;

@property (nonatomic) UIView *outlineView;
@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *weatherLabel;
@property (nonatomic) UILabel *temperatureLabel;

@property (nonatomic) UIView *dynamicView;

@property (nonatomic) UIView *todayView;
@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) UILabel *maxTemperatureLabel;
@property (nonatomic) UILabel *minTemperatureLabel;

@property (nonatomic) UICollectionView *hourWeatherCollectionView;
@property (nonatomic) DMLHairLineDecorateView *upperHairLineView;
@property (nonatomic) DMLHairLineDecorateView *lowerHairLineView;

@property (nonatomic) UIScrollView *innerScrollView;
@property (nonatomic) UIView *innerContentView;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIToolbar *toolbar;

@property (nonatomic) NSLayoutConstraint *topConstraintOfLocationLabel;

@property (nonatomic) DMLCurrentWeatherAPIManager *currentWeatherAPIManager;
@property (nonatomic) DMLDailyForecastAPIManager *dailyForecastAPIManager;
@property (nonatomic) DMLPerThreeHourForecastAPIManager *perThreeHourForecastAPIManager;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) NSTimer *weatherUpdateTimer;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *hourDateFormatter;
@property (nonatomic) NSDateFormatter *hhmmDateFormatter;

@property (nonatomic, copy) NSArray *listOfForecastWeather;
@property (nonatomic, copy) NSArray *listOfHourWeather;
@property (nonatomic, copy) NSMutableDictionary *weatherConditions;
@property (nonatomic, copy) NSArray *weatherConditionKeyPairs;

@end

@implementation DMLWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dml_bostonBlue];
    
    // Set up root view hierarchy
    [self.view addSubview:self.outlineView];
    [self configureConstraintsForOutlineView];
    
    [self.view addSubview:self.scrollView];
    [self configureConstraintsForScrollView];
    
    [self.scrollView addSubview:self.contentView];
    [self configureConstraintsForContentView];
    
    // View hierarchy of outline view
    [self.outlineView addSubview:self.locationLabel];
    [self configureConstraintsForLocationLabel];
    
    [self.outlineView addSubview:self.weatherLabel];
    [self configureConstraintsForWeatherLabel];
    
    [self.outlineView addSubview:self.temperatureLabel];
    [self configureConstraintsForTemperatureLabel];
    
    // View hierarchy of content view
    [self.contentView addSubview:self.todayView];
    [self configureConstraintsForTodayView];
    
    [self.contentView addSubview:self.hourWeatherCollectionView];
    [self configureConstraintsForHourWeatherCollectionView];
    
    [self.contentView addSubview:self.innerScrollView];
    [self configureConstraintsForInnerScrollView];
    
    // Configure hair line for hour weahter collection view
    [self.contentView addSubview:self.upperHairLineView];
    [self.contentView addSubview:self.lowerHairLineView];
    [self configureConstraintsForUpperHairLineView];
    [self configureConstraintsForLowerHairLineView];
    
    // View hierarchy of scroll view
    [self.innerScrollView addSubview:self.innerContentView];
    [self configureConstraintsForInnerContentView];
    
    // View hiearchy of inner content view
    [self.innerContentView addSubview:self.tableView];
    [self configureConstraintsForTableView];
    
    // View hiearchy of today view
    [self.todayView addSubview:self.dayLabel];
    [self.todayView addSubview:self.maxTemperatureLabel];
    [self.todayView addSubview:self.minTemperatureLabel];
    
    [self configureConstraintsForDayLabel];
    [self configureConstraintsForMaxTemperatureLabel];
    [self configureConstraintsForMinTemperatureLabel];
    
    [self.view addSubview:self.toolbar];
    [self configureConstraintsForToolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (authorizationStatus != kCLAuthorizationStatusRestricted && authorizationStatus != kCLAuthorizationStatusDenied) {
        self.locationManager.delegate = self;
        
        if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestAlwaysAuthorization];
        }
        else {
            if ([CLLocationManager locationServicesEnabled]) {
                [self.locationManager startUpdatingLocation];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
    
    self.locationManager.delegate = nil;
    
    if ([self.weatherUpdateTimer isValid]) {
        [self.weatherUpdateTimer invalidate];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat innerScrollViewOffsetY = DBL_MAX;
    
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
    
    CGFloat yOffset = scrollView.contentOffset.y;

    if (scrollView == self.scrollView) {
        CGFloat yIntentset = sOutlineViewHeight - sCollapseOutlineViewHeight;
        
        // En-Disable inner scroll view
        if (yOffset > 0 && !self.innerScrollView.scrollEnabled) {
            self.scrollView.scrollEnabled = NO;
            self.innerScrollView.scrollEnabled = YES;
        }
        
        if (yOffset > sDistanceAffectAlpha - yIntentset) {
            self.temperatureLabel.alpha = 0.0;
        }
        else if (yOffset < -yIntentset) {
            self.temperatureLabel.alpha = 1.0;
        }
        else {
            // 1 / sDistanceAffectAlpha * distance = 1 / 50 * (yIntentset - sDistanceAffectAlpha + yOffset) = 0.02 * (yIntentset - sDistanceAffectAlpha + yOffset)
            self.temperatureLabel.alpha = -0.02 * (yIntentset - sDistanceAffectAlpha + yOffset);
//            NSLog(@"Alpha:%.2f\n", self.temperatureLabel.alpha);
        }
        
        // Sync today view's alpha with temperature label
        self.todayView.alpha = self.temperatureLabel.alpha;
        
        // Animate location label
        if (yOffset > 0) {
            self.topConstraintOfLocationLabel.constant = 0;
        }
        else if (yOffset < -(yIntentset - sDistanceAffectAlpha)) {
            self.topConstraintOfLocationLabel.constant = sMaxTopPaddingOfLocationLabel;
        }
        else {
            // sMaxTopPaddingOfLocationLabel / 125 * yOffset = 30 / 125 * yOffset = 0.24 * yOffset
            self.topConstraintOfLocationLabel.constant = -0.24 * yOffset;
        }
        
        [self.outlineView setNeedsUpdateConstraints];
    }
    else if (scrollView == self.innerScrollView) {
//        NSLog(@"canCancelContentTouches:%@", scrollView.canCancelContentTouches ? @"YES" : @"NO");

        if (fabs(innerScrollViewOffsetY - DBL_MAX) < DBL_EPSILON) {
            innerScrollViewOffsetY = yOffset;
        }
        else {
            BOOL scrollDown = yOffset < innerScrollViewOffsetY;
            if (scrollDown && yOffset < 0) {
                self.innerScrollView.scrollEnabled = NO;
                self.scrollView.scrollEnabled = YES;
                
                innerScrollViewOffsetY = DBL_MAX;
            }
            else {
                innerScrollViewOffsetY = yOffset;
            }
        }
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"%s\n", __PRETTY_FUNCTION__);
//}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLWeatherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sWeatherCollectionCellIdentifier forIndexPath:indexPath];
    
    NSUInteger mappedIndex = indexPath.row / 3;// Per three hour forecast
    
    if (mappedIndex < self.listOfHourWeather.count) {
        NSDictionary *hourForecastWeather = self.listOfHourWeather[mappedIndex];
        NSArray *weathers = hourForecastWeather[@"weather"];
        if (weathers.count > 0) {
            NSDictionary *weather = weathers.firstObject;
            
            NSString *weatherIconString = [NSString stringWithFormat:@"%@%@.png", sWeatherIconBaseURLString, weather[@"icon"]];
            
            [cell.weatherImageView setImageWithURL:[NSURL URLWithString:weatherIconString]];
        }
        
        NSDictionary *temp = hourForecastWeather[@"main"];
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%@", temp[@"temp"]];
        
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour value:indexPath.row toDate:[NSDate date] options:0];
        cell.hourLabel.text = [self.hourDateFormatter stringFromDate:date];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(sItemWidth, sHourWeatherViewHeight);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sWeatherForecastSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return self.weatherConditionKeyPairs.count / 2;
    }
    else {
        return sDaysOfForecast;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section) {
        DMLSubtitleTableCell *subtitleCell = [tableView dequeueReusableCellWithIdentifier:sSubtitleTableCellIdentifier forIndexPath:indexPath];
        
        NSUInteger keyIndex = indexPath.row * 2;
        
        NSString *key = self.weatherConditionKeyPairs[keyIndex];
        NSString *subKey = self.weatherConditionKeyPairs[keyIndex + 1];
        
        subtitleCell.titleLabel.text = [key stringByAppendingString:@":"];
        subtitleCell.titleValueLabel.text = self.weatherConditions[key];
        
        subtitleCell.subtitleLabel.text = [subKey stringByAppendingString:@":"];
        subtitleCell.subtitleValueLabel.text = self.weatherConditions[subKey];
        
        cell = subtitleCell;
    }
    else {
        DMLWeatherTableCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:sWeatherTableCellIdentifier forIndexPath:indexPath];
        
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:indexPath.row + 1 toDate:[NSDate date] options:0];
        
        weatherCell.dayLabel.text = [self.dateFormatter stringFromDate:date];
        
        if (indexPath.row < self.listOfForecastWeather.count) {
            NSDictionary *forecastWeather = self.listOfForecastWeather[indexPath.row];
            
            NSDictionary *temp = forecastWeather[@"temp"];
            
            weatherCell.maxTemperatureLabel.text = [NSString stringWithFormat:@"%@", temp[@"max"]];
            weatherCell.minTemperatureLabel.text = [NSString stringWithFormat:@"%@", temp[@"min"]];
            
            NSArray *weathers = forecastWeather[@"weather"];
            if (weathers.count > 0) {
                NSDictionary *weather = weathers.firstObject;
                
                NSString *weatherIconString = [NSString stringWithFormat:@"%@%@.png", sWeatherIconBaseURLString, weather[@"icon"]];
                
                [weatherCell.weatherImageView setImageWithURL:[NSURL URLWithString:weatherIconString]];
            }
        }
        else {
            weatherCell.maxTemperatureLabel.text = @"-";
            weatherCell.minTemperatureLabel.text = @"-";
        }
        
        cell = weatherCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return sSubtitleCellHeight;
    }
    else {
        return sWeatherCellHeight;
    }
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    NSDictionary *params = @{};
    
    CLLocation *location = self.locationManager.location;

    if (manager == self.currentWeatherAPIManager || manager == self.perThreeHourForecastAPIManager) {
        
        params = @{
                   @"lat" : @(location.coordinate.latitude),
                   @"lon" : @(location.coordinate.longitude),
                   @"units" : @"metric"
                   };
    }
    else if (manager == self.dailyForecastAPIManager) {
        params = @{
                   @"lat" : @(location.coordinate.latitude),
                   @"lon" : @(location.coordinate.longitude),
                   @"cnt" : @(sDaysOfForecast),
                   @"units" : @"metric"
                   };
    }
    
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    if (manager == self.currentWeatherAPIManager) {
        
        [[NSUserDefaults standardUserDefaults] setLastWeatherUpdateTime:[NSDate date]];
        
        NSDictionary *responseDictionary = [manager fetchDataWithReformer:nil];
//        NSLog(@"responseDictionary:%@", responseDictionary);
        
        NSArray *weathers = responseDictionary[@"weather"];
        if (weathers.count > 0) {
            NSDictionary *weather = weathers.firstObject;
            
            self.weatherLabel.text = weather[@"main"];

        }
        
        self.locationLabel.text = responseDictionary[@"name"];

        NSDictionary *main = responseDictionary[@"main"];
        
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@ᵒ", main[@"temp"]];
        
        self.maxTemperatureLabel.text = [NSString stringWithFormat:@"%@", main[@"temp_max"]];
        self.minTemperatureLabel.text = [NSString stringWithFormat:@"%@", main[@"temp_min"]];
        
        self.weatherConditions[sPressureKey] = [NSString stringWithFormat:@"%@ hPa", main[@"pressure"]];
        self.weatherConditions[sHumidityKey] = [NSString stringWithFormat:@"%@ %%", main[@"humidity"]];
        
        NSDictionary *sys = responseDictionary[@"sys"];
        
        NSDate *sunrise = [[NSDate alloc] initWithTimeIntervalSince1970:[(NSNumber *)sys[@"sunrise"] doubleValue]];
        NSDate *sunset = [[NSDate alloc] initWithTimeIntervalSince1970:[(NSNumber *)sys[@"sunset"] doubleValue]];
        
        self.weatherConditions[sSunriseKey] = [self.hhmmDateFormatter stringFromDate:sunrise];
        self.weatherConditions[sSunsetKey] = [self.hhmmDateFormatter stringFromDate:sunset];
        
        NSDictionary *wind = responseDictionary[@"wind"];
        
        self.weatherConditions[sWindKey] = [NSString stringWithFormat:@"%@ %@m/s", wind[@"deg"], wind[@"speed"]];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (manager == self.dailyForecastAPIManager) {
        NSDictionary *responseDictionary = [manager fetchDataWithReformer:nil];
//        NSLog(@"responseDictionary:%@", responseDictionary);
        NSArray *listOfForecastWeather = responseDictionary[@"list"];
        if ([listOfForecastWeather isKindOfClass:[NSArray class]]) {
            self.listOfForecastWeather = listOfForecastWeather;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else if (manager == self.perThreeHourForecastAPIManager) {
        NSDictionary *responseDictionary = [manager fetchDataWithReformer:nil];
        NSArray *listOfHourWeather = responseDictionary[@"list"];
        if ([listOfHourWeather isKindOfClass:[NSArray class]]) {
            self.listOfHourWeather = listOfHourWeather;
            
            [self.hourWeatherCollectionView reloadData];
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    if (manager == self.currentWeatherAPIManager) {
        NSLog(@"%@", [manager fetchDataWithReformer:nil]);
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    static BOOL firstLaunched = NO;
    
    // Set up weather update timer
    if (!self.weatherUpdateTimer) {
        __weak typeof(self) weakSelf = self;
        self.weatherUpdateTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:2 * [CTNetworkingConfiguration sharedNetworkConfiguration].cacheOutDateTimeSeconds block:^{
            [weakSelf.currentWeatherAPIManager loadData];
            [weakSelf.dailyForecastAPIManager loadData];
            [weakSelf.perThreeHourForecastAPIManager loadData];
        } repeats:YES];
    }
    
    if (!firstLaunched) {
        firstLaunched = YES;
    }
    else {
        NSDate *date = [NSUserDefaults standardUserDefaults].lastWeatherUpdateTime;
        NSDate *cacheOutDate = [[NSDate date] dateByAddingTimeInterval:-1 * [CTNetworkingConfiguration sharedNetworkConfiguration].cacheOutDateTimeSeconds];
        NSComparisonResult result = [date compare:cacheOutDate];
        if (date && result != NSOrderedAscending) {
            return;
        }
    }
    
    // If it's a relatively recent event, turn off updates to save power.
    if (self.currentWeatherAPIManager.isLoading) {
        return;
    }
    
    CLLocation* location = [locations lastObject];
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self.currentWeatherAPIManager loadData];
    [self.dailyForecastAPIManager loadData];
    [self.perThreeHourForecastAPIManager loadData];
}

#pragma mark - Private Methods

- (void)configureConstraintsForOutlineView
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.outlineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.outlineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.outlineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.outlineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sOutlineViewHeight]];
}

- (void)configureConstraintsForScrollView
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:sCollapseOutlineViewHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForContentView
{
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetWidth(fullScreenRect)]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sContentViewHeight]];
}

- (void)configureConstraintsForLocationLabel
{
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    self.topConstraintOfLocationLabel = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeTop multiplier:1.0 constant:sMaxTopPaddingOfLocationLabel];
    
    [self.outlineView addConstraint:self.topConstraintOfLocationLabel];
    
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sLocationLabelHeight]];
}

- (void)configureConstraintsForWeatherLabel
{
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.locationLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sWeatherLabelHeight]];
}

- (void)configureConstraintsForTemperatureLabel
{
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.outlineView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weatherLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.outlineView addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sTemperatureLabelHeight]];
}

- (void)configureConstraintsForTodayView
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.todayView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.todayView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.todayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.todayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sTodayViewHeight]];
}

- (void)configureConstraintsForHourWeatherCollectionView
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hourWeatherCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hourWeatherCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hourWeatherCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hourWeatherCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sHourWeatherViewHeight]];
}

- (void)configureConstraintsForInnerScrollView
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hourWeatherCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForInnerContentView
{
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    
    [self.innerScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.innerScrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.innerScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.innerScrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.innerScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.innerScrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.innerScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.innerScrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.innerScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetWidth(fullScreenRect)]];
    [self.innerScrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.innerContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sInnerContentViewHeight]];
}

- (void)configureConstraintsForTableView
{
    [self.innerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.innerContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.innerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.innerContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.innerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.innerContentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.innerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.innerContentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForDayLabel
{
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sStandarPadding]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.maxTemperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-sStandarPadding]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForMaxTemperatureLabel
{
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.maxTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.minTemperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-sStandarPadding * 0.5]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.maxTemperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.maxTemperatureLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForMinTemperatureLabel
{
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.minTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sStandarPadding]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.minTemperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.todayView addConstraint:[NSLayoutConstraint constraintWithItem:self.minTemperatureLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForToolbar
{
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForUpperHairLineView
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.upperHairLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.upperHairLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.upperHairLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.todayView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.upperHairLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
}

- (void)configureConstraintsForLowerHairLineView
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerHairLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerHairLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerHairLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hourWeatherCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lowerHairLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
}

#pragma mark - Getters

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _scrollView.contentInset = UIEdgeInsetsMake(sOutlineViewHeight - sCollapseOutlineViewHeight, 0, 44.0, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _contentView;
}

- (UIView *)outlineView
{
    if (!_outlineView) {
        _outlineView = [[UIView alloc] initWithFrame:CGRectZero];
        [_outlineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _outlineView;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.font = [UIFont systemFontOfSize:22];
        _locationLabel.text = @"--";
    }
    return _locationLabel;
}

- (UILabel *)weatherLabel
{
    if (!_weatherLabel) {
        _weatherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_weatherLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.font = [UIFont systemFontOfSize:16];
        _weatherLabel.text = @"--";
    }
    return _weatherLabel;
}

- (UILabel *)temperatureLabel
{
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_temperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:72];
        _temperatureLabel.text = @"--";
    }
    return _temperatureLabel;
}

- (UIView *)todayView
{
    if (!_todayView) {
        _todayView = [[UIView alloc] initWithFrame:CGRectZero];
        [_todayView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _todayView;
}

- (UICollectionView *)hourWeatherCollectionView
{
    if (!_hourWeatherCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _hourWeatherCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

        [_hourWeatherCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _hourWeatherCollectionView.backgroundColor = [UIColor clearColor];
        _hourWeatherCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_hourWeatherCollectionView registerClass:[DMLWeatherCollectionCell class] forCellWithReuseIdentifier:sWeatherCollectionCellIdentifier];
        
        _hourWeatherCollectionView.dataSource = self;
        _hourWeatherCollectionView.delegate = self;
    }
    return _hourWeatherCollectionView;
}

- (UIScrollView *)innerScrollView
{
    if (!_innerScrollView) {
        _innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_innerScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _innerScrollView.scrollEnabled = NO;
        _innerScrollView.showsVerticalScrollIndicator = NO;
        _innerScrollView.delegate = self;
    }
    return _innerScrollView;
}

- (UIView *)innerContentView
{
    if (!_innerContentView) {
        _innerContentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_innerContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _innerContentView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[DMLWeatherTableCell class] forCellReuseIdentifier:sWeatherTableCellIdentifier];
        [_tableView registerClass:[DMLSubtitleTableCell class] forCellReuseIdentifier:sSubtitleTableCellIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _dayLabel.textAlignment = NSTextAlignmentLeft;
        _dayLabel.textColor = [UIColor whiteColor];
        _dayLabel.text = [NSString stringWithFormat:@"%@ Today", [self.dateFormatter stringFromDate:[NSDate date]]];
        
        [_dayLabel setContentHuggingPriority:UILayoutPriorityDefaultLow - 1 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _dayLabel;
}

- (UILabel *)maxTemperatureLabel
{
    if (!_maxTemperatureLabel) {
        _maxTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_maxTemperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _maxTemperatureLabel.textAlignment = NSTextAlignmentRight;
        _maxTemperatureLabel.textColor = [UIColor whiteColor];
        _maxTemperatureLabel.text = @"-";
    }
    return _maxTemperatureLabel;
}

- (UILabel *)minTemperatureLabel
{
    if (!_minTemperatureLabel) {
        _minTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_minTemperatureLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _minTemperatureLabel.textAlignment = NSTextAlignmentRight;
        _minTemperatureLabel.textColor = [UIColor whiteColor];
        _minTemperatureLabel.text = @"-";
    }
    return _minTemperatureLabel;
}

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WeatherChannel"] style:UIBarButtonItemStylePlain target:nil action:NULL];
        UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *menuBarButonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:nil action:NULL];
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _toolbar.items = @[leftBarButtonItem, flexibleSpaceBarButtonItem, menuBarButonItem];
        [_toolbar setBackgroundImage:[UIImage new]
                      forToolbarPosition:UIBarPositionAny
                              barMetrics:UIBarMetricsDefault];
        UIImage *shadowImage = [UIImage imageNamed:@"WhitePixel"];
        shadowImage = [shadowImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
        [_toolbar setShadowImage:shadowImage
                  forToolbarPosition:UIBarPositionBottom];
        _toolbar.tintColor = [UIColor whiteColor];
    }
    return _toolbar;
}

- (DMLHairLineDecorateView *)upperHairLineView
{
    if (!_upperHairLineView) {
        _upperHairLineView = [[DMLHairLineDecorateView alloc] initWithFrame:CGRectZero];
        [_upperHairLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _upperHairLineView;
}

- (DMLHairLineDecorateView *)lowerHairLineView
{
    if (!_lowerHairLineView) {
        _lowerHairLineView = [[DMLHairLineDecorateView alloc] initWithFrame:CGRectZero];
        [_lowerHairLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _lowerHairLineView;
}

- (DMLCurrentWeatherAPIManager *)currentWeatherAPIManager
{
    if (!_currentWeatherAPIManager) {
        _currentWeatherAPIManager = [DMLCurrentWeatherAPIManager new];
        _currentWeatherAPIManager.paramSource = self;
        _currentWeatherAPIManager.delegate = self;
    }
    return _currentWeatherAPIManager;
}

- (DMLDailyForecastAPIManager *)dailyForecastAPIManager
{
    if (!_dailyForecastAPIManager) {
        _dailyForecastAPIManager = [DMLDailyForecastAPIManager new];
        _dailyForecastAPIManager.paramSource = self;
        _dailyForecastAPIManager.delegate = self;
    }
    return _dailyForecastAPIManager;
}

- (DMLPerThreeHourForecastAPIManager *)perThreeHourForecastAPIManager
{
    if (!_perThreeHourForecastAPIManager) {
        _perThreeHourForecastAPIManager = [DMLPerThreeHourForecastAPIManager new];
        _perThreeHourForecastAPIManager.paramSource = self;
        _perThreeHourForecastAPIManager.delegate = self;
    }
    return _perThreeHourForecastAPIManager;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 1000;
    }
    return _locationManager;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"EEEE";
    }
    return _dateFormatter;
}

- (NSDateFormatter *)hourDateFormatter
{
    if (!_hourDateFormatter) {
        _hourDateFormatter = [[NSDateFormatter alloc] init];
        _hourDateFormatter.dateFormat = @"HH";
    }
    return _hourDateFormatter;
}

- (NSDateFormatter *)hhmmDateFormatter
{
    if (!_hhmmDateFormatter) {
        _hhmmDateFormatter = [[NSDateFormatter alloc] init];
        _hhmmDateFormatter.dateFormat = @"HH:mm";
    }
    return _hhmmDateFormatter;
}

- (NSMutableDictionary *)weatherConditions
{
    if (!_weatherConditions) {
        _weatherConditions = @{}.mutableCopy;
    }
    return _weatherConditions;
}

- (NSArray *)weatherConditionKeyPairs
{
    if (!_weatherConditionKeyPairs) {
        _weatherConditionKeyPairs = @[
                                      sSunriseKey,
                                      sSunsetKey,
                                      sChanceOfRainKey,
                                      sHumidityKey,
                                      sWindKey,
                                      sFeelsLikeKey,
                                      sPrecipitationKey,
                                      sPressureKey,
                                      sVisibilityKey,
                                      sUVIndexKey
                                      ];
    }
    return _weatherConditionKeyPairs;
}

@end
