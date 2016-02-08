//
//  MemberInfoViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/4/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MemberInfoViewController : UIViewController

{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UILabel *birthDate;

@property (strong, nonatomic) IBOutlet UILabel *stateDistrictLAbel;
@property (strong, nonatomic) IBOutlet UIImageView *memberImage;
@property (strong, nonatomic) IBOutlet UILabel *bioTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberNameLabel;
- (IBAction)addFavorite:(id)sender;


@property (strong, nonatomic) UIImage *recievedImage;
@property (strong, nonatomic) NSString *recievedName;
@property (strong, nonatomic) NSString *recievedParty;
@property (strong, nonatomic) NSString *recievedPhone;
@property (strong, nonatomic) NSString *recievedBioID;
@property (strong, nonatomic) NSString *recievedCRPID;
@property (strong, nonatomic) NSString *recievedState;
@property (strong, nonatomic) NSString *recievedDistrict;
@property (strong, nonatomic) NSString *recievedTwittterId;
@property (strong, nonatomic) NSString *recievedFacebookId;
@property (strong, nonatomic) NSString *recievedWebsiteUrl;


- (IBAction)openFacebook:(id)sender;
- (IBAction)openTwitter:(id)sender;
- (IBAction)openWebsite:(id)sender;
- (IBAction)makeCall:(id)sender;

@end
