//
//  ServiceRequestViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ServiceRequestViewController.h"

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
  
  /* !- TODO For demo only, remove hard coded values -! */
  NSString *entry1 = @"Create";
  NSString *entry2 = @"View";
  NSString *entry3 = @"Acknowledge";
  NSString *entry4 = @"Approve";
  NSString *entry5 = @"Provision";
  NSString *entry6 = @"Create Feedback";
  
  [serviceRequestPageEntries addObject:entry1];
  [serviceRequestPageEntries addObject:entry2];
  [serviceRequestPageEntries addObject:entry3];
  [serviceRequestPageEntries addObject:entry4];
  [serviceRequestPageEntries addObject:entry5];
  [serviceRequestPageEntries addObject:entry6];
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
  NSLog(@"%d", [serviceRequestPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Service Request Page View");
  static NSString *CellIdentifier = @"serviceRequestPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.serviceRequestPageEntries objectAtIndex:indexPath.row];
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
    //View
    case 1: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    //Acknowledge
    case 2: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    //Approve
    case 3: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    //Provision
    case 4: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    //Feedback
    case 5: [self performSegueWithIdentifier:@"srToSRFeedbackList" sender:self];
      break;
    default: break;
  }
}


@end
