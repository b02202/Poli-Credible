//
//  DetailViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DetailViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *contributionView;
@property (strong, nonatomic) IBOutlet UIView *memberDataContainer;

@property (strong, nonatomic) IBOutlet UIView *contributionsViewContainer;
@property (strong, nonatomic) IBOutlet UIView *votesContainer;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) IBOutlet UINavigationItem *NavTitle;

// Member Info

@property (strong, nonatomic) NSString *memberNameString;
@property (strong, nonatomic) NSString *imageUrlString;
@property (strong, nonatomic) UIImage *memImage;
@property (strong, nonatomic) NSString *partyString;
@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *memBioID;
@property (strong, nonatomic) NSString *memCRPID;
@property (strong, nonatomic) NSString *memState;
@property (strong, nonatomic) NSString *memDistrict;
@property (strong, nonatomic) NSString *twitterID;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *websiteURL;



// Contributors



- (IBAction)segmantValueChanged:(id)sender;
- (IBAction)launchShare:(id)sender;
- (IBAction)backDismiss:(id)sender;

@end
