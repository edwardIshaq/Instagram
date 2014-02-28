//
//  Media.h
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject
@property NSURL *lowResImageURL;
@property NSURL *standardImageURL;
@property NSURL *thumbnailURL;

- (id)initWithDictionary:(NSDictionary*)mediaDic;

@end
