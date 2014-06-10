#import "ArrivalClient.h"

@implementation ArrivalClient

AFHTTPRequestOperationManager *manager;

#ifdef DEBUG
NSString* const HOST = @"http://api.arrivalboard.com";
#else
NSString* const HOST = @"http://api.arrivalboard.com";
#endif

-(id)init
{
  self = [super init];
  if (self)
  {
    manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
  }
  
  return self;
}

-(void)fetchETAsWithLat:(float)lat
                withLng:(float)lng
             withBuffer:(NSNumber *)buffer
           withCallBack:(void (^)(id json))callBack
{
  NSDictionary *params = @{
    @"lat": [NSNumber numberWithFloat: lat],
    @"lng": [NSNumber numberWithFloat: lng],
    @"buffer": buffer
  };
  
  NSLog(@"%@", params[@"lat"]);
  NSString *fullURI = [NSString stringWithFormat:@"%@%@", HOST, @"/v1/arrivals"];
  
  [manager GET:fullURI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    callBack(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Fail %@", error);
  }];
}

@end
