//
//  SettingsViewController.h
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *goalName;
-(IBAction)logAllParseGoalsForNumberInUserDefaults:(id)sender;

-(IBAction)removePhoneNumberAndLogOut:(id)sender;
@end
