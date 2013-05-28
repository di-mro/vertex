//
//  SRFeedbackPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SRFeedbackPageViewController.h"
#import "HomePageViewController.h"
#import "ServiceRequestViewController.h"
#import "RestKit/RestKit.h"

@interface SRFeedbackPageViewController ()

@end

@implementation SRFeedbackPageViewController

@synthesize srCommentsTextArea;
@synthesize srFeedbackScroller;
@synthesize srRatings;
@synthesize cancelSRFeedbackConfirmation;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize serviceRequestId;

@synthesize topicId;
@synthesize srFeedbackInfo;

@synthesize srFeedbackQuestions;
@synthesize srFeedbackQuestionId;

@synthesize addFeebackJson;

@synthesize srFeedbackRatingsArray;


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
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelSRFeedback)];
  
  //[Submit] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(submitSRFeedback)];
  
  //Scroller size
  self.srFeedbackScroller.contentSize = CGSizeMake(320.0, 900.0);
  
  //Set topicId to Service Request topic Id
  topicId = @20130101530000001;
  
  //srFeedbackRatings init
  srFeedbackRatingsArray = [[NSMutableArray alloc] init];
  
  //srRatings init
  srRatings = 0.0;
  
  //Retrieve feedback questions from endpoint URL
  [self getFeedbackQuestions];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Service Request ID to the selected serviceRequestId from previous page
- (void) setServiceRequestId:(NSNumber *) srIdFromPrev
{
  serviceRequestId = srIdFromPrev;
  NSLog(@"SRFeedbackPage - serviceRequestId: %@", serviceRequestId);
}


#pragma mark - Get Feedback Questions
- (void) getFeedbackQuestions
{
  //endpoint for getTopicQuestions/{topicId}
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.113/vertex-api/feedback/topic/getTopicQuestions/%@", topicId];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:urlParams]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  
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
  
  if(responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Warning"
                                              message:@"No network connection detected. Displaying data from phone cache."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //Connect to CoreData for local data
    //!- FOR TESTING ONLY -!
    srFeedbackQuestions = [[NSMutableArray alloc] init];
    [srFeedbackQuestions addObject:@"Is the Service fast?"];
    [srFeedbackQuestions addObject:@"Is Service efficient?"];
    [srFeedbackQuestions addObject:@"Is the fee reasonable?"];
    [srFeedbackQuestions addObject:@"Was the Service quality good?"];
  }
  else
  {
    srFeedbackInfo = [NSJSONSerialization
                      JSONObjectWithData:responseData
                                 options:kNilOptions
                                   error:&error];
    
    NSLog(@"getTopicQuestions JSON Result: %@", srFeedbackInfo);
    
    srFeedbackQuestions = [[NSMutableArray alloc] init];
    srFeedbackQuestionId = [[NSMutableArray alloc] init];
    for(int i = 0; i < [[[srFeedbackInfo valueForKey:@"questions"] valueForKey:@"question"] count]; i++)
    {
      //Store question
      [srFeedbackQuestions addObject:[[[srFeedbackInfo valueForKey:@"questions"] valueForKey:@"question"] objectAtIndex:i]];
      //Store question id
      [srFeedbackQuestionId addObject:[[[srFeedbackInfo valueForKey:@"questions"] valueForKey:@"id"] objectAtIndex:i]];
    }

    NSLog(@"srFeedbackQuestions: %@", srFeedbackQuestions);
    NSLog(@"srFeedbackQuestionId: %@", srFeedbackQuestionId);
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
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Feedbacks and Comments"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [srFeedbackQuestions count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Service Requests Feedback Page Questions");
  
  static NSString *CellIdentifier = @"srFeedbackQuestionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text          = [self.srFeedbackQuestions objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  NSArray *choices = [NSArray arrayWithObjects:@"Yes", @"No", nil];
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:choices];
  
  CGRect segmentedControlFrame      = segmentedControl.frame;
  segmentedControlFrame.size.width  = 100;
  segmentedControlFrame.size.height = 40;
  segmentedControl.frame            = segmentedControlFrame;
  
  //segmentedControl.selectedSegmentIndex = 0; //set 'Yes' as default selected button
  [segmentedControl addTarget:self
	                     action:@selector(rate:)
	           forControlEvents:UIControlEventValueChanged];
  
  cell.accessoryView = segmentedControl;
  
  return cell;
}

//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 75;
}


#pragma mark - Method executes when user touches the segmented control button [YES | NO] in the questions
- (void) rate:(id)sender
{
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  
  //if ([[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex] isEqual: @"Yes"])
  if(segmentedControl.selectedSegmentIndex == 0) //YES
  {
    srRatings += 25.0;
    [srFeedbackRatingsArray addObject:@10];
  }
  else if(segmentedControl.selectedSegmentIndex == 1) //NO
  {
    srRatings += 0.0;
    [srFeedbackRatingsArray addObject:@0];
  }
  else
  {
    [srFeedbackRatingsArray addObject:@10];
  }
}


