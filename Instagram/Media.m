//
//  Media.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "Media.h"

@implementation Media

- (id)initWithDictionary:(NSDictionary*)mediaDic {
    self = [super init];
    if ( ! [mediaDic[@"type"] isEqualToString:@"image"] ) {
        return self;
    }
    
    self.standardImageURL = [NSURL URLWithString:mediaDic[@"images"][@"standard_resolution"][@"url"]];
    self.lowResImageURL = [NSURL URLWithString:mediaDic[@"images"][@"low_resolution"][@"url"]];
    self.thumbnailURL = [NSURL URLWithString:mediaDic[@"images"][@"thumbnail"][@"url"]];
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"< %@ | %@ >", [super description], self.thumbnailURL];
}
@end
