#import "ETA.h"

@implementation ETA

-(id)initWithJSON:(NSDictionary *)rawETA
{
  self = [super init];
  if (self) {
    [self setArrivalTimeWithString:rawETA[@"arrival_time"]];
    self.destination = rawETA[@"destination"];
    self.route = rawETA[@"route"];
    self.station = rawETA[@"station"];
    self.direction = rawETA[@"direction"];
  }
  
  return self;
}
-(void)setArrivalTimeWithString:(NSString *)time
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
  NSDate *date = [formatter dateFromString:time];
  
  [self setArrivalTime:date];
}

@end
