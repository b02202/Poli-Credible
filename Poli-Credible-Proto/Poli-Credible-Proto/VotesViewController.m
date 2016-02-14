//
//  VotesViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/7/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "VotesViewController.h"
#import "HTTPManager.h"
#import "VoteDataClass.h"
#import "CustomVoteCell.h"
#import "VoteDetailController.h"

@interface VotesViewController () <HTTPManagerDelegate>
@property (nonatomic, strong) NSMutableArray *votesArray;
@property (nonatomic, strong) HTTPManager *httpManager;
@end

@implementation VotesViewController

// HttpManager
-(HTTPManager*)httpManager {
    if (!_httpManager) {
        _httpManager = [[HTTPManager alloc] init];
    }
    return _httpManager;
}

-(void)viewDidLoad {
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    [super viewDidLoad];
    
    self.votesArray = [[NSMutableArray alloc]init];
    
    self.votesTableView.delegate = self;
    self.votesTableView.dataSource =self;
    
    self.votesTableView.estimatedRowHeight = 60.0f;
    self.votesTableView.rowHeight = UITableViewAutomaticDimension;
    
    // Run NYTimes Query
    [self runSLQuery];
    
}

// Set URL for NYTimes API Query and run
-(void)runSLQuery {
   // NSString *urlString = [NSString stringWithFormat:@"http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/%@/votes.json?api-key=5a6a3fe8f0cf2954781b10bdce9761fd:16:72239310", self.recievedBioID];
    
   NSString *urlString = [NSString stringWithFormat:@"http://congress.api.sunlightfoundation.com/votes?voter_ids.%@__exists=true&fields=voter_ids.%@,bill,result,breakdown,nomination,question&apikey=6f9f2e31124941a98e97110aeeaec3ff", self.recievedBioID, self.recievedBioID];
    
    [self httpGetRequest:urlString];
}

// Http Get Request - @"http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/A000055/votes.json?api-key=5a6a3fe8f0cf2954781b10bdce9761fd:16:72239310
-(void)httpGetRequest:(NSString*)searchString {
    self.httpManager.delegate = self;
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    searchString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *url = [NSURL URLWithString:searchString];
    
    [self.httpManager httpRequest:url];
    
}

// Get Recieved Data
-(void)getReceivedData:(NSData*)data sender:(HTTPManager*)sender {
    NSError *error = nil;
    NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *resultsArray = [NSArray arrayWithArray:[receivedData objectForKey:@"results"]];
    NSLog(@"TEST OBJ = %@", [[[resultsArray objectAtIndex:0]objectForKey:@"bill"]valueForKey:@"bill_id"]);
  
    //NSArray *votingArray = [NSArray arrayWithArray:[resultsObj valueForKey:@"votes"]];
    
    
    for (int i=0; i < resultsArray.count; i++) {
        VoteDataClass *voteDataObj = [[VoteDataClass alloc] init];
        voteDataObj.billTitle = [[[resultsArray objectAtIndex:i]objectForKey:@"bill"]valueForKey:@"short_title"];
        voteDataObj.billDesc  = [[[resultsArray objectAtIndex:i]objectForKey:@"bill"]valueForKey:@"official_title"];
        voteDataObj.memberPos = [[[resultsArray objectAtIndex:i]objectForKey:@"voter_ids"]valueForKey:self.recievedBioID];
        voteDataObj.billID = [[[resultsArray objectAtIndex:i]objectForKey:@"bill"]valueForKey:@"bill_id"];
        voteDataObj.result = [[resultsArray objectAtIndex:i]objectForKey:@"result"];
        voteDataObj.totalYea = [[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"total"] valueForKey:@"Yea"];
        voteDataObj.totalNay = [[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"total"] valueForKey:@"Nay"];
        voteDataObj.noVote = [[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"total"] valueForKey:@"Not Voting"];
        voteDataObj.demYea = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"D"] valueForKey:@"Yea"];
        voteDataObj.demNay = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"D"] valueForKey:@"Nay"];
        voteDataObj.demNoVote = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"D"] valueForKey:@"Not Voting"];
        voteDataObj.rYea = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"R"] valueForKey:@"Yea"];
        voteDataObj.rNay = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"R"] valueForKey:@"Nay"];
        voteDataObj.rNoVote = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"R"] valueForKey:@"Not Voting"];
        voteDataObj.nominationID = [[[resultsArray objectAtIndex:i]objectForKey:@"nomination"]valueForKey:@"nomination_id"];
        voteDataObj.question = [[resultsArray objectAtIndex:i]objectForKey:@"question"];
        voteDataObj.billPdfUrl = [[[[[resultsArray objectAtIndex:i]objectForKey:@"bill"]objectForKey:@"last_version"]objectForKey:@"urls"]valueForKey:@"pdf"];
        
        if ([[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"]) {
            voteDataObj.iYea = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Yea"];
            voteDataObj.iNay = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Nay"];
            voteDataObj.iNoVote = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Not Voting"];
        }
            // add to array
            [self.votesArray addObject:voteDataObj];
    }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.votesTableView reloadData];
        });
}

