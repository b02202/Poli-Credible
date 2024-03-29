//
//  SearchByNameViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "SearchByNameViewController.h"
#import "SWRevealViewController.h"
#import "ResultsViewController.h"

@implementation SearchByNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Menu Button
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    // set nameField Delegate
    self.nameField.delegate = self;
}

// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameField resignFirstResponder];
}
// Search Button
- (IBAction)searchBtn:(id)sender {
    [self performSegueWithIdentifier:@"nameToResults" sender:self];
}
// Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"nameToResults"]) {
        NSString *nameQuery = self.nameField.text;
        NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?query=", nameQuery, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff" ];
        
        //Pass url string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = urlString;
        resultsVC.titleString = @"Results";
        
        // Reset Name field text
        self.nameField.text = @"";
    }
}

@end
