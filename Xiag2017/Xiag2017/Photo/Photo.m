
#import "Photo.h"

@interface Photo()

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *thumbnail;

@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSURL *thumbnailUrl;

@end

@implementation Photo

- (instancetype)initWithUrl:(NSString *)url thumbnailUrl:(NSString *)thumbnailUrl name:(NSString *)name {
    self = [super init];

    if (self) {
        self.url = [NSURL URLWithString:url];
        self.thumbnailUrl = [NSURL URLWithString:thumbnailUrl];
        self.name = name;
    }

    return self;
}


- (void)getImageByURL:(NSURL *)url withCallback:(void (^)(UIImage *))callback {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"DownloadImageConfiguration"];

    configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;

    NSURLSession *session = [NSURLSession sharedSession];

    NSString *name = self.name;

    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                NSLog(@"received %@", name);


                UIImage *image = [[UIImage alloc] initWithData:data];

                if (callback) {
                    callback(image);
                }
            }] resume];

    NSLog(@"sent %@", name);
}



- (void)getThumbnailWithCallback:(void (^)(UIImage *))callback {
    if (nil == callback) {
        return;
    }

    if (nil != self.thumbnail) {
        callback(self.thumbnail);
    }
    else {
        [self getImageByURL:self.thumbnailUrl withCallback:^(UIImage *image) {
            self.thumbnail = image;

            callback(image);
        }];
    }
}



- (void)getImageWithCallback:(void (^)(UIImage *))callback {
    if (nil == callback) {
        return;
    }

    if (nil != self.image) {
        callback(self.image);
    }
    else {
        [self getImageByURL:self.url withCallback:^(UIImage *image) {
            self.image = image;

            callback(image);
        }];
    }
}

@end