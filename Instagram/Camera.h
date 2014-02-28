//
//  Camera.h
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Camera : NSObject

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate;

- (UIImage *)mergeFgImage:(UIImage *)bgImage withBGImage:(UIImage *)fgImage;
@end
