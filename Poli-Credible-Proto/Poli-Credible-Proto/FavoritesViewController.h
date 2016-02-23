//
//  FavoritesViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;

- (IBAction)editAction:(id)sender;

@end
