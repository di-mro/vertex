//
//  UserAccountConfigurationViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UserAccountConfigurationPageViewController.h"
#import "AdminTasksViewController.h"


@interface UserAccountConfigurationPageViewController ()

@end

@implementation UserAccountConfigurationPageViewController

@synthesize userAccountConfigPageEntries;

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
  NSLog(@"User Account Configuration Page View");
  
  //[Back] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(goToAdminTasks)];
  
  [self displayUserAccountConfigPageEntries];
  
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
- (void) displayUserAccountConfigPageEntries
{
  userAccountConfigPageEntries = [[NSMutableArray alloc] init];
  
  NSString *entry1 = @"User Account Activation";
  NSString *entry2 = @"User Group Configuration";
  NSString *entry3 = @"Edit User Account Details";
  NSString *entry4 = @"Add User Profile";
  NSString *entry5 = @"View User Profile";
  NSString *entry6 = @"Edit User Profile";
  NSString *entry7 = @"Remove User Profile";
  
  [userAccountConfigPageEntries addObject:entry1];
  [userAccountConfigPageEntries addObject:entry2];
  [userAccountConfigPageEntries addObject:entry3];
  [userAccountConfigPageEntries addObject:entry4];
  [userAccountConfigPageEntries addObject:entry5];
  [userAccountConfigPageEntries addObject:entry6];
  [userAccountConfigPageEntries addObject:entry7];
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"User Account Management"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [userAccountConfigPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"userConfigPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.userAccountConfigPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //User Account Activation
    case 0: [self performSegueWithIdentifier:@"userAccountConfigToUserAccountActivation" sender:self];
      break;
    //User Group Configuration
    case 1: [self performSegueWithIdentifier:@"userAccountConfigToUserGroupConfig" sender:self];
      break;
    //Edit User Account Details
    case 2: [self performSegueWithIdentifier:@"userAccountConfigToEditUserAccountDetails" sender:self];
      break;
    //Add User Profile
    case 3: [self performSegueWithIdentifier:@"userAccountConfigToAddUserProfile" sender:self];
      break;
    //View User Profile
    case 4: [self performSegueWithIdentifier:@"userAccountConfigToViewUserProfile" sender:self];
      break;
    //Edit User Profile
    case 5: [self performSegueWithIdentifier:@"userAccountConfigToEditUserProfile" sender:self];
      break;
    //Remove User Profile
    case 6: [self performSegueWithIdentifier:@"userAccountConfigToRemoveUserProfile" sender:self];
      break;
    default: break;
  }
}


@end
