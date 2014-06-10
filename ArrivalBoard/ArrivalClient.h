#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface ArrivalClient : NSObject
extern NSString * const host;
-(id)init;
-(void)fetchETAsWithLat:(float)lat
                     withLng:(float)lng
                  withBuffer:(NSNumber *)buffer
                withCallBack:(void (^)(id json))callBack;
@end
