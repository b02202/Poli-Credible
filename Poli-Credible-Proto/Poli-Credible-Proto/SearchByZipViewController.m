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
#import "FormValidationUtility.h"

@implementation SearchByZipViewController
{
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Menu setup
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];

    // Initialize locationManager
    locationManager = [[CLLocationManager alloc]init];
    // zip code delegate
    self.zipCodeField.delegate = self;
    // get location
    [self getLocation];
}

// Get Location Manager
-(void)getLocation{
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}
// Location Fail
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // Show Alert
    [self showAlert:@"Error" message:@"There was an error retrieving your location"];
    NSLog(@"Error: %@",error.description);
}
// did update locations
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    self.latitude = [NSString stringWithFormat:@"%.2f",location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.2f",location.coordinate.longitude];
}

// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.zipCodeField resignFirstResponder];
}
// Zip Code Search Button
- (IBAction)searchBtn:(id)sender {
    // Validate Zip Code
    if ([FormValidationUtility zipVal:self.zipCodeField.text]) {
        [self performSegueWithIdentifier:@"zipToResults" sender:self];
    }
    else {
        // Show Alert
        [self showAlert:@"Oops!" message:@"Please enter a valid 5 digit zip code"];
    }
}
// Search by Location button
- (IBAction)seachByLocation:(id)sender {
    [self performSegueWithIdentifier:@"locationToResults" sender:self];
}
// segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"zipToResults"]) {
       NSString *zipQuery = self.zipCodeField.text;
        NSString *searchUrl = [NSString stringWithFormat:@"https://congress.api.sunlightfoundation.com/legislators/locate?zip=%@&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff", zipQuery];
        //Pass to zip string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = searchUrl;
        resultsVC.titleString = zipQuery;
        
        // Reset zip code field
        self.zipCodeField.text = @"";
    }
    
    if ([segue.identifier isEqualToString:@"locationToResults"]) {
        NSString *locQuery = [NSString stringWithFormat:@"latitude=%@&longitude=%@", self.latitude, self.longitude];
        NSString *urlString = [NSString stringWithFormat:@"https://congress.api.sunlightfoundation.com/legislators/locate?%@&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff", locQuery];
        //Pass to zip string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = urlString;
        resultsVC.titleString = @"Current Location";
    }
}

// Alert Controller
-(void)showAlert:(NSString*)title message:(NSString*)messageString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
