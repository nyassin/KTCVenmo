//
//  EnterNumberViewController.h
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterNumberViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *enterNumberTextField;

-(IBAction)signUpButtonClicked:(id)sender;
@end
