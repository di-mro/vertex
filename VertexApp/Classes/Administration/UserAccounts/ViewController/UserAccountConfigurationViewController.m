//
//  UserAccountConfigurationViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/30/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UserAccountConfigurationViewController.h"

@interface UserAccountConfigurationViewController ()

@end

@implementation UserAccountConfigurationViewController

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
  
  [self displayUserAccountConfigPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Admin Page
- (void) displayUserAccountConfigPageEntries
{
  userAccountConfigPageEntries = [[NSMutableArray alloc] init];
  
  /* !- For demo only, remove hard coded values. Must retrieve listing in DB -! */
  NSString *entry1 = @"User Account Activation";
  NSString *entry2 = @"User Group Configuration";
  NSString *entry3 = @"Edit User Account Details";
  NSString *entry4 = @"Add User Profile";
  NSString *entry5 = @"Edit User Profile";
  
  [userAccountConfigPageEntries addObject:entry1];
  [userAccountConfigPageEntries addObject:entry2];
  [userAccountConfigPageEntries addObject:entry3];
  [userAccountConfigPageEntries addObject:entry4];
  [userAccountConfigPageEntries addObject:entry5];
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
  NSLog(@"%d", [userAccountConfigPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"userConfigPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.userAccountConfigPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
      /*
       //Add Service
       case 0: [self performSegueWithIdentifier:@"" sender:self];
       break;
       case 1: [self performSegueWithIdentifier:@"" sender:self];
       break;
       case 2: [self performSegueWithIdentifier:@"" sender:self];
       break;
       case 3: [self performSegueWithIdentifier:@"" sender:self];
       break;
       default: break;
       */
  }
}


@end
