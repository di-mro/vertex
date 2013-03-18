//
//  ViewAssetsPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/13/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewAssetsPageViewController.h"
#import "ManagedAssets.h"
#import "Reachability.h"

@interface ViewAssetsPageViewController ()

@end

@implementation ViewAssetsPageViewController

@synthesize viewAssetsPageEntries;
@synthesize URL;
@synthesize managedAssets;
@synthesize assetsTableView;

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
  URL = @"http://192.168.2.13:8080/vertex-api/asset/getManagedAssets";
  [self displayViewAssetsPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Asset Page
- (void) displayViewAssetsPageEntries
{
  viewAssetsPageEntries = [[NSMutableArray alloc] init];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:URL]];
  
  // Set the request's content type to application/x-www-form-urlencoded
  [getRequest setValue:@"application/json"
     forHTTPHeaderField:@"Content-Type"];
  // Designate the request a POST request and specify its body data
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
    
  // Initialize the NSURLConnection and proceed as usual
  NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:getRequest
                                   delegate:self];
  //start the connection
  [connection start];
    
  // Get Response. Validation before proceeding to next page. Retrieve confirmation from the ws that user is valid.
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
    
  NSData *responseData = [NSURLConnection
                            sendSynchronousRequest:getRequest
                            returningResponse:&urlResponse
                            error:&error];

  if (responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                      initWithTitle:@"Warning"
                                      message:@"No network connection detected. Displaying data from phone cache."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [connectionAlert show];
      
    /* !- For demo only, remove hard coded values. Must retrieve listing in CoreData DB -! */
      NSString *entry1 = @"Demo - Aircon";
      NSString *entry2 = @"Demo - Bath Tub";
      NSString *entry3 = @"Demo - Kitchen Sink";
      NSString *entry4 = @"Demo - Window";
       
      [viewAssetsPageEntries addObject:entry1];
      [viewAssetsPageEntries addObject:entry2];
      [viewAssetsPageEntries addObject:entry3];
      [viewAssetsPageEntries addObject:entry4];
  }
  else
  {
    //json
    managedAssets = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions
                                   error:&error];
    NSLog(@"getManagedAssets JSON Result: %@", managedAssets);
      
    viewAssetsPageEntries = [managedAssets valueForKey:@"name"];
    NSLog(@"managedAssets: %@", managedAssets);
  }
}
  
#pragma mark - Check for network availability
-(BOOL)reachable
{
  Reachability *r = [Reachability  reachabilityWithHostName:URL];
  NetworkStatus internetStatus = [r currentReachabilityStatus];
    
  if(internetStatus == NotReachable)
  {
    return NO;
  }
  
  return YES;
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Assets List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [viewAssetsPageEntries count];
  NSLog(@"%d", [viewAssetsPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"View Assets Page View");
  static NSString *CellIdentifier = @"viewAssetsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.viewAssetsPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"viewAssetsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  for(int i = 0; i < managedAssets.count; i++)
  {
    if([managedAssets objectForKey:cell.textLabel.text])
      NSLog(@"managedAsset id: %@", [managedAssets objectForKey:@"id"]);
  }
  
  [self performSegueWithIdentifier:@"viewAssetsToSingleAsset" sender:self];
  
  /* 
   !- TODO -!
   Call a function to populate the fields in Single Asset View passing the assetId
   Remove hardcoded fields in Single Asset View Storyboard
   */
}

#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"viewAssetsToSingleAsset"])
  {
    NSIndexPath *indexPath = [assetsTableView indexPathForSelectedRow];
    
    //SingleAssetViewController *destViewController = segue.destinationViewController;
    //destViewController.assetNameField.text = [viewAssetsPageEntries objectAtIndex:indexPath.row];
  }
}


@end
