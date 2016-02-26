//
//  VotesViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/7/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VotesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *votesTableView;
@property (strong, nonatomic) NSString *recievedBioID;

// Search Bar
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

// API Pages
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;

// All items pages
@property (nonatomic, assign) NSInteger currPage;
@property (nonatomic, assign) NSInteger totPages;
@property (nonatomic, assign) NSInteger totItems;

@end
