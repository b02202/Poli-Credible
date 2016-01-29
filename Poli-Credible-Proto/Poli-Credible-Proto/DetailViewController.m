//
//  DetailViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, strong) NSArray *contributorArray;
@property (nonatomic, strong) NSArray *totalArray;

@end

@implementation DetailViewController
@synthesize detailView, contributionView, segmentControl, memberDataContainer, contributionsViewContainer;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.contributorArray = [NSArray arrayWithObjects:@"David Allen Co",
                             @"Exxon Mobil",
                             @"AT&T Inc",
                             @"CSX Corp",
                             @"Deere & Co",
                             @"GOP Fund",
                             @"Home Depot",
                             @"Pfizer Inc",
                             @"TRUST PAC",
                             @"Time Warner Cable",
                             @"McKesson Corp",
                             @"Flint Water Co",
                             nil];
    // 12 - Erase
    
    self.totalArray = [NSArray arrayWithObjects:@"$11,600",
                       @"$10,250",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       @"$10,000",
                       nil];
    
    self.contributorsTableView.delegate = self;
    self.contributorsTableView.dataSource =self;
    
    
}

- (IBAction)segmantValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            // Detail View
        case 0:
            self.contributionsViewContainer.hidden = YES;
            self.memberDataContainer.hidden = NO;
            //self.contributionView.hidden = YES;
            //self.detailView.hidden = NO;
            break;
            // Contributions View
        case 1:
            self.contributionsViewContainer.hidden = NO;
            self.memberDataContainer.hidden = YES;
            //self.contributionView.hidden = NO;
            //self.detailView.hidden = YES;
            
        default:
            break;
    }
}

- (IBAction)launchShare:(id)sender {
    UIActivityViewController *shareAVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Poli-Credible", @"Information to share"] applicationActivities:nil];
    
    [self presentViewController:shareAVC animated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

// Contributors View
// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return self.contributorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contributorCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    
    // Set Cell Text
    cell.textLabel.text = self.contributorArray[indexPath.row];
    // Set Cell Detail Text
    cell.detailTextLabel.text = self.totalArray[indexPath.row];
    
    return cell;
}

@end
