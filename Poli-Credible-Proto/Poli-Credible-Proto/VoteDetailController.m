//
//  VoteDetailController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/14/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "VoteDetailController.h"
#import "VoteDetailCell.h"

@implementation VoteDetailController

-(void)viewDidLoad {
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    [super viewDidLoad];
    
    self.voteDetailTable.delegate = self;
    self.voteDetailTable.dataSource = self;
    // set labels
    [self populateLabels];
    // set view bill button visibility
    [self setBillBtnVisibility];
}
// set labels
-(void)populateLabels {
    self.questionLabel.text = self.recievedQuestion;
    self.resultLabel.text = self.recievedResult;
    
    // Convert date to readable format
    NSDateFormatter *dFormat = [[NSDateFormatter alloc]init];
    [dFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [dFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *date = [dFormat dateFromString:self.recievedDate];
    // Convert NSDate back to string
    NSDateFormatter *toStringFormat = [[NSDateFormatter alloc]init];
    [toStringFormat setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [toStringFormat setDateFormat:@"MMM dd, yyyy h:mm a"];
    NSString *dateString = [toStringFormat stringFromDate:date];
    self.dateLabel.text = dateString;
}
// set bill visibility if there is an associated bill with the vote
-(void)setBillBtnVisibility {
    if (self.isBill) {
        self.viewBillBtn.hidden = NO;
    }
    else {
        self.viewBillBtn.hidden = YES;
    }
}

// TableView
 // Table Header View Customization
 // Sections
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 4;
 }
 
 -(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
 // Change Header Colors
 UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*) view;
 headerView.contentView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
 headerView.textLabel.textColor = [UIColor whiteColor];
 }
 
 // Table Section Header Titles
 -(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     NSString *headerTitle;
     if (section == 0) {
         headerTitle = @"Vote Breakdown";
     } else if (section == 1){
         headerTitle = @"Democrats";
     } else if (section == 2) {
         headerTitle = @"Republicans";
     } else if (section == 3) {
         headerTitle = @"Independents";
     }
 return headerTitle;
 }
 
 // TableView Number of Rows
 // Specify number of rows displayed
 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return 1;
 }
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 VoteDetailCell *vDCell = [tableView dequeueReusableCellWithIdentifier:@"voteDetailCell"];
     float totalVotes;
     
     if (indexPath.section == 0) {
         vDCell.yeaVotes.text = [NSString stringWithFormat:@"%@", self.recievedTotalYea];
         vDCell.nayVotes.text = [NSString stringWithFormat:@"%@", self.recievedTotalNay];
         vDCell.notVoting.text = [NSString stringWithFormat:@"%@", self.recievedTotalNoVote];
         
         // progress nums
         totalVotes = [self.recievedTotalYea floatValue] + [self.recievedTotalNay floatValue] + [self.recievedTotalNoVote floatValue];
         
         vDCell.yeaProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedTotalYea floatValue]];
         vDCell.nayProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedTotalNay floatValue]];
         vDCell.noVoteProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedTotalNoVote floatValue]];
     }
     else if (indexPath.section == 1) {
         vDCell.yeaVotes.text = [NSString stringWithFormat:@"%@", self.recievedDemYea];
         vDCell.nayVotes.text = [NSString stringWithFormat:@"%@", self.recievedDemNay];
         vDCell.notVoting.text = [NSString stringWithFormat:@"%@", self.recievedDemNo];
         
         // progress nums
         totalVotes = [self.recievedDemYea floatValue] + [self.recievedDemNay floatValue] + [self.recievedDemNo floatValue];
         // set Progress
         vDCell.yeaProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedDemYea floatValue]];
         vDCell.nayProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedDemNay floatValue]];
         vDCell.noVoteProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedDemNo floatValue]];
         
         // change progress tint color for party: D
         vDCell.yeaProgress.progressTintColor = [UIColor blueColor];
         vDCell.nayProgress.progressTintColor = [UIColor blueColor];
         vDCell.noVoteProgress.progressTintColor = [UIColor blueColor];
     }
     else if (indexPath.section == 2) {
         vDCell.yeaVotes.text = [NSString stringWithFormat:@"%@", self.recievedRYea];
         vDCell.nayVotes.text = [NSString stringWithFormat:@"%@", self.recievedRNay];
         vDCell.notVoting.text = [NSString stringWithFormat:@"%@", self.recievedRNo];
         
         // progress nums
         totalVotes = [self.recievedRYea floatValue] + [self.recievedRNay floatValue] + [self.recievedRNo floatValue];
         // set Progress
         vDCell.yeaProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedRYea floatValue]];
         vDCell.nayProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedRNay floatValue]];
         vDCell.noVoteProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedRNo floatValue]];
         
         // change progress tint color for party: R
         vDCell.yeaProgress.progressTintColor = [UIColor redColor];
         vDCell.nayProgress.progressTintColor = [UIColor redColor];
         vDCell.noVoteProgress.progressTintColor = [UIColor redColor];
     }
     else if (indexPath.section == 3) {
         
         if (self.recievedIYea != nil && self.recievedRNay != nil && self.recievedRNo != nil) {
             vDCell.yeaVotes.text = [NSString stringWithFormat:@"%@", self.recievedIYea];
             vDCell.nayVotes.text = [NSString stringWithFormat:@"%@", self.recievedINay];
             vDCell.notVoting.text = [NSString stringWithFormat:@"%@", self.recievedINo];
             
             // progress nums
             totalVotes = [self.recievedIYea floatValue] + [self.recievedINay floatValue] + [self.recievedINo floatValue];
             // set Progress
             vDCell.yeaProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedIYea floatValue]];
             vDCell.nayProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedINay floatValue]];
             vDCell.noVoteProgress.progress = [self setTotalVoteProgress:totalVotes vote:[self.recievedINo floatValue]];
             
             // change progress tint color for party: I
             vDCell.yeaProgress.progressTintColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
             vDCell.nayProgress.progressTintColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
             vDCell.noVoteProgress.progressTintColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
         } else {
             vDCell.yeaProgress.hidden = YES;
             vDCell.nayProgress.hidden = YES;
             vDCell.noVoteProgress.hidden = YES;
             vDCell.yeaVotes.hidden = YES;
             vDCell.nayVotes.hidden = YES;
             vDCell.notVoting.hidden = YES;
             vDCell.yeaLabel.hidden = YES;
             vDCell.nayLabel.hidden = YES;
             vDCell.noVoteLabel.hidden = YES;
             vDCell.noILabel.hidden = NO;
         }
     }
     return vDCell;
 }
 // set vote progress
-(float)setTotalVoteProgress:(float)total vote:(float)votes {
    float value = votes / total;
    
 return value;
 }
// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// View Bill Button
- (IBAction)viewBill:(id)sender {
    NSString *pdfUrl = self.recievedPdf;
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:pdfUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pdfUrl]];
    }
}

- (IBAction)backDismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
