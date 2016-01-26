//
//  NameViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/26/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "NameViewController.h"
#import "ResultsViewController.h"

@implementation NameViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameField.delegate = self;
}




- (IBAction)searchBtn:(id)sender {
    [self performSegueWithIdentifier:@"nameToResults" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"nameToResults"]) {
        NSString *nameQuery = self.nameField.text;
        NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?query=", nameQuery, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff" ];
        
        //Pass to zip string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = urlString;
    }
    
}


@end
