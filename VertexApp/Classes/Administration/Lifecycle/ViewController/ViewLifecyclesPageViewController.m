//
//  ViewLifecyclesPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewLifecyclesPageViewController.h"
#import "LifecycleDetailPageViewController.h"

@interface ViewLifecyclesPageViewController ()

@end

@implementation ViewLifecyclesPageViewController

@synthesize viewLifecyclesPageEntries;
@synthesize lifecycleNameArray;
@synthesize lifecycleIdArray;
@synthesize lifecyclesDict;
@synthesize selectedLifecycleId;

@synthesize URL;


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
  [self displayViewLifecyclesPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in View Lifecycle Page
- (void) displayViewLifecyclesPageEntries
{
  viewLifecyclesPageEntries = [[NSMutableArray alloc] init];
  //URL = @"http://192.168.2.113/vertex-api/lifecycle/getLifecycles";
  URL = @"http://192.168.2.107/vertex-api/lifecycle/getLifecycles";
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; 
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
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
    NSString *entry1 = @"Demo - canvass";
    NSString *entry2 = @"Demo - requisition";
    NSString *entry3 = @"Demo - purchase";
    NSString *entry4 = @"Demo - receipt";
    NSString *entry5 = @"Demo - install/commission";
    NSString *entry6 = @"Demo - configure";
    NSString *entry7 = @"Demo - operational";
    NSString *entry8 = @"Demo - repair";
    NSString *entry9 = @"Demo - decommission";
    
    [viewLifecyclesPageEntries addObject:entry1];
    [viewLifecyclesPageEntries addObject:entry2];
    [viewLifecyclesPageEntries addObject:entry3];
    [viewLifecyclesPageEntries addObject:entry4];
    [viewLifecyclesPageEntries addObject:entry5];
    [viewLifecyclesPageEntries addObject:entry6];
    [viewLifecyclesPageEntries addObject:entry7];
    [viewLifecyclesPageEntries addObject:entry8];
    [viewLifecyclesPageEntries addObject:entry9];
  }
  else
  {
    //JSON
    lifecyclesDict = [NSJSONSerialization
                      JSONObjectWithData:responseData
                                 options:kNilOptions
                                   error:&error];
    
    NSLog(@"lifecycles JSON: %@", lifecyclesDict);
    
    viewLifecyclesPageEntries = [lifecyclesDict valueForKey:@"name"];
    
    lifecycleNameArray = [[NSMutableArray alloc] init];
    lifecycleIdArray   = [[NSMutableArray alloc] init];
    
    lifecycleNameArray = [lifecyclesDict valueForKey:@"name"];
    lifecycleIdArray   = [lifecyclesDict valueForKey:@"id"];
  }
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Lifecycle List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [viewLifecyclesPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"viewLifecyclesPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.viewLifecyclesPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  
  selectedRowName     = [viewLifecyclesPageEntries objectAtIndex:indexPath.row];
  selectedLifecycleId = [lifecycleIdArray objectAtIndex:indexPath.row];
  
  [self performSegueWithIdentifier:@"viewLifecyclesToLifecycleDetail" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"viewLifecyclesToLifecycleDetail"])
  {
    [segue.destinationViewController setLifecycleId:selectedLifecycleId];
  }
}


@end
