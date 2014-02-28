//
//  ViewController.m
//  Instagram
//
//  Created by Edward Ashak on 2/27/14.
//  Copyright (c) 2014 Edward Ashak. All rights reserved.
//

#import "ViewController.h"
#import "ImageGridViewController.h"
#import "InstagramManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Login";
    self.instagramManager = [InstagramManager sharedManager];
    //@"InstagramManager_Authenticated"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:@"InstagramManager_Authenticated" object:nil];
    
}
//- (void)viewWillAppear:(BOOL)animated {
//    if ([[[InstagramManager sharedManager] instagram] isSessionValid]) {
//        [self userLoggedIn];
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [[InstagramManager sharedManager] login];
}
- (void)userLoggedIn {
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageGridViewController *vc = [mainStory instantiateViewControllerWithIdentifier:@"ImageGridViewControllerID"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
