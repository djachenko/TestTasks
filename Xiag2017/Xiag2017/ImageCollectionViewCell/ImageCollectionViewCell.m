
#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation ImageCollectionViewCell


- (void)setPhoto:(Photo *)photo {
    self.nameLabel.text = photo.name;

    [photo getThumbnailWithCallback:^(UIImage *image){
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.imageView.image = image;
        });
    }];
}


@end