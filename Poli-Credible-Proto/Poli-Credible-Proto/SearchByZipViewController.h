//
//  SearchByZipViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface SearchByZipViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

// Actions
- (IBAction)searchBtn:(id)sender;
- (IBAction)seachByLocation:(id)sender;

@end
