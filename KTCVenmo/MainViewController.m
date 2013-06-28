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
#import <Parse/Parse.h>
#import "GoalsViewController.h"
BOOL settingsButtonClicked;
@implementation MainViewController
double donationAmountNumber = 0.0;

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
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Iterate through your subviews, or some other custom array of views
        [_donationAmount resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"] == nil) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UIViewController *tvc = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        [[self navigationController] popToViewController:tvc animated:YES];
        [self performSegueWithIdentifier:@"backToTutorialPage" sender:nil];
           
    }
    self.donationAmount.delegate = self;
    
}

-(IBAction)chooseGoal:(id)sender {
    GoalsViewController *goalsView = [[GoalsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:goalsView];
    [self presentViewController:navigationController animated:YES completion: nil];

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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)confirmChangeCharge:(NSNotification *) notification {
    NSDictionary *dict = [notification userInfo];
    VenmoTransaction *transaction = [dict objectForKey:@"transaction"];
    
    NSNumber *paymentAmount = [transaction amount];
    donationAmountNumber = [paymentAmount doubleValue];
    donationAmountNumber = donationAmountNumber * 0.05;
    NSString *donationAmountStringFormat = [NSString stringWithFormat:@"%2f", donationAmountNumber];
    _donationAmount.text = (NSString *)donationAmountStringFormat;
    
    
}
-(IBAction)completeCharge:(id)sender {
    
    NSString *accessToken = @"cZh3NYA7NQVQxhLdD757nFuSnG7mLV3s";
    NSString *urlString = [NSString stringWithFormat:@"https://api.venmo.com/payments"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    if(donationAmountNumber > 0) {
        donationAmountNumber = donationAmountNumber * -1.00;
    }
    NSString *params = [[NSString alloc] initWithFormat:@"access_token=%@&phone=%@&amount=%f&note=test", accessToken, [[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNumber"],donationAmountNumber];
    NSLog(@"%@", params);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%@", connection);
}
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *newResp = (NSHTTPURLResponse *)response;
    
    NSString *phoneNumber =[[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNumber"];
    if([newResp statusCode] == 200) {
        donationAmountNumber = donationAmountNumber * -1.00;
        PFQuery *query = [PFQuery queryWithClassName:@"Goals"];
        [query whereKey:@"phoneNumber" equalTo:phoneNumber];
        [query whereKey:@"title" equalTo:@"buy a car"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(objects == nil || [objects count] == 0) {
                //create new record
                PFObject * createNewGoal = [PFObject objectWithClassName:@"Goals"];
                [createNewGoal setObject:phoneNumber forKey:@"phoneNumber"];
                [createNewGoal setObject:@"buy a car" forKey:@"title"];
                [createNewGoal setObject:[NSNumber numberWithDouble:donationAmountNumber] forKey:@"balance"];
                [createNewGoal saveInBackground];
            } else {
                for(PFObject *object in objects) {
                    double current_balance = [[object objectForKey:@"balance"] doubleValue];
                    current_balance = current_balance + donationAmountNumber;
                    [object setObject:[NSNumber numberWithDouble:current_balance] forKey:@"balance"];
                    [object saveInBackground];
                }
            }
        }];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Success" message:@"Approve the message sent to you" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}
@end
