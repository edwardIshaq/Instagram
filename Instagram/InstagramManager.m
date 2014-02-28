//
//  InstagramManager.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "InstagramManager.h"

#define APP_ID @"d46d6144433f456ca7016edc6b0c7e1f"

@implementation InstagramManager

static InstagramManager *_sharedManager = nil;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [InstagramManager new];
    });
}

+ (InstagramManager*)sharedManager {
    return _sharedManager;
}
- (id)init {
    self = [super init];
    self.instagram = [[Instagram alloc] initWithClientId:APP_ID delegate:nil];

    return self;
}

- (BOOL)handleOpenURL:(NSURL*)url {
    BOOL authenticated = [self.instagram handleOpenURL:url];
    if (authenticated) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstagramManager_Authenticated" object:self];
    }
    return authenticated;
}

- (void)login {
    [self.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];

}
@end
