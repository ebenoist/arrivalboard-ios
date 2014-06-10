//
//  ABViewController.m
//  ArrivalBoard
//
//  Created by Erik Benoist on 5/17/14.
//  Copyright (c) 2014 eb. All rights reserved.
//

#import "ABViewController.h"

@interface ABViewController ()

@end

@implementation ABViewController

CLLocationManager *locationManager;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.etas count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *simpleTableIdentifier = @"ETACell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  }
  
  ETA *eta = [self.etas objectAtIndex:indexPath.row];
  UILabel *destinationLabel = (UILabel *)[cell.contentView viewWithTag:1];
  UILabel *arrivalTimeLabel = (UILabel *)[cell.contentView viewWithTag:4];
  UILabel *routeLabel = (UILabel *)[cell.contentView viewWithTag:3];
  UILabel *stationLabel = (UILabel *)[cell.contentView viewWithTag:2];
//  UILabel *directionLabel = (UILabel *)[cell.contentView viewWithTag:5];
  
  [destinationLabel setText:eta.destination];
  NSTimeInterval timeUntil = [eta.arrivalTime timeIntervalSinceDate:[NSDate date]];
  
  float timeInMinutes = timeUntil / 60;
  [arrivalTimeLabel setText:[NSString stringWithFormat:@"%.0f", timeInMinutes]];
  [routeLabel setText:eta.route];
  [stationLabel setText:eta.station];
  
//  if (eta.direction != NULL) {
//    [directionLabel setText:eta.direction];
//  } else {
//    [directionLabel setText:@""];
//  }
//  
  return cell;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
  self.etas = [[NSMutableArray alloc] init];
  
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refreshControl;
  
  [self fetchCurrentLocation];
}

- (void)refresh
{
  NSLog(@"Refresh");
  [self.etas removeAllObjects];
  [self.tableView reloadData];
  
  [self fetchCurrentLocation];
  [self.refreshControl endRefreshing];
}

- (NSMutableArray *)sortByDate:(NSMutableArray *)unsortedETAs
{
  NSMutableArray *array = [[NSMutableArray alloc] init];
  [array addObjectsFromArray:[unsortedETAs sortedArrayUsingComparator:^(ETA *a, ETA *b) {
    return [a.arrivalTime compare:b.arrivalTime];
  }]];
  
  return array;
}

- (void)fetchETAs
{
  ArrivalClient *client = [[ArrivalClient alloc] init];
  float lat = locationManager.location.coordinate.latitude;
  float lng = locationManager.location.coordinate.longitude;
  NSNumber *buffer = @2000;
  
  [client fetchETAsWithLat:lat withLng:lng withBuffer:buffer withCallBack:^(id json) {
    NSMutableArray *unsortedETAs = [[NSMutableArray alloc] init];
    for(id rawETA in json) {
      ETA *eta = [[ETA alloc] initWithJSON:rawETA];
      [unsortedETAs addObject:eta];
    }
    
    
    self.etas = [self sortByDate:unsortedETAs];
    [self.tableView reloadData];
  }];
}

- (void)fetchCurrentLocation
{
  if (nil == locationManager)
    locationManager = [[CLLocationManager alloc] init];
  
  locationManager.distanceFilter = 100;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager startUpdatingLocation];
  
  locationManager.delegate = self;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"didFailWithError: %@", error);
  UIAlertView *errorAlert = [
   [UIAlertView alloc]
   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
  if (locationManager.location.coordinate.latitude != 0) {
    [locationManager stopUpdatingLocation];
    [self fetchETAs];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
