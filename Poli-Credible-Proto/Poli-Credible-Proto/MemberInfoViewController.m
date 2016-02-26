//
//  MemberInfoViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/4/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "TFHpple.h"
#import "RepBio.h"


@implementation MemberInfoViewController

// Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Populate Image
    [self populateImage];
    // Populate Name, state, and DOB
    [self populateName];
    // load Bio
    [self loadBiography];
    // set Links
    [self setLinkButtons];
}
// Html parse
-(void)loadBiography {
    NSString *bioguideUrl = [NSString stringWithFormat:@"http://bioguide.congress.gov/scripts/biodisplay.pl?index=%@", self.recievedBioID];
    NSURL *repBioUrl = [NSURL URLWithString:bioguideUrl];
    NSData *repBioData = [NSData dataWithContentsOfURL:repBioUrl];
    NSString *bioXpathQueryString = @"//p";
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:repBioData];
    NSArray *elements = [doc searchWithXPathQuery:bioXpathQueryString];
    TFHppleElement *element = [elements objectAtIndex:0];
    RepBio *repBio = [[RepBio alloc] init];
    repBio.bioText = [element text];
    NSString *noLineBreaks = [repBio.bioText stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *bioString = [NSString stringWithFormat:@"%@ %@", self.recievedName, noLineBreaks];
    self.bioTextLabel.text = bioString;
}
// Populate Member Image
-(void)populateImage {
    [self.memberImage setImage:self.recievedImage];
}
// Populate Name and set label text color according to party affiliation
// Set DOB and State
-(void)populateName {
    self.stateDistrictLabel.text = self.recievedState;
    // Convert recievedDOB to mm/dd/yyyy format
    NSArray *dobArray = [self.recievedDOB componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    NSString *dobString = [NSString stringWithFormat:@"%@/%@/%@", [dobArray objectAtIndex:1], [dobArray objectAtIndex:2], [dobArray objectAtIndex:0]];
    self.birthDate.text = [NSString stringWithFormat:@"D.O.B.: %@", dobString];
    
    if (![self.recievedDistrict isEqual:[NSNull null]]) {
        self.stateDistrictLabel.text = [NSString stringWithFormat:@"%@, District %@", self.recievedState, self.recievedDistrict];
    } else
    {
      self.stateDistrictLabel.text = self.recievedState;
    }
    self.memberNameLabel.text = self.recievedName;
    
    if ([self.recievedParty isEqualToString:@"R"]) {
        self.memberNameLabel.textColor = [UIColor redColor];
    }
    else if ([self.recievedParty isEqualToString:@"D"]) {
        self.memberNameLabel.textColor = [UIColor blueColor];
    }
    else if ([self.recievedParty isEqualToString:@"I"]) {
        self.memberNameLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
    }
}
// Facebook
- (IBAction)openFacebook:(id)sender {
  NSString *facebookUrl = [NSString stringWithFormat:@"http://facebook.com/%@", self.recievedFacebookId];
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:facebookUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookUrl]];
    }
}
// Twitter
- (IBAction)openTwitter:(id)sender {
    NSString *twitterUrl = [NSString stringWithFormat:@"http://twitter.com/%@", self.recievedTwittterId];
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:twitterUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterUrl]];
    }
}
// Website
- (IBAction)openWebsite:(id)sender {
    NSString *websiteUrl = self.recievedWebsiteUrl;
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:websiteUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrl]];
    }
}
// Call
- (IBAction)makeCall:(id)sender {
    NSString *callNumber = [NSString stringWithFormat:@"1-%@", self.recievedPhone];
    // Strip out unneeded characters
    NSString *number = [[callNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]]];
}
// Contact Form
- (IBAction)openContactForm:(id)sender {
    if (self.recievedContactForm != nil || ![self.recievedContactForm isEqual:[NSNull null]]) {
        NSString *contactUrl = self.recievedContactForm;
        if ([[UIApplication sharedApplication]
             canOpenURL:[NSURL URLWithString:contactUrl]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactUrl]];
        }
    }
}
// Enable link buttons if not null
-(void)setLinkButtons {
    // Contact form
    if (self.recievedContactForm == nil || [self.recievedContactForm isEqual:[NSNull null]]) {
        self.mailBtn.enabled = NO;
    }
    if (self.recievedFacebookId == nil || [self.recievedFacebookId isEqual:[NSNull null]]) {
        self.facebookBtn.enabled = NO;
    }
    if (self.recievedTwittterId == nil || [self.recievedTwittterId isEqual:[NSNull null]]) {
        self.twitterBtn.enabled = NO;
    }
    if (self.recievedWebsiteUrl == nil || [self.recievedWebsiteUrl isEqual:[NSNull null]]) {
        self.websiteBtn.enabled = NO;
    }
}
// Core Data Save Legislator
-(void)saveToFavorites {
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray *favArray = [[NSMutableArray alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Legislator"];
    favArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    BOOL isDuplicate = FALSE;
    // check for duplicate
    for (int i = 0; i < favArray.count; i++) {
        NSString *bioID = [[favArray objectAtIndex:i]valueForKey:@"bioGuideID"];
        if ([bioID isEqualToString:self.recievedBioID]) {
            isDuplicate = TRUE;
            break;
        }
    }
    if (!isDuplicate) {
        // Create a new managed object
        NSManagedObject *newLegislator = [NSEntityDescription insertNewObjectForEntityForName:@"Legislator" inManagedObjectContext:context];
        [newLegislator setValue:self.recievedName forKey:@"fullName"];
        [newLegislator setValue:self.recievedParty forKey:@"party"];
        [newLegislator setValue:self.recievedPhone forKey:@"phone"];
        [newLegislator setValue:self.recievedBioID forKey:@"bioGuideID"];
        [newLegislator setValue:self.recievedCRPID forKey:@"crpID"];
        [newLegislator setValue:self.recievedState forKey:@"stateName"];
        [newLegislator setValue:self.recievedWebsiteUrl forKey:@"website"];
        [newLegislator setValue:self.recievedDOB forKey:@"birthday"];
        // Twitter Validation
        if (![self.recievedTwittterId isEqual:[NSNull null]]) {
            [newLegislator setValue:self.recievedTwittterId forKey:@"twitterID"];
        }
        // Facebook Validation
        if (![self.recievedFacebookId isEqual:[NSNull null]]) {
            [newLegislator setValue:self.recievedFacebookId forKey:@"facebookID"];
        }
        // ContactUrl Validation
        if (![self.recievedContactForm isEqual:[NSNull null]]) {
            [newLegislator setValue:self.recievedContactForm forKey:@"contactURL"];
        }
        // District Validation
        if (![self.recievedDistrict isEqual:[NSNull null]]) {
            NSNumber  *districtNum = [NSNumber numberWithInteger: [self.recievedDistrict integerValue]];
            [newLegislator setValue:districtNum forKey:@"district"];
            
        }
        NSError *error = nil;
        // Save the object to Core Data
        if (![context save:&error]) {
            // Handle Error
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        } else {
            // Show Alert
            [self showAlert:@"Success"  message:@"Legislator has been added to your favorites."];
        }
    }
    else {
        // Show Alert
        [self showAlert:@"Duplicate" message:@"Legislator has already been added to your favorites."];
    }
}
// Add  to Favorites Button
- (IBAction)addFavorite:(id)sender {
    [self saveToFavorites];
}
// Alert Controller
-(void)showAlert:(NSString*)title message:(NSString*)messageString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
