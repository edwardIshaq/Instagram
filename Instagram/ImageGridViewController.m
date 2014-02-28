//
//  ImageGridViewController.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "ImageGridViewController.h"
#import "MediaController.h"
#import "Media.h"
#import "Camera.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ImageGridViewController ()
@property MediaController* mediaController;
@property Media *selectedMedia;
@end

@implementation ImageGridViewController

- (void)dealloc {
    [self.mediaController removeObserver:self forKeyPath:@"allMedia"];
}
- (id)commonInit {
    self.mediaController = [[AppDelegate sharedAppDelegate] mediaController];
    [self.mediaController addObserver:self forKeyPath:@"allMedia" options:NSKeyValueObservingOptionNew context:NULL];

    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)datasource {
    return self.mediaController.allMedia;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"allMedia"]) {
        [self.collectionView reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mediaController.allMedia.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    Media *media = [self.datasource objectAtIndex:indexPath.row];
    
    if (media.thumbnail) {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        imageView.image = media.thumbnail;
    }
    else {
        media.mediaDelegate = self;
    }

    UILabel *label = (UILabel*)[cell.contentView viewWithTag:2];
    label.text = media.title;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Media *media = [self.datasource objectAtIndex:indexPath.row];
    self.selectedMedia = media;
    Camera *cam = [Camera new];
    [cam startCameraControllerFromViewController:self usingDelegate:self];
}
- (void)media:(Media *)photo downloadedImage:(UIImage *)image {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.datasource indexOfObject:photo] inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.image = image;
    [cell setNeedsDisplay];

}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        Media *media = self.selectedMedia;
        self.selectedMedia = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.mediaController downloadStandardImageForMedia:media];
            [self mergeFgImage:originalImage foregroundImage:media.standardImage];
        });
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)mergeFgImage:(UIImage *)bgImage foregroundImage:(UIImage *)fgImage  {

    CGSize newSize = CGSizeMake(bgImage.size.width, bgImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bgImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    // Change xPos, yPos if applicable
    CGFloat xOffset = (bgImage.size.width-fgImage.size.width)/2.0;
    CGFloat yOffset = (bgImage.size.height-fgImage.size.height)/2.0;
    [fgImage drawInRect:CGRectMake(xOffset, yOffset ,fgImage.size.width,fgImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *test = [[UIImageView alloc] initWithImage:newImage];
        test.frame = self.view.bounds;
        test.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:test];
    });
    
    return newImage;
}

@end
