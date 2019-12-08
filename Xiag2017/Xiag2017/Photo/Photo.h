
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic, readonly) NSString *name;

- (instancetype)initWithUrl:(NSString *)url thumbnailUrl:(NSString *)thumbnailUrl name:(NSString *)name;


- (void)getThumbnailWithCallback:(void (^)(UIImage *))callback;
- (void)getImageWithCallback:(void (^)(UIImage *))callback;

@end