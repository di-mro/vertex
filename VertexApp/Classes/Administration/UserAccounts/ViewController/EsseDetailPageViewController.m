//
//  EsseDetailPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "EsseDetailPageViewController.h"

@interface EsseDetailPageViewController ()

@end

@implementation EsseDetailPageViewController

@synthesize esseDetailTextArea;

@synthesize esseId;
@synthesize esseInfo;

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
  [self getEsseInfo];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Esse ID to the selected esseId from previous page
- (void) setEsseId:(NSNumber *) esseIdFromPrev
{
  esseId = esseIdFromPrev;
  NSLog(@"Esse Detail Page View Controller - esseId: %@", esseId);
}


#pragma mark - Get chosen esse info
-(void) getEsseInfo
{
  //TODO : WS Endpoint for getEsseInfo
  URL = @"";
  //@"http://192.168.2.113/vertex-api/user/esse/getEsseInfo/%@
  //@"http://192.168.2.107/vertex-api/user/esse/getEsseInfo/%@
  
  //! TEST
  NSMutableString *urlParams = [NSMutableString
                                stringWithFormat:@"%@"
                                , esseId];
  
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
                                             delegate:nil //TEST ~ ~ ~
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //TODO: Retrieve local records from CoreData
    //Setting the display for the Text Area
    NSMutableString *esseDetailsDisplay = [[NSMutableString alloc] init];
    
    //Format display string
    esseDetailsDisplay = [NSMutableString
                               stringWithFormat:@"LAST NAME: \n  %@ \n\nFIRST NAME: \n  %@ \n\nMIDDLE NAME: \n  %@ \n\nWIRELINE: \n  %@ \n\nWIRELESS: \n  %@ \n\nEMAIL ADDRESS: \n  %@ \n\nADDRESS: \n  %@ \n"
                          , @"Demo - Jobs"
                          , @"Demo - Steven"
                          , @"Demo - Paul"
                          , @"Demo - 123-456"
                          , @"Demo - 09110000000"
                          , @"Demo - steve.jobs@apple.com"
                          , @"Demo - Cupertino, California"];
    
    esseDetailTextArea.text = esseDetailsDisplay;
  }
  else
  {
    //JSON
    esseInfo = [NSJSONSerialization
                JSONObjectWithData:responseData
                           options:kNilOptions
                             error:&error];
    
    NSLog(@"esseInfo JSON: %@", esseInfo);
    
    //Setting the display for the Text Area
    NSMutableString *esseDetailsDisplay = [[NSMutableString alloc] init];
    
    //Format display string
    esseDetailsDisplay = [NSMutableString
                               stringWithFormat:@"LAST NAME: \n  %@ \n\nFIRST NAME: \n  %@ \n\nMIDDLE NAME: \n  %@ \n\nWIRELINE: \n  %@ \n\nWIRELESS: \n  %@ \n\nEMAIL ADDRESS: \n  %@ \n\nADDRESS: \n  %@ \n"
                          , [esseInfo valueForKey:@"lastname"]
                          , [esseInfo valueForKey:@"firstname"]
                          , [esseInfo valueForKey:@"middlename"]
                          , [esseInfo valueForKey:@"wireline"]
                          , [esseInfo valueForKey:@"wireless"]
                          , [esseInfo valueForKey:@"emailaddress"]
                          , [esseInfo valueForKey:@"address"]];

    esseDetailTextArea.text = esseDetailsDisplay;
    
  }//end - else if (responseData == nil)
}


@end
