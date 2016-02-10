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
    [self runNYQuery];
    
}

// Set URL for NYTimes API Query and run
-(void)runNYQuery {
    NSString *urlString = [NSString stringWithFormat:@"http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/%@/votes.json?api-key=5a6a3fe8f0cf2954781b10bdce9761fd:16:72239310", self.recievedBioID];
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
    NSObject *resultsObj = [resultsArray objectAtIndex:0];
    NSArray *votingArray = [NSArray arrayWithArray:[resultsObj valueForKey:@"votes"]];
    
    for (int i=0; i < votingArray.count; i++) {
        VoteDataClass *voteDataObj = [[VoteDataClass alloc] init];
        NSObject *billOBJ = [votingArray objectAtIndex:i];
        NSObject *posOBJ = [votingArray objectAtIndex:i];
        NSObject *billInfoOBJ = [billOBJ valueForKey:@"bill"];
        
        if ([billInfoOBJ valueForKey:@"number"]) {
            NSString *billTitle = [billInfoOBJ valueForKey:@"title"];
            NSString *billDate = [billOBJ valueForKey:@"date"];
            NSString *billDescription = [billOBJ valueForKey:@"description"];
            NSString *memPosition = [posOBJ valueForKey:@"position"];
            
            voteDataObj.billTitle = billTitle;
            voteDataObj.billDate = billDate;
            voteDataObj.billDesc = billDescription;
            voteDataObj.memberPos = memPosition;
            
            // add to array
            [self.votesArray addObject:voteDataObj];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.votesTableView reloadData];
        });
        
    }
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
    return self.votesArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    CustomVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:(NSIndexPath *)indexPath];
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    NSString *voteTitleString = [[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"billTitle"];
    NSString *memPosString = [NSString stringWithFormat:@"Voted: %@",[[self.votesArray objectAtIndex:indexPath.row] valueForKey:@"memberPos"]];
    // Set Cell Text
    //cell.textLabel.text = voteTitleString;
    cell.cellTitle.text = voteTitleString;
    
    // Set Cell Detail Text
    //cell.detailTextLabel.text = memPosString;
    cell.cellSubText.text = memPosString;
    [cell layoutIfNeeded];
    
    return cell;
}

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
