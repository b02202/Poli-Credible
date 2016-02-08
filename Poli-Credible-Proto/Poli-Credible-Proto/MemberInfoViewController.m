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
    // Populate Name
    [self populateName];
    
    [self loadBiography];
    
    
}

// Html parse
// Load a web page.
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
    
    
    //NSString *testString = [repBio.title stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *noLineBreaks = [repBio.bioText stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //NSLog(@"TEXT = %@", testString);
    
    NSString *bioString = [NSString stringWithFormat:@"%@ %@", self.recievedName, noLineBreaks];
    
    self.bioTextLabel.text = bioString;
    
    
}



// Populate Member Image
-(void)populateImage {

    [self.memberImage setImage:self.recievedImage];
}

// Populate Name and set label text color according to party affiliation
-(void)populateName {
    self.stateDistrictLabel.text = self.recievedState;
    self.birthDate.text = self.recievedDOB;
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






- (IBAction)openFacebook:(id)sender {
  NSString *facebookUrl = [NSString stringWithFormat:@"http://facebook.com/%@", self.recievedFacebookId];
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:facebookUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookUrl]];
    }
}

- (IBAction)openTwitter:(id)sender {
    NSString *twitterUrl = [NSString stringWithFormat:@"http://twitter.com/%@", self.recievedTwittterId];
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:twitterUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterUrl]];
    }
}

- (IBAction)openWebsite:(id)sender {
    
    NSString *websiteUrl = self.recievedWebsiteUrl;
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:websiteUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrl]];
    }
}

- (IBAction)makeCall:(id)sender {
    
    NSString *callNumber = [NSString stringWithFormat:@"1-%@", self.recievedPhone];
    
    // Strip out unneeded characters
    NSString *number = [[callNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]]];
    
   // NSString *number = @"telpromt://1-703-655-1031";
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    
}

- (IBAction)openContactForm:(id)sender {
    NSString *contactUrl = self.recievedContactForm;
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:contactUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactUrl]];
    }
}


// Core Data Save Legislator
-(void)saveToFavorites {
    NSManagedObjectContext *context = [self managedObjectContext];
    appDelegate = [[UIApplication sharedApplication] delegate];
    // Create a new managed object
    NSManagedObject *newLegislator = [NSEntityDescription insertNewObjectForEntityForName:@"Legislator" inManagedObjectContext:context];
    [newLegislator setValue:self.recievedName forKey:@"fullName"];
    [newLegislator setValue:self.recievedParty forKey:@"party"];
    [newLegislator setValue:self.recievedPhone forKey:@"phone"];
    [newLegislator setValue:self.recievedBioID forKey:@"bioGuideID"];
    [newLegislator setValue:self.recievedCRPID forKey:@"crpID"];
    [newLegislator setValue:self.recievedState forKey:@"stateName"];
//    if (![self.recievedDistrict isEqual:[NSNull null]]) {
//        
//        [newLegislator setValue:self.recievedDistrict forKey:@"district"];
//    }
   
    
    NSError *error = nil;
    // Save the object to Core Data
    if (![context save:&error]) {
        // Handle Error
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Legislator has been added to your favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [successAlert show];
    }
}
- (IBAction)addFavorite:(id)sender {
    
    [self saveToFavorites];
}
@end
