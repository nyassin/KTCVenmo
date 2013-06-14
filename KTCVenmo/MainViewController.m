//
//  MainViewController.m
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import "MainViewController.h"
#import "IIViewDeckController.h"

BOOL settingsButtonClicked;
@implementation MainViewController


-(IBAction)settingsView:(id)sender {
    if(settingsButtonClicked == YES) {
        [self.viewDeckController closeLeftView];
        settingsButtonClicked = NO;
    } else {
        [self.viewDeckController openLeftView];
        settingsButtonClicked = YES;

    }
}
-(void) viewDidLoad {
    settingsButtonClicked = NO;
    _show_number.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"signedout"];

    if(self.viewDeckController == nil) {
        NSLog(@"INITILIZING VIEWDECK");
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UIViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        UIViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
        IIViewDeckController *deckController =  [[IIViewDeckController alloc] initWithCenterViewController:cvc
                                                                                        leftViewController:lvc];
        
        
        deckController.panningMode = IIViewDeckFullViewPanning;
        deckController.leftSize = 70;
        deckController.openSlideAnimationDuration = 0.20f; // In seconds
        self.window.rootViewController = deckController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];

    }
    
}

-(void)viewDidAppear:(BOOL)animated {
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"] == nil) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UIViewController *tvc = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        [[self navigationController] popToViewController:tvc animated:YES];
        [self performSegueWithIdentifier:@"backToTutorialPage" sender:nil];
           
    }
}
@end
