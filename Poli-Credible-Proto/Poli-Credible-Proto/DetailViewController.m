//
//  DetailViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize detailView, contributionView, segmentControl;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)segmantValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            // Detail View
        case 0:
            self.contributionView.hidden = YES;
            self.detailView.hidden = NO;
            break;
            // Contributions View
        case 1:
            self.contributionView.hidden = NO;
            self.detailView.hidden = YES;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
