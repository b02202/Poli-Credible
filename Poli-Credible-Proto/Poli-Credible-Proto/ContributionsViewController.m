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
#import "IndustryDataClass.h"
#import "CustomIndustryCell.h"
#import "FundraisingDataClass.h"
#import "CustomFundraisingCell.h"

@interface ContributionsViewController () <HTTPManagerDelegate>
@property (nonatomic, strong) NSMutableArray *contributorArray;
@property (nonatomic, strong) NSMutableArray *industryArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *totalArray;
@property (nonatomic, strong) HTTPManager *httpManager;
@property (nonatomic, strong) NSString *apiString;
// Fundraising summary
@property (nonatomic, strong) NSString *totalRaised;
@property (nonatomic, strong) NSString *totalSpent;
@property (nonatomic, strong) NSString *cashOnHand;
@property (nonatomic, strong) NSString *totalDebts;
@property (nonatomic, strong) NSString *lastReported;



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
    self.industryArray = [[NSMutableArray alloc]init];
    // Section Array
    self.sectionArray = [NSArray arrayWithObjects:@"Campaign Fundraising 2015 - 2016", @"Top Industries", @"Top Contributors", nil ];
    
    self.contributorsTableView.delegate = self;
    self.contributorsTableView.dataSource =self;
    
    self.contributorsTableView.estimatedRowHeight = 60.0f;
    self.contributorsTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    NSString *industryUrl = [NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=candIndustry&cid=%@&cycle=2016&apikey=bf5679d09f71e7c88c881d99d9d82bc7&output=json", self.recievedCRPID];
    NSString *contributorUrl = [NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=candContrib&cid=%@&cycle=2016&apikey=bf5679d09f71e7c88c881d99d9d82bc7&output=json", self.recievedCRPID];
    NSString *fundraisingUrl = [NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=candSummary&cid=%@&cycle=2016&apikey=bf5679d09f71e7c88c881d99d9d82bc7&output=json", self.recievedCRPID];
    
    
    [self fundraisingAsyncRequest:fundraisingUrl];
    
    [self httpAsyncRequest:industryUrl];
    
    [self runQuery:contributorUrl];
}

// Set URL for Open Secrets API Query and run
-(void)runQuery:(NSString*)url {
   
    [self httpGetRequest:url];
}
// Async - Top Industries
-(void)httpAsyncRequest: (NSString*)urlString {
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self getData:data];
            NSLog(@"Session ran");
        }
        else {
            // Handle Errors
            NSLog(@"%@", error.description);
        }
    }] resume];
}

// Async - Campaign Fundraising Report
-(void)fundraisingAsyncRequest: (NSString*)urlString {
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self getFundraisingData:data];
            NSLog(@"Session ran");
        }
        else {
            // Handle Errors
            NSLog(@"%@", error.description);
        }
    }] resume];
}

// Http Get Request
-(void)httpGetRequest:(NSString*)searchString {
    self.httpManager.delegate = self;
    self.apiString = searchString;
    
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
        NSLog(@"Cont = %@", cdcObj.contributorName);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contributorsTableView reloadData];
    });
    
    
    
   
}

// Get Industry Data
-(void)getData:(NSData*)data {
    NSError *error = nil;
    NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSObject *industriesObj = [receivedData objectForKey:@"response"];
    NSObject *industryObj = [industriesObj valueForKey:@"industries"];
    NSArray *industryDataArray = [NSArray arrayWithArray:[industryObj valueForKey:@"industry"]];
    
    for (int i=0; i < industryDataArray.count; i++) {
        IndustryDataClass *idcObj = [[IndustryDataClass alloc] init];
        idcObj.industryName = [[[industryDataArray objectAtIndex:i]objectForKey:@"@attributes"]valueForKey:@"industry_name"];
        idcObj.individualTotals = [[[industryDataArray objectAtIndex:i]objectForKey:@"@attributes"]valueForKey:@"indivs"];
        idcObj.pacsTotal = [[[industryDataArray objectAtIndex:i]objectForKey:@"@attributes"]valueForKey:@"pacs"];
        idcObj.total = [[[industryDataArray objectAtIndex:i]objectForKey:@"@attributes"]valueForKey:@"total"];
    
        [self.industryArray addObject:idcObj];
        NSLog(@"IND =  %@", idcObj.industryName);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contributorsTableView reloadData];
    });
}

// Get Fundraising Data
-(void)getFundraisingData:(NSData*)data {
    NSError *error = nil;
    NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSObject *responseObj = [receivedData objectForKey:@"response"];
    NSObject *summaryObj = [responseObj valueForKey:@"summary"];
    NSArray *attributesArray = [NSArray arrayWithObject:summaryObj];
    // Set Fundraising Objects
    FundraisingDataClass *fdcObj = [[FundraisingDataClass alloc] init];
    fdcObj.raised = [[[attributesArray objectAtIndex:0]objectForKey:@"@attributes"] valueForKey:@"total"];
    fdcObj.spent = [[[attributesArray objectAtIndex:0]objectForKey:@"@attributes"] valueForKey:@"spent"];
    fdcObj.cashOnHand =[[[attributesArray objectAtIndex:0]objectForKey:@"@attributes"] valueForKey:@"cash_on_hand"];
    fdcObj.debts =[[[attributesArray objectAtIndex:0]objectForKey:@"@attributes"] valueForKey:@"debt"];
    fdcObj.lastReported =[[[attributesArray objectAtIndex:0]objectForKey:@"@attributes"] valueForKey:@"last_updated"];
    // Set Strings
    self.totalRaised = fdcObj.raised;
    self.totalSpent = fdcObj.spent;
    self.cashOnHand = fdcObj.cashOnHand;
    self.totalDebts = fdcObj.debts;
    self.lastReported = fdcObj.lastReported;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contributorsTableView reloadData];
    });
}

