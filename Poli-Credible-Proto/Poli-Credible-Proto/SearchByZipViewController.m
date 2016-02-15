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
{
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    [super viewDidLoad];
    
    // Initialize locationManager
    locationManager = [[CLLocationManager alloc]init];
    //[self initLocationManager];
    
    
    
    self.zipCodeField.delegate = self;
    
    [self getLocation];
    
}

// initialize Location Manager
-(void)getLocation{
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

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

- (IBAction)searchBtn:(id)sender {
    [self performSegueWithIdentifier:@"zipToResults" sender:self];
}

- (IBAction)seachByLocation:(id)sender {

    [self performSegueWithIdentifier:@"locationToResults" sender:self];
    
}

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


@end
