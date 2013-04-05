//
//  DeleteAssetTypePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "DeleteAssetTypePageViewController.h"
#import "HomePageViewController.h"

@interface DeleteAssetTypePageViewController ()

@end

@implementation DeleteAssetTypePageViewController

@synthesize deleteAssetTypePageEntries;
@synthesize assetTypeNameArray;
@synthesize assetTypeIdArray;
@synthesize assetTypeDict;
@synthesize selectedAssetTypeId;

@synthesize URL;
@synthesize httpResponseCode;


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
  NSLog(@"Delete Asset Type Page");
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDeleteAssetType)];
  
  //[Delete] navigation button - Delete Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAssetType)];
  
  [self displayDeleteAssetTypeEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in Delete Asset Type Page
- (void) displayDeleteAssetTypeEntries
{
  deleteAssetTypePageEntries = [[NSMutableArray alloc] init];
  
  //URL Endpoint to get Asset Types
  URL = @"http://192.168.2.113:8080/vertex-api/asset/getAssetTypes";
  
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
    NSString *entry1 = @"Demo - Air Conditioner";
    NSString *entry2 = @"Demo - Door";
    NSString *entry3 = @"Demo - Window";
    NSString *entry4 = @"Demo - Sink";
    NSString *entry5 = @"Demo - Pool";
    
    [deleteAssetTypePageEntries addObject:entry1];
    [deleteAssetTypePageEntries addObject:entry2];
    [deleteAssetTypePageEntries addObject:entry3];
    [deleteAssetTypePageEntries addObject:entry4];
    [deleteAssetTypePageEntries addObject:entry5];
  }
  else
  {
    //JSON
    assetTypeDict = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    NSLog(@"assetType JSON: %@", assetTypeDict);
    
    deleteAssetTypePageEntries = [assetTypeDict valueForKey:@"name"];
    
    assetTypeNameArray = [[NSMutableArray alloc] init];
    assetTypeIdArray = [[NSMutableArray alloc] init];
    
    assetTypeNameArray = [assetTypeDict valueForKey:@"name"];
    assetTypeIdArray = [assetTypeDict valueForKey:@"id"];
  }
}


#pragma mark - [Cancel] button implementation
-(void) cancelDeleteAssetType
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Delete Asset Type");
  
  //Go back to Home Page
  HomePageViewController *controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - [Delete] button implementation
-(void) deleteAssetType
{
  UIAlertView *assetTypeDeleteConfirmation = [[UIAlertView alloc]
                                              initWithTitle:@"Asset Type Delete"
                                              message:@"Are you sure you want to delete the selected asset type?"
                                              delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No",
                                              nil];
  [assetTypeDeleteConfirmation show];
  //clickedButtonAtIndex:
}


#pragma mark - Transition to Home Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  if (buttonIndex == 0)
  {
    //TODO : WS Endpoint for delete
    URL = @"";
    
    //! TEST
    NSMutableString *urlParams = [NSMutableString
                                  stringWithFormat:@""
                                  , selectedAssetTypeId];
    
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
      UIAlertView *assetTypeDeleteAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Warning"
                                       message:@"Asset Type not deleted. Please try again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
      [assetTypeDeleteAlert show];
    }
    else
    {
      UIAlertView *assetTypeDeleteAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Asset Type Delete"
                                       message:@"Asset Type deleted"
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
      [assetTypeDeleteAlert show];
    }
    [self.navigationController pushViewController:controller animated:YES];
  }
  else
  {
    [self.navigationController pushViewController:controller animated:YES];
    NSLog(@"Delete Asset Typed Canceled");
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
  httpResponse = (NSHTTPURLResponse *)response;
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
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Choose Asset Type to delete"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [deleteAssetTypePageEntries count];
  NSLog(@"%d", [deleteAssetTypePageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"deleteAssetTypePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.deleteAssetTypePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  selectedRowName = [deleteAssetTypePageEntries objectAtIndex:indexPath.row];
  NSLog(@"Selected row name: %@", selectedRowName);
  
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:indexPath.row];
  NSLog(@"selectedAssetTypeId: %@", selectedAssetTypeId);
}



@end
