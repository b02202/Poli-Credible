//
//  VotesViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/7/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "VotesViewController.h"
#import "VoteDataClass.h"
#import "CustomVoteCell.h"
#import "VoteDetailController.h"

@interface VotesViewController ()
@property (nonatomic, strong) NSMutableArray *votesArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *allItems;
@end

@implementation VotesViewController

-(void)viewDidLoad {
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    [super viewDidLoad];
    
    self.votesArray = [[NSMutableArray alloc]init];
    self.searchArray = [[NSMutableArray alloc]init];
    self.allItems = [[NSMutableArray alloc]init];
    
    self.votesTableView.delegate = self;
    self.votesTableView.dataSource =self;
    
    self.votesTableView.estimatedRowHeight = 60.0f;
    self.votesTableView.rowHeight = UITableViewAutomaticDimension;
    
    // search bar
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:1] CGColor];
    self.searchBar.delegate = self;

    
    // load data
    [self loadData:1];
}
// Load votes
-(void)loadData:(NSInteger)page {
    NSString *urlString = [NSString stringWithFormat:@"http://congress.api.sunlightfoundation.com/votes?voter_ids.%@__exists=true&fields=voter_ids.%@,voted_at,bill,result,breakdown,nomination,question&per_page=50&page=%ld&apikey=6f9f2e31124941a98e97110aeeaec3ff", self.recievedBioID, self.recievedBioID, (long)page];
    
    NSURLSession *session = [NSURLSession sharedSession];
   [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (!error) {
           NSError *error = nil;
           NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
           NSArray *resultsArray = [NSArray arrayWithArray:[receivedData objectForKey:@"results"]];
           
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
               voteDataObj.voteDate = [[resultsArray objectAtIndex:i]objectForKey:@"voted_at"];
               
               if ([[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"]) {
                   voteDataObj.iYea = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Yea"];
                   voteDataObj.iNay = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Nay"];
                   voteDataObj.iNoVote = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Not Voting"];
               }
               // add to array
               [self.votesArray addObject:voteDataObj];
               // set search array
               self.searchArray = [[NSMutableArray alloc] initWithArray:self.votesArray];
               // set page info
               self.currentPage = [[[receivedData objectForKey:@"page"]valueForKey:@"page"] integerValue];
               self.totalPages  = [[[receivedData objectForKey:@"page"]valueForKey:@"count"] integerValue];
               self.totalItems  = [[receivedData objectForKey:@"count"] integerValue];
           }
           // Reload TableView
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.votesTableView reloadData];
           });
       }
   }]resume];
}
// Load data after search
-(void)loadSearchData:(NSInteger)page searchQuery:(NSString*)query {
    NSString *urlString = [NSString stringWithFormat:@"http://congress.api.sunlightfoundation.com/votes?query=%@&voter_ids.%@__exists=true&fields=voter_ids.%@,bill,result,breakdown,nomination,question&per_page=50&page=%ld&apikey=6f9f2e31124941a98e97110aeeaec3ff", query, self.recievedBioID, self.recievedBioID, (long)page];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // code
        if (!error) {
            NSError *error = nil;
            NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *resultsArray = [NSArray arrayWithArray:[receivedData objectForKey:@"results"]];
  
            // Remove all objects from votesArray
            [self.votesArray removeAllObjects];
   
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
                voteDataObj.voteDate = [[resultsArray objectAtIndex:i]objectForKey:@"voted_at"];
                
                if ([[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"]) {
                    voteDataObj.iYea = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Yea"];
                    voteDataObj.iNay = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Nay"];
                    voteDataObj.iNoVote = [[[[[resultsArray objectAtIndex:i]objectForKey:@"breakdown"]objectForKey:@"party"] objectForKey:@"I"] valueForKey:@"Not Voting"];
                }
                // add to array
                [self.votesArray addObject:voteDataObj];
                // set search array
                self.searchArray = [[NSMutableArray alloc] initWithArray:self.votesArray];
                // set page info
                self.currentPage = [[[receivedData objectForKey:@"page"]valueForKey:@"page"] integerValue];
                self.totalPages  = [[[receivedData objectForKey:@"page"]valueForKey:@"count"] integerValue];
                self.totalItems  = [[receivedData objectForKey:@"count"] integerValue];
            }
            // Reload TableView
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.votesTableView reloadData];
            });
        }
    }]resume];
}

// Table Header View Customization
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Change Header Colors
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*) view;
    headerView.contentView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
    headerView.textLabel.textColor = [UIColor whiteColor];
}

// Table Section Header Titles
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Recent Votes";
}

// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentPage == self.totalPages
        || self.totalItems == self.votesArray.count) {
        return self.votesArray.count;
    }
    return self.votesArray.count + 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.votesArray count] - 1 ) {
        [self loadData:++self.currentPage];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *returnCell = nil;
    CustomVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell"];
    
    if (indexPath.row == [self.votesArray count]) {
        returnCell = [tableView dequeueReusableCellWithIdentifier:@"loadCell" forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[returnCell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
    }
    else {
        NSString *voteTitleString;
        NSString *billString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billTitle"];
        NSString *resultsString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"result"];
        
        if (billString == nil || [billString isEqual:[NSNull null]]) {
            voteTitleString = [[self.votesArray objectAtIndex:indexPath.row]valueForKey:@"question"];
        }
        else {
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
        returnCell = cell;
    }
    
    // change selected cells color
    if (![returnCell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, returnCell.frame.size.width, returnCell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        returnCell.selectedBackgroundView = selectedView;
    }
    [returnCell layoutIfNeeded];
    return returnCell;
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
    NSString *voteDate = [[self.votesArray objectAtIndex:indexPath.row]valueForKey:@"voteDate"];
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
    NSString *pdfUrl = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billPdfUrl"];
    
    
    if ([segue.identifier isEqualToString:@"toVoteDetail"]) {
        VoteDetailController *vDC = segue.destinationViewController;
        vDC.recievedDate = voteDate;
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

// Search Bar - URL - /votes?query=%@&voter_ids
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.showsCancelButton = YES;
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"Cancel"];
    
}
// Search bar search
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *queryString = self.searchBar.text;
    // run query
    [self loadSearchData:1 searchQuery:queryString];
}
// SearchBar Cancel
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"Search Cancel button Clicked");
    // clear votesArray
    [self.votesArray removeAllObjects];
    // reload initial data
    [self loadData:1];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

@end
