
#import "PhotoViewController.h"


@interface PhotoViewController()

@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet UINavigationItem *navigationItem1;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem1.title = self.photo.name;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIImageView *photoView = self.photoView;

    [self.photo getImageWithCallback:^(UIImage *image){
        dispatch_async(dispatch_get_main_queue(), ^() {
            photoView.image = image;
        });
    }];
}


- (IBAction)share:(id)sender {
    UIImage *image = self.photoView.image;

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];

    activityViewController.excludedActivityTypes = @[
            UIActivityTypePostToFacebook,
            UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypeAirDrop,
            UIActivityTypeOpenInIBooks,
    ];

    [self presentViewController:activityViewController animated:YES completion:nil];
}


@end