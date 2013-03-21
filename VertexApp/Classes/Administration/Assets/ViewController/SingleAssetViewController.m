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

/*
@synthesize assetNameField;
@synthesize assetTypeField;
@synthesize modelField;
@synthesize brandField;
@synthesize powerConsumptionField;
@synthesize remarksArea;

@synthesize modelLabel;
@synthesize brandLabel;
@synthesize powerConsumptionLabel;
@synthesize remarksLabel;
*/

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
  URL = @"http://192.168.2.13:8080/vertex-api/asset/getAsset/";
  
  //! TEST
  //NSString *assetId = @"20130101010200000";
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.13:8080/vertex-api/asset/getAsset/%@"
                                , assetOwnedId];

  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"userId=20130101005100000"];
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
    NSMutableString *assetAttribString = [[NSMutableString alloc] init];
    NSMutableArray *assetAttribListing = [[NSMutableArray alloc] init];
    
    NSMutableArray *assetAttribKeyArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] init];
    
    //Get the key-value pair in the returned JSON object
    assetAttributesDict = [assetInfo objectForKey:@"attributes"];
    for(NSString *key in assetAttributesDict)
    {
      NSLog(@"Key: %@", key);
      [assetAttribKeyArray addObject:[key valueForKey:@"keyName"]];
      [assetAttribValueArray addObject:[key valueForKey:@"value"]];
      NSLog(@"assetAttribKeyArray: %@", assetAttribKeyArray);
      NSLog(@"assetAttribValueArray: %@", assetAttribValueArray);
    }
    
    //Format as string the key-value pair and save in an array
    for(int i = 0; i < [assetAttribKeyArray count]; i++)
    {
      assetAttribString = [NSMutableString stringWithFormat:@"%@ : %@",
                           [assetAttribKeyArray objectAtIndex:i], [assetAttribValueArray objectAtIndex:i]];
      NSLog(@"assetAttribString: %@", assetAttribString);
      [assetAttribListing insertObject:assetAttribString atIndex:i];
      NSLog(@"assetAttribListing: %@", assetAttribListing);
      assetAttribString = [[NSMutableString alloc] init];
    }
    
    NSString *assetAttribStringFormatted = [[NSString alloc] init];
    assetAttribStringFormatted = [assetAttribListing componentsJoinedByString:@"\n  "];
    
    //[assetAttributesDict setObject:[[assetInfo valueForKey:@"attributes"] valueForKey:@"keyName"] forKey:@"keyName"];
    //[assetAttributesDict setObject:[[assetInfo valueForKey:@"attributes"] valueForKey:@"value"] forKey:@"value"];
    /*
    NSMutableArray *assetAttribKeyArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribValueArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetAttribListing = [[NSMutableArray alloc] init];
    
    [assetAttribKeyArray addObject:[[assetInfo valueForKey:@"attributes"] valueForKey:@"keyName"]];
    [assetAttribValueArray addObject:[[assetInfo valueForKey:@"attributes"] valueForKey:@"value"]];
    
    NSLog(@"assetAttribKeyArray: %@", assetAttribKeyArray);
    NSLog(@"assetAttribValueArray: %@", assetAttribValueArray);
    
    for(int i = 0; i < [assetAttribKeyArray count]; i++)
    {
      assetAttribString = [NSMutableString stringWithFormat:@"%@ : %@",
                           [assetAttribKeyArray objectAtIndex:i], [assetAttribValueArray objectAtIndex:i]];
      NSLog(@"assetAttribString: %@", assetAttribString);
      [assetAttribListing addObject:assetAttribString];
      assetAttribString = [[NSMutableString alloc] init];
    }
    NSLog(@"assetAttribListing: %@", assetAttribListing);
    */
    
    //Setting the display for the Text Area
    NSMutableString *assetDetailsDisplay = [[NSMutableString alloc] init];
    NSRange boldedRange = NSMakeRange(22, 4);
    
    //Format the labels to be bold text
    NSMutableAttributedString *assetNameLabel = [[NSMutableAttributedString alloc] initWithString:@"Asset Name: "];
    NSMutableAttributedString *assetTypeLabel = [[NSMutableAttributedString alloc] initWithString:@"Asset Type: "];
    NSMutableAttributedString *assetAttribLabel = [[NSMutableAttributedString alloc] initWithString:@"Asset Attributes: "];
     
    [assetNameLabel addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Helvetica" size:18.0] //Helvetica-Bold
                           range:boldedRange];
    [assetTypeLabel addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Helvetica" size:18.0]
                           range:boldedRange];
    [assetAttribLabel addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Helvetica" size:18.0]
                           range:boldedRange];
    
    //Format string
    assetDetailsDisplay = [NSMutableString
                           stringWithFormat:@"ASSET NAME: \n  %@ \n\nASSET TYPE: \n  %@ \n\nASSET ATTRIBUTES: \n  %@ \n\n",
                           [assetInfo valueForKey:@"name"], [[assetInfo valueForKey:@"assetType"] valueForKey:@"name"], assetAttribStringFormatted];
    
    assetDetailsTextArea.text = assetDetailsDisplay;
    
    /*
    //Set the field texts using the retrieved values
    assetNameField.text = [assetInfo valueForKey:@"name"];
    assetTypeField.text = [[assetInfo valueForKey:@"assetType"] valueForKey:@"name"];
    
    //For TESTING
    //modelLabel.text = [[assetInfo valueForKey:@"attributes"] valueOfAttribute:@"keyName" forResultAtIndex:0];
    //modelField.text = [[assetInfo valueForKey:@"attributes"] valueOfAttribute:@"value" forResultAtIndex:0];
    modelField.text = @"Lorem Ipsum";
    brandField.text = @"Lorem Ipsum";
    powerConsumptionField.text = @"Lorem Ipsum";
    remarksArea.text = @"Lorem Ipsum";
    */
    
    /*
    //AssetAttributes
    modelField.text = [assetInfo valueForKey:@"attributes"];
    brandField.text = [assetInfo valueForKey:@"attributes"];
    powerConsumptionField.text = [assetInfo valueForKey:@"attributes"];
    remarksArea.text = [assetInfo valueForKey:@"attributes"];
    */
    
    /*
     viewAssetsPageEntries = [assetOwned valueForKey:@"name"];
    
    assetNameArray = [[NSMutableArray alloc] init];
    assetIdArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *assetInfoDict = [[NSMutableDictionary alloc] init];
    
    assetNameArray = [assetOwned valueForKey:@"name"];
    assetIdArray = [assetOwned valueForKey:@"id"];
    
    for(int i = 0; i < [viewAssetsPageEntries count]; i++)
    {
      [assetInfoDict setObject:[assetIdArray objectAtIndex:i] forKey:@"id"];
      [assetInfoDict setObject:[assetNameArray objectAtIndex:i] forKey:@"name"];
      
      [assetIdNameArray insertObject:assetInfoDict atIndex:i];
      assetInfoDict = [[NSMutableDictionary alloc] init]; //container of id-name pair for asset
      NSLog(@"assetInfoDict: %@", assetInfoDict);
    }
     */
  }

  
}

@end
