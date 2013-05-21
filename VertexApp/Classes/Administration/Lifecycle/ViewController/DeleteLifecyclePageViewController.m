//
//  DeleteLifecyclePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "DeleteLifecyclePageViewController.h"
#import "HomePageViewController.h"
#import "ViewLifecyclesPageViewController.h"

@interface DeleteLifecyclePageViewController ()

@end

@implementation DeleteLifecyclePageViewController

@synthesize deleteLifecyclePageEntries;
@synthesize lifecycleNameArray;
@synthesize lifecycleIdArray;
@synthesize lifecyclesDict;
@synthesize selectedLifecycleId;

@synthesize URL;
@synthesize httpResponseCode;


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
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelDeleteLifecycle)];
  
  //[Delete] navigation button - Delete Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(deleteLifecycle)];
  
  [self displayDeleteLifecyclesPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in View Lifecycle Page
- (void) displayDeleteLifecyclesPageEntries
{
  deleteLifecyclePageEntries = [[NSMutableArray alloc] init];
  //TODO
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
    
    [deleteLifecyclePageEntries addObject:entry1];
    [deleteLifecyclePageEntries addObject:entry2];
    [deleteLifecyclePageEntries addObject:entry3];
    [deleteLifecyclePageEntries addObject:entry4];
    [deleteLifecyclePageEntries addObject:entry5];
    [deleteLifecyclePageEntries addObject:entry6];
    [deleteLifecyclePageEntries addObject:entry7];
    [deleteLifecyclePageEntries addObject:entry8];
    [deleteLifecyclePageEntries addObject:entry9];
  }
  else
  {
    //JSON
    lifecyclesDict = [NSJSONSerialization
                      JSONObjectWithData:responseData
                                 options:kNilOptions
                                   error:&error];
    
    NSLog(@"lifecycles JSON: %@", lifecyclesDict);
    
    deleteLifecyclePageEntries = [lifecyclesDict valueForKey:@"name"];
    
    lifecycleNameArray = [[NSMutableArray alloc] init];
    lifecycleIdArray   = [[NSMutableArray alloc] init];
    
    lifecycleNameArray = [lifecyclesDict valueForKey:@"name"];
    lifecycleIdArray   = [lifecyclesDict valueForKey:@"id"];
  }
}


#pragma mark - [Cancel] button implementation
-(void) cancelDeleteLifecycle
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Delete Lifecycle");
  
  //Go back to Home Page
  HomePageViewController *controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - [Delete] button implementation
-(void) deleteLifecycle
{
  UIAlertView *lifecycleDeleteConfirmation = [[UIAlertView alloc]
                                           initWithTitle:@"Lifecycle Delete"
                                                 message:@"Are you sure you want to delete the selected lifecycle?"
                                                delegate:self
                                       cancelButtonTitle:@"Yes"
                                       otherButtonTitles:@"No",
                                       nil];
  [lifecycleDeleteConfirmation show];
  //clickedButtonAtIndex:
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  if (buttonIndex == 0)
  {
    //TODO
    URL = @"";
    
    //! TEST
    NSMutableString *urlParams = [NSMutableString
                                  stringWithFormat:@""
                                  , selectedLifecycleId];
    
    NSMutableURLRequest *deleteRequest = [NSMutableURLRequest
                                          requestWithURL:[NSURL URLWithString:urlParams]];
    
    [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [deleteRequest setHTTPMethod:@"DELETE"];
    NSLog(@"%@", deleteRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:deleteRequest
                                          delegate:self];
    [connection start];
    
    NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection
                            sendSynchronousRequest:deleteRequest
                                 returningResponse:&urlResponse
                                             error:&error];
    
    if (responseData == nil)
    {
      //Show an alert if connection is not available
      UIAlertView *lifecycleDeleteAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Warning"
                                                     message:@"Lifecycle not deleted. Please try again."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [lifecycleDeleteAlert show];
    }
    else
    {
      UIAlertView *lifecycleDeleteAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Lifecycle Delete"
                                                     message:@"Lifecycle deleted"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
      [lifecycleDeleteAlert show];
    }
    [self.navigationController pushViewController:controller animated:YES];
  }
  else
  {
    [self.navigationController pushViewController:controller animated:YES];
    NSLog(@"Delete Lifecycle Cancel");
  }
}


#pragma mark - Connection didFailWithError
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"connection didFailWithError: %@", [error localizedDescription]);
}


#pragma mark - Connection didReceiveResponse
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSHTTPURLResponse *httpResponse;
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Choose Lifecycle to delete"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [deleteLifecyclePageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"deleteLifecyclePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.deleteLifecyclePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  
  selectedRowName     = [deleteLifecyclePageEntries objectAtIndex:indexPath.row];
  selectedLifecycleId = [lifecycleIdArray objectAtIndex:indexPath.row];
  
  //Call method to delete lifecycle, pass lifecycleId
  //[self deleteLifecycle];
  
  //[self performSegueWithIdentifier:@"viewLifecyclesToLifecycleDetail" sender:self];
}

/*
#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"viewLifecyclesToLifecycleDetail"])
  {
    [segue.destinationViewController setLifecycleId:selectedLifecycleId];
  }
}
*/


@end
