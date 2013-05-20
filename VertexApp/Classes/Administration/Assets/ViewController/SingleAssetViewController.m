//
//  SingleAssetViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/14/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SingleAssetViewController.h"

@interface SingleAssetViewController ()

@end

@implementation SingleAssetViewController

@synthesize singleAssetViewScroller;
@synthesize assetDetailsTextArea;

@synthesize managedAssetId;
@synthesize assetOwnedId;
@synthesize assetInfo;

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
  //Configure Scroller size
  self.singleAssetViewScroller.contentSize = CGSizeMake(320, 720);
  
  //Connect to WS endpoint to retrieve details for the chosen Asset
  [self getAssetInfo];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Set Asset ID to the selected assetID from previous page
- (void) setAssetId:(NSNumber *) assetId
{
  assetOwnedId = assetId;
  NSLog(@"SingleAssetViewController - assetOwnedId: %@", assetOwnedId);
}


#pragma mark - Call WS endpoint to get details for the selected asset
-(void) getAssetInfo
{
  //URL for getAsset
  //URL = @"http://192.168.2.113/vertex-api/asset/getAsset/";
  URL = @"http://192.168.2.107/vertex-api/asset/getAsset/";
  
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getAsset/%@"
                                , assetOwnedId];

  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
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
    
    //TODO: Retrieve local records from CoreData
  }
  else
  {
    //JSON
    assetInfo = [NSJSONSerialization
                  JSONObjectWithData:responseData
                             options:kNilOptions
                               error:&error];
    
    NSLog(@"assetInfo JSON: %@", assetInfo);
    
    
    NSMutableDictionary *assetAttributesDict = [[NSMutableDictionary alloc] init];
    NSMutableString *assetAttribString       = [[NSMutableString alloc] init];
    NSMutableArray *assetAttribListing       = [[NSMutableArray alloc] init];
    
    NSMutableArray *assetAttribKeyArray   = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] init];
    
    //Get the key-value pair in the returned JSON object
    assetAttributesDict = [assetInfo objectForKey:@"attributes"];
    for(NSString *key in assetAttributesDict)
    {
      [assetAttribKeyArray addObject:[key valueForKey:@"keyName"]];
      [assetAttribValueArray addObject:[key valueForKey:@"value"]];
    }
    
    //Format as string the key-value pair and save in an array
    for(int i = 0; i < [assetAttribKeyArray count]; i++)
    {
      assetAttribString = [NSMutableString stringWithFormat:@"%@ : %@",
                             [assetAttribKeyArray objectAtIndex:i]
                           , [assetAttribValueArray objectAtIndex:i]];
      
      [assetAttribListing insertObject:assetAttribString atIndex:i];
      
      assetAttribString = [[NSMutableString alloc] init];
    }
    
    NSString *assetAttribStringFormatted = [[NSString alloc] init];
    assetAttribStringFormatted           = [assetAttribListing componentsJoinedByString:@"\n  "];
    
    //Setting the display for the Text Area
    NSMutableString *assetDetailsDisplay = [[NSMutableString alloc] init];
    
    //Format display string
    assetDetailsDisplay = [NSMutableString
                           stringWithFormat:@"ASSET NAME: \n  %@ \n\nASSET TYPE: \n  %@ \n\nASSET ATTRIBUTES: \n  %@ \n\n"
                           , [assetInfo valueForKey:@"name"]
                           , [[assetInfo valueForKey:@"assetType"] valueForKey:@"name"]
                           , assetAttribStringFormatted];
    
    assetDetailsTextArea.text = assetDetailsDisplay;
  } //end - else if (responseData == nil)
}

@end
