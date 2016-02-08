//
//  VotesViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/7/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VotesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *votesTableView;
@property (strong, nonatomic) NSString *recievedBioID;



@end
