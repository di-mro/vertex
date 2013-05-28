//
//  SRFeedbackListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SRFeedbackListViewController.h"
#import "SRFeedbackPageViewController.h"


@interface SRFeedbackListViewController ()

@end

@implementation SRFeedbackListViewController

@synthesize srForFeedbackAsset;
@synthesize srForFeedbackService;
@synthesize srForFeedbackSRIds;

@synthesize srForFeedbackEntries;
@synthesize srForFeedbackDate;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize srForFeedbackDictionary;

@synthesize selectedSRId;
@synthesize statusId;

//@synthesize displaySRFeedbackListEntries;
//@synthesize displaySRFeedbackSubtitles;

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
  //Connect to endpoint - getServiceRequestByStatus - Fulfilled status
  [self getServiceRequestByStatus];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Retrieve Service Request with 'Service Request Creation' Status ID - for Acknowledgement
-(void) getServiceRequestByStatus
{
  //endpoint for getServiceRequestByStatus
  statusId = @20130101420000003; //9 //Service Request Fulfilled Status Id - Awaiting Feedbacks
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
    srForFeedbackAsset = [[NSMutableArray alloc] initWithObjects:
                            @"Demo - Aircon"
                          , @"Demo - Door"
                          , @"Demo - Window"
                          , nil];
    
    srForFeedbackService = [[NSMutableArray alloc] initWithObjects:
                              @"- Fix filter"
                            , @"- Repair hinge"
                            , @"- Repair handle"
                            , nil];
    
    srForFeedbackSRIds = [[NSMutableArray alloc] initWithObjects:
                            @"Demo - 00001"
                          , @"Demo - 00002"
                          , @"Demo - 00003"
                          , nil];
    
    srForFeedbackDate = [[NSMutableArray alloc] initWithObjects:
                           @"2013-05-05"
                         , @"2013-05-06"
                         , @"2013-05-07"
                         , nil];
  }
  else
  {
    srForFeedbackDictionary = [NSJSONSerialization
                               JSONObjectWithData:responseData
                                          options:kNilOptions
                                            error:&error];
    
    NSLog(@"srForFeedbackDictionary JSON Result: %@", srForFeedbackDictionary);
    
    srForFeedbackAsset   = [[srForFeedbackDictionary valueForKey:@"asset"] valueForKey:@"name"];
    srForFeedbackService = [[srForFeedbackDictionary valueForKey:@"service"] valueForKey:@"name"];
    srForFeedbackSRIds   = [srForFeedbackDictionary valueForKey:@"id"];
    srForFeedbackDate    = [srForFeedbackDictionary valueForKey:@"createdDate"];
  }
  
  //Concatenate asset name and service name of service request for display in table view
  srForFeedbackEntries = [[NSMutableArray alloc] init];
  for(int i = 0; i < srForFeedbackAsset.count; i++)
  {
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@ - %@"
                                      , [srForFeedbackAsset objectAtIndex:i]
                                      , [srForFeedbackService objectAtIndex:i]];
    
    [srForFeedbackEntries insertObject:displayString atIndex:i];
    displayString = [[NSMutableString alloc] init];
  }
  
  NSLog(@"srForFeedbackEntries: %@", srForFeedbackEntries);
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Service Request Feedback List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [srForFeedbackEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"srFeedbackListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text          = [srForFeedbackEntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text    = [srForFeedbackDate objectAtIndex:indexPath.row];
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
  selectedSRId = [srForFeedbackSRIds objectAtIndex:indexPath.row];
  NSLog(@"selectedSRId: %@", selectedSRId);
  
  [self performSegueWithIdentifier:@"srFeedbackListToQuestionsPage" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"srFeedbackListToQuestionsPage"])
  {
    [segue.destinationViewController setServiceRequestId:selectedSRId];
  }
}



@end
