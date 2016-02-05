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
    
    //TFHpple *bioParser = [TFHpple hppleWithHTMLData:repBioData];
    NSString *bioXpathQueryString = @"//p";
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:repBioData];
    NSArray *elements = [doc searchWithXPathQuery:bioXpathQueryString];
    
    TFHppleElement *element = [elements objectAtIndex:0];
    RepBio *repBio = [[RepBio alloc] init];
    repBio.title = [element text];
    
    
    //NSString *testString = [repBio.title stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *noLineBreaks = [repBio.title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
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
    
    self.memberNameLabel.text = self.recievedName;
    
    if ([self.recievedParty isEqualToString:@"R"]) {
        self.memberNameLabel.textColor = [UIColor redColor];
    }
    else if ([self.recievedParty isEqualToString:@"D"]) {
        self.memberNameLabel.textColor = [UIColor blueColor];
    }
    else if ([self.recievedParty isEqualToString:@"I"]) {
        self.memberNameLabel.textColor = [UIColor greenColor];
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
@end
