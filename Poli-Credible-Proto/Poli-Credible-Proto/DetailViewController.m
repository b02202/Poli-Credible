//
//  DetailViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize detailView, contributionView, segmentControl, memberDataContainer, contributionsViewContainer;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
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

@end
