
#import "PhotosModel.h"
#import "Photo.h"


@implementation PhotosModel


- (void)downloadJSONWithCallback:(void (^)(NSArray *))callback {
    NSString *urlString = @"http://www.xiag.ch/share/testtask/list.json";
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                NSLog(@"RESPONSE: %@", response);
                NSLog(@"DATA: %@", data);

                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:nil];

                NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:jsonArray.count];

                for (NSDictionary *photoDictionary in jsonArray) {
                    [resultArray addObject:[[Photo alloc] initWithUrl:photoDictionary[@"url"]
                                                         thumbnailUrl:photoDictionary[@"url_tn"]
                                                                 name:photoDictionary[@"name"]]];
                }

                if (callback) {
                    callback([resultArray copy]);
                }
            }] resume];
}

@end