#import "Place.h"
#import "ETA.h"


@implementation Place {

}
- (id)initWithJSON:(NSDictionary *)rawJSON {
  self = [super init];
  if (self) {
    self.name = rawJSON[@"name"];
    self.distance = rawJSON[@"distance"];
    self.etas = [[NSMutableArray alloc] init];

    [rawJSON[@"etas"] enumerateObjectsUsingBlock:^(id rawETA, NSUInteger idx, BOOL *stop) {
      ETA *eta = [[ETA alloc] initWithJSON:rawETA];
      [self.etas addObject:eta];
    }];
  }

  return self;
}
@end