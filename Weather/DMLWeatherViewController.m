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
#import "DMLDailyWeatherCell.h"
#import "DMLDetailWeatherCell.h"
#import "DMLTextCollectionViewCell.h"

#import "DMLCurrentWeatherAPIManager.h"
#import "DMLDailyForecastAPIManager.h"
#import "DMLPerThreeHourForecastAPIManager.h"

#import "DMLHeader.h"
#import "DMLMenu.h"
#import "DMLCollectionViewHandOffLayout.h"
#import "DMLCollectionViewDelegateHandOffLayout.h"

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
 
    contentView: | outlineView(230) - hourWeatherView(96) - weekWeatherView(262) - todayWeatherDescribleLable(61) | = 649
 */

static const CGFloat sHourWeatherViewHeight = 96.0;

static const CGFloat sItemWidth = 75.0;

static const NSUInteger sDaysOfForecast = 9;

static NSString *const sWeatherCollectionCellIdentifier = @"WeatherCollectionCell";

static NSString *const sDailyWeatherCellIdentifier = @"DailyWeatherCell";
static NSString *const sDetailWeatherCellIdentifier = @"DetailWeatherCell";
static NSString *const sTodayDescribeCellIdentifier = @"TodayDescribeCell";

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
static NSString *const sAQIKey = @"AQI";
static NSString *const sAirQualityKey = @"Air Quality";

static NSString *const sWeatherHeaderReuseIdentifier = @"WeatherHeader";
static NSString *const sWeatherMenuReuseIdentifier = @"WeatherMenu";

static NSString *const sWeatherIconBaseURLString = @"http://openweathermap.org/img/w/";

@interface DMLWeatherViewController ()<UICollectionViewDataSource, CTAPIManagerParamSource, CTAPIManagerCallBackDelegate, CLLocationManagerDelegate, DMLCollectionViewDelegateHandOffLayout>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) UIToolbar *toolbar;

@property (nonatomic) DMLCurrentWeatherAPIManager *currentWeatherAPIManager;
@property (nonatomic) DMLDailyForecastAPIManager *dailyForecastAPIManager;
@property (nonatomic) DMLPerThreeHourForecastAPIManager *perThreeHourForecastAPIManager;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) NSTimer *weatherUpdateTimer;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *hhmmDateFormatter;

@property (nonatomic, copy) NSArray *listOfForecastWeather;
@property (nonatomic, copy) NSArray *listOfHourWeather;
@property (nonatomic, copy) NSMutableDictionary *weatherConditions;
@property (nonatomic, copy) NSArray *weatherConditionKeyPairs;

@property (nonatomic) NSDictionary *currentWeatherDict;

@end

@implementation DMLWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dml_skyBlue];
    
    [self.collectionView registerClass:DMLHeader.class forSupplementaryViewOfKind:[DMLCollectionViewHandOffLayout kindOfElement:DMLHandOffLayoutElementHeader] withReuseIdentifier:sWeatherHeaderReuseIdentifier];
    [self.collectionView registerClass:DMLMenu.class forSupplementaryViewOfKind:[DMLCollectionViewHandOffLayout kindOfElement:DMLHandOffLayoutElementMenu] withReuseIdentifier:sWeatherMenuReuseIdentifier];
    
    [self.collectionView registerClass:DMLDailyWeatherCell.class forCellWithReuseIdentifier:sDailyWeatherCellIdentifier];
    [self.collectionView registerClass:DMLDetailWeatherCell.class forCellWithReuseIdentifier:sDetailWeatherCellIdentifier];
    [self.collectionView registerClass:DMLTextCollectionViewCell.class forCellWithReuseIdentifier:sTodayDescribeCellIdentifier];
    
    [self.view addSubview:self.collectionView];
    [self configureConstraintsForCollectionView];
    
    [self.view addSubview:self.toolbar];
    [self configureConstraintsForToolbar];
    
    UIEdgeInsets edgeInsets = self.collectionView.contentInset;
    edgeInsets.bottom = self.toolbar.intrinsicContentSize.height;
    self.collectionView.contentInset = edgeInsets;
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

#pragma mark - UICollectionViewDataSource

