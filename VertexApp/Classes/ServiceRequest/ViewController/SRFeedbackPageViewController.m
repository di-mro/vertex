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
//#import "Feedback.h"
#import "RestKit/RestKit.h"

@interface SRFeedbackPageViewController ()

@end

@implementation SRFeedbackPageViewController

@synthesize srCommentsTextArea;
@synthesize srFeedbackScroller;
@synthesize displaySRFeedbackQuestions;
@synthesize srRatings;

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
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSRFeedback)];
  
  //[Submit] navigation button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitSRFeedback)];
  
  //Scroller size
  self.srFeedbackScroller.contentSize = CGSizeMake(320.0, 900.0);
  
  //srRatings
  srRatings = 0;
  
  [self displaySRFeedbackPageQuestions];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries/questions in Service Requests Feedback Page
- (void) displaySRFeedbackPageQuestions
{
  /* !- TODO For demo only, remove hard coded values or finalize the feedback questions to be used-! */
  displaySRFeedbackQuestions = [[NSMutableArray alloc] init];
  NSString *entry1 = @"Service is fast?";
  NSString *entry2 = @"Service is efficient?";
  NSString *entry3 = @"Reasonable fee?";
  NSString *entry4 = @"Service quality is good?";
  
  [displaySRFeedbackQuestions addObject:entry1];
  [displaySRFeedbackQuestions addObject:entry2];
  [displaySRFeedbackQuestions addObject:entry3];
  [displaySRFeedbackQuestions addObject:entry4];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Feedback and Comments"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [displaySRFeedbackQuestions count];
  NSLog(@"%d", [displaySRFeedbackQuestions count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Service Requests Feedback Page Questions");
  static NSString *CellIdentifier = @"srFeedbackQuestionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text = [self.displaySRFeedbackQuestions objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  NSArray *choices = [NSArray arrayWithObjects:@"Yes", @"No", nil];
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:choices];
  //segmentedControl.frame = CGRectMake(35, 200, 250, 50);
  //segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
  segmentedControl.selectedSegmentIndex = 1;
  [segmentedControl addTarget:self
	                     action:@selector(rate:)
	           forControlEvents:UIControlEventValueChanged];
  
  cell.accessoryView = segmentedControl;
  
  return cell;
}

//Action method executes when user touches the button
- (void) rate:(id)sender{
	
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  //label.text = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
  
  if ([[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex] isEqual: @"Yes"])
  {
    srRatings += 25;
  }
  else
  {
    srRatings += 0;
  }
}


#pragma mark - [Cancel] button implementation
-(void) cancelSRFeedback
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Service Request Feedback");
  
  //Go back to Home
  HomePageViewController *controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - [Submit] button implementation
-(void) submitSRFeedback
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Submit Service Request Feedback");
  NSInteger *finalRating = 0;
  NSString *comments = [[NSString alloc] init];
  
  finalRating = (*srRatings / 100) * 10;
  NSLog(@"srRating: %i", *srRatings);
  NSLog(@"finalRating: %i", *finalRating);
  
  comments = srCommentsTextArea.text;
  NSLog(@"Comments: %@", comments);
  
  /*
  // !- DO A POST -!
  RKObjectMapping* feedbackMapping = [RKObjectMapping requestMapping ];
  [feedbackMapping addAttributeMappingsFromArray:@[@"rating", @"comments"]];
  NSLog(@"feedbackMapping: %@", feedbackMapping);
  
  // Now configure the request descriptor
  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:feedbackMapping objectClass:[Feedback class] rootKeyPath:@"user"];
  NSLog(@"requestDescriptor: %@", requestDescriptor);
  
  // Create a new Feedback object and POST it to the server
  Feedback *feedbackObject = [[Feedback alloc] init];
  feedbackObject.rating = *(&finalRating);
  feedbackObject.comments = comments;
  
  NSLog(@"feedbackObject - rating: %i", feedbackObject.rating);
  NSLog(@"feedbackObject - comments: %@", feedbackObject.comments);
  NSLog(@"feedbackObject: %@", feedbackObject);
  
  [[RKObjectManager sharedManager] postObject:feedbackObject path:@"http://192.168.2.103:8080/vertex/user/login" parameters:nil success:nil failure:nil];
  */
  
  /* !- TODO -! */
  //if(validateSaveToDB)
  //Inform user Service Request is saved
  UIAlertView *srFeedbackAlert = [[UIAlertView alloc]
                                initWithTitle:@"Service Request Feedback"
                                      message:@"Feedback submitted."
                                     delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
  [srFeedbackAlert show];
  //Transition to Service Request Page - alertView clickedButtonAtIndex
}

#pragma mark - Transition to Service Request Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) //OK
  {
    /*
    ServiceRequestViewController* controller = (ServiceRequestViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SRPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
    */
    //Go back to Home
    HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}

#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [srCommentsTextArea resignFirstResponder];
}


@end
