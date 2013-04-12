//
//  SchedulePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/9/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SchedulePageViewController.h"

@interface SchedulePageViewController ()

@end

@implementation SchedulePageViewController

@synthesize schedulePageEntries;

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
  [self displaySchedulePageEntries];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Settings Page
- (void) displaySchedulePageEntries
{
  schedulePageEntries = [[NSMutableArray alloc] init];
  
  /*
   NSString *entry1 = @"Edit Password";
   NSString *entry2 = @"Edit Account Details";
   
   [schedulePageEntries addObject:entry1];
   [schedulePageEntries addObject:entry2];
   */
}

#pragma mark - Table view data source implementation
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
  return [schedulePageEntries count];
  NSLog(@"%d", [schedulePageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Schedule Page View");
  static NSString *CellIdentifier = @"schedulePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.schedulePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /* !-Remove these hardcoded cases -! */
  switch (indexPath.row)
  {
      /*
       //Edit Password
       case 0: [self performSegueWithIdentifier:@"" sender:self];
       break;
       //Edit Account Details
       case 1: [self performSegueWithIdentifier:@"" sender:self];
       break;
       default: break;
       */
  }
}


@end
