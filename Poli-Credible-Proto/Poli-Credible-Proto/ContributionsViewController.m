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

@interface ContributionsViewController () <HTTPManagerDelegate>
@property (nonatomic, strong) NSMutableArray *contributorArray;
@property (nonatomic, strong) NSMutableArray *industryArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *totalArray;
@property (nonatomic, strong) HTTPManager *httpManager;
@property (nonatomic, strong) NSString *apiString;



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
    self.sectionArray = [NSArray arrayWithObjects:@"Top Industries", @"Top Contributors", nil ];
    
    self.contributorsTableView.delegate = self;
    self.contributorsTableView.dataSource =self;
    
    self.contributorsTableView.estimatedRowHeight = 60.0f;
    self.contributorsTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    NSString *industryUrl = [NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=candIndustry&cid=%@&cycle=2016&apikey=bf5679d09f71e7c88c881d99d9d82bc7&output=json", self.recievedCRPID];
    NSString *contributorUrl = [NSString stringWithFormat:@"http://www.opensecrets.org/api/?method=candContrib&cid=%@&cycle=2016&apikey=bf5679d09f71e7c88c881d99d9d82bc7&output=json", self.recievedCRPID];

    
    [self httpAsyncRequest:industryUrl];
    
    [self runQuery:contributorUrl];
}

// Set URL for Open Secrets API Query and run
-(void)runQuery:(NSString*)url {
   
    [self httpGetRequest:url];
}

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

// Get Recieved Data
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
-(int)setProgressValue:(NSString*)industryTotal {
    int indTotal = [industryTotal intValue];
    int total = 0;
    for (IndustryDataClass * idcObj in self.industryArray) {
        total += [idcObj.total intValue];
    }
    int percentage = indTotal / total * 10;
    
    NSLog(@"TOTAL = %d", percentage);
    
    
    
    return percentage;
}



// Table Header View Customization

// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return _sectionArray.count;
    return 2;
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
    
    if (section == 0) {
        return [self.industryArray count];
    }
    else {
        return [self.contributorArray count];
    }
}


//moneyProgress, nameLabel, totalLabel;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contributorCell"]; // forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    CustomIndustryCell *industryCell = [tableView dequeueReusableCellWithIdentifier:@"industryCell"]; // forIndexPath:(NSIndexPath *) indexPath];
    
    UITableViewCell *cellToReturn;
    
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    
    if (indexPath.section == 0) {
        
        NSString *industryName = [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"industryName"];
        NSString *totalSubString =[NSString stringWithFormat:@"Individuals: $%@, Pacs: $%@, Total: $%@ ", [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"individualTotals"], [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"pacsTotal"], [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"total"]];
        
        industryCell.nameLabel.text = industryName;
        industryCell.totalLabel.text = totalSubString; //[NSString stringWithFormat:@"$%@",totalSubString];
        NSString *totalString = [[self.industryArray objectAtIndex:indexPath.row] valueForKey:@"total"];
        float indTotal = [totalString floatValue];
        
        
        
        float total = 0;
        for (IndustryDataClass * idcObj in self.industryArray) {
            total += [idcObj.total intValue];
        }
        float max = total / 100;
        float indValue = indTotal / 100;
        
        float value = indValue / max;
        
        
        float precentage = (100 * indTotal)/total;
        
        NSLog(@"Progress = %f", precentage);
        
       industryCell.moneyProgress.progress = value / 1.0;
        
        cellToReturn = industryCell;
        
        
    } else if (indexPath.section == 1) {
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

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
