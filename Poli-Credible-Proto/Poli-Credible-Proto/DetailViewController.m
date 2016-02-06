//
//  DetailViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "DetailViewController.h"
#import "MemberInfoViewController.h"
#import "ContributionsViewController.h"


@implementation DetailViewController
@synthesize detailView, contributionView, segmentControl, memberDataContainer, contributionsViewContainer;

// url for member image - https://theunitedstates.i0/images/congress/225x275/bioid.jpg


-(void)viewDidLoad {
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
   
    
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
        memberInfoVC.recievedBioID = self.memBioID;
    }
    
    if ([segue.identifier isEqualToString:@"toContributions"]) {
        ContributionsViewController *contributionsVC = segue.destinationViewController;
        contributionsVC.recievedCRPID = self.memCRPID;
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



@end
