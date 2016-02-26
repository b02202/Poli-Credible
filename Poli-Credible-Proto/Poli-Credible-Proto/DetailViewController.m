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
#import "VotesViewController.h"


@implementation DetailViewController
@synthesize detailView, contributionView, segmentControl, memberDataContainer, contributionsViewContainer, NavTitle;

-(void)viewDidLoad {
    [super viewDidLoad];
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    // Set Nav Bar Title
    NavTitle.title = self.memberNameString;
}
-(void)viewWillAppear:(BOOL)animated{
   
}
// Segmented Control
- (IBAction)segmantValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            // Detail View
        case 0:
            self.segmentControl.tintColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
            self.contributionsViewContainer.hidden = YES;
            self.votesContainer.hidden = YES;
            self.memberDataContainer.hidden = NO;
            break;
            // Contributions View
        case 1:
            self.segmentControl.tintColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
            self.contributionsViewContainer.hidden = NO;
            self.memberDataContainer.hidden = YES;
            self.votesContainer.hidden = YES;
            break;
            // Votes View
        case 2:
            self.segmentControl.tintColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
            self.votesContainer.hidden = NO;
            self.contributionsViewContainer.hidden = YES;
            self.memberDataContainer.hidden = YES;    
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
// Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toInfo"]) {
        MemberInfoViewController *memberInfoVC = segue.destinationViewController;
        memberInfoVC.recievedImage = self.memImage;
        memberInfoVC.recievedName = self.memberNameString;
        memberInfoVC.recievedParty = self.partyString;
        memberInfoVC.recievedPhone = self.phoneString;
        memberInfoVC.recievedBioID = self.memBioID;
        memberInfoVC.recievedCRPID = self.memCRPID;
        memberInfoVC.recievedState = self.memState;
        memberInfoVC.recievedDistrict = self.memDistrict;
        memberInfoVC.recievedTwittterId = self.twitterID;
        memberInfoVC.recievedFacebookId = self.facebookID;
        memberInfoVC.recievedWebsiteUrl = self.websiteURL;
        memberInfoVC.recievedDOB = self.dateOfBirth;
        memberInfoVC.recievedContactForm = self.contactForm;
    }
    
    if ([segue.identifier isEqualToString:@"toContributions"]) {
        ContributionsViewController *contributionsVC = segue.destinationViewController;
        contributionsVC.recievedCRPID = self.memCRPID;
    }
    
    if ([segue.identifier isEqualToString:@"detailToVotes"]) {
        VotesViewController *votesVC = segue.destinationViewController;
        votesVC.recievedBioID = self.memBioID;
    }
}

@end
