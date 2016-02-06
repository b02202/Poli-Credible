//
//  ContributionsViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/5/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "ContributionsViewController.h"
#import "HTTPManager.h"
#import "ContributorDataClass.h"

@interface ContributionsViewController () <HTTPManagerDelegate>
@property (nonatomic, strong) NSMutableArray *contributorArray;
@property (nonatomic, strong) NSArray *totalArray;
@property (nonatomic, strong) HTTPManager *httpManager;

@end

@implementation ContributionsViewController

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
    
    self.contributorArray = [[NSMutableArray alloc]init];
    
    self.contributorsTableView.delegate = self;
    self.contributorsTableView.dataSource =self;
    
    [self runQuery];
    
 
}

// Set URL for Open Secrets API Query and run
-(void)runQuery {
    NSString *urlString = [NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=candContrib&cid=%@&cycle=2016&apikey=bf5679d09f71e7c88c881d99d9d82bc7&output=json", self.recievedCRPID];
    [self httpGetRequest:urlString];
}

// Http Get Request
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
    NSObject *responseObj = [receivedData objectForKey:@"response"];
    NSObject *contributorsObj = [responseObj valueForKey:@"contributors"];
    NSArray *resultsArray = [NSArray arrayWithArray:[contributorsObj valueForKey:@"contributor"]];
   
    for (int i=0; i < resultsArray.count; i++) {
        ContributorDataClass *cdcObj = [[ContributorDataClass alloc] init];
        cdcObj.contributorName = [[[resultsArray objectAtIndex:i]objectForKey:@"@attributes"]valueForKey:@"org_name"];
        cdcObj.contributionTotal = [[[resultsArray objectAtIndex:i]objectForKey:@"@attributes"]valueForKey:@"total"];
        
        [self.contributorArray addObject:cdcObj];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contributorsTableView reloadData];
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
    
    return @"Top Contributors";
}

// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return self.contributorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contributorCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    NSString *totalString = [NSString stringWithFormat:@"Total: $%@", [[self.contributorArray objectAtIndex:indexPath.row] valueForKey:@"contributionTotal"]];
    // Set Cell Text
    cell.textLabel.text = [[self.contributorArray objectAtIndex:indexPath.row] valueForKey:@"contributorName"];
    // Set Cell Detail Text
    cell.detailTextLabel.text = totalString;
    
    return cell;
}

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
