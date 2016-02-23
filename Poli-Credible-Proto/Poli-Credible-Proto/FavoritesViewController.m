//
//  FavoritesViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "SWRevealViewController.h"

@interface FavoritesViewController ()
@property (nonatomic, strong) NSMutableArray *favoritesArray;

@end

@implementation FavoritesViewController
// Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.favoritesTableView.delegate = self;
    self.favoritesTableView.dataSource = self;
    
    self.favoritesTableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.favoritesArray = [[NSMutableArray alloc] init];
    
    // load data
    [self fetchData];
    
   // self.favoritesArray = [NSArray arrayWithObjects:@"Richard Burr (R)",@"David Price (D)", @"Norm Dicks (D)", @"Patty Murray (D)", nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchData];
}

// Get Legislators from Core Data
-(void)fetchData {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Legislator"];
    // Add to Array
    self.favoritesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.favoritesTableView reloadData];
    });
    
}


// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
    return self.favoritesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    
    // Change selected cells background color
    if (![cell viewWithTag:1]) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.tag = 1;
        selectedView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:152.0/255.0 blue:198.0/255.0 alpha:0.75];
        cell.selectedBackgroundView = selectedView;
    }
    
    NSString *district = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"district"];
    NSString *subText;
    
    NSString *labelText = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"fullName"];
    subText = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"stateName"];
    NSString *repParty = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"party"];
    
    if (![district isEqual:[NSNull null]] || ![district isEqualToString:@"0"]) {
        subText = [NSString stringWithFormat:@"%@, District %@", [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"stateName"], [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"district"]];
    }
    else {
        subText = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"stateName"];
    }
    
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = subText;
    
    // Change Text Color
    if ([repParty isEqualToString:@"R"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else if ([repParty isEqualToString:@"D"]) {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    else if ([repParty isEqualToString:@"I"]) {
        cell.textLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:64.0/255.0 alpha:0.75];
    }
    
    return cell;
}

// Deselect cell after selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Table Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [self deleteRecord:indexPath];
    }
}

// Delete Legislator from Core Data
-(void)deleteRecord:(NSIndexPath *)iPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:[self.favoritesArray objectAtIndex:iPath.row]];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    else {
        // Remove device from table view
        [self.favoritesArray removeObjectAtIndex:iPath.row];
        [self.favoritesTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:iPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Legislator has been removed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [successAlert show];
        
        // Show Alert
        [self showAlert:@"Success" message:@"Legislator has been removed."];
    }
    
    
    
}

//Segue - "favoritesToDetail"
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
    NSString *stateName;
    NSString *twitterID;
    NSString *facebookID;
    NSString *website;
    NSString *birthday;
    NSString *contactURL;
    NSString *district;
    
    
    
    if ([segue.identifier isEqualToString:@"favoritesToDetail"]) {
        NSIndexPath *indexPath = [self.favoritesTableView indexPathForSelectedRow];
        
        district = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"district"];
        
        bioGuideID = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"bioGuideID"];
        memFullName = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"fullName"];
        memParty = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"party"];
        repPhone = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"phone"];
        repCRPID = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"crpID"];
        stateName = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"stateName"];
        twitterID = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"twitterID"];
        facebookID = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"facebookID"];
        website = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"website"];
        birthday = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"birthday"];
        contactURL = [[self.favoritesArray objectAtIndex:indexPath.row] valueForKey:@"contactURL"];
        
        
        // Create Image Url
        NSString *imageUrl = [NSString stringWithFormat:@"https://theunitedstates.io/images/congress/225x275/%@.jpg", bioGuideID];
        NSURL *imgUrl = [NSURL URLWithString:imageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:imageData];
        
        // Pass data to detail view
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.memImage = image;
        // ** MIGHT WANT TO CHECK FOR NULL HERE **
        detailVC.memberNameString = memFullName;
        detailVC.partyString = memParty;
        detailVC.phoneString = repPhone;
        detailVC.memBioID = bioGuideID;
        detailVC.memCRPID = repCRPID;
        detailVC.memState = stateName;
        
        if (district != nil || ![district isEqual:[NSNull null]]) {
            detailVC.memDistrict = district;
        }
        
        
        detailVC.twitterID = twitterID;
        detailVC.facebookID =facebookID;
        detailVC.websiteURL = website;
        detailVC.dateOfBirth = birthday;
        detailVC.contactForm = contactURL;
        
    }
    
}

// Alert Controller
-(void)showAlert:(NSString*)title message:(NSString*)messageString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)editAction:(id)sender {
    
    [self tableEditing];
}

-(void)tableEditing {
    if ([self.editBtn.title isEqualToString:@"Cancel"]) {
        self.favoritesTableView.editing = NO;
        self.editBtn.title = @"Edit";
    }
    else {
        self.favoritesTableView.editing = YES;
        self.editBtn.title = @"Cancel";
    }
}
@end
