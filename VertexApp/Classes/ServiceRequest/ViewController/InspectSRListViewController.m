//
//  InspectSRListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "InspectSRListViewController.h"
#import "InspectSRPageViewController.h"

@interface InspectSRListViewController ()

@end

@implementation InspectSRListViewController

@synthesize srForInspectionAsset;
@synthesize srForInspectionService;
@synthesize srForInspectionSRIds;

@synthesize srForInspectionEntries;
@synthesize srForInspectionDate;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize srForInspectionDictionary;

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
  //Connect to endpoint - getServiceRequestByStatus - For Inspection status
  [self getServiceRequestByStatus];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Retrieve Service Request with 'For Inspection' Status ID - for Inspection
-(void) getServiceRequestByStatus
{
  //endpoint for getServiceRequestByStatus
  statusId = @20130101420000003; //Service Request 'Acknowledged' Status Id - this will be updated to 'Inspected'
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service-request/getServiceRequestByStatus/%@", statusId]; //107
  
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
    srForInspectionAsset = [[NSMutableArray alloc] initWithObjects:@"Demo - Aircon", @"Demo - Door", @"Demo - Window", nil];
    srForInspectionService = [[NSMutableArray alloc] initWithObjects:@"- Fix filter", @"- Repair hinge", @"- Repair handle", nil];
    srForInspectionSRIds = [[NSMutableArray alloc] initWithObjects: @"Demo - 00001", @"Demo - 00002", @"Demo - 00003", nil];
    srForInspectionDate = [[NSMutableArray alloc] initWithObjects:@"2013-05-05", @"2013-05-06", @"2013-05-07", nil];
  }
  else
  {
    srForInspectionDictionary = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                      options:kNilOptions
                                      error:&error];
    NSLog(@"srForInspectionDictionary JSON Result: %@", srForInspectionDictionary);
    
    srForInspectionAsset = [[srForInspectionDictionary valueForKey:@"asset"] valueForKey:@"name"];
    srForInspectionService = [[srForInspectionDictionary valueForKey:@"service"] valueForKey:@"name"];
    srForInspectionSRIds = [srForInspectionDictionary valueForKey:@"id"];
    srForInspectionDate = [srForInspectionDictionary valueForKey:@"createdDate"];
  }
  
  //Concatenate asset name and service name of service request for display in table view
  srForInspectionEntries = [[NSMutableArray alloc] init];
  for(int i = 0; i < srForInspectionAsset.count; i++)
  {
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@ - %@", [srForInspectionAsset objectAtIndex:i], [srForInspectionService objectAtIndex:i]];
    
    [srForInspectionEntries insertObject:displayString atIndex:i];
    displayString = [[NSMutableString alloc] init];
  }
  
  NSLog(@"srForInspectionEntries: %@", srForInspectionEntries);
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"For Inspection List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [srForInspectionEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"inspectSRCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text = [srForInspectionEntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [srForInspectionDate objectAtIndex:indexPath.row];
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
  selectedSRId = [srForInspectionSRIds objectAtIndex:indexPath.row];
  NSLog(@"selectedSRId: %@", selectedSRId);
  
  [self performSegueWithIdentifier:@"srInspectionListToInspectionPage" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"srInspectionListToInspectionPage"])
  {
    [segue.destinationViewController setServiceRequestId:selectedSRId];
  }
}



@end
