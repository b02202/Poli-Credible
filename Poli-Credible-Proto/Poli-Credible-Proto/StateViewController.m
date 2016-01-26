//
//  StateViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "StateViewController.h"
#import "MemberDataClass.h"
#import "HTTPManager.h"
#import "ResultsViewController.h"

@interface StateViewController () <HTTPManagerDelegate>
@property (nonatomic, strong) NSArray *stateArray;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) HTTPManager *httpManager;

@end

@implementation StateViewController

-(HTTPManager*)httpManager {
    if (!_httpManager) {
        _httpManager = [[HTTPManager alloc] init];
    }
    return _httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Test HttpManager
    //[self httpGetRequest];
    
    // self delegate
    // Make self delegate and datasource of table view
    self.stateTableView.delegate = self;
    self.stateTableView.dataSource = self;
    
    self.stateArray = [NSArray arrayWithObjects: @"Alabama",
                       @"Alaska",
                       @"Arizona",
                       @"Arkansas",
                       @"California",
                       @"Colorado",
                       @"Connecticut",
                       @"Delaware",
                       @"Florida",
                       @"Georgia",
                       @"Hawaii",
                       @"Idaho",
                       @"Illinois",
                       @"Indiana",
                       @"Iowa",
                       @"Kansas",
                       @"Kentucky",
                       @"Louisiana",
                       @"Maine",
                       @"Maryland",
                       @"Massachusetts",
                       @"Michigan",
                       @"Minnesota",
                       @"Mississippi",
                       @"Missouri",
                       @"Montana",
                       @"Nebraska",
                       @"Nevada",
                       @"New Hampshire",
                       @"New Jersey",
                       @"New Mexico",
                       @"New York",
                       @"North Carolina",
                       @"North Dakota",
                       @"Ohio",
                       @"Oklahoma",
                       @"Oregon",
                       @"Pennsylvania",
                       @"Rhode Island",
                       @"South Carolina",
                       @"South Dakota",
                       @"Tennessee",
                       @"Texas",
                       @"Utah",
                       @"Vermont",
                       @"Virginia",
                       @"Washington",
                       @"West Virginia",
                       @"Wisconsin",
                       @"Wyoming",
                       nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return self.stateArray.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stateCell" forIndexPath:(NSIndexPath *)indexPath];
     //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
     
     cell.textLabel.text = self.stateArray[indexPath.row];
     
     return cell;
 }

// Http Get Request
-(void)httpGetRequest:(NSString*)stateString {
    NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?state_name=", stateString, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff" ];
    NSLog(@"URLSTRING = %@", urlString);
    // Escape special characters
    //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    // Convert to URL
    NSURL *url = [NSURL URLWithString:urlString];
    self.httpManager.delegate = self;
    [self.httpManager httpRequest:url];
    
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod:GET];
    //NSURL *urlRequest = [NSURLRequest requestWithURL:url];
   // [self.httpManager httpRequest:request];
}

-(void)getReceivedData:(NSData*)data sender:(HTTPManager*)sender {
    NSError *error = nil;
    NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *resultsArray = [NSArray arrayWithArray:[receivedData objectForKey:@"results"]];
    _memberArray = [[NSMutableArray alloc] init];
    
    //WordVectorObject *wVObject = [[WordVectorObject alloc] init];
    
    for (int i=0; i < resultsArray.count; i++) {
        MemberDataClass *memberObj = [[MemberDataClass alloc] init];
        memberObj.repFirstName = [[resultsArray objectAtIndex:i]objectForKey:@"first_name"];
        memberObj.repLastName = [[resultsArray objectAtIndex:i]objectForKey:@"last_name"];
        memberObj.party = [[resultsArray objectAtIndex:i]objectForKey:@"party"];
        memberObj.chamber = [[resultsArray objectAtIndex:i]objectForKey:@"chamber"];
        memberObj.bioGuideID = [[resultsArray objectAtIndex:i]objectForKey:@"bioguide_id"];
        memberObj.repPhone = [[resultsArray objectAtIndex:i]objectForKey:@"phone"];
        memberObj.repWebsite = [[resultsArray objectAtIndex:i]objectForKey:@"website"];
        //memberObj.billTitle = [[resultsArray objectAtIndex:i]objectForKey:@"last_name"];
        //memberObj.billNumber = [[resultsArray objectAtIndex:i]objectForKey:@"last_name"];
        //memberObj.memberPosition = [[resultsArray objectAtIndex:i]objectForKey:@"last_name"];
        memberObj.repAddress = [[resultsArray objectAtIndex:i]objectForKey:@"office"];
        NSLog(@"%@ %@", memberObj.repFirstName, memberObj.repLastName);
        [_memberArray addObject:memberObj];
        
    }
    
    //ResultsViewController *resultsVC = [[ResultsViewController alloc] init];
    //[resultsVC setMemberArray:_memberArray];
}

// Storyboard prepareForSeque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toResults"]) {
        //NSIndexPath *indexPath = [self.stateTableView indexPathForSelectedRow];
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSString * stateQuery = selectedCell.textLabel.text;
        NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?state_name=", stateQuery, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff"];
        
        // Pass state string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = urlString;
        
        // run httpGetRequest
        //[self httpGetRequest:stateQuery];
       
       //[resultsVC setMemberArray:_memberArray];
    }
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)close:(UIStoryboardSegue*)segue
{
    
}

@end
