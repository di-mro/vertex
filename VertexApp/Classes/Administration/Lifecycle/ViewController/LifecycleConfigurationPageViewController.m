//
//  LifecycleConfigurationPageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "LifecycleConfigurationPageViewController.h"
#import "AdminTasksViewController.h"


@interface LifecycleConfigurationPageViewController ()

@end

@implementation LifecycleConfigurationPageViewController

@synthesize lifecycleConfigPageEntries;

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
  NSLog(@"Lifecycle Configurations Page View");
  
  //[Home] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(goToAdminTasks)];
  
  [self displayLifecycleConfigPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Segue to Admin Tasks Page
-(void) goToAdminTasks
{
  //Go back to Admin Tasks Page
  AdminTasksViewController *controller = (AdminTasksViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AdminTasksPage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


# pragma mark - Display entries in Admin Page
- (void) displayLifecycleConfigPageEntries
{
  lifecycleConfigPageEntries = [[NSMutableArray alloc] init];
  
  NSString *entry1 = @"Add";
  NSString *entry2 = @"View";
  NSString *entry3 = @"Update";
  NSString *entry4 = @"Remove";
    
  [lifecycleConfigPageEntries addObject:entry1];
  [lifecycleConfigPageEntries addObject:entry2];
  [lifecycleConfigPageEntries addObject:entry3];
  [lifecycleConfigPageEntries addObject:entry4];
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Lifecycle Management Tasks"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [lifecycleConfigPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"lifecycleConfigPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.lifecycleConfigPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   switch (indexPath.row)
   {
     //Add Lifecycle
     case 0: [self performSegueWithIdentifier:@"lifecycleConfigToAddLifecycle" sender:self];
       break;
    //View Lifecycle
     case 1: [self performSegueWithIdentifier:@"lifecycleConfigToViewLifecycle" sender:self];
       break;
    //Update Lifecycle
     case 2: [self performSegueWithIdentifier:@"lifecycleConfigToUpdateLifecycle" sender:self];
       break;
    //Delete Lifecycle
     case 3: [self performSegueWithIdentifier:@"lifecycleConfigToDeleteLifecycle" sender:self];
       break;
     default: break;
   }
}

@end
