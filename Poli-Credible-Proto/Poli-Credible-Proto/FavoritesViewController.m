//
//  FavoritesViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()
@property (nonatomic, strong) NSArray* favoritesArray;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.favoritesTableView.delegate = self;
    self.favoritesTableView.dataSource = self;
    
    self.favoritesArray = [NSArray arrayWithObjects:@"Richard Burr (R)",@"David Price (D)", @"Norm Dicks (D)", @"Patty Murray (D)", nil];
    
}


// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return self.favoritesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    
    cell.textLabel.text = self.favoritesArray[indexPath.row];
    
    return cell;
}
@end
