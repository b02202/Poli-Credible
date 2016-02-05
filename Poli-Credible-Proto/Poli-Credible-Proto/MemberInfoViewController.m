//
//  MemberInfoViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/4/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "MemberInfoViewController.h"

@implementation MemberInfoViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Populate Image
    [self populateImage];
    // Populate Name
    [self populateName];
    
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
