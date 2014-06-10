#import "Kiwi.h"
#import "Nocilla.h"
#import "ArrivalClient.h"


SPEC_BEGIN(ArrivalClientTest)

beforeAll(^{
  [[LSNocilla sharedInstance] start];
});

afterAll(^{
  [[LSNocilla sharedInstance] stop];
});

afterEach(^{
  [[LSNocilla sharedInstance] clearStubs];
});


describe(@"ArrivalClient", ^{
  xit(@"fetches from the arrivals endpoint", ^{
    NSNumber *lat = @42.0;
    NSNumber *lng = @-81.9;
    NSNumber *buffer = @500;
    
    stubRequest(@"GET", @"http://localhost:9292.*".regex).
    andReturn(200).withBody(@" \
      [{ \
        \"route\": \"Blue\", \
        \"station\": \"California\", \
        \"destination\": \"O'Hare\", \
        \"arrival_time\": \"2014-05-17T15:33:58-05:00\" \
      }, \
      { \
        \"route\": \"Blue\", \
        \"station\": \"California\", \
        \"destination\": \"O'Hare\", \
        \"arrival_time\": \"2014-05-17T15:41:49-05:00\" \
      }]");
    
    ArrivalClient *client = [[ArrivalClient alloc] init];
    
    __block BOOL finished = false;
    [client fetchETAsWithLat:lat withLng:lng withBuffer:buffer withCallBack:^(id json) {
      finished = true;
    }];
   
    NSDate* timeoutDate = [NSDate dateWithTimeIntervalSinceNow:60];
    while (!finished && ([timeoutDate timeIntervalSinceNow]>0))
      CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
    
  });
});

SPEC_END