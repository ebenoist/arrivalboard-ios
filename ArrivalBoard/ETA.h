#import <Foundation/Foundation.h>

@interface ETA : NSObject
@property NSString *destination;
@property NSDate *arrivalTime;
@property NSString *route;
@property NSString *station;
@property NSString *direction;

- (void) setArrivalTimeWithString: (NSString*)time;
- (id) initWithJSON: (NSDictionary *)rawETA;
@end
