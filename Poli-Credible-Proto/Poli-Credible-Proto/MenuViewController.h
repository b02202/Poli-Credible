//
//  MenuViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

- (IBAction)logoutBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;

@end
