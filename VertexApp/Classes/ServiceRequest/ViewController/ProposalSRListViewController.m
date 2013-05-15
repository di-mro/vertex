//
//  ProposalSRListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ProposalSRListViewController.h"
#import "ServiceRequestViewController.h"
#import "HomePageViewController.h"
#import "ProposalSRPageViewController.h"

@interface ProposalSRListViewController ()

@end

@implementation ProposalSRListViewController

@synthesize srForProposalAsset;
@synthesize srForProposalService;
@synthesize srForProposalSRIds;

@synthesize srForProposalEntries;
@synthesize srForProposalDate;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize srForProposalDictionary;

@synthesize selectedSRId;
@synthesize statusId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  //Connect to endpoint - getServiceRequestByStatus - Created status
  [self getServiceRequestByStatus];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segue to SR Page
-(void) backToSRPage
{
  //Go back to Service Request Page
  ServiceRequestViewController* controller = (ServiceRequestViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
  
  [self.navigationController pushViewController:controller animated:YES];
  
}


#pragma mark - Retrieve Service Request with 'Service Request Creation' Status ID - for Acknowledgement
-(void) getServiceRequestByStatus
{
  //endpoint for getServiceRequestByStatus
  statusId = @20130101420000004; //Service Request For Inspection Status Id
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service-request/getServiceRequestByStatus/%@", statusId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                 delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                          returningResponse:&urlResponse
                          error:&error];
  
  if(responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Warning"
                                    message:@"No network connection detected. Displaying data from phone cache."
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    srForProposalAsset = [[NSMutableArray alloc] initWithObjects:@"Demo - Aircon", @"Demo - Door", @"Demo - Window", nil];
    srForProposalService = [[NSMutableArray alloc] initWithObjects:@"- Fix filter", @"- Repair hinge", @"- Repair handle", nil];
    srForProposalSRIds = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00003", nil];
    srForProposalDate = [[NSMutableArray alloc] initWithObjects:@"2013-05-05", @"2013-05-06", @"2013-05-07", nil];
  }
  else
  {
    srForProposalDictionary = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                      options:kNilOptions
                                      error:&error];
    NSLog(@"srForProposalDictionary JSON Result: %@", srForProposalDictionary);
    
    srForProposalAsset = [[srForProposalDictionary valueForKey:@"asset"] valueForKey:@"name"];
    srForProposalService = [[srForProposalDictionary valueForKey:@"service"] valueForKey:@"name"];
    srForProposalSRIds = [srForProposalDictionary valueForKey:@"id"];
    srForProposalDate = [srForProposalDictionary valueForKey:@"createdDate"];
  }
  
  //Concatenate asset name and service name of service request for display in table view
  srForProposalEntries = [[NSMutableArray alloc] init];
  for(int i = 0; i < srForProposalAsset.count; i++)
  {
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@ - %@", [srForProposalAsset objectAtIndex:i], [srForProposalService objectAtIndex:i]];
    
    [srForProposalEntries insertObject:displayString atIndex:i];
    displayString = [[NSMutableString alloc] init];
  }
  
  NSLog(@"srForProposalEntries: %@", srForProposalEntries);
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"For Proposal List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [srForProposalEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"srProposalCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text = [srForProposalEntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [srForProposalDate objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 70;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedSRId = [srForProposalSRIds objectAtIndex:indexPath.row];
  NSLog(@"selectedSRId: %@", selectedSRId);
  
  [self performSegueWithIdentifier:@"srProposalListToProposalPage" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"srProposalListToProposalPage"])
  {
    [segue.destinationViewController setServiceRequestId:selectedSRId];
  }
}




@end
