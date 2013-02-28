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
  NSString *entry1 = @"Create Service Request";
  NSString *entry2 = @"View Service Requests";
  NSString *entry3 = @"Submit Feedback";
  
  [serviceRequestPageEntries addObject:entry1];
  [serviceRequestPageEntries addObject:entry2];
  [serviceRequestPageEntries addObject:entry3];
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@""];
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
    case 0: [self performSegueWithIdentifier:@"srToCreateSR" sender:self];
      break;
    case 1: [self performSegueWithIdentifier:@"srToViewSR" sender:self];
      break;
    case 2: [self performSegueWithIdentifier:@"srToCreateSR" sender:self];
      break;
    default: break;
  }
}


@end