static NSInteger const sWeatherInfoSections = 3;
static NSInteger const sWeatherDetailInfoEntries = 6;

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sWeatherInfoSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return sDaysOfForecast;
        case 1:
            return 1;
        case 2:
            return sWeatherDetailInfoEntries;
        default:
            return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            DMLDailyWeatherCell *dailyWeatherCell = [collectionView dequeueReusableCellWithReuseIdentifier:sDailyWeatherCellIdentifier forIndexPath:indexPath];
            
            NSDate *date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:indexPath.row + 1 toDate:[NSDate date] options:0];
            
            dailyWeatherCell.dayLabel.text = [self.dateFormatter stringFromDate:date];
    
            if (indexPath.row < self.listOfForecastWeather.count) {
                NSDictionary *forecastWeather = self.listOfForecastWeather[indexPath.row];
    
                NSDictionary *temp = forecastWeather[@"temp"];
                NSNumber *max = temp[@"max"];
                NSNumber *min = temp[@"min"];
                dailyWeatherCell.maxTemperatureLabel.text = [NSString stringWithFormat:@"%.2f", [max doubleValue]];
                dailyWeatherCell.minTemperatureLabel.text = [NSString stringWithFormat:@"%.2f", [min doubleValue]];
    
                NSArray *weathers = forecastWeather[@"weather"];
                if (weathers.count > 0) {
                    NSDictionary *weather = weathers.firstObject;
    
                    NSString *weatherIconString = [NSString stringWithFormat:@"%@%@.png", sWeatherIconBaseURLString, weather[@"icon"]];
    
                    [dailyWeatherCell.weatherImageView setImageWithURL:[NSURL URLWithString:weatherIconString]];
                }
            }
            else {
                dailyWeatherCell.maxTemperatureLabel.text = @"-";
                dailyWeatherCell.minTemperatureLabel.text = @"-";
            }
            
            cell = dailyWeatherCell;
            break;
        }
        
        case 1: {
            DMLTextCollectionViewCell *textCell = [collectionView dequeueReusableCellWithReuseIdentifier:sTodayDescribeCellIdentifier forIndexPath:indexPath];
            textCell.textView.text = @"今天：今日大部多云。当前气温26；最高气温34。";
            
            cell = textCell;
            break;
        }
        case 2: {
            DMLDetailWeatherCell *detailWeatherCell = [collectionView dequeueReusableCellWithReuseIdentifier:sDetailWeatherCellIdentifier forIndexPath:indexPath];
            
            NSUInteger keyIndex = indexPath.row * 2;
            
            if (keyIndex + 2 <= self.weatherConditionKeyPairs.count) {
                NSString *key = self.weatherConditionKeyPairs[keyIndex];
                NSString *subKey = self.weatherConditionKeyPairs[keyIndex + 1];
                
                detailWeatherCell.leftTitleLabel.text = key;
                detailWeatherCell.leftValueLabel.text = self.weatherConditions[key];
                
                detailWeatherCell.rightTitleLabel.text = subKey;
                detailWeatherCell.rightValueLabel.text = self.weatherConditions[subKey];
            }
            
            if (indexPath.row + 1 == sWeatherDetailInfoEntries) {
                detailWeatherCell.separatorLineView.hidden = YES;
            }
            
            cell = detailWeatherCell;

            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:[DMLCollectionViewHandOffLayout kindOfElement:DMLHandOffLayoutElementHeader]]) {
        DMLHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sWeatherHeaderReuseIdentifier forIndexPath:indexPath];
        if (self.currentWeatherDict) {
            [header configureWithDict:self.currentWeatherDict];
        }
        return header;
    }
    
    if ([kind isEqualToString:[DMLCollectionViewHandOffLayout kindOfElement:DMLHandOffLayoutElementMenu]]) {
        DMLMenu *menu = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sWeatherMenuReuseIdentifier forIndexPath:indexPath];
        if (self.currentWeatherDict) {
            [menu configureTemperatureWithDict:self.currentWeatherDict];
        }
        return menu;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(sItemWidth, sHourWeatherViewHeight);
}

#pragma mark - DMLCollectionViewDelegateHandOffLayout

static CGFloat const sHeaderHeight = 230.0;
static CGFloat const sMenuHeight = 124.0;

static CGFloat const sDailyForecastCellHeight = 32.0;
static CGFloat const sTodayWeatherDescribeCellHeight = 60.0;
static CGFloat const sWeatherDetailInfoCellHeight = 52.0;

- (CGSize)collectionView:(UICollectionView *)collectionView handOffLayout:(DMLCollectionViewHandOffLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(CGRectGetWidth(collectionView.frame), sDailyForecastCellHeight);
            
        case 1:
            return CGSizeMake(CGRectGetWidth(collectionView.frame), sTodayWeatherDescribeCellHeight);
            
        case 2:
            return CGSizeMake(CGRectGetWidth(collectionView.frame), sWeatherDetailInfoCellHeight);
            
        default:
            return CGSizeZero;
    }
}

