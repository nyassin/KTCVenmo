//
//  MainViewController.h
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Venmo/Venmo.h>
@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *show_number;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VenmoClient *venmoClient;

-(IBAction)launchVenmoClient:(id)sender;
-(IBAction)settingsView:(id)sender;
@end
