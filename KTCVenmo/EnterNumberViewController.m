//
//  EnterNumberViewController.m
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/14/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import "EnterNumberViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"

@implementation EnterNumberViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_enterNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];

}
-(void)signUpButtonClicked:(id)sender {

    NSString *enteredNumber = _enterNumberTextField.text;    
    [[NSUserDefaults standardUserDefaults] setObject:enteredNumber forKey:@"phoneNumber"];

    [self performSegueWithIdentifier:@"finishProcess" sender:sender];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