- (CGSize)collectionViewReferenceSizeForHeader:(UICollectionView *)collectionView handOffLayout:(DMLCollectionViewHandOffLayout*)collectionViewLayout
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), sHeaderHeight);
}

- (CGSize)collectionViewReferenceSizeForMenu:(UICollectionView *)collectionView handOffLayout:(DMLCollectionViewHandOffLayout*)collectionViewLayout
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), sMenuHeight);
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
        self.currentWeatherDict = responseDictionary;

        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

        NSDictionary *main = responseDictionary[@"main"];
        
        self.weatherConditions[sPressureKey] = [NSString stringWithFormat:@"%@ hPa", main[@"pressure"]];
        self.weatherConditions[sHumidityKey] = [NSString stringWithFormat:@"%@ %%", main[@"humidity"]];
        
        NSDictionary *sys = responseDictionary[@"sys"];
        if (sys) {
            NSNumber *sunriseNumber = (NSNumber *)sys[@"sunrise"];
            if (sunriseNumber) {
                NSDate *sunriseDate = [[NSDate alloc] initWithTimeIntervalSince1970:[sunriseNumber doubleValue]];
                NSString *sunriseStr = [self.hhmmDateFormatter stringFromDate:sunriseDate];
                if (sunriseStr) {
                    self.weatherConditions[sSunriseKey] = sunriseStr;
                }
            }
            
            NSNumber *sunsetNumber = (NSNumber *)sys[@"sunset"];
            if (sunsetNumber) {
                NSDate *sunsetDate = [[NSDate alloc] initWithTimeIntervalSince1970:[sunsetNumber doubleValue]];
                if (sunsetDate) {
                    NSString *sunsetStr = [self.hhmmDateFormatter stringFromDate:sunsetDate];
                    if (sunsetStr) {
                        self.weatherConditions[sSunsetKey] = sunsetStr;
                    }
                }
            }
        }
        
        NSDictionary *wind = responseDictionary[@"wind"];
        
        self.weatherConditions[sWindKey] = [NSString stringWithFormat:@"%@ %@m/s", wind[@"deg"], wind[@"speed"]];
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }
    else if (manager == self.dailyForecastAPIManager) {
        NSDictionary *responseDictionary = [manager fetchDataWithReformer:nil];
//        NSLog(@"responseDictionary:%@", responseDictionary);
        NSArray *listOfForecastWeather = responseDictionary[@"list"];
        if ([listOfForecastWeather isKindOfClass:[NSArray class]]) {
            self.listOfForecastWeather = listOfForecastWeather;
            
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    }
    else if (manager == self.perThreeHourForecastAPIManager) {
        NSDictionary *responseDictionary = [manager fetchDataWithReformer:nil];
        NSArray *listOfHourWeather = responseDictionary[@"list"];
        if ([listOfHourWeather isKindOfClass:[NSArray class]]) {
            self.listOfHourWeather = listOfHourWeather;
            
            DMLMenu *menu = (DMLMenu *)[self.collectionView supplementaryViewForElementKind:[DMLCollectionViewHandOffLayout kindOfElement:DMLHandOffLayoutElementMenu] atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            [menu updateWithNewDataSource:listOfHourWeather];
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

- (void)configureConstraintsForCollectionView
{
    if (@available(iOS 11.0, *)) {
        [self.view.safeAreaLayoutGuide.leftAnchor constraintEqualToAnchor:self.collectionView.leftAnchor].active = YES;
        [self.view.safeAreaLayoutGuide.rightAnchor constraintEqualToAnchor:self.collectionView.rightAnchor].active = YES;
        [self.view.safeAreaLayoutGuide.topAnchor constraintEqualToAnchor:self.collectionView.topAnchor].active = YES;
        [self.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.collectionView.bottomAnchor].active = YES;
    }
    else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }
}

- (void)configureConstraintsForToolbar
{
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

#pragma mark - Getters

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DMLCollectionViewHandOffLayout *handOffLayout = [DMLCollectionViewHandOffLayout new];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:handOffLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
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
        _weatherConditions = @{
                               sChanceOfRainKey : @"20%",
                               sFeelsLikeKey : @"37",
                               sPrecipitationKey : @"5.1mm",
                               sVisibilityKey : @"14.5 km",
                               sUVIndexKey : @"7",
                               sAQIKey : @"43",
                               sAirQualityKey : @"good"
                               }.mutableCopy;
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
                                      sUVIndexKey,
                                      sAQIKey,
                                      sAirQualityKey
                                      ];
    }
    return _weatherConditionKeyPairs;
}

@end
