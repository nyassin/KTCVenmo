//
//  SettingsViewController.m
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import "SettingsViewController.h"
#import "IIViewDeckController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)removePhoneNumberAndLogOut:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"phoneNumber"];
    [self performSegueWithIdentifier:@"signOut" sender:nil];
    
    [self.viewDeckController closeLeftView];

    
}
@end
