//
//  Camera.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "Camera.h"

@implementation Camera
- (void)showCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self.nav presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"done");
        }];
    }
    return;
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
//                                                       message:@"Unable to find a camera on your device."
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil, nil];
//        [alert show];
//        alert = nil;
//    }
}
@end
