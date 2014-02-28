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
@end


@implementation MediaController

- (id)init {
    self = [super init];
    self.mediaStore = [NSMutableArray new];
    self.mediaThumbs = [NSMutableDictionary new];
    return self;
}

- (void)processDownloadedMedia:(NSArray*)mediaArray{
    @autoreleasepool {
        for (id dicEntry in mediaArray) {
            Media *_media = [[Media alloc] initWithDictionary:dicEntry];
            [self.mediaStore addObject:_media];
        }
    }
}

- (UIImage*)thumbForMedia:(Media*)media{
    return nil;
}


@end
