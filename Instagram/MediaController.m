//
//  MediaController.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "MediaController.h"

@interface MediaController ()
@property NSMutableArray *mediaStore;
@property NSMutableDictionary *mediaThumbs;
@property (strong) dispatch_queue_t thumbDispatch;
@end


@implementation MediaController

- (id)init {
    self = [super init];
    self.mediaStore = [NSMutableArray new];
    self.mediaThumbs = [NSMutableDictionary new];
    self.thumbDispatch = dispatch_queue_create("com.objectiv-coder.thumbDownload", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_set_target_queue(self.thumbDispatch, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    
    return self;
}

- (NSArray*)allMedia {
    return [NSArray arrayWithArray:self.mediaStore];
}

- (void)processDownloadedMedia:(NSArray*)mediaArray{
    @autoreleasepool {
        [self willChangeValueForKey:@"allMedia"];
        for (id dicEntry in mediaArray) {
            Media *_media = [[Media alloc] initWithDictionary:dicEntry];
            [self.mediaStore addObject:_media];
            
            [self downloadImageForMedia:_media];
        }
        [self didChangeValueForKey:@"allMedia"];
    }
}

- (void)downloadImageForMedia:(Media*)media {
    dispatch_async(self.thumbDispatch, ^{
        NSData * data = [NSData dataWithContentsOfURL:media.thumbnailURL];
        UIImage *result = [UIImage imageWithData:data];
        media.thumbnail = result;
        if (media.mediaDelegate && [media.mediaDelegate conformsToProtocol:@protocol(MediaDelegate)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [media.mediaDelegate media:media downloadedImage:media.thumbnail];
            });
            
        }
    });
}
- (UIImage*)downloadStandardImageForMedia:(Media*)media {
    NSData * data = [NSData dataWithContentsOfURL:media.standardImageURL];
    media.standardImage = [UIImage imageWithData:data];
    return media.standardImage;
}
- (UIImage*)thumbForMedia:(Media*)media{
    return [self.mediaThumbs objectForKey:media];
}


@end
