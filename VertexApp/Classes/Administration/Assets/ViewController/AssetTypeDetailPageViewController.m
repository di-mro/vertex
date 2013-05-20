//
//  AssetTypeDetailPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AssetTypeDetailPageViewController.h"

@interface AssetTypeDetailPageViewController ()

@end

@implementation AssetTypeDetailPageViewController

@synthesize assetTypeDetailTextArea;
@synthesize assetTypeId;
@synthesize assetTypeInfo;

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
  NSLog(@"Asset Type Details Page");
  
  [self getAssetTypeInfo];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setAssetTypeId:(NSNumber *) assetTypeIdFromPrev
{
  assetTypeId = assetTypeIdFromPrev;
  NSLog(@"assetTypeId: %@", assetTypeId);
}


#pragma mark - Get chosen asset type info
-(void) getAssetTypeInfo
{
  //URL for retrieving particular asset type info
  //URL = @"http://192.168.2.113/vertex-api/asset/getAssetType/";
  URL = @"http://192.168.2.107/vertex-api/asset/getAssetType/";
  
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.107/vertex-api/asset/getAssetType/%@"
                                , assetTypeId];
  
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
    NSMutableString *assetTypeDetailDisplay = [[NSMutableString alloc] init];
    
    assetTypeDetailDisplay = [NSMutableString stringWithFormat:@"ASSET TYPE NAME: \n  Demo-Aircon \n\nASSET TYPE DESCRIPTION: \n  Demo-Description \n\nASSET ATTRIBUTES: \n  Power Consumption - Watts"];
    
    assetTypeDetailTextArea.text = assetTypeDetailDisplay;
  }
  else
  {
    //JSON
    assetTypeInfo = [NSJSONSerialization
                     JSONObjectWithData:responseData
                                options:kNilOptions
                                  error:&error];
    
    NSLog(@"assetTypeInfo JSON: %@", assetTypeInfo);
    
    //Setting the display for the text area
    NSMutableString *assetTypeDetailDisplay = [[NSMutableString alloc] init];
    
    //Format display string
    assetTypeDetailDisplay = [NSMutableString stringWithFormat:@"ASSET TYPE NAME: \n  %@ \n\nASSET TYPE DESCRIPTION: \n  %@ \n\nASSET ATTRIBUTES: \n  %@"
                              , [assetTypeInfo valueForKey:@"name"]
                              , [assetTypeInfo valueForKey:@"description"]
                              , [[assetTypeInfo valueForKey:@"attributes"] valueForKey:@"keyName"]];
    
    assetTypeDetailTextArea.text = assetTypeDetailDisplay;
  }//end - else if (responseData == nil)
}


@end
