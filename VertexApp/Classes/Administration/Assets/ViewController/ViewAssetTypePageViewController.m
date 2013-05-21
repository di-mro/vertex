//
//  ViewAssetTypePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewAssetTypePageViewController.h"
#import "AssetTypeDetailPageViewController.h"

@interface ViewAssetTypePageViewController ()

@end

@implementation ViewAssetTypePageViewController

@synthesize viewAssetTypePageEntries;
@synthesize assetTypeDict;
@synthesize assetTypeNameArray;
@synthesize assetTypeIdArray;
@synthesize selectedAssetTypeId;

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
  NSLog(@"View Asset Type Page");
  
  [self displayViewAssetTypePageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in View Asset Type Page
- (void) displayViewAssetTypePageEntries
{
  viewAssetTypePageEntries = [[NSMutableArray alloc] init];
  //Get Asset Types
  //URL = @"http://192.168.2.113/vertex-api/asset/getAssetTypes";
  URL = @"http://192.168.2.107/vertex-api/asset/getAssetTypes";
  
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
    NSString *entry1 = @"Demo - Aircon";
    NSString *entry2 = @"Demo - Bath Tub";
    NSString *entry3 = @"Demo - Kitchen Sink";
    NSString *entry4 = @"Demo - Window";
    
    [viewAssetTypePageEntries addObject:entry1];
    [viewAssetTypePageEntries addObject:entry2];
    [viewAssetTypePageEntries addObject:entry3];
    [viewAssetTypePageEntries addObject:entry4];
  }
  else
  {
    //JSON
    assetTypeDict = [NSJSONSerialization
                     JSONObjectWithData:responseData
                                options:kNilOptions
                                  error:&error];
    
    NSLog(@"assetTypeDict JSON: %@", assetTypeDict);
    
    viewAssetTypePageEntries = [assetTypeDict valueForKey:@"name"];
    
    assetTypeIdArray = [[NSMutableArray alloc] init];
    assetTypeIdArray = [assetTypeDict valueForKey:@"id"];
    
    assetTypeNameArray = [[NSMutableArray alloc] init];
    assetTypeNameArray = [assetTypeDict valueForKey:@"name"];
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
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Asset Types List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [viewAssetTypePageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"viewAssetTypeListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.viewAssetTypePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  
  selectedRowName     = [viewAssetTypePageEntries objectAtIndex:indexPath.row];
  selectedAssetTypeId = [assetTypeIdArray objectAtIndex:indexPath.row];
  
  [self performSegueWithIdentifier:@"viewAssetTypesToAssetTypeDetail" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"viewAssetTypesToAssetTypeDetail"])
  {
    [segue.destinationViewController setAssetTypeId:selectedAssetTypeId];
  }
}


@end
