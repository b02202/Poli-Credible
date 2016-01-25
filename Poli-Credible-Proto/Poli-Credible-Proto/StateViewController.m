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

@interface StateViewController ()
@property (nonatomic, strong) NSArray *stateArray;
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
     
     cell.textLabel.text = [self.stateArray[indexPath.row]uppercaseString];
     
     return cell;
 }

// Http Get Request
-(void)httpGetRequest {
    NSString *urlString = @"http://congress.api.sunlightfoundation.com/legislators?state_name=Alabama&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff";
    // Escape special characters
    //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    // Convert to URL
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:GET];
    [self.httpManager httpRequest:request];
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
