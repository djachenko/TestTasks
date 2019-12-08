
#import <Foundation/Foundation.h>


@interface PhotosModel : NSObject
- (void)downloadJSONWithCallback:(void (^)(NSArray *))callback;
@end