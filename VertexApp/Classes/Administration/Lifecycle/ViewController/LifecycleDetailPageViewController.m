//
//  LifecycleDetailPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/2/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "LifecycleDetailPageViewController.h"

@interface LifecycleDetailPageViewController ()

@end

@implementation LifecycleDetailPageViewController

@synthesize lifecycleDetailTextArea;
@synthesize lifecycleId;
@synthesize lifecycleInfo;

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
  [self getLifecycleInfo];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Asset ID to the selected assetID from previous page
- (void) setLifecycleId:(NSNumber *) lifecycleIdFromPrev
{
  lifecycleId = lifecycleIdFromPrev;
  NSLog(@"LifeCycleDetailPage - lifecycleId: %@", lifecycleId);
}


#pragma mark - Call WS endpoint to get details for the selected lifecycle
-(void) getLifecycleInfo
{
  //URL = @"http://192.168.2.113:8080/vertex-api/lifecycle/getLifecycle/";
  URL = @"http://192.168.2.113/vertex-api/lifecycle/getLifecycle/";
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"http://192.168.2.113/vertex-api/lifecycle/getLifecycle/%@"
                                , lifecycleId];
  
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
    //TEST DATA ONLY
    //Setting the display for the Text Area
    NSMutableString *lifecycleDetailsDisplay = [[NSMutableString alloc] init];
    
    //Format display string
    lifecycleDetailsDisplay = [NSMutableString
                           stringWithFormat:@"LIFECYCLE NAME: \n  %@ \n\nLIFECYCLE DESCRIPTION: \n  %@",
                           @"Demo - repair", @"Demo - repair"];
    
    lifecycleDetailTextArea.text = lifecycleDetailsDisplay;
  }
  else
  {
    //JSON
    lifecycleInfo = [NSJSONSerialization
                 JSONObjectWithData:responseData
                 options:kNilOptions
                 error:&error];
    NSLog(@"lifecycleInfo JSON: %@", lifecycleInfo);
    
    //Setting the display for the Text Area
    NSMutableString *lifecycleDetailsDisplay = [[NSMutableString alloc] init];
    
    //Format display string
    lifecycleDetailsDisplay = [NSMutableString
                               stringWithFormat:@"LIFECYCLE NAME: \n  %@ \n\nLIFECYCLE DESCRIPTION: \n  %@",
                               [lifecycleInfo valueForKey:@"name"], [lifecycleInfo valueForKey:@"description"]];
    
    lifecycleDetailTextArea.text = lifecycleDetailsDisplay;
  } //end - else if (responseData == nil)
}


@end