// Table Header View Customization
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Change Header Color
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*) view;
    headerView.contentView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
    //view.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:1];
    
    headerView.textLabel.textColor = [UIColor whiteColor];
}

// Table Section Header Titles
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Recent Votes";
}

// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return [self.votesArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    CustomVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell"]; // forIndexPath:(NSIndexPath *)indexPath];
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    NSString *voteTitleString;
    NSString *nominationString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"nominationID"];
    NSString *billString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billTitle"];
    NSString *resultsString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"result"];
    
   // NSString *altBillString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billDesc"];
    NSLog(@"Nom = %@ ", nominationString);
    NSLog(@"Bill = %@", billString);
    
    if (billString == nil || [billString isEqual:[NSNull null]]) {
        voteTitleString = [[self.votesArray objectAtIndex:indexPath.row]valueForKey:@"question"];
        
    } else {
        voteTitleString = billString;
        
    }
    
    NSString *memPosString;
    if ([[[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"memberPos"] isEqual:[NSNull null]]) {
        memPosString = @"Voted: No Vote";
    } else {
        memPosString = [NSString stringWithFormat:@"Voted: %@", [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"memberPos"]];
    }

    // Set Cell Text
 
    cell.cellTitle.text = voteTitleString;
    
    // Set Cell Detail Text
    
    cell.cellSubText.text = memPosString;
    
    // Set Results Text
    cell.cellSubText2.text = [NSString stringWithFormat:@"Result: %@", resultsString];
    [cell layoutIfNeeded];
    
    return cell;
}

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.votesTableView indexPathForSelectedRow];
    NSString *question = [[self.votesArray objectAtIndex:indexPath.row]valueForKey:@"question"];
    NSString *result = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"result"];
    //NSString *date;
    //NSString *navTitle;
    NSString *totalYea = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"totalYea"];
    NSString *totalNay = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"totalNay"];
    NSString *totalNo = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"noVote"];
    NSString *demYea = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"demYea"];
    NSString *demNay = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"demNay"];
    NSString *demNo = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"demNoVote"];
    NSString *rYea = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"rYea"];
    NSString *rNay = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"rNay"];
    NSString *rNo = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"rNoVote"];
    NSString *iYea = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"iYea"];
    NSString *iNay = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"iNay"];
    NSString *iNo = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"iNoVote"];
    //NSString *billTitle = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billTitle"];
    NSString *pdfUrl = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billPdfUrl"];
    
    
    if ([segue.identifier isEqualToString:@"toVoteDetail"]) {
        VoteDetailController *vDC = segue.destinationViewController;
        vDC.recievedQuestion = question;
        vDC.recievedResult = result;
        vDC.recievedTotalYea = totalYea;
        vDC.recievedTotalNay = totalNay;
        vDC.recievedTotalNoVote = totalNo;
        vDC.recievedDemYea = demYea;
        vDC.recievedDemNay = demNay;
        vDC.recievedDemNo = demNo;
        vDC.recievedRYea = rYea;
        vDC.recievedRNay = rNay;
        vDC.recievedRNo = rNo;
        vDC.recievedIYea = iYea;
        vDC.recievedINay = iNay;
        vDC.recievedINo = iNo;
        
        if (pdfUrl == nil || [pdfUrl isEqual:[NSNull null]]) {
            vDC.isBill = FALSE;
        }
        else {
            vDC.isBill = TRUE;
            vDC.recievedPdf = pdfUrl;
        }
    }
    
}


@end
