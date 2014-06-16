#import "Kiwi.h"
#import "Place.h"
#import "ETA.h"


SPEC_BEGIN(PlaceSpec)
  describe(@"Place", ^{
    it(@"can be instantiated from JSON", ^{
      NSDictionary *rawETA = @{
        @"arrival_time": @"2014-05-17T23:30:18-05:00",
        @"destination": @"Forest Park",
        @"route": @"blue",
        @"station": @"California"
      };

      NSDictionary *rawPlace = @{
        @"name" : @"california",
        @"distance": @10,
        @"etas": @[rawETA]
      };

      Place *place = [[Place alloc] initWithJSON:rawPlace];
      [[place.distance should] equal:@10];
      [[place.name should] equal:@"california"];
      [[[place.etas[0] destination] should] equal:@"Forest Park"];
    });

    it(@"has a distance", ^{

    });

    it(@"has a places", ^{

    });

    it(@"has a name", ^{

    });
  });
SPEC_END
