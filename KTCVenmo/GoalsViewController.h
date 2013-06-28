//
//  GoalsViewController.h
//  KTCVenmo
//
//  Created by Nuseir Yassin on 6/28/13.
//  Copyright (c) 2013 Nuseir Yassin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalsViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray * tagArray;

@end
