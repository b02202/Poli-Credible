//
//  ResultsViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/25/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "ResultsViewController.h"
#import "MemberDataClass.h"
#import "HTTPManager.h"

@interface ResultsViewController () <HTTPManagerDelegate>

@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) NSMutableArray *senateArray;
@property (nonatomic, strong) NSMutableArray *houseArray;
@property (nonatomic, strong) HTTPManager *httpManager;
@property (nonatomic, strong) NSArray *sectionArray;

@end

@implementation ResultsViewController

-(HTTPManager*)httpManager {
    if (!_httpManager) {
        _httpManager = [[HTTPManager alloc] init];
    }
    return _httpManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"ViewDidLoad is being Called");
    _memberArray = [[NSMutableArray alloc] init];
    // Section Array
    _sectionArray = [NSArray arrayWithObjects:@"U.S. Senate", @"U.S House of Representatives", nil ];
    
    // Run API Get
    [self httpGetRequest:self.searchStr];
    // Set Chamber Arrays
    //[self setChamberArrays];
    
   // self.senateTableView.delegate = self;
   // self.senateTableView.dataSource = self;
    
   
    
//    for (int i = 0; i < _memberArray.count; i++) {
//        NSString *memFirst = [[_memberArray objectAtIndex:i] valueForKey:@"repFirstName"];
//        NSString *chamber = [[_memberArray objectAtIndex:i] valueForKey:@"chamber"];
//        NSLog(@"%@ - %@", memFirst, chamber );
//        if (chamber isEqualToString:@"senate") {
//            
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    //[self httpGetRequest:self.searchStr];
}

// Http Get Request
-(void)httpGetRequest:(NSString*)stateString {
    self.httpManager.delegate = self;
    NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?state_name=", stateString, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff" ];
    NSLog(@"URLSTRING = %@", urlString);
    // Escape special characters
    //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    // Convert to URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.httpManager httpRequest:url];
}

// getReceivedData
-(void)getReceivedData:(NSData*)data sender:(HTTPManager*)sender {
    NSLog(@"getRecievedData called");
    NSError *error = nil;
    NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *resultsArray = [NSArray arrayWithArray:[receivedData objectForKey:@"results"]];
    
    
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
    
    [self setChamberArrays];
    
    self.senateTableView.delegate = self;
    self.senateTableView.dataSource = self;
}

// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return _sectionArray.count;
    return 2;
}

// Table Section Header Titles
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //NSArray *sectionArray = [NSArray arrayWithObjects:@"U.S. Senate", @"U.S House of Representatives", nil ];
    return [_sectionArray objectAtIndex:section];
}

// TableView Number of Rows per Section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberofRows is being called");
    //return self.addressArray.count;
    // return self.stateArray.count;
    //return self.senateArray.count; // self.senateArray.count;
    
    if (section == 0) {
        return [_senateArray count];
    }
    else {
        return [_houseArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:(NSIndexPath *)indexPath];
    NSLog(@"cellForRow is being called");
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    
    if (indexPath.section == 0) {
        NSString *senateCellText = [NSString stringWithFormat:@"%@ %@ (%@)",[[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repFirstName"],
                                    [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repLastName"],
                                    [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"party"]];
        cell.textLabel.text = senateCellText;
    }
    else {
        NSString *houseCellText = [NSString stringWithFormat:@"%@ %@ (%@)",[[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repFirstName"],
                                   [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repLastName"],
                                   [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"party"]];
        cell.textLabel.text = houseCellText;
    }
    return cell;
}

// set Chamber Arrays
-(void)setChamberArrays{
    NSLog(@"setChamberArrays called");
   // _memberArray = [[NSMutableArray alloc] initWithArray:array];
    _senateArray = [[NSMutableArray alloc] init];
    _houseArray = [[NSMutableArray alloc] init];
   
    
    for (MemberDataClass *memberObj in _memberArray) {
        NSString *chamber = [memberObj valueForKey:@"chamber"];
        
        if ([chamber isEqualToString:@"senate"]) {
            [_senateArray addObject:memberObj];
        }
        else if([chamber isEqualToString:@"house"]) {
            [_houseArray addObject:memberObj];
        }
    }
    
    for (MemberDataClass *memberObj in _senateArray) {
        NSLog(@"%@ %@ - %@", [memberObj valueForKey:@"repFirstName"],[memberObj valueForKey:@"repLastName"],[memberObj valueForKey:@"chamber"]);
    }
    
    for (MemberDataClass *memberObj in _houseArray) {
        NSLog(@"%@ %@ - %@", [memberObj valueForKey:@"repFirstName"],[memberObj valueForKey:@"repLastName"],[memberObj valueForKey:@"chamber"]);
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

@end
