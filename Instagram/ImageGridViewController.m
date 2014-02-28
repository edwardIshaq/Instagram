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
@property Camera *camera;
@end

@implementation ImageGridViewController

- (void)dealloc {
    [self.mediaController removeObserver:self forKeyPath:@"allMedia"];
}
- (id)commonInit {
    self.mediaController = [[AppDelegate sharedAppDelegate] mediaController];
    [self.mediaController addObserver:self forKeyPath:@"allMedia" options:NSKeyValueObservingOptionNew context:NULL];
    self.camera = [Camera new];
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

#pragma mark - datasource
- (NSArray *)datasource {
    return self.mediaController.allMedia;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"allMedia"]) {
        [self.collectionView reloadData];
    }
}

#pragma mark - CollectionView
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
    [self.camera startCameraControllerFromViewController:self usingDelegate:self];
}
- (void)media:(Media *)photo downloadedImage:(UIImage *)image {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.datasource indexOfObject:photo] inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.image = image;
    [cell setNeedsDisplay];
}

#pragma mark - imagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        [self presentNotification];
        
        UIImage *originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        Media *media = self.selectedMedia;
        self.selectedMedia = nil;
        
        [self processAndEmailImage:originalImage withMedia:media];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)presentNotification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Processing" message:@"Image is being proccessed..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.tag = 123;
    [alert show];
    
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:TRUE];
    });
}

- (void)processAndEmailImage:(UIImage*)originalImage withMedia:(Media*)media {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.mediaController downloadStandardImageForMedia:media];
        UIImage *mergedImage = [self.camera mergeFgImage:originalImage withBGImage:media.standardImage];
        
        if (![MFMailComposeViewController canSendMail]) return;
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        NSData *imageData = UIImagePNGRepresentation(mergedImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];

        dispatch_async(dispatch_get_main_queue(), ^{
            mailer.mailComposeDelegate = self;
            [self presentViewController:mailer animated:YES completion:NULL];
        });

    });
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Mail Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Result: failed");
            break;
        default:
            //NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
