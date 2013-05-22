//
//  ServiceConfigurationPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ServiceConfigurationPageViewController.h"

@interface ServiceConfigurationPageViewController ()

@end

@implementation ServiceConfigurationPageViewController

@synthesize serviceConfigPageEntries;

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
  NSLog(@"Service Configurations Page View");
  
  [self displayServiceConfigPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Admin Page
- (void) displayServiceConfigPageEntries
{
  serviceConfigPageEntries = [[NSMutableArray alloc] init];
  
  NSString *entry1 = @"Add";
  NSString *entry2 = @"View";
  NSString *entry3 = @"Update";
  NSString *entry4 = @"Remove";
  
  [serviceConfigPageEntries addObject:entry1];
  [serviceConfigPageEntries addObject:entry2];
  [serviceConfigPageEntries addObject:entry3];
  [serviceConfigPageEntries addObject:entry4];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Service Management Tasks"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [serviceConfigPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"serviceConfigPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.serviceConfigPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //Add Service
    case 0: [self performSegueWithIdentifier:@"serviceConfigToAddService" sender:self];
      break;
    //View Service
    case 1: [self performSegueWithIdentifier:@"serviceConfigToViewService" sender:self];
      break;
    //Update Service
    case 2: [self performSegueWithIdentifier:@"serviceConfigToUpdateService" sender:self];
      break;
    //Delete Service
    case 3: [self performSegueWithIdentifier:@"serviceConfigToDeleteService" sender:self];
      break;
    default: break;
  }
}


@end
