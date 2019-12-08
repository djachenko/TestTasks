
#import "PhotosCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "PhotosModel.h"
#import "PhotoViewController.h"

@interface PhotosCollectionViewController()
        <
        UICollectionViewDataSource
        ,UICollectionViewDelegateFlowLayout
        ,UISearchBarDelegate
        >

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSArray<Photo *> *allPhotos;
@property (nonatomic) NSArray<Photo *> *photos;

@end

@implementation PhotosCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PhotosModel *photosModel = [[PhotosModel alloc] init];

    [photosModel downloadJSONWithCallback:^(NSArray *result) {
        dispatch_sync(dispatch_get_main_queue(), ^() {
            self.photos = result;
            self.allPhotos = result;

            [self.collectionView reloadData];
        });
    }];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];

    [cell setPhoto:self.photos[(NSUInteger) indexPath.row]];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return nil == self.photos ? 0 : self.photos.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger colCount = 3;

    CGFloat width = (collectionView.frame.size.width - 5 * (colCount - 1)) / colCount;

    CGSize result = CGSizeMake(width, width * 1.2f);

    return result;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (0 == searchText.length) {
        [self resetCollection];
    }
    else {
        NSMutableArray<Photo *> *filteredPhotos = [NSMutableArray array];

        for (Photo *photo in self.allPhotos) {
            if ([photo.name localizedCaseInsensitiveContainsString:searchText]) {
                [filteredPhotos addObject:photo];
            }
        }

        self.photos = filteredPhotos;
    }

    [searchBar setShowsCancelButton:0 != searchText.length animated:YES];

    [self.collectionView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self resetCollection];
    [self.collectionView reloadData];

    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)resetCollection {
    self.photos = self.allPhotos;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSArray<NSIndexPath *> *pathsForSelectedItems = self.collectionView.indexPathsForSelectedItems;
    NSIndexPath *indexPath = pathsForSelectedItems.firstObject;

    PhotoViewController *destination = segue.destinationViewController;

    destination.photo = self.photos[(NSUInteger) indexPath.row];
}


- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender {
}

@end