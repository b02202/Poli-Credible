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
#import "DetailViewController.h"

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
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    // Do any additional setup after loading the view.
    NSLog(@"ViewDidLoad is being Called");
    _memberArray = [[NSMutableArray alloc] init];
    // Section Array
    _sectionArray = [NSArray arrayWithObjects:@"U.S. Senate", @"U.S House of Representatives", nil ];
    
    // Run API Get
    [self httpGetRequest:self.searchStr];
    // Set Chamber Arrays
    //[self setChamberArrays];
    
    self.senateTableView.delegate = self;
    self.senateTableView.dataSource = self;
    
   
    
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
-(void)httpGetRequest:(NSString*)searchString {
    self.httpManager.delegate = self;
//    NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?state_name=", stateString, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff" ];
    
    NSLog(@"SEARCH STRING = %@", searchString);
    // Escape special characters
    //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    searchString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:set];
    // Convert to URL
    NSURL *url = [NSURL URLWithString:searchString];
    
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
        memberObj.repTitle = [[resultsArray objectAtIndex:i]objectForKey:@"title"];
        memberObj.repDistrict = [[resultsArray objectAtIndex:i]objectForKey:@"district"];
        memberObj.stateName = [[resultsArray objectAtIndex:i]objectForKey:@"state_name"];
        memberObj.repAddress = [[resultsArray objectAtIndex:i]objectForKey:@"office"];
        memberObj.crpID = [[resultsArray objectAtIndex:i]objectForKey:@"crp_id"];
  
        [_memberArray addObject:memberObj];
        
    }
    
    [self setChamberArrays];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.senateTableView reloadData];
    });
}

// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return _sectionArray.count;
    return 2;
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
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    
    NSString *repParty;
    
    if (indexPath.section == 0) {
        NSString *senateCellText = [NSString stringWithFormat:@"%@ %@ (%@)",[[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repFirstName"],
                                    [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repLastName"],
                                    [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"party"]];
        NSString *senateCellSubText = [NSString stringWithFormat:@"%@",[[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"stateName"]];
        repParty = [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"party"];
        cell.textLabel.text = senateCellText;
        cell.detailTextLabel.text = senateCellSubText;
        
        if ([repParty isEqualToString:@"R"]) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else if ([repParty isEqualToString:@"D"]) {
            cell.textLabel.textColor = [UIColor blueColor];
        }
        else if ([repParty isEqualToString:@"I"]) {
            cell.textLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
        }
        
        
        
    }
    else {
        NSString *houseCellText = [NSString stringWithFormat:@"%@ %@ (%@)",[[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repFirstName"],
                                   [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repLastName"],
                                   [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"party"]];
       
        repParty = [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"party"];
        
        NSString *houseCellSubText = [NSString stringWithFormat:@"%@, District %@",[[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"stateName"], [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repDistrict"]];
        cell.textLabel.text = houseCellText;
        cell.detailTextLabel.text = houseCellSubText;
        
        if ([repParty isEqualToString:@"R"]) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else if ([repParty isEqualToString:@"D"]) {
            cell.textLabel.textColor = [UIColor blueColor];
        }
        else if ([repParty isEqualToString:@"I"]) {
            cell.textLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
        }
        
    }
    return cell;
}
// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(IBAction)back:(UIStoryboardSegue*)segue
{
    
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *bioGuideID;
    NSString *memFullName;
    NSString *memParty;
    NSString *repPhone;
    NSString *repCRPID;
    
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.senateTableView indexPathForSelectedRow];
        
        if (indexPath.section == 0) {
            bioGuideID = [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"bioGuideID"];
            memFullName = [NSString stringWithFormat:@"%@. %@ %@ (%@)", [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repTitle"], [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repFirstName"], [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repLastName"], [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"party"]];
            memParty = [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"party"];
            repPhone = [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"repPhone"];
            repCRPID = [[self.senateArray objectAtIndex:indexPath.row] valueForKey:@"crpID"];
        }
        else {
            bioGuideID = [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"bioGuideID"];
            memFullName = [NSString stringWithFormat:@"%@. %@ %@ (%@)", [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repTitle"], [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repFirstName"], [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repLastName"], [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"party"]];
            memParty = [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"party"];
            repPhone = [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"repPhone"];
            repCRPID = [[self.houseArray objectAtIndex:indexPath.row] valueForKey:@"crpID"];
        }
        
        // Create Image Url
        NSString *imageUrl = [NSString stringWithFormat:@"https://theunitedstates.io/images/congress/225x275/%@.jpg", bioGuideID];
        NSURL *imgUrl = [NSURL URLWithString:imageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:imageData];
        
        // Get member data
        
        
        // Pass data to detail view
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.memImage = image;
        // ** MIGHT WANT TO CHECK FOR NIL HERE **
        detailVC.memberNameString = memFullName;
        detailVC.partyString = memParty;
        detailVC.phoneString = repPhone;
        detailVC.memBioID = bioGuideID;
        detailVC.memCRPID = repCRPID;
        
        
        
        
    }
    
    
}

/*
 dispatch_async(dispatch_get_main_queue(), ^{
 // Update the UI
 self.imageView.image = [UIImage imageWithData:imageData];
 });
 */

@end
