//
//  SearchByZipViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "SearchByZipViewController.h"
#import "SWRevealViewController.h"
#import "ResultsViewController.h"

@implementation SearchByZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    [super viewDidLoad];
    
    self.zipCodeField.delegate = self;
    
}



// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.zipCodeField resignFirstResponder];
    
}

- (IBAction)searchBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"zipToResults" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"zipToResults"]) {
        NSString *zipQuery = self.zipCodeField.text;
        NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators/locate?zip=", zipQuery, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff" ];
        
        
        
        //Pass to zip string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = urlString;
        resultsVC.titleString = zipQuery;
        
        // Reset zip code field
        self.zipCodeField.text = @"";
    }
    
}

@end