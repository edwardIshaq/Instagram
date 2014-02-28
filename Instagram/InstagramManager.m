//
//  InstagramManager.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "InstagramManager.h"
#import "MediaController.h"

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
    self.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    self.instagram.sessionDelegate = self;
    if (self.instagram.isSessionValid) {
        [self getMediaByTag:@""];
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL*)url {
    return [self.instagram handleOpenURL:url];
}

- (void)login {
    [self.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];

}

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    [[NSUserDefaults standardUserDefaults] setObject:self.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];

    [self getMediaByTag:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InstagramManager_Authenticated" object:self];

}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}



- (void)getMediaByTag:(NSString*)tag {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"tags/NewYork/media/recent", @"method", nil];
    [self.instagram requestWithParams:params delegate:self];
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
//    NSLog(@"Instagram did load: %@", result);
    NSArray *mediaArray = (NSArray*)[result objectForKey:@"data"];
    [[[AppDelegate sharedAppDelegate] mediaController] processDownloadedMedia:mediaArray];
}
@end
