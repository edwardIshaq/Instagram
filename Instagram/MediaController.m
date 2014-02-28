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
        }
        [self didChangeValueForKey:@"allMedia"];
    }
}

- (UIImage*)thumbForMedia:(Media*)media{
    return [self.mediaThumbs objectForKey:media];
}


@end
