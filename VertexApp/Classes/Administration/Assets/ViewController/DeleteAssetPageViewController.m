//
//  DeleteAssetViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "DeleteAssetPageViewController.h"
#import "HomePageViewController.h"
#import "AssetPageViewController.h"

@interface DeleteAssetPageViewController ()

@end

@implementation DeleteAssetPageViewController

@synthesize deleteAssetPageEntries;
@synthesize assetIdArray;
@synthesize assetNameArray;
@synthesize assetsDict;
@synthesize selectedAssetId;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize cancelDeleteAssetConfirmation;
@synthesize deleteAssetConfirmation;


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
  NSLog(@"Delete Asset Page");
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelDeleteAsset)];
  
  //[Delete] navigation button - Delete Lifecycle
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(deleteAsset)];
  
  [self displayDeleteAssetPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in Delete Lifecycle Page
- (void) displayDeleteAssetPageEntries
{
  deleteAssetPageEntries = [[NSMutableArray alloc] init];
  
  //TODO : WS Endpoint to get Assets
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
    NSString *entry1 = @"Demo - myAircon";
    NSString *entry2 = @"Demo - myDoor";
    NSString *entry3 = @"Demo - myWindow";
    NSString *entry4 = @"Demo - mySink";
    NSString *entry5 = @"Demo - myPool";
    
    [deleteAssetPageEntries addObject:entry1];
    [deleteAssetPageEntries addObject:entry2];
    [deleteAssetPageEntries addObject:entry3];
    [deleteAssetPageEntries addObject:entry4];
    [deleteAssetPageEntries addObject:entry5];
  }
  else
  {
    //JSON
    assetsDict = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    NSLog(@"assets JSON: %@", assetsDict);
    
    deleteAssetPageEntries = [assetsDict valueForKey:@"name"];
    
    assetNameArray = [[NSMutableArray alloc] init];
    assetIdArray   = [[NSMutableArray alloc] init];
    
    assetNameArray = [assetsDict valueForKey:@"name"];
    assetIdArray   = [assetsDict valueForKey:@"id"];
  }
}


#pragma mark - [Cancel] button implementation
-(void) cancelDeleteAsset
{
  NSLog(@"Cancel Delete Assets");
  
  cancelDeleteAssetConfirmation = [[UIAlertView alloc]
                                       initWithTitle:@"Cancel Delete Asset"
                                             message:@"Are you sure you want to cancel deleting this asset?"
                                            delegate:self
                                   cancelButtonTitle:@"Yes"
                                   otherButtonTitles:@"No", nil];
  
  [cancelDeleteAssetConfirmation show];
}


#pragma mark - [Delete] button implementation
-(void) deleteAsset
{
  deleteAssetConfirmation = [[UIAlertView alloc]
                              initWithTitle:@"Asset Delete"
                                    message:@"Are you sure you want to delete the selected asset?"
                                   delegate:self
                          cancelButtonTitle:@"Yes"
                          otherButtonTitles:@"No", nil];
  
  [deleteAssetConfirmation show];
  //clickedButtonAtIndex:
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  HomePageViewController *homePageController = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  if([alertView isEqual:cancelDeleteAssetConfirmation])
  {
    NSLog(@"Cancel Delete Asset Confirmation");
    
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      AssetPageViewController *controller = (AssetPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetsPage"];
      
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
  else if([alertView isEqual:deleteAssetConfirmation])
  {
    NSLog(@"Delete Asset");
    
    if (buttonIndex == 0)
    {
      //!!! TODO : WS Endpoint for delete
      URL = @"";
      
      //! TEST
      NSMutableString *urlParams = [NSMutableString
                                    stringWithFormat:@"http://blah/%@"
                                    , selectedAssetId];
      
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
        UIAlertView *assetDeleteAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Warning"
                                                   message:@"Asset not deleted. Please try again."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
        [assetDeleteAlert show];
      }
      else
      {
        UIAlertView *assetDeleteAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Asset Delete"
                                                   message:@"Asset deleted"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
        [assetDeleteAlert show];
      }
      [self.navigationController pushViewController:homePageController animated:YES];
    }
    else
    {
      [self.navigationController pushViewController:homePageController animated:YES];
      NSLog(@"Delete Asset Cancel");
    }
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
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Choose Asset to delete"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [deleteAssetPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"deleteAssetPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.deleteAssetPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];

  selectedRowName = [deleteAssetPageEntries objectAtIndex:indexPath.row];
  selectedAssetId = [assetIdArray objectAtIndex:indexPath.row];
}


@end
