#import "ABViewController.h"
#import "Place.h"

@interface ABViewController ()

@end

@implementation ABViewController

CLLocationManager *locationManager;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger cellsToDisplay = [[self.places[section] etas] count];
  if (cellsToDisplay == 0) {
    cellsToDisplay = 1;
  }
  
  return cellsToDisplay;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.places count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

   return [[self.places objectAtIndex:(NSUInteger) section] name];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section"];
  }
  
  UILabel *stationLabel = (UILabel *)[cell.contentView viewWithTag:1];
  [stationLabel setText: [[self.places objectAtIndex:(NSUInteger) section] name]];
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  Place *place = [self.places objectAtIndex:(NSUInteger) indexPath.section];
  
  if ([place.etas count] > 0 ) {
    static NSString *simpleTableIdentifier = @"ETACell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    ETA *eta = [place.etas objectAtIndex:(NSUInteger) indexPath.item];

    UILabel *destinationLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *arrivalTimeLabel = (UILabel *)[cell.contentView viewWithTag:4];
    UILabel *routeLabel = (UILabel *)[cell.contentView viewWithTag:3];

    [destinationLabel setText:eta.destination];
    NSTimeInterval timeUntil = [eta.arrivalTime timeIntervalSinceDate:[NSDate date]];
    
    float timeInMinutes = timeUntil / 60;
    [arrivalTimeLabel setText:[NSString stringWithFormat:@"%.0f", timeInMinutes]];
    [routeLabel setText:eta.route];
    
    return cell;
    
  } else {
    static NSString *simpleTableIdentifier = @"notAvailable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
  self.places = [[NSMutableArray alloc] init];
  
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refreshControl;
  
  [self fetchCurrentLocation];
}

- (void)refresh
{
  NSLog(@"Refresh");
  [self.places removeAllObjects];
  [self.tableView reloadData];
  
  [self fetchCurrentLocation];
  [self.refreshControl endRefreshing];
}

- (NSMutableArray *)sortByDistance:(NSMutableArray *)unsortedETAs
{
  NSMutableArray *array = [[NSMutableArray alloc] init];
  [array addObjectsFromArray:[unsortedETAs sortedArrayUsingComparator:^(Place *a, Place *b) {
    return [a.distance compare:b.distance];
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
    NSMutableArray *unsortedPlaces = [[NSMutableArray alloc] init];
    for(id rawPlace in json) {
      Place *place = [[Place alloc] initWithJSON:rawPlace];
      [unsortedPlaces addObject:place];
    }

    self.places = [self sortByDistance:unsortedPlaces];
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
