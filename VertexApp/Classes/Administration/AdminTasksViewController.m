//
//  AdminTasksViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AdminTasksViewController.h"

@interface AdminTasksViewController ()

@end

@implementation AdminTasksViewController

@synthesize adminTaskPageEntries;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [self displayAdminTaskPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Admin Page
- (void) displayAdminTaskPageEntries
{
  adminTaskPageEntries = [[NSMutableArray alloc] init];
  
  /* !- For demo only, remove hard coded values. Must retrieve listing in DB -! */
  NSString *entry1 = @"Add Service";
  NSString *entry2 = @"Update Services";
  NSString *entry3 = @"Remove Service";
  NSString *entry4 = @"Add Lifecycle";
  NSString *entry5 = @"Update Lifecycle";
  NSString *entry6 = @"Activate User Account";
  NSString *entry7 = @"Add Asset Types";
  
  [adminTaskPageEntries addObject:entry1];
  [adminTaskPageEntries addObject:entry2];
  [adminTaskPageEntries addObject:entry3];
  [adminTaskPageEntries addObject:entry4];
  [adminTaskPageEntries addObject:entry5];
  [adminTaskPageEntries addObject:entry6];
  [adminTaskPageEntries addObject:entry7];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Administration Tasks"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [adminTaskPageEntries count];
  NSLog(@"%d", [adminTaskPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Admin Tasks Page View");
  static NSString *CellIdentifier = @"adminTasksPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.adminTaskPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*
  switch (indexPath.row)
  {
    case 0: [self performSegueWithIdentifier:@"" sender:self];
      break;
    case 1: [self performSegueWithIdentifier:@"" sender:self];
      break;
    case 2: [self performSegueWithIdentifier:@"" sender:self];
      break;
    case 3: [self performSegueWithIdentifier:@"" sender:self];
      break;
    case 4: [self performSegueWithIdentifier:@"" sender:self];
      break;
    case 5: [self performSegueWithIdentifier:@"" sender:self];
      break;
    case 6: [self performSegueWithIdentifier:@"" sender:self];
      break;
    default: break;
  }
  */
  
  /*
   !- TODO -!
   Segue to additinal storyboards 
   */
}


@end
