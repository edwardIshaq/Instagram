//
//  Camera.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "Camera.h"

@interface Camera ()
@property (nonatomic) UIImagePickerController *imagePickerController;

@end
@implementation Camera

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay"]];
    overlay.frame = cameraUI.view.bounds;
    cameraUI.cameraOverlayView = overlay;
    [controller presentViewController:cameraUI animated:YES completion:NULL];
    return YES;
}

- (UIImage *)mergeFgImage:(UIImage *)bgImage withBGImage:(UIImage *)fgImage  {
    
    CGSize newSize = CGSizeMake(bgImage.size.width, bgImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bgImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    // Change xPos, yPos if applicable
    CGFloat xOffset = (bgImage.size.width-fgImage.size.width)/2.0;
    CGFloat yOffset = (bgImage.size.height-fgImage.size.height)/2.0;
    [fgImage drawInRect:CGRectMake(xOffset, yOffset ,fgImage.size.width,fgImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}
@end
