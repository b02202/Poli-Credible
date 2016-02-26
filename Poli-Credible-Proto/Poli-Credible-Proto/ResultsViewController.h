//
//  ResultsViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/25/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *senateTableView;
@property (strong, nonatomic)NSString *searchStr;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavTitle;
@property (strong, nonatomic)NSString *titleString;

// Actions
- (IBAction)dismissView:(id)sender;

@end
