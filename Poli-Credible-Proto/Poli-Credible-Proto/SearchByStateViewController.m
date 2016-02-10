//
//  SearchByStateViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "SearchByStateViewController.h"
#import "SWRevealViewController.h"
#import "MemberDataClass.h"
#import "StateDataClass.h"
#import "CustomStateCell.h"
#import "ResultsViewController.h"

@interface SearchByStateViewController ()

@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSMutableArray *stateDataArray;

@end

@implementation SearchByStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    // Make self delegate and datasource of table view
    self.stateTableView.delegate = self;
    self.stateTableView.dataSource = self;
    
    [self setArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set Arrays
-(void)setArray {
    self.stateArray = [NSMutableArray arrayWithObjects: @"Alabama",
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
                       @"Wyoming", nil];
    
    self.stateDataArray = [[NSMutableArray alloc] init];
    
    
    
    for (int i = 0; i < [self.stateArray count]; i++) {
        StateDataClass *stateDataOBJ = [[StateDataClass alloc]init];
        NSString *stateString = [self.stateArray objectAtIndex:i];
        NSString *correctedString = [stateString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString *imgString = [[NSString stringWithFormat:@"state-%@.png", correctedString] lowercaseString];
        stateDataOBJ.stateName = stateString;
        stateDataOBJ.imageString = imgString;
        
        [self.stateDataArray addObject:stateDataOBJ];
        NSLog(@"stateName = %@", [[self.stateDataArray objectAtIndex:i]valueForKey:@"stateName"]);
    }
}

// Table View Components
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return self.stateDataArray.count;
}
// TableView Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stateCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    CustomStateCell *cell = (CustomStateCell *)[tableView dequeueReusableCellWithIdentifier:@"stateCell" forIndexPath:(NSIndexPath *)indexPath];
    
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    
    //cell.textLabel.text = self.stateArray[indexPath.row];
    
    cell.stateLabel.text = [[self.stateDataArray objectAtIndex:indexPath.row] valueForKey:@"stateName"];
    cell.stateImage.image = [UIImage imageNamed:[[self.stateDataArray objectAtIndex:indexPath.row] valueForKey:@"imageString"]];
    
    [cell layoutIfNeeded];
    
    return cell;
}

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Storyboard prepareForSeque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toResults"]) {
        NSIndexPath *indexPath = [self.stateTableView indexPathForSelectedRow];
        NSString * stateString = [[self.stateDataArray objectAtIndex:indexPath.row] valueForKey:@"stateName"];
        
        
        NSString *urlString =[NSString stringWithFormat:@"%@%@%@", @"https://congress.api.sunlightfoundation.com/legislators?state_name=", stateString, @"&per_page=all&apikey=6f9f2e31124941a98e97110aeeaec3ff"];
        
        // Pass state string to results VC
        ResultsViewController *resultsVC = segue.destinationViewController;
        resultsVC.searchStr = urlString;
        resultsVC.titleString = stateString;
    }
}

@end
