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

@interface ImageGridViewController ()
@property MediaController* mediaController;
@end

@implementation ImageGridViewController

- (void)dealloc {
    [self.mediaController removeObserver:self forKeyPath:@"allMedia"];
}
- (id)commonInit {
    self.mediaController = [[AppDelegate sharedAppDelegate] mediaController];
    NSLog(@"%@",self.mediaController.allMedia);
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"allMedia"]) {
        NSLog(@"%@",self.mediaController.allMedia);
        [self.collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mediaController.allMedia.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    Media *media = [self.mediaController.allMedia objectAtIndex:indexPath.row];
    if (media.thumbnail) {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        imageView.image = media.thumbnail;
    }

    UILabel *label = (UILabel*)[cell.contentView viewWithTag:2];
    label.text = media.title;
    
    return cell;
}

@end
