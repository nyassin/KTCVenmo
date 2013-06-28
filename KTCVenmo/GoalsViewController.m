//
//  GoalsViewController.m
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/28/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import "GoalsViewController.h"
#import <Parse/Parse.h>
@interface GoalsViewController ()

@end

@implementation GoalsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Tags";
        
        _tagArray = [[NSMutableArray alloc] init];
        PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
        [query whereKey:@"phoneNumber" equalTo:[[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNumber"]];
        NSArray *Array = [query findObjects];
        
        for(PFObject *object in Array) {
                
                [_tagArray addObject:[object objectForKey:@"title"]];
            }
         NSLog(@"SO THE ARRAY IS NOW THIS %@", _tagArray);
        
        
//        if(![[NSUserDefaults standardUserDefaults]objectForKey:
//             @"picmentsTagArray"]) {
//            
//            
//            _tagArray = [[NSMutableArray alloc]
//                         initWithObjects:@"meal", @"cab",
//                         @"travelcab", @"travelmeal", @"flight", @"hotel", @"travelcar",  @"travelother", @"conference", @"computer", @"supplies", @"consultant", @"help", @"transfer", @"officeevents", @"promotion", @"other", nil];
//        }
//        else {
//            _tagArray = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults
//                                                                 standardUserDefaults] objectForKey:@"picmentsTagArray"]
//                                                               mutableCopy]];
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >=6.0 ) {
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"tagCell"];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(doneWithTags)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(insertNewMessage)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    else {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self
                                       action:@selector(doneWithTags)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)insertNewMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Message"
                                                    message:@"" delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Okay", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)doneWithTags {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    return _tagArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tagCell";
    
    UITableViewCell *cell;
    
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0 ) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                               forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
    }
    
    cell.textLabel.text = [_tagArray objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)
indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        [_tagArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [[NSUserDefaults standardUserDefaults] setObject:_tagArray forKey:
         @"picmentsTagArray"];
    }
}

#pragma mark - UIAlertView Delegate methods

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    // If the user hit "Okay" button
    if (buttonIndex == 1){
        NSString *tmpTextField = [alertView textFieldAtIndex:0].text;
        
        if(!_tagArray)
            _tagArray = [[NSMutableArray alloc]init];
        
        [_tagArray insertObject:tmpTextField atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:_tagArray forKey:
         @"picmentsTagArray"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    // Add selected text to main view controller before dismissal
//    NSString *selectedText = [_tagArray objectAtIndex:indexPath.row];
//    [(PicmentsMainViewController *)self.presentingViewController
//     addTag:selectedText];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
