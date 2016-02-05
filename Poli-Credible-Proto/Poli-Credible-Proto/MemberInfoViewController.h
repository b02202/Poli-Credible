//
//  MemberInfoViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/4/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MemberInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *memberImage;
@property (strong, nonatomic) IBOutlet UILabel *bioTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberNameLabel;


@property (strong, nonatomic) UIImage *recievedImage;
@property (strong, nonatomic) NSString *recievedName;
@property (strong, nonatomic) NSString *recievedParty;
@property (strong, nonatomic) NSString *recievedPhone;
@property (strong, nonatomic) NSString *recievedBioID;



- (IBAction)makeCall:(id)sender;

@end
