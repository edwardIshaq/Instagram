//
//  InstagramManager.h
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instagram.h"

@interface InstagramManager : NSObject <IGRequestDelegate, IGSessionDelegate>
@property (strong) Instagram *instagram;

+ (InstagramManager*)sharedManager;
- (BOOL)handleOpenURL:(NSURL*)url;
- (void)login;

@end
