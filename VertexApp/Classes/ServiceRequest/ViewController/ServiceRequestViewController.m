//
//  ServiceRequestViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ServiceRequestViewController.h"
#import "HomePageViewController.h"

@interface ServiceRequestViewController ()

@end

@implementation ServiceRequestViewController

@synthesize serviceRequestPageEntries;


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
  NSLog(@"Service Request Page View");
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(goToHome)];
  
  
  [self displayServiceRequestPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Asset Page
- (void) displayServiceRequestPageEntries
{
  serviceRequestPageEntries = [[NSMutableArray alloc] init];
  
  NSString *entry1 = @"Create";
  NSString *entry2 = @"Acknowledge";
  NSString *entry3 = @"Inspection";
  NSString *entry4 = @"Proposal";
  NSString *entry5 = @"Approval";
  NSString *entry6 = @"Provisioning";
  NSString *entry7 = @"Feedback";
  NSString *entry8 = @"View";
  
  [serviceRequestPageEntries addObject:entry1];
  [serviceRequestPageEntries addObject:entry2];
  [serviceRequestPageEntries addObject:entry3];
  [serviceRequestPageEntries addObject:entry4];
  [serviceRequestPageEntries addObject:entry5];
  [serviceRequestPageEntries addObject:entry6];
  [serviceRequestPageEntries addObject:entry7];
  [serviceRequestPageEntries addObject:entry8];
}


#pragma mark - Segue to Home Page
-(void) goToHome
{
  //Go back to Home Page
  HomePageViewController *controller = (HomePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Service Request Tasks"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [serviceRequestPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"serviceRequestPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.serviceRequestPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //Create
    case 0: [self performSegueWithIdentifier:@"srToCreateSR" sender:self];
      break;
    //Acknowledge
    case 1: [self performSegueWithIdentifier:@"srToAcknowledgeSR" sender:self];
      break;
    //Inspection
    case 2: [self performSegueWithIdentifier:@"srToInspectSR" sender:self];
      break;
    //Proposal
    case 3: [self performSegueWithIdentifier:@"srToProposalSR" sender:self];
      break;
    //Approval
    case 4: [self performSegueWithIdentifier:@"srToApprovalSR" sender:self];
      break;
    //~ Provisioning
    case 5: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    //Feedback
    case 6: [self performSegueWithIdentifier:@"srToSRFeedbackList" sender:self];
      break;
    //~ View
    case 7: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    default: break;
  }
}


@end
