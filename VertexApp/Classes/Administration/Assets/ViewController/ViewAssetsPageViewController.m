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
#import "SingleAssetViewController.h"
#import "HomePageViewController.h"

@interface ViewAssetsPageViewController ()

@end

@implementation ViewAssetsPageViewController

@synthesize viewAssetsPageEntries;
@synthesize URL;
@synthesize managedAssets;
@synthesize assetsTableView;
@synthesize assetOwned;

@synthesize assetIdNameArray;
@synthesize selectedAssetId;
@synthesize assetNameArray;
@synthesize assetIdArray;


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
  NSLog(@"View Assets Page View");
  
  //[Home] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(backToHome)];
  
  [self displayViewAssetsPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - [Home] button implementation
-(void) backToHome
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Add Asset");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


# pragma mark - Display entries in Asset Page
- (void) displayViewAssetsPageEntries
{
  viewAssetsPageEntries = [[NSMutableArray alloc] init];
  //URL = @"http://192.168.2.113/vertex-api/asset/getOwnership/";
  URL = @"http://192.168.2.107/vertex-api/asset/getOwnership/";
  
  //TEST
  //Where to get userId
  NSString *userId = @"20130101500000001";
  NSMutableString *urlParams = [NSMutableString
                               stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getOwnership/%@"
                               , userId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //@"Content-Type" / userId / userId=20130101010200000
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
    /*
    //json
    managedAssets = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions
                                   error:&error];
    NSLog(@"getManagedAssets JSON Result: %@", managedAssets);
      
    viewAssetsPageEntries = [managedAssets valueForKey:@"name"];
    NSLog(@"managedAssets: %@", managedAssets);
    */
    
    //JSON
    assetOwned = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    
    NSLog(@"assetOwned JSON: %@", assetOwned);
    
    viewAssetsPageEntries = [assetOwned valueForKey:@"name"];
    
    assetNameArray   = [[NSMutableArray alloc] init];
    assetIdArray     = [[NSMutableArray alloc] init];
    assetIdNameArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *assetInfoDict = [[NSMutableDictionary alloc] init];
    
    assetNameArray = [assetOwned valueForKey:@"name"];
    assetIdArray   = [assetOwned valueForKey:@"id"];
    
    for(int i = 0; i < [viewAssetsPageEntries count]; i++)
    {
      [assetInfoDict setObject:[assetIdArray objectAtIndex:i] forKey:@"id"];
      [assetInfoDict setObject:[assetNameArray objectAtIndex:i] forKey:@"name"];
      
      //container of id-name pair for asset
      [assetIdNameArray insertObject:assetInfoDict atIndex:i];
      assetInfoDict = [[NSMutableDictionary alloc] init];
    }
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
  static NSString *CellIdentifier = @"viewAssetsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.viewAssetsPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  
  selectedRowName = [viewAssetsPageEntries objectAtIndex:indexPath.row];
  selectedAssetId = [assetIdArray objectAtIndex:indexPath.row];
  
  [self performSegueWithIdentifier:@"viewAssetsToSingleAsset" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"viewAssetsToSingleAsset"])
  {
    [segue.destinationViewController setAssetId:selectedAssetId];
  }
}


@end
