#import "Kiwi.h"
#import "ETA.h"


SPEC_BEGIN(ETASpec)

describe(@"ETA", ^{
  it(@"has a destination", ^{
    ETA *eta = [[ETA alloc] init];
    eta.destination = @"foo";
    [[[eta destination] should] equal:@"foo"];
  });
  
  it(@"has an arrival time", ^{
    ETA *eta = [[ETA alloc] init];
    NSDate *date = [NSDate date];
    
    eta.arrivalTime = date;
    [[[eta arrivalTime] should] equal:date];
  });
  
  it(@"can set the arrival time from a string", ^{
    ETA *eta = [[ETA alloc] init];
    NSString *dateString = @"2014-05-17T15:37:58-05:00";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    [eta setArrivalTimeWithString:dateString];
    [[[eta arrivalTime] should] equal:date];
  });
  
  it(@"can be deserialized from a json NSDict", ^{
    NSDictionary *rawETA = @{
      @"arrival_time": @"2014-05-17T23:30:18-05:00",
      @"destination": @"Forest Park",
      @"route": @"blue",
      @"station": @"California"
    };
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    NSDate *date = [formatter dateFromString:rawETA[@"arrival_time"]];
    
    ETA *eta = [[ETA alloc] initWithJSON: rawETA];
    [[[eta destination] should] equal:@"Forest Park"];
    [[[eta route] should] equal:@"blue"];
    [[[eta station] should] equal:@"California"];
    [[[eta arrivalTime] should] equal:date];
  });
});

SPEC_END