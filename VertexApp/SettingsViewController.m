//
//  SettingsViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/26/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize settingsPageEntries;

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
  [self displaySettingsPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Home Page
- (void) displaySettingsPageEntries
{
  settingsPageEntries = [[NSMutableArray alloc] init];
  
  //!-For demo only, remove hard coded values-!
  NSString *entry1 = @"Edit Password";
  NSString *entry2 = @"Edit Account Details";
  NSString *entry3 = @"Customize Lifecycle";
  NSString *entry4 = @"Customize Services";
  NSString *entry5 = @"Customize Users";
  
  [settingsPageEntries addObject:entry1];
  [settingsPageEntries addObject:entry2];
  [settingsPageEntries addObject:entry3];
  [settingsPageEntries addObject:entry4];
  [settingsPageEntries addObject:entry5];
}


#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Options and Configurations"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [settingsPageEntries count];
  NSLog(@"%d", [settingsPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Settings Page View");
  static NSString *CellIdentifier = @"settingsPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.settingsPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //!-Remove these hardcoded shiznitz-!
  switch (indexPath.row)
  {
    /*
    //Edit Password
    case 0: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //Edit Account Details
    case 1: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //Customize Lifecycle
    case 2: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //Customize Services
    case 3: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //Customize Users
    case 4: [self performSegueWithIdentifier:@"" sender:self];
      break;
    default: break;
    */
  }
}


@end
