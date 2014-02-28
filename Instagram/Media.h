//
//  Media.h
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MediaDelegate;

@interface Media : NSObject

@property NSString *title;

@property NSURL *lowResImageURL;
@property NSURL *standardImageURL;
@property NSURL *thumbnailURL;

@property (strong) UIImage *thumbnail;
@property (strong) UIImage *standardImage;

@property (weak) id <MediaDelegate> mediaDelegate;

- (id)initWithDictionary:(NSDictionary*)mediaDic;


@end


@protocol MediaDelegate <NSObject>

- (void)media:(Media*)photo downloadedImage:(UIImage*)image;

@end