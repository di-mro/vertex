//
//  RemoveEssePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "RemoveEssePageViewController.h"
#import "HomePageViewController.h"

@interface RemoveEssePageViewController ()

@end

@implementation RemoveEssePageViewController

@synthesize removeEssePageEntries;

@synthesize esseNameArray;
@synthesize esseIdArray;
@synthesize esse;
@synthesize selectedEsseId;

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
                                                                          action:@selector(cancelDeleteEsse)];
  
  //[Delete] navigation button - Delete Esse
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(removeEsse)];
  
  [self displayDeleteEssePageEntries];

  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in View Esse Page for Removal
- (void) displayDeleteEssePageEntries
{
  removeEssePageEntries = [[NSMutableArray alloc] init];
  
  //TODO - WS Endpoint getEsseList
  //URL = @"http://192.168.2.113/vertex-api/user/esse/getEsseList";
  URL = @"";
  
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
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    /* !- For demo only, remove hard coded values. Must retrieve listing in CoreData DB -! */
    NSString *entry1 = @"Demo - esse_1";
    NSString *entry2 = @"Demo - esse_2";
    NSString *entry3 = @"Demo - esse_3";
    NSString *entry4 = @"Demo - esse_4";
    NSString *entry5 = @"Demo - esse_5";
    
    [removeEssePageEntries addObject:entry1];
    [removeEssePageEntries addObject:entry2];
    [removeEssePageEntries addObject:entry3];
    [removeEssePageEntries addObject:entry4];
    [removeEssePageEntries addObject:entry5];
  }
  else
  {
    //JSON
    esse = [NSJSONSerialization
            JSONObjectWithData:responseData
                       options:kNilOptions
                         error:&error];
    
    NSLog(@"esse JSON: %@", esse);
    
    removeEssePageEntries = [esse valueForKey:@"name"];
    
    esseIdArray   = [[NSMutableArray alloc] init];
    esseNameArray = [[NSMutableArray alloc] init];
    
    esseNameArray = [esse valueForKey:@"name"];
    esseIdArray   = [esse valueForKey:@"id"];
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
-(void) removeEsse
{
  UIAlertView *removeEsseConfirmation = [[UIAlertView alloc]
                                              initWithTitle:@"Remove Esse"
                                                    message:@"Are you sure you want to delete the selected esse?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No",
                                          nil];
  [removeEsseConfirmation show];
  //clickedButtonAtIndex:
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  if (buttonIndex == 0)
  {
    //TODO - WS Endpoint for delete / remove Esse
    URL = @"";
    
    //! TEST
    NSMutableString *urlParams = [NSMutableString
                                  stringWithFormat:@"%@"
                                  , selectedEsseId];
    
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
      UIAlertView *removeEsseAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Warning"
                                                message:@"Esse not removed. Please try again."
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
      [removeEsseAlert show];
    }
    else
    {
      UIAlertView *removeEsseAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Remove Esse"
                                                message:@"Esse removed"
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
      [removeEsseAlert show];
    }
    [self.navigationController pushViewController:controller animated:YES];
  }
  else
  {
    [self.navigationController pushViewController:controller animated:YES];
    NSLog(@"Delete Esse Cancel");
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
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Choose Esse to remove"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [removeEssePageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"removeEssePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.removeEssePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  
  selectedRowName = [removeEssePageEntries objectAtIndex:indexPath.row];
  selectedEsseId  = [esseIdArray objectAtIndex:indexPath.row];
}


@end
