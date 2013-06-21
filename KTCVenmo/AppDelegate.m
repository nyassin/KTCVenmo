//
//  AppDelegate.m
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "KTCVenmoClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

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
    return YES;
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([sourceApplication isEqualToString:@"net.kortina.labs.Venmo"]) {
        
        _venmoClient = [KTCVenmoClient sharedVenmoClient];
        return [_venmoClient openURL:url
                   completionHandler:^(VenmoTransaction *transaction, NSError *error) {
                       if (transaction) {
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"TransactionCompleted"
                                                                               object:nil];
                           NSString *success = (transaction.success ? @"Success" : @"Failure");
                           NSString *title = [@"Transaction " stringByAppendingString:success];
                           UIAlertView *alertView = [[UIAlertView alloc]
                                                     initWithTitle:title
                                                     message:nil
                                                     delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];

                           [alertView performSelectorOnMainThread:@selector(show)
                                                       withObject:nil
                                                    waitUntilDone:NO];
                       } else { // error
                           UIAlertView *alertView = [[UIAlertView alloc]
                                                     initWithTitle:@"Error"
                                                     message:@"Check Venmo App to see if transaction went through"
                                                     delegate:self
                                                     cancelButtonTitle:@"Dismiss"
                                                     otherButtonTitles:nil];
                           
                           [alertView performSelectorOnMainThread:@selector(show)
                                                       withObject:nil
                                                    waitUntilDone:NO];
                       }
                   }];
    }
    
    return NO;
}


@end
