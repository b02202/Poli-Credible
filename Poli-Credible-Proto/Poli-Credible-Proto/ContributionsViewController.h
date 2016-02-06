//
//  ContributionsViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/5/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContributionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *recievedCRPID;

@property (strong, nonatomic) IBOutlet UITableView *contributorsTableView;


@end
