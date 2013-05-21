//
//  ApprovalSRListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/20/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ApprovalSRListViewController.h"

@interface ApprovalSRListViewController ()

@end

@implementation ApprovalSRListViewController

@synthesize srForApprovalAsset;
@synthesize srForApprovalService;
@synthesize srForApprovalSRIds;

@synthesize srForApprovalEntries;
@synthesize srForApprovalDate;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize srForApprovalDictionary;

@synthesize selectedSRId;
@synthesize statusId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  //Connect to endpoint - getServiceRequestByStatus - Proposal status
  [self getServiceRequestByStatus];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Retrieve Service Request with 'Service Request Proposal' Status ID - for Approval
-(void) getServiceRequestByStatus
{
  //endpoint for getServiceRequestByStatus
  //Service Request Proposal Status Id
  statusId = @20130101420000005;
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.107/vertex-api/service-request/getServiceRequestByStatus/%@", statusId]; //113
  
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
    srForApprovalAsset = [[NSMutableArray alloc] initWithObjects:
                                 @"Demo - Aircon"
                                 , @"Demo - Door"
                                 , @"Demo - Window"
                                 , nil];
    
    srForApprovalService = [[NSMutableArray alloc] initWithObjects:
                                   @"- Fix filter"
                                   , @"- Repair hinge"
                                   , @"- Repair handle"
                                   , nil];
    
    srForApprovalSRIds = [[NSMutableArray alloc] initWithObjects:
                                 @"Demo - 00001"
                                 , @"Demo - 00002"
                                 , @"Demo - 00003"
                                 , nil];
    
    srForApprovalDate = [[NSMutableArray alloc] initWithObjects:
                                @"2013-05-05"
                                , @"2013-05-06"
                                , @"2013-05-07"
                                , nil];
  }
  else
  {
    srForApprovalDictionary = [NSJSONSerialization
                                JSONObjectWithData:responseData
                                           options:kNilOptions
                                             error:&error];
    
    NSLog(@"srForApprovalDictionary JSON Result: %@", srForApprovalDictionary);
    
    srForApprovalAsset   = [[srForApprovalDictionary valueForKey:@"asset"] valueForKey:@"name"];
    srForApprovalService = [[srForApprovalDictionary valueForKey:@"service"] valueForKey:@"name"];
    srForApprovalSRIds   = [srForApprovalDictionary valueForKey:@"id"];
    srForApprovalDate    = [srForApprovalDictionary valueForKey:@"createdDate"];
  }
  
  //Concatenate asset name and service name of service request for display in table view
  srForApprovalEntries = [[NSMutableArray alloc] init];
  for(int i = 0; i < srForApprovalAsset.count; i++)
  {
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@ - %@"
                                      , [srForApprovalAsset objectAtIndex:i]
                                      , [srForApprovalService objectAtIndex:i]];
    
    [srForApprovalEntries insertObject:displayString atIndex:i];
    displayString = [[NSMutableString alloc] init];
  }
  
  NSLog(@"srForApprovalEntries: %@", srForApprovalEntries);
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"For Approval List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [srForApprovalEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"srApprovalCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text          = [srForApprovalEntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text    = [srForApprovalDate objectAtIndex:indexPath.row];
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
  selectedSRId = [srForApprovalSRIds objectAtIndex:indexPath.row];
  NSLog(@"selectedSRId: %@", selectedSRId);
  
  //[self performSegueWithIdentifier:@"srAcknowledgeListToAcknowledgePage" sender:self];
}

/*
#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"srAcknowledgeListToAcknowledgePage"])
  {
    [segue.destinationViewController setServiceRequestId:selectedSRId];
  }
}
*/

@end