#pragma mark - [Cancel] button implementation
-(void) cancelSRFeedback
{
  NSLog(@"Cancel Service Request Feedback");
  
  cancelSRFeedbackConfirmation = [[UIAlertView alloc]
                                      initWithTitle:@"Cancel Service Request Feedback"
                                            message:@"Are you sure you want to cancel this service request feedback?"
                                           delegate:self
                                  cancelButtonTitle:@"Yes"
                                  otherButtonTitles:@"No", nil];
  
  [cancelSRFeedbackConfirmation show];
}


#pragma mark - Transition to a page depending on what alert box is shown and what button is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if([alertView isEqual:cancelSRFeedbackConfirmation])
  {
    NSLog(@"Cancel SR Feedback");
    if(buttonIndex == 0) //Yes - Cancel
    {
      //Go back to SR Page
      ServiceRequestViewController *controller = (ServiceRequestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
      
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
  else
  {
    if (buttonIndex == 0) //OK
    {
      //Go back to Home
      HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
      
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
}


#pragma mark - [Submit] button implementation
-(void) submitSRFeedback
{
  NSLog(@"Submit Service Request Feedback");
  /*
   "{
      responder:
      {
        id: long
      },
      submittedDate: string,
      results:
      [
        {
          question:
          {
            id: long
          },
          rating: int
        }
        , ...
      ],
      comment: string
   }"
   */
  
  addFeebackJson = [[NSMutableDictionary alloc] init];
  
  //responder
  NSMutableDictionary *responderJson = [[NSMutableDictionary alloc] init];
  [responderJson setObject:@20130101500000001 forKey:@"id"]; //!!! - TODO - Replace with userId of logged user
  [addFeebackJson setObject:responderJson forKey:@"responder"];
  
  //submittedDate
  NSDate *date = [[NSDate alloc] init];
  NSString *submittedDate = [[NSString alloc] init];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  submittedDate = [dateFormatter stringFromDate:date];
  
  [addFeebackJson setObject:submittedDate forKey:@"submittedDate"];
  
  //comment
  [addFeebackJson setObject:srCommentsTextArea.text forKey:@"comment"];
  
  //results
  NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
  NSMutableDictionary *resultsDictionary;
  NSMutableDictionary *questionJson;
  
  for(int i = 0; i < srFeedbackQuestionId.count; i++)
  {
    resultsDictionary = [[NSMutableDictionary alloc] init];
    questionJson = [[NSMutableDictionary alloc] init];
    
    //question
    [questionJson setObject:[srFeedbackQuestionId objectAtIndex:i] forKey:@"id"];
    [resultsDictionary setObject:questionJson forKey:@"question"];
    
    //rating
    [resultsDictionary setObject:[srFeedbackRatingsArray objectAtIndex:i] forKey:@"rating"];
    
    //save question-rating node in an array
    [resultsArray insertObject:resultsDictionary atIndex:i];
  }
  
  //save results array in whole JSON request for addFeedback
  [addFeebackJson setObject:resultsArray forKey:@"results"];
  NSLog(@"addFeedback JSON: %@", addFeebackJson);

  NSError *error   = [[NSError alloc] init];
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:addFeebackJson
                      options:NSJSONWritingPrettyPrinted
                      error:&error];
  
  NSString *jsonString = [[NSString alloc]
                          initWithData:jsonData
                          encoding:NSUTF8StringEncoding];
    
  //Set URL for Add Feedback
  //URL = @"http://192.168.2.113/vertex-api/feedback/feedback-form/addFeedback/{serviceRequestId}";
  NSMutableString *urlParams = [NSMutableString stringWithFormat:@"http://192.168.2.113/vertex-api/feedback/feedback-form/addFeedback/%@", serviceRequestId];
  
  NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:urlParams]];
  
  //POST method - Create
  [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [postRequest setHTTPMethod:@"POST"];
  [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
  NSLog(@"%@", postRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:postRequest
                                        delegate:self];
  
  [connection start];
  
  NSLog(@"addFeedback - httpResponseCode: %d", httpResponseCode);
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *srFeedbackAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Service Request Feedback"
                                              message:@"Feedback submitted."
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
   [srFeedbackAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *srFeedbackFailAlert = [[UIAlertView alloc]
                                            initWithTitle:@"Service Request Feedback Failed"
                                                  message:@"Feedback not submitted. Please try again later"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [srFeedbackFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [srCommentsTextArea resignFirstResponder];
}


@end
