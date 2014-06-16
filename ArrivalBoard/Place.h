#import <Foundation/Foundation.h>


@interface Place : NSObject
@property(nonatomic, strong) id name;
@property(nonatomic, strong) id distance;
@property(nonatomic, strong) id etas;

- (id)initWithJSON:(NSDictionary *)rawJSON;
@end