//
//  MainViewController.m
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import "MainViewController.h"
#import "IIViewDeckController.h"
#import "KTCVenmoClient.h"
#import <Venmo/Venmo.h>

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(confirmChangeCharge:)
                                                 name:@"TransactionCompleted"
                                               object:nil];
    
    settingsButtonClicked = NO;
    _showNumber.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNumber"];
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

-(IBAction)launchVenmoClient:(id)sender {
    _venmoClient = [KTCVenmoClient sharedVenmoClient];
    VenmoTransaction *transaction = [[VenmoTransaction alloc] init];
    transaction.note = @"Charity!";
    transaction.toUserHandle = @"VenmoChairty";
    VenmoViewController *venmoViewController = [_venmoClient viewControllerWithTransaction:transaction forceWeb:NO];
    
    if(venmoViewController) {
        UIAlertView *no_app_alert = [[UIAlertView alloc]
                                     initWithTitle:@"No app found"
                                     message:@"Please install Venmo app first to proceed"
                                     delegate:nil
                                     cancelButtonTitle:@"Dismiss"
                                     otherButtonTitles:nil];
        
        [no_app_alert show];
    }
}

-(void)confirmChangeCharge:(NSNotification *) notification {
    NSDictionary *dict = [notification userInfo];
    VenmoTransaction *transaction = [dict objectForKey:@"transaction"];
    
    NSNumber *paymentAmount = [transaction amount];
    double donationAmount = [paymentAmount doubleValue];
    donationAmount = fmod(donationAmount, 1.00);
    donationAmount = 1 - donationAmount;
    NSString *donationAmountStringFormat = [NSString stringWithFormat:@"%2f", donationAmount];
    _donationAmount.text = (NSString *)donationAmountStringFormat;
    
    
}
-(IBAction)completeCharge:(id)sender {
    
//    NSString *accessToken = "cZh3NYA7NQVQxhLdD757nFuSnG7mLV3s";
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://fathomless-citadel-8757.herokuapp.com/?cat=%@&time=%d",categoryChoice,self.timeInterval];
//    
//    NSLog(@"%@",urlString);
//    
//    NSURL *url = [[NSURL alloc] initWithString:urlString];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation
//     JSONRequestOperationWithRequest:request
//     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
//         
//         
//     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         //        [delegate.window.viewForBaselineLayout setUserInteractionEnabled:YES];
//         NSLog(@"%@", error.localizedDescription);
//     }];
//    
//    [operation start];
//    
//    NSLog(@"Request Start");

}
@end
