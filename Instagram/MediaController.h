//
//  MediaController.h
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Media.h"

@interface MediaController : NSObject

@property (readonly) NSArray *allMedia;

- (void)processDownloadedMedia:(NSArray*)mediaArray;
- (UIImage*)thumbForMedia:(Media*)media;

@end
