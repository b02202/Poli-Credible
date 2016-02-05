//
//  DetailViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "DetailViewController.h"
#import "MemberInfoViewController.h"

@interface DetailViewController ()
@property (nonatomic, strong) NSArray *contributorArray;
@property (nonatomic, strong) NSArray *totalArray;

@end

@implementation DetailViewController
@synthesize detailView, contributionView, segmentControl, memberDataContainer, contributionsViewContainer;

// url for member image - https://theunitedstates.i0/images/congress/225x275/bioid.jpg


-(void)viewDidLoad {
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    [super viewDidLoad];
    
    // Populate Member Image
    //[self populateImage];
    
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

-(void)viewWillAppear:(BOOL)animated{
   
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self populateImage];
//    });
//    if (self.memImage != nil) {
//        [self.memberImage setImage:self.memImage];
//    }
//    else {
//        NSLog(@"memImage = nil");
//    }
    
    
}






- (IBAction)segmantValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            // Detail View
        case 0:
            self.segmentControl.tintColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
            self.contributionsViewContainer.hidden = YES;
            self.memberDataContainer.hidden = NO;
           
            //self.contributionView.hidden = YES;
            //self.detailView.hidden = NO;
            break;
            // Contributions View
        case 1:
            self.segmentControl.tintColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
            self.contributionsViewContainer.hidden = NO;
            self.memberDataContainer.hidden = YES;
            //self.contributionView.hidden = NO;
            //self.detailView.hidden = YES;
            
        default:
            break;
    }
}

// Social Sharing Extensions
- (IBAction)launchShare:(id)sender {
    UIActivityViewController *shareAVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Poli-Credible", @"Information to share"] applicationActivities:nil];
    
    [self presentViewController:shareAVC animated:YES completion:nil];
    
}

- (IBAction)backDismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toInfo"]) {
        MemberInfoViewController *memberInfoVC = segue.destinationViewController;
        memberInfoVC.recievedImage = self.memImage;
        memberInfoVC.recievedName = self.memberNameString;
        memberInfoVC.recievedParty = self.partyString;
        memberInfoVC.recievedPhone = self.phoneString;
        
    }
}

// Member Info View

// Populate Member Image
-(void)populateImage {
   // NSURL *imageUrl = [NSURL URLWithString:self.imageUrlString];
    
    //NSData *data = [NSData dataWithContentsOfURL:imageUrl];
    //UIImage *image = [UIImage imageWithData:data];
    //dispatch_async(dispatch_get_main_queue(), ^{
    //[self.memberImage setImage:self.memImage];
    //self.memberImage.image = self.memImage;
   // });
    
    
    
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
    
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    
    // Set Cell Text
    cell.textLabel.text = self.contributorArray[indexPath.row];
    // Set Cell Detail Text
    cell.detailTextLabel.text = self.totalArray[indexPath.row];
    
    return cell;
}

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