// Table Header View Customization

// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return _sectionArray.count;
    return 3;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Change Header Color
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*) view;
    headerView.contentView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.95];
    //view.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:1];
    
    headerView.textLabel.textColor = [UIColor whiteColor];
}

// Table Section Header Titles
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sectionArray objectAtIndex:section];
}

// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger rowsToReturn;
   
    if (section == 0) {
        rowsToReturn = 1;
        //return 1;
    }
    else if (section == 1) {
        rowsToReturn = [self.industryArray count];
        //return [self.industryArray count];
    }
    else if (section == 2) {
        rowsToReturn = [self.contributorArray count];
        //return [self.contributorArray count];
    }
    
    return rowsToReturn;
}


//moneyProgress, nameLabel, totalLabel;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contributorCell"]; // forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    CustomIndustryCell *industryCell = [tableView dequeueReusableCellWithIdentifier:@"industryCell"]; // forIndexPath:(NSIndexPath *) indexPath];
    CustomFundraisingCell *fundraisingCell = [tableView dequeueReusableCellWithIdentifier:@"fundraisingCell"];
    
    UITableViewCell *cellToReturn;
    
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    
    if (indexPath.section == 0) {
        fundraisingCell.raisedLabel.text = [NSString stringWithFormat:@"$%@", self.totalRaised];
        fundraisingCell.spentLabel.text = [NSString stringWithFormat:@"$%@", self.totalSpent];
        fundraisingCell.cashLabel.text = [NSString stringWithFormat:@"$%@", self.cashOnHand];
        fundraisingCell.debtsLabel.text = [NSString stringWithFormat:@"$%@", self.totalDebts];
        fundraisingCell.lastReportedLabel.text = self.lastReported;
        
        // set progress bars
        float maxValue = [self.totalRaised floatValue];
        fundraisingCell.raisedBar.progress = [self setProgressBars:[self.totalRaised floatValue] maxValue:maxValue];
        fundraisingCell.spentBar.progress = [self setProgressBars:[self.totalSpent floatValue] maxValue:maxValue];
        fundraisingCell.cashBar.progress = [self setProgressBars:[self.cashOnHand floatValue] maxValue:maxValue];
        fundraisingCell.debtsBar.progress = [self setProgressBars:[self.totalDebts floatValue] maxValue:maxValue];
        
        cellToReturn = fundraisingCell;
    }
    else if (indexPath.section == 1) {
        
        NSString *industryName = [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"industryName"];
//        NSString *totalSubString =[NSString stringWithFormat:@"Individuals: $%@, Pacs: $%@, Total: $%@ ", [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"individualTotals"], [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"pacsTotal"], [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"total"]];
        
        industryCell.nameLabel.text = industryName;
        
        NSString *totalString = [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"total"];
        
        // find industry total out of all the industries total
        float indTotal = [totalString floatValue];
        float total = 0;
        for (IndustryDataClass * idcObj in self.industryArray) {
            total += [idcObj.total intValue];
        }
        float max = total / 100;
        float indValue = indTotal / 100;
        float value = indValue / max;
        industryCell.moneyProgress.progress = value / 1.0;
        
        int totalInt = (int)roundf(total);
        
        NSString * totalSubString = [NSString stringWithFormat:@"$%@ of $%d", totalString, totalInt];
        industryCell.totalLabel.text = totalSubString; //[NSString stringWithFormat:@"$%@",totalSubString];
        
        cellToReturn = industryCell;
        
        
    }
    else if (indexPath.section == 2) {
        NSString *totalString = [NSString stringWithFormat:@"Total: $%@", [[self.contributorArray objectAtIndex:indexPath.row] valueForKey:@"contributionTotal"]];
        // Set Cell Text
        cell.textLabel.text = [[self.contributorArray objectAtIndex:indexPath.row] valueForKey:@"contributorName"];
        // Set Cell Detail Text
        cell.detailTextLabel.text = totalString;
        cellToReturn = cell;
    }
    
    [cellToReturn layoutIfNeeded];
    
    return cellToReturn;
}

-(float)setProgressBars:(float)total maxValue:(float)max {
    float progressValue;
    float maxValue = max * 1.5;
    if (total != 0) {
        progressValue = total / maxValue;
    } else{
        progressValue = 0;
    }
    
    //NSLog(@"Progress Value = %f", progressValue);
    return progressValue;
}

/*self.totalRaised = fdcObj.raised;
 self.totalSpent = fdcObj.spent;
 self.cashOnHand = fdcObj.cashOnHand;
 self.totalDebts = fdcObj.debts;
 self.lastReported = fdcObj.lastReported;*/

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
