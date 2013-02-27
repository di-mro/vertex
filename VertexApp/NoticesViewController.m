//
//  NoticesViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/26/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "NoticesViewController.h"

@interface NoticesViewController ()

@end

@implementation NoticesViewController

@synthesize noticesPageEntries;

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
  [self displayNoticesPageEntries];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


# pragma mark - Display entries in Home Page
- (void) displayNoticesPageEntries
{
  noticesPageEntries = [[NSMutableArray alloc] init];
  
  //!-For demo only, remove hard coded values-!
  NSString *entry1 = @"Create Memo";
  NSString *entry2 = @"View Memo";
  NSString *entry3 = @"Create Notice";
  NSString *entry4 = @"View Notice";
  
  [noticesPageEntries addObject:entry1];
  [noticesPageEntries addObject:entry2];
  [noticesPageEntries addObject:entry3];
  [noticesPageEntries addObject:entry4];
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
  return [noticesPageEntries count];
  NSLog(@"%d", [noticesPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Notices Page View");
  static NSString *CellIdentifier = @"noticesPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.noticesPageEntries objectAtIndex:indexPath.row];
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
       //Create Memo
       case 0: [self performSegueWithIdentifier:@"" sender:self];
       break;
       //View Memo
       case 1: [self performSegueWithIdentifier:@"" sender:self];
       break;
       //Create Notice
       case 2: [self performSegueWithIdentifier:@"" sender:self];
       break;
       //View Notice
       case 3: [self performSegueWithIdentifier:@"" sender:self];
       break;
       */
  }
}


@end
