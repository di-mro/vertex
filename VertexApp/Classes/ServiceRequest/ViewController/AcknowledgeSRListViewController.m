//
//  AcknowledgeSRListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/6/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AcknowledgeSRListViewController.h"
#import "AcknowledgeSRPageViewController.h"
#import "ServiceRequestViewController.h"

@interface AcknowledgeSRListViewController ()

@end

@implementation AcknowledgeSRListViewController

@synthesize srForAcknowledgementAsset;
@synthesize srForAcknowledgementService;
@synthesize srForAcknowledgementSRIds;

@synthesize srForAcknowledgementEntries;
@synthesize srForAcknowledgementDate;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize srForAcknowledgementDictionary;

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
  /*
  //[Back] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToSRPage)];
  */
  /*
   //[Back] button
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
   
   [[UIBarButtonItem alloc]
   initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
   target:self
   action:@selector(searchItem:)];
   */

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
  statusId = @20130101420000001; //Service Request Creation Status Id
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
    srForAcknowledgementAsset = [[NSMutableArray alloc] initWithObjects:
                                   @"Demo - Aircon"
                                 , @"Demo - Door"
                                 , @"Demo - Window"
                                 , nil];
    
    srForAcknowledgementService = [[NSMutableArray alloc] initWithObjects:
                                     @"- Fix filter"
                                   , @"- Repair hinge"
                                   , @"- Repair handle"
                                   , nil];
    
    srForAcknowledgementSRIds = [[NSMutableArray alloc] initWithObjects:
                                   @"Demo - 00001"
                                 , @"Demo - 00002"
                                 , @"Demo - 00003"
                                 , nil];
    
    srForAcknowledgementDate = [[NSMutableArray alloc] initWithObjects:
                                  @"2013-05-05"
                                , @"2013-05-06"
                                , @"2013-05-07"
                                , nil];
  }
  else
  {
    srForAcknowledgementDictionary = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                                 options:kNilOptions
                                                   error:&error];
    NSLog(@"srForAcknowledgementDictionary JSON Result: %@", srForAcknowledgementDictionary);
    
    srForAcknowledgementAsset   = [[srForAcknowledgementDictionary valueForKey:@"asset"] valueForKey:@"name"];
    srForAcknowledgementService = [[srForAcknowledgementDictionary valueForKey:@"service"] valueForKey:@"name"];
    srForAcknowledgementSRIds   = [srForAcknowledgementDictionary valueForKey:@"id"];
    srForAcknowledgementDate    = [srForAcknowledgementDictionary valueForKey:@"createdDate"];
  }

  //Concatenate asset name and service name of service request for display in table view
  srForAcknowledgementEntries = [[NSMutableArray alloc] init];
  for(int i = 0; i < srForAcknowledgementAsset.count; i++)
  {
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@ - %@"
                                      , [srForAcknowledgementAsset objectAtIndex:i]
                                      , [srForAcknowledgementService objectAtIndex:i]];
    
    [srForAcknowledgementEntries insertObject:displayString atIndex:i];
    displayString = [[NSMutableString alloc] init];
  }
  
  NSLog(@"srForAcknowledgementEntries: %@", srForAcknowledgementEntries);
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"For Acknowledgement List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [srForAcknowledgementEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"acknowledgeSRCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text          = [srForAcknowledgementEntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text    = [srForAcknowledgementDate objectAtIndex:indexPath.row];
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
  selectedSRId = [srForAcknowledgementSRIds objectAtIndex:indexPath.row];
  NSLog(@"selectedSRId: %@", selectedSRId);
  
  [self performSegueWithIdentifier:@"srAcknowledgeListToAcknowledgePage" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"srAcknowledgeListToAcknowledgePage"])
  {
    [segue.destinationViewController setServiceRequestId:selectedSRId];
  }
}





@end
